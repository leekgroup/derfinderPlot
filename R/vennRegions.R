#' Venn diagram for annotated regions given the genomic state
#'
#' Makes a venn diagram for the regions given the genomic state showing how many
#' regions overlap introns, exons, intergenic regions, none or multiple groups.
#' 
#' @param annotatedRegions The output from \link[derfinder]{annotateRegions} 
#' used on \code{regions}.
#' @param subsetIndex A vector of to use to subset the regions to use for the
#' venn diagram. It can be a logical vector of length equal to the number of
#' regions or an integer vector. If \code{NULl}, then it's ignored.
#' @param ... Arguments passed to \link[limma:venn]{vennDiagram}.
#'
#' @return Makes a venn diagram plot for the annotation given the genomic state
#'     and the actual venn counts used to make the plot.
#'
#' @author Leonardo Collado-Torres
#' @seealso \link[derfinder]{annotateRegions}, \link[limma:venn]{vennCounts},
#'     \link[limma:venn]{vennDiagram}
#' @export
#'
#' @importFrom limma vennCounts vennDiagram
#'
#' @examples
#' ## Load data
#' library('derfinder')
#'
#' ## Annotate regions
#' annotatedRegions <- annotateRegions(regions = genomeRegions$regions, 
#'     genomicState = genomicState$fullGenome, minoverlap = 1)
#'
#' ## Make venn diagram
#' venn <- vennRegions(annotatedRegions)
#'
#' ## Add title and choose text color
#' venn2 <- vennRegions(annotatedRegions, main = 'Venn diagram', counts.col = 
#'     'blue')
#'
#' ## Subset to only significant regions, so you don't have to annotate them
#' ## again
#' venn3 <- vennRegions(annotatedRegions, subsetIndex = 
#'     genomeRegions$regions$significant == 'TRUE', main = 'Significant only') 

vennRegions <- function(annotatedRegions, subsetIndex = NULL, ...) {
    
    ## Check input
    stopifnot('countTable' %in% names(annotatedRegions))
    
    ## Subset if necessary
    if(!is.null(subsetIndex)) {
        annotatedRegions$countTable <- annotatedRegions$countTable[subsetIndex, ]
    }
    
    ## Get venn counts
    vennInfo <- vennCounts(annotatedRegions$countTable > 0)
    
    ## Make plot
	vennDiagram(vennInfo, ...)
    
    ## Return data
    return(vennInfo)
}