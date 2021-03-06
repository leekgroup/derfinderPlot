#' Plot a karyotype overview of the genome with the identified regions
#'
#' Plots an overview of the genomic locations of the identified regions (see
#' [calculatePvalues][derfinder::calculatePvalues]) in a karyotype view. The coloring can be
#' done either by significant regions according to their p-values, significant
#' by adjusted p-values, or by annotated region if using
#' [matchGenes][bumphunter::matchGenes].
#'
#'
#' @param regions The `$regions` output from
#' [calculatePvalues][derfinder::calculatePvalues].
#' @param annotation The output from running [matchGenes][bumphunter::matchGenes]
#' on the output from [calculatePvalues][derfinder::calculatePvalues]. It is only required
#' if `type='annotation'`.
#' @param type Must be either `pval`, `qval`, `fwer` or
#' `annotation`. It
#' determines whether the plot coloring should be done according to significant
#' p-values (<0.05), significant q-values (<0.10), significant FWER adjusted
#' p-values (<0.05) or annotation regions.
#' @param significantCut A vector of length two specifiying the cutoffs used to
#' determine significance. The first element is used to determine significance
#' for the p-values and the second element is used for the q-values.
#' @param ... Arguments passed to other methods and/or advanced arguments.
#' Advanced arguments:
#' \describe{
#' \item{base_size }{ Base point size of the plot. This argument is passed to
#' [element_text][ggplot2::element] (`size` argument).}
#' \item{areaRel }{ The relative size for the area label when
#' `type='pval'`
#' or `type='qval'`. Can be useful when making high resolution versions of
#' these plots in devices like CairoPNG.}
#' \item{legend.position }{ This argument is passed to [theme][ggplot2::theme].
#' From ggplot2: the position of legends. ('left', 'right', 'bottom', 'top', or
#' two-element numeric vector).}
#' }
#' Passed to [extendedMapSeqlevels][derfinder::extendedMapSeqlevels].
#'
#' @return A ggplot2 plot that is ready to be printed out. Tecnically it is a
#' ggbio object.
#'
#' @seealso [calculatePvalues][derfinder::calculatePvalues],
#' [matchGenes][bumphunter::matchGenes]
#' @author Leonardo Collado-Torres
#' @export
#'
#' @importFrom GenomicRanges seqinfo
#' @importFrom GenomeInfoDb seqlengths 'seqlengths<-' seqlevels renameSeqlevels
#' getChromInfoFromUCSC mapSeqlevels
#' @importMethodsFrom ggbio autoplot layout_karyogram
#' @importFrom ggplot2 aes labs scale_colour_manual scale_fill_manual geom_text
#' rel geom_segment xlab theme element_text element_blank
#' @importFrom derfinder extendedMapSeqlevels
#' @importFrom utils data
#'
#' @examples
#' ## Construct toy data
#' chrs <- paste0('chr', c(1:22, 'X', 'Y'))
#' chrs <- factor(chrs, levels=chrs)
#' library('GenomicRanges')
#' regs <- GRanges(rep(chrs, 10), ranges=IRanges(runif(240, 1, 4e7),
#'     width=1e3), significant=sample(c(TRUE, FALSE), 240, TRUE, p=c(0.05,
#'     0.95)), significantQval=sample(c(TRUE, FALSE), 240, TRUE, p=c(0.1,
#'     0.9)), area=rnorm(240))
#' annotation <- data.frame(region=sample(c("upstream", "promoter",
#'     "overlaps 5'", "inside", "overlaps 3'", "close to 3'", "downstream"),
#'     240, TRUE))
#'
#' ## Type pval
#' plotOverview(regs)
#'
#' \dontrun{
#' ## Type qval
#' plotOverview(regs, type='qval')
#'
#' ## Annotation
#' plotOverview(regs, annotation, type='annotation')
#'
#' ## Resize the plots if needed.
#'
#' ## You might prefer to leave the legend at ggplot2's default option: right
#' plotOverview(regs, legend.position='right')
#'
#' ## Although the legend looks better on the bottom
#' plotOverview(regs, legend.position='bottom')
#'
#' ## Example knitr chunk for higher res plot using the CairoPNG device
#' ```{r overview, message=FALSE, fig.width=7, fig.height=9, dev='CairoPNG', dpi=300}
#' plotOverview(regs, base_size=30, areaRel=10, legend.position=c(0.95, 0.12))
#' ```
#'
#' ## For more custom plots, take a look at the ggplot2 and ggbio packages
#' ## and feel free to look at the code of this function:
#' plotOverview
#' }

