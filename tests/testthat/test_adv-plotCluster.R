## Setup
library('derfinder')
library('TxDb.Hsapiens.UCSC.hg19.knownGene')

## Find nearest annotation with bumphunter::matchGenes()
library('bumphunter')
library('TxDb.Hsapiens.UCSC.hg19.knownGene')
genes <- annotateTranscripts(txdb = TxDb.Hsapiens.UCSC.hg19.knownGene)
annotation <- matchGenes(x = genomeRegions$regions, subject = genes)

#### This is a detailed example for a specific cluster of candidate DERs
## The purpose is to illustrate how data filtering (and availability), 
## F-stat cutoff, cluster cutoff interact into determing the candidate DERs.

## Collapse the coverage information
collapsedFull <- collapseFullCoverage(list(genomeDataRaw), verbose=TRUE)

## Calculate library size adjustments
sampleDepths <- sampleDepth(collapsedFull, probs=c(0.5), nonzero=TRUE, 
    verbose=TRUE)

## Build the models
adjustvars <- data.frame(genomeInfo$gender)
models <- makeModels(sampleDepths, testvars=genomeInfo$pop, 
    adjustvars=adjustvars)

## Preprocess the data
prep <- preprocessCoverage(genomeData, cutoff=0, scalefac=32, 
    chunksize=NULL, colsubset=NULL, mc.cores=1)

## Get the F statistics
fstats <- calculateStats(prep, models, mc.cores=1, verbose=FALSE)

## Using as example candidate DER #7
## Note how despite having data and using a very small F-stat cutoff, some 
## regions with data are split into different DERs
pdf(file = 'advanced-plotCluster-example.pdf')
plotCluster(idx=7, regions=genomeRegions$regions, annotation=annotation, 
    coverageInfo=genomeDataRaw$coverage, groupInfo=genomeInfo$pop, 
    txdb=TxDb.Hsapiens.UCSC.hg19.knownGene)

## Identify DERs clusters and regions of the genome where we have data
clusters <- derfinder:::.clusterMakerRle(prep$position, ranges=TRUE)
dataRegions <- derfinder:::.clusterMakerRle(prep$position, maxGap=0, 
ranges=TRUE)

## Apply F-stat cutoff of 1
segs <- derfinder:::.getSegmentsRle(fstats, 1)$upIndex

## Separate the sections that passed the F-stat cutoff by regions in the 
## genome
library('IRanges')
pieces <- disjoin(c(segs, dataRegions))

## The DERs are actually the following ones:
ders <- pieces[queryHits(findOverlaps(pieces, segs))]
## You can very that this is the case:
identical(width(ders), width(sort(ranges(genomeRegions$regions))))

## Ranges plotting function (from IRanges documentation)
plotRanges <- function(x, xlim = x, main = deparse(substitute(x)), col = 
    'black', sep = 0.5, ...) {
    height <- 1
    if (is(xlim, 'Ranges')) 
    xlim <- c(min(start(xlim)), max(end(xlim)))
    bins <- disjointBins(IRanges(start(x), end(x) + 1))
    plot.new()
    plot.window(xlim, c(0, max(bins) * (height + sep)))
    ybottom <- bins * (sep + height) - height
    rect(start(x) - 0.5, ybottom, end(x) + 0.5, ybottom + height, col = col, 
        ...)
    title(main)
    axis(1)
}

## Visualize the different DER clusters
plotRanges(clusters)
## Note that region 7 is part of cluster #5.
genomeRegions$regions$cluster[7]

clus.range <- c(min(genomeRegions$regions[ genomeRegions$regions$cluster == 
    5]$indexStart), max(genomeRegions$regions[ genomeRegions$regions$cluster
    == 5]$indexEnd))

## Plot the different segmentation steps, the final DERs, and the fstats 
## with the cutoff
par(mfrow=c(5, 1))
plotRanges(dataRegions, xlim=clus.range)
plotRanges(segs, xlim=clus.range)
plotRanges(pieces, xlim=clus.range)
plotRanges(ders, xlim=clus.range)
f <- as.numeric(fstats)
plot(f, type='l', xlim=clus.range)
abline(h=1, col='red')
dev.off()

## We can see that the different data regions match with how 
## many sections of the genome have data in plotCluster(idx=7, ...)

## The F-stat cutoff applied to F-stats leads to 5 different segments 
## passing the cutoff.
## We can see this both in the F-stat panel as well as in the segs panel.

## Between the regions with data and the segments, we have lots
## of different pieces to take into account. 

## From the pieces, only 6 of them correspond to unique regions in
## the genome that passed the F-stat cutoff.

## They are the 6 different DERs we see in cluster 5 as shown in 
## plotCluster(idx=7, ...)

## So despite using a very low F-stat cutoff, with the intention of getting
## anything that had data (for illustrative purposes, in reality you will 
## want to use a higher cutoff), some regions were not considered to be 
## candidate DERs.


## Run numerical tests although an important part of this test is graphical
test_that('Advanced plot cluster', {
    expect_that(nrun(fstats), is_identical_to(358L))
    expect_that(range(fstats), is_equivalent_to(c(0.000317652753957216,
        22.340754110513)))
    expect_that(length(clusters), is_identical_to(11L))
    expect_that(length(dataRegions), is_identical_to(33L))
    expect_that(length(segs), is_identical_to(24L))
    expect_that(length(pieces), is_identical_to(69L))
    expect_that(width(ders), is_identical_to(width(sort(ranges(genomeRegions$regions)))))
    expect_that(genomeRegions$regions$cluster[7], is_identical_to(Rle(5L, 1)))
    expect_that(clus.range, is_identical_to(c(353L, 469L)))
    expect_that(dir(pattern = 'pdf'), is_identical_to('advanced-plotCluster-example.pdf'))
})
