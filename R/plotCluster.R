#' Plot the coverage information surrounding a region cluster
#'
#' For a given region found in \link[derfinder]{calculatePvalues}, plot the 
#' coverage for the cluster this region belongs to as well as some padding. The 
#' mean by group is shown to facilitate comparisons between groups. If 
#' annotation exists, you can plot the trancripts and exons (if any) 
#' overlapping in the vicinity of the region of interest.
#'
#' 
#' @param idx A integer specifying the index number of the region of interest.
#' This region is graphically highlighted by a red bar.
#' @param regions The \code{$regions} output from 
#' \link[derfinder]{calculatePvalues}.
#' @param annotation The output from running \link[bumphunter]{annotateNearest} 
#' on the output from \link[derfinder]{calculatePvalues}.
#' @param coverageInfo A DataFrame resulting from 
#' \link[derfinder]{loadCoverage} using \code{cutoff=NULL}.
#' @param groupInfo A factor specifying the group membership of each sample. It 
#' will be used to color the samples by group.
#' @param titleUse Whether to show the p-value (\code{pval}), the q-value 
#' (\code{qval}) or the FWER adjusted p-value (\code{fwer}) in the title. If 
#' \code{titleUse=none} then no p-value or 
#' q-value information is used; useful if no permutations were performed and 
#' thus p-value and q-value information is absent.
#' @param txdb A transcript data base such as
#' \code{TxDb.Hsapiens.UCSC.hg19.knownGene}. If \code{NULL} then no annotation 
#' information is used.
#' @param p.ideogram If \code{NULL}, the ideogram for hg19 is built for the 
#' corresponding chromosome. Otherwise an ideogram resuling from 
#' \link[ggbio]{plotIdeogram}.
#' @param ... Arguments passed to other methods and/or advanced arguments.
#'
#' @return A ggplot2 plot that is ready to be printed out. Tecnically it is a 
#' ggbio object. The region with the red bar is the one whose information is 
#' shown in the title.
#'
#' @details See the parameter \code{significantCut} in 
#' \link[derfinder]{calculatePvalues} for how the significance cutoffs are 
#' determined.
#'
#' @seealso \link[derfinder]{loadCoverage}, \link[derfinder]{calculatePvalues}, 
#' \link[bumphunter]{annotateNearest}, \link[ggbio]{plotIdeogram}
#' @author Leonardo Collado-Torres
#' @export
#' @aliases plot_cluster
#'
#' @importFrom IRanges width resize
#' @importMethodsFrom IRanges '[' as.matrix findOverlaps queryHits
#' @importFrom GenomicRanges seqnames
#' @importMethodsFrom GenomicRanges findOverlaps start end as.data.frame range
#' @importFrom ggbio plotIdeogram tracks theme_tracks_sunset
#' @importMethodsFrom ggbio autoplot
#' @importFrom reshape2 melt
#' @importFrom ggplot2 autoplot aes scale_fill_manual ggplot geom_line ylab 
#' guides scale_y_continuous geom_segment
#' @importFrom plyr ddply summarise
#' @importFrom scales log2_trans log_trans
#' @importFrom GenomeInfoDb seqlevels renameSeqlevels
#' @importFrom GenomicFeatures exonsBy
#' @importFrom RColorBrewer brewer.pal
#' @importFrom derfinder extendedMapSeqlevels
#' 
#' @examples
#' ## Load data
#' library('derfinder')
#'
#' ## Annotate the results with bumphunter::matchGenes()
#' library('bumphunter')
#' library('TxDb.Hsapiens.UCSC.hg19.knownGene')
#' library('org.Hs.eg.db')
#' genes <- annotateTranscripts(txdb = TxDb.Hsapiens.UCSC.hg19.knownGene, 
#'     annotationPackage = 'org.Hs.eg.db')
#' annotation <- matchGenes(x = genomeRegions$regions, subject = genes)
#'
#' ## Make the plot
#' plotCluster(idx=1, regions=genomeRegions$regions, annotation=annotation, 
#'     coverageInfo=genomeDataRaw$coverage, groupInfo=genomeInfo$pop, 
#'     txdb=TxDb.Hsapiens.UCSC.hg19.knownGene)
#' ## Resize the plot window and the labels will look good.
#'
#' \dontrun{
#' ## For a custom plot, check the ggbio and ggplot2 packages.
#' ## Also feel free to look at the code for this function:
#' plotCluster
#'
#' }

