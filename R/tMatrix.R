#' Interaction plot between bins of the genome
#'
#' This function takes a \code{GRanges} object with a variable specifying some
#' values of interest. It then construct bins for the genome and for each bin
#' it identifies which regions overlap it. It then calculates t-Statistics
#' between bins and displays them as an interaction plot. Note that this type
#' of plot is normally used to visualize HiC data as is done in 
#' \link[Sushi]{plotHic}.
#'
#' @param regions A \code{GRanges} object that has a column with the name
#' specified in \code{valueVar}.
#' @param tilewidth A single value that specifies the bin size. Regions
#' overlapping a bin are used to compare against another mean. Their values
#' (defined by \code{valueVar}) are used to construct the t-Statistics. Avoid
#' choosing a small value because that will greatly increase the number of bins
#' needed. Unless the genome is small.
#' @param valueVar This should be a character vector of length one that
#' specifies which variable from \code{regions} to use to construct the
#' t-statistic matrix.
#' @param scale This argument is passed to \link[Sushi]{labelgenome} and should
#' be either \code{'bp'}, \code{'Kb'} or \code{'Mb'}.
#' @param title This argument is passed to \link[Sushi]{addlegend}.
#' @param binPad Defines how many bins to include before and after the first and
#' last bins that overlap regions.
#' @param palette This argument is passed to \link[Sushi]{plotHic} and 
#' \link[Sushi]{addlegend}.
#'
#' @return A list with one element per chromosome. For each chromosome 
#' \code{tMatrix} returns the matrix of t-Statistics supplied to 
#' \link[Sushi]{plotHic}. This function will also make the 'interaction' plots,
#' one per chromosome.
#'
#' @author Leonardo Collado-Torres
#' @seealso \link[Sushi]{plotHic}, \link[grDevices]{colorRampPalette}, 
#'     \link[RColorBrewer]{brewer.pal}
#' @export
#'
#' @details This plot gives an overview of which bins of the genome have similar
#' mean values from \code{valueVar}. Bins that have 1 or no observations are
#' assigned a t-Statistics of 0 because \link[Sushi]{plotHic} does not handle
#' NA values. While these zeros are indistinguable from bins that have the same
#' means, the reality is that we expect few such cases to happen.
#'
#' The numerator of the t-Statistics shown in the plot is given by the mean of #' the first bin (leftmost of the two bins) minus the mean of the second bin.
#' Diagonal elements are z-Scores. 
#'
#' @importFrom Sushi SushiColors plotHic labelgenome addlegend
#' @importFrom GenomicRanges tileGenome
#' @importMethodsFrom GenomicRanges findOverlaps mcols overlapsAny '[[' resize
#'     start
#' @importMethodsFrom S4Vectors unlist
#'
#' @examples
#' ## Load data
#' library('derfinder')
#'
#' ## Make plot using a small tilewidth given the small size of the data
#' res <- tMatrix(genomeRegions$regions, tilewidth = 1e4)
#'
#' ## Change the color palette with grDevices::colorRampPalette()
#' library('grDevices')
#' res2 <- tMatrix(genomeRegions$regions, tilewidth = 1e4, palette = 
#'    colorRampPalette(c('grey', 'blue')))
#' 
#' ## Now also use a divergin palette from RColorBrewer
#' library('RColorBrewer')
#' res3 <- tMatrix(genomeRegions$regions, tilewidth = 1e4, 
#'    palette = colorRampPalette(brewer.pal(11, 'PuOr')))
#' ## If you only have negative or positive t-Statistics, consider using a
#' ## sequential palette such as 'YlGnBu'.
#'

tMatrix <- function(regions, tilewidth = 1e6, valueVar = 'area', scale = 'bp', title = 't-Statistic', binPad = 2, palette = SushiColors(7)) {
    
    stopifnot(valueVar %in% colnames(mcols(regions)))
    stopifnot(scale %in% c('bp', 'Kb', 'Mb'))
    stopifnot(length(binPad) == 1 & binPad >= 0)
    if(tilewidth < 1e4) message("'tilewidth' is too small and will generate many bins, consider using a larger value.")
    
    seqs <- seqlengths(regions)
    if(any(is.na(seqs))) { 
        seqs <- sapply(names(seqs), function(chr) {
            if(!is.na(seqs[chr])) {
                return(seqs[chr]) 
            } else {
                return(max(end(regions[seqnames(regions) == chr])))
            }
        })
    }
    
    result <- lapply(names(seqs), function(chr) {
        
        ## Make bins
        tiles <- tileGenome(seqs[chr], tilewidth = tilewidth)
        
        ## Identify bins with data
        idx <- which(overlapsAny(tiles, regions))
        if(length(idx) < 2) {
            warning(paste0('Not enough data, skipping chromosome ', chr, ". Consider using a smaller 'tilewidth'."))
            return(NULL)
        }
    
        ## Use central positions of bins
        pos <- unlist(start(resize(tiles, width = 1, fix = 'center')))
        
        
        tMatrix <- matrix(0, nrow = length(pos), ncol = length(pos), dimnames = list(pos, pos))
    
        ## Calculate t-stats
        ov <- findOverlaps(tiles, regions)
        queries <- queryHits(ov)
        means <- sds <- rep(0, length(pos))
        values <- mcols(regions)[[valueVar]][subjectHits(ov)]
        means[idx] <- tapply(values, queries, mean)
        sds[idx] <- tapply(values, queries, sd)
        
        ## For diagonal
        diag(tMatrix)[idx] <- means[idx] / sds[idx]
    
        grid <- combn(idx, 2)
        for(j in seq_len(ncol(grid))) {
            i <- grid[, j]
            t <- (means[i[1]] - means[i[2]]) / sqrt(sum(sds[i]^2)) 
            tMatrix[i[1], i[2]]  <- -1 * t
            tMatrix[i[2], i[1]]  <- t
        }
    
        ## Set 0 for those that had sd NA due to lack of observations
        tMatrix[is.na(tMatrix)] <- 0
    
        ## Set chromosome limits
        chromstart <- ifelse(idx[1] >= 3, pos[idx[1] - binPad], 1)
        chromend <- ifelse(idx[length(idx)] >= length(pos), seqs[chr], pos[idx[length(idx)] + binPad])
        
        ## Make plot
        hic <- plotHic(hicdata = tMatrix, chrom = chr, chromstart = chromstart,
            chromend = chromend, palette = palette)
        labelgenome(chrom = chr, chromstart = chromstart, chromend = chromend,
            scale = scale)
        addlegend(range = hic[[1]], palette = hic[[2]], title = title, 
            side = 'right', bottominset = 0.4, topinset = 0, xoffset = -.035,
            labelside = 'left', width = 0.05, title.offset = 0.05)
    
        return(tMatrix)
    })
    
    ## Assign names
    names(result) <- names(seqs)
    
    ## Done
    return(result)
}
