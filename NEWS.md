# derfinderPlot 1.21.2

SIGNIFICANT USER-VISIBLE CHANGES

* Switched from Travis to GitHub actions through usethis.
* Build the documentation website automatically with pkgdown.
* Added a dev/01_setup.R script.
* Now using a README.Rmd file.


# derfinderPlot 1.21.1

SIGNIFICANT USER-VISIBLE CHANGES

* Use GenomeInfoDb::getChromInfoFromUCSC() when possible instead of data
from biovizBase::hg19Ideogram for getting the hg19 chromosome lengths.


# derfinderPlot 1.19.3

* Added a `NEWS.md` file to track changes to the package.

# derfinderPlot 1.17.2


NEW FEATURES

* Add ORCID's following changes at
http://bioconductor.org/developers/package-guidelines/#description

# derfinderPlot 1.15.1


SIGNIFICANT USER-VISIBLE CHANGES

* Use BiocManager

# derfinderPlot 1.13.5


BUG FIXES

* Fixed an issue in `plotCluster()` on how it was loading the
`hg19IdeogramCyto` object from the `biovizBase` package.

# derfinderPlot 1.13.4


BUG FIXES

* Fixed an issue with a call to `GenomicRanges::gaps()` that affected
how the introns were plotting in `plotRegionCoverage()`
when the underlying data has a specifying start and end of the
chromosome (that is, a `seqinfo()` with `seqlengths` specified).
Thanks to Emily E Burke for reporting this issue
https://github.com/emilyburke.


# derfinderPlot 1.11.2


SIGNIFICANT USER-VISIBLE CHANGES

* Vignette now uses the new `BiocStyle::html_document()` that was recently
released.

# derfinderPlot 1.7.10


SIGNIFICANT USER-VISIBLE CHANGES

* Help pages now document advanced arguments.

# derfinderPlot 1.7.8


BUG FIXES

* Updated links to BrainSpan. Issue reported by Steve Semick
https://github.com/SteveSemick.

# derfinderPlot 1.7.1


SIGNIFICANT USER-VISIBLE CHANGES

* Dropped defunct functions.

# derfinderPlot 1.5.8


BUG FIXES

* `plotRegionCoverage()` used to take into account the strand of the regions
for finding transcripts that overlapped the regions. This was not a
problem with DERs from derfinder since they have strand `*` by default
but it is a problem when using it with stranded regions.
* `plotCluster()` will also now ignore strand for finding neighboring regions.

# derfinderPlot 1.5.4


SIGNIFICANT USER-VISIBLE CHANGES

* Only use distance if it's not `NA` in `plotRegionCoverage()`

# derfinderPlot 1.3.4


SIGNIFICANT USER-VISIBLE CHANGES

* Dropped `tMatrix()` because it was a confusing plot and also lead to build
errors.


# derfinderPlot 1.3.3


NEW FEATURES

* Added the function `tMatrix()` which uses a `GRanges` object that has a 
variable of interest to compute t-Statistics between bins of the genome.
For each bin, the values of the variable of interest from the regions
overlapping the bin are used. We use t-Statistics instead of correlation
because not all bins will have the same number of regions. This type of
plot is similar to interaction plots made for HiC data.

# derfinderPlot 1.3.2


NEW FEATURES

* Added the `vennRegions()` function to visualize how many regions overlap
known exons, introns, intergenic regions, none of them or several of 
these groups.


# derfinderPlot 1.3.1


SIGNIFICANT USER-VISIBLE CHANGES

* Deprecated functions with underscores in their names in favor of 
camelCase functions. This was done to simplify the package.

# derfinderPlot 1.1.6


SIGNIFICANT USER-VISIBLE CHANGES

* Adapted to work with `bumphunter` version >= 1.7.6

# derfinderPlot 1.1.3


BUG FIXES

* Adapted `plotCluster()` and `plotOverview()` to derfinder 1.1.5


# derfinderPlot 0.99.0


NEW FEATURES

* Preparing to submit to Bioconductor.
* Added tests and vignette.
    
SIGNIFICANT USER-VISIBLE CHANGES

* `plotOverview()` and `plotCluster()` can now plot FWER adjusted p-values if
calculated with `derfinder::mergeResults()`

# derfinderPlot 0.0.4


SIGNIFICANT USER-VISIBLE CHANGES

* Hid some arguments in `plotCluster()` and `plotOverview()` as advanced just
like in `derfinder` v0.0.74

BUG FIXES

* Improved the speed in `plotRegionCoverage()` then `txdb` is specified. Also
fixed the introns on the gene track.

# derfinderPlot 0.0.3


SIGNIFICANT USER-VISIBLE CHANGES

* `plotRegionCoverage()` now has a `txdb` argument. When specified, this 
function will extract the transcript information needed and display
the transcripts.


# derfinderPlot 0.0.1


SIGNIFICANT USER-VISIBLE CHANGES

* Moved plotting functions from derfinder into this package