plotCluster <- function(idx, regions, annotation, coverageInfo, 
    groupInfo, titleUse = 'qval', txdb = NULL, p.ideogram = NULL,  ...) {
    stopifnot(titleUse %in% c('pval', 'qval', 'fwer', 'none'))
    stopifnot(is.factor(groupInfo))

    ## Advanced parameters    
#' @param maxExtend The maximum number of base-pairs to extend the view (on 
#' each side) before and after the region cluster of interest. For small region 
#' clusters, the one side extension is equal to the width of the region cluster.
    maxExtend <- .advanced_argument('maxExtend', 300L, ...)

#' @param colsubset Column subset in case that it was specified in 
#' \link[derfinder]{preprocessCoverage}.
    colsubset <- .advanced_argument('colsubset', seq_len(length(groupInfo)), ...)

#' @param forceLarge If \code{TRUE} then the data size limitations are ignored. 
#' The window size (region cluster width + 2 times \code{maxExtend}) has to be 
#' less than 100 kb. Note that a single plot at the 300kb range can take around 
#' 2 hours to complete.
    forceLarge <- .advanced_argument('forceLarge', FALSE, ...)

    ## Use UCSC names for homo_sapiens by default
    regions <- renameSeqlevels(regions, 
        extendedMapSeqlevels(seqlevels(regions), ...))
    
    current <- regions[idx]
    
    ## Satisfying R CMD check
    x <- xend <- y <- meanCov <- significant <- significantQval <- position <-
        valueScaled <- variable <- group <- value <- meanScaled <- 
        significantFWER <- NULL
    
    ## Select region and build title
    cluster <- regions[seqnames(regions) == seqnames(current) & 
        regions$cluster == current$cluster]
    if (length(cluster) > 1) {
        cluster <- range(cluster)
    }
    l <- width(cluster) + 2 * min(maxExtend, width(cluster))
    
    if (l > 1e+05 & !forceLarge) {
        message(paste("No plot will be made because the data is too large. The window size exceeds 100 kb. To ignore this, use the advanced argument 'forgeLarge'."))
        return(invisible(l))
    }
    
    wh <- resize(cluster, l, fix = 'center')
    if (titleUse == 'pval') {
        title <- paste0('Cluster for region with name ', annotation$name[idx], 
            ' and p-value ', signif(current$pvalues, 4))
    } else if (titleUse == 'qval') {
        title <- paste0('Cluster for region with name ', annotation$name[idx], 
            ' and q-value ', signif(current$qvalues, 4))
    } else if (titleUse == 'fwer') {
        stopifnot(all(c('fwer', 'significantFWER') %in% names(mcols(current))))
        title <- paste0('Cluster for region with name ', annotation$name[idx], 
            ' and FWER adjusted p-value ', signif(current$fwer, 4))
    } else {
        title <- paste0('Cluster for region with name ', annotation$name[idx])
    }
    
    ## Plot the ideogram if not supplied
    if (is.null(p.ideogram)) {
        chr <- as.character(seqnames(wh))
        ## Now load the ideogram info
        hg19IdeogramCyto <- NULL
        load(system.file('data', 'hg19IdeogramCyto.rda',
            package = 'biovizBase', mustWork = TRUE))
        p.ideogram <- plotIdeogram(hg19IdeogramCyto, extendedMapSeqlevels(chr, 'UCSC', "homo_sapiens"))
    }
    
    ## Regions found (from the view)
    neighbors <- regions[queryHits(findOverlaps(regions, wh))]
    neighbors$originalRegion <- neighbors == current
    ann_line <- data.frame(x = start(current), xend = end(current), 
        y = 1)
    if (titleUse == 'pval') {
        p.region <- autoplot(neighbors, aes(fill = significant)) + 
            scale_fill_manual(values = c('chartreuse4', 'wheat2'), 
                limits = c('TRUE', 'FALSE')) + geom_segment(aes(x = x, 
            xend = xend, y = y, yend = y, size = 3), data = ann_line, 
            colour = 'red') + guides(size = FALSE)
    } else if (titleUse == 'qval') {
        p.region <- autoplot(neighbors, aes(fill = significantQval)) + 
            scale_fill_manual(values = c('chartreuse4', 'wheat2'), 
                limits = c('TRUE', 'FALSE')) + geom_segment(aes(x = x, 
            xend = xend, y = y, yend = y, size = 3), data = ann_line, 
            colour = 'red') + guides(size = FALSE)
    } else if (titleUse == 'fwer') {
        p.region <- autoplot(neighbors, aes(fill = significantFWER)) + 
            scale_fill_manual(values = c('chartreuse4', 'wheat2'), 
                limits = c('TRUE', 'FALSE')) + geom_segment(aes(x = x, 
            xend = xend, y = y, yend = y, size = 3), data = ann_line, 
            colour = 'red') + guides(size = FALSE)
    } else {
        p.region <- autoplot(neighbors) + geom_segment(aes(x = x, 
            xend = xend, y = y, yend = y, size = 3), data = ann_line, 
            colour = 'red') + guides(size = FALSE)
    }
    
    ## Graphical parameters
    nGroups <- length(levels(groupInfo))
    
    ## Construct the coverage plot
    pos <- start(wh):end(wh)
    rawData <- as.data.frame(coverageInfo[pos, colsubset])
    rawData$position <- pos
    covData <- melt(rawData, id.vars = 'position')
    covData$group <- rep(groupInfo, each = nrow(rawData))
    p.coverage <- ggplot(covData, aes(x = position, y = value, 
        group = variable, colour = group)) + geom_line(alpha = 1/nGroups) + 
        scale_y_continuous(trans = log2_trans())
    
    ## Construct mean by group coverage plot
    meanCoverage <- ddply(covData, c('position', 'group'), summarise, 
        meanCov = mean(value))
    p.meanCov <- ggplot(meanCoverage, aes(x = position, y = meanCov, 
        colour = group)) + geom_line(alpha = 1/max(1, 1/2 * nGroups)) + 
        scale_y_continuous(trans = log2_trans())
    
    ## Annotation info and final plot
    if (is.null(txdb)) {
        p.transcripts <- FALSE
    } else {
        ## The tryCatch is needed because not all regions overlap a
        ## transcript
        p.transcripts <- tryCatch(autoplot(txdb, which = wh, 
            names.expr = 'tx_name(gene_id)'), error = function(e) {
            FALSE
        })
    }
    if (!is.logical(p.transcripts)) {
        result <- tracks(p.ideogram, Coverage = p.coverage, `Mean coverage` =
            p.meanCov, Regions = p.region, `tx_name\n(gene_id)` = p.transcripts, 
            heights = c(2, 4, 4, 1.5, 3), xlim = wh, title = title) + 
            ylab('') + theme_tracks_sunset()
    } else {
        result <- tracks(p.ideogram, Coverage = p.coverage, `Mean coverage` =
            p.meanCov, Regions = p.region, heights = c(2, 5, 5, 2), xlim = wh, 
            title = title) + ylab('') + theme_tracks_sunset()
    }
    return(result)
} 

#' @export
plot_cluster <- plotCluster
