context('Plotting functions')

# Setup
## Load data
library('derfinder')

## Annotate regions, first two regions only
regions <- genomeRegions$regions[1:2]
annotatedRegions <- annotateRegions(regions = regions, 
    genomicState = genomicState$fullGenome, minoverlap = 1)

## Find nearest annoation with bumphunter::matchGenes()
library('bumphunter')
library('TxDb.Hsapiens.UCSC.hg19.knownGene')
genes <- annotateTranscripts(txdb = TxDb.Hsapiens.UCSC.hg19.knownGene)
nearestAnnotation <- matchGenes(x = regions, subject = genes)

## Obtain fullCov object
fullCov <- list('21'=genomeDataRaw$coverage)

## Assign chr lengths using hg19 information
library('GenomicRanges')
data(hg19Ideogram, package = 'biovizBase', envir = environment())
seqlengths(regions) <- seqlengths(hg19Ideogram)[names(seqlengths(regions))]

## Get the region coverage
regionCov <- getRegionCoverage(fullCov=fullCov, regions=regions)

test_that('Region plots', {
    expect_that(plotRegionCoverage(regions=regions, regionCoverage=regionCov,
        groupInfo=genomeInfo$pop, nearestAnnotation=nearestAnnotation,
        annotatedRegions=data.frame('fail' = 1), whichRegions=1:2, ask=FALSE),
        throws_error())
    expect_that(plotRegionCoverage(regions=regions, regionCoverage=regionCov,
        groupInfo=genomeInfo$pop, nearestAnnotation=data.frame('fail' = 1),
        annotatedRegions=annotatedRegions, whichRegions=1:2, ask=FALSE),
        throws_error())
    expect_that(plotRegionCoverage(regions=regions, regionCoverage=regionCov,
        groupInfo=genomeInfo$pop, nearestAnnotation=GRanges('chr1', IRanges(1,
            2), 'fail' = 1),
        annotatedRegions=annotatedRegions, whichRegions=1:2, ask=FALSE),
        throws_error())
    expect_that(plotRegionCoverage(regions=regions, regionCoverage=regionCov,
        groupInfo=c('a', 'b'), nearestAnnotation=nearestAnnotation,
        annotatedRegions=annotatedRegions, whichRegions=1:2, ask=FALSE),
        throws_error())
    expect_that(plotRegionCoverage(regions=regions, regionCoverage=regionCov,
        groupInfo=genomeInfo$pop, nearestAnnotation=nearestAnnotation,
        annotatedRegions=annotatedRegions, whichRegions=1:3, ask=FALSE),
        gives_warning())
})