plotOverview <- function(regions, annotation = NULL, type = 'pval',
    significantCut = c(0.05, 0.1), ...) {
    stopifnot(type %in% c('pval', 'qval', 'fwer', 'annotation'))
    stopifnot(length(significantCut) == 2 & all(significantCut >=
            0 & significantCut <= 1))

    ## Advanced parameters
    # @param base_size Base point size of the plot. This argument is passed to
    # \link[ggplot2:element]{element_text} (\code{size} argument).
    base_size <- .advanced_argument('base_size', 12, ...)

    # @param areaRel The relative size for the area label when \code{type='pval'}
    # or \code{type='qval'}. Can be useful when making high resolution versions of
    # these plots in devices like CairoPNG.
    areaRel <- .advanced_argument('areaRel', 4, ...)

    # @param legend.position This argument is passed to \link[ggplot2]{theme}.
    # From ggplot2: the position of legends. ('left', 'right', 'bottom', 'top', or
    # two-element numeric vector).
    legend.position <- .advanced_argument('legend.position', c(0.85, 0.12), ...)

    ## Keeping R CMD check happy
    significant <- midpoint <- area <- x <- y <- xend <-
        significantQval <- region <- significantFWER <- NULL

    ## Use UCSC names for homo_sapiens by default
    regions <- renameSeqlevels(regions,
        extendedMapSeqlevels(seqlevels(regions), ...))

    ## Assign chr lengths if needed
    if (any(is.na(seqlengths(regions)))) {
        message(paste(Sys.time(),
            'plotOverview: assigning chromosome lengths from hg19!'))
        seqlengths(regions) <- seqlengths(getChromInfoFromUCSC('hg19',
            as.Seqinfo = TRUE))[
                mapSeqlevels(names(seqlengths(regions)), 'UCSC')]
    }

    ## Graphical setup
    ann_chr <- ifelse(any(seqnames(regions) == 'chrX'), 'chrX',
        levels(seqnames(regions))[length(levels(seqnames(regions)))])
    ann_pos <- min(c(2.25e+08, max(seqlengths(regions) * 0.9)))
    ann_text <- data.frame(x = ann_pos, y = 10, lab = 'Area',
        seqnames = ann_chr)
    ann_line <- data.frame(x = ann_pos * 0.888, xend = ann_pos * 0.955, y = 10,
        seqnames = ann_chr)

    ## Make the plot
    if (type == 'pval') {
        ## P-value plot
        result <- autoplot(seqinfo(regions)) + layout_karyogram(regions,
            aes(fill = significant, color = significant), geom = 'rect',
            base_size = 30) + labs(title = paste0('Overview of regions found in the genome; significant: p-value <', significantCut[1]))
    } else if (type == 'qval') {
        ## FDR adjusted p-value plot
        result <- autoplot(seqinfo(regions)) + layout_karyogram(regions,
            aes(fill = significantQval, color = significantQval),
            geom = 'rect') + labs(title = paste0('Overview of regions found in the genome; significant: q-value <', significantCut[2]))
    } else if (type == 'fwer') {
        stopifnot(all(c('fwer', 'significantFWER') %in% names(mcols(regions))))
        ## FWER adjusted p-value plot
        result <- autoplot(seqinfo(regions)) + layout_karyogram(regions,
            aes(fill = significantFWER, color = significantFWER),
            geom = 'rect') + labs(title = paste0('Overview of regions found in the genome; significant: FWER adjusted p-value <', significantCut[1]))
    } else {
        ## Annotation region plot
        stopifnot(is.null(annotation) == FALSE)
        regions$region <- annotation$region
        result <- autoplot(seqinfo(regions)) + layout_karyogram(regions,
            aes(fill = region, color = region), geom = 'rect') +
            labs(title = 'Annotation region (if available)')
    }

    if(type %in% c('pval', 'qval', 'fwer')) {
        result <- result + layout_karyogram(regions, aes(x = midpoint,
            y = area), geom = 'line', color = 'coral1', ylim = c(10, 20)) +
            scale_colour_manual(values = c('chartreuse4', 'wheat2'),
                limits = c('TRUE', 'FALSE')) +
            scale_fill_manual( values = c('chartreuse4', 'wheat2'),
                limits = c('TRUE', 'FALSE')) + geom_text(aes(x = x,
                    y = y), data = ann_text, label = 'Area', size = rel(areaRel)) +
            geom_segment(aes(x = x, xend = xend, y = y, yend = y),
                data = ann_line, colour ='coral1')
    }
    result <- result + xlab('Genomic location') + theme(text = element_text(
        size = base_size), legend.background = element_blank(),
        legend.position = legend.position)
    return(result)
}
