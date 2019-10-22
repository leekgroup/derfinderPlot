<a href="http://www.bioconductor.org/packages/release/bioc/html/derfinderPlot.html#since"><img border="0" src="http://www.bioconductor.org/shields/years-in-bioc/derfinderPlot.svg" title="How long since the package was first in a released Bioconductor version (or is it in devel only)."></a> <a href="https://bioconductor.org/packages/stats/bioc/derfinderPlot/"><img border="0" src="http://www.bioconductor.org/shields/downloads/derfinderPlot.svg" title="Percentile (top 5/20/50% or 'available') of downloads over last 6 full months. Comparison is done across all package categories (software, annotation, experiment)."></a> <a href="https://support.bioconductor.org/t/derfinderPlot/"><img border="0" src="http://www.bioconductor.org/shields/posts/derfinderPlot.svg" title="Support site activity, last 6 months: tagged questions/avg. answers per question/avg. comments per question/accepted answers, or 0 if no tagged posts."></a> <a href="http://www.bioconductor.org/packages/release/bioc/html/derfinderPlot.html#svn_source"><img border="0" src="http://www.bioconductor.org/shields/commits/bioc/derfinderPlot.svg" title="average Subversion commits (to the devel branch) per month for the last 6 months"></a>

Status: Travis CI [![Build Status](https://travis-ci.org/leekgroup/derfinderPlot.svg?branch=master)](https://travis-ci.org/leekgroup/derfinderPlot),
Bioc-release <a href="http://www.bioconductor.org/packages/release/bioc/html/derfinderPlot.html#archives"><img border="0" src="http://www.bioconductor.org/shields/availability/release/derfinderPlot.svg" title="Whether the package is available on all platforms; click for details."></a> <a href="http://bioconductor.org/checkResults/release/bioc-LATEST/derfinderPlot/"><img border="0" src="http://www.bioconductor.org/shields/build/release/bioc/derfinderPlot.svg" title="build results; click for full report"></a>,
Bioc-devel <a href="http://www.bioconductor.org/packages/devel/bioc/html/derfinderPlot.html#archives"><img border="0" src="http://www.bioconductor.org/shields/availability/devel/derfinderPlot.svg" title="Whether the package is available on all platforms; click for details."></a> <a href="http://bioconductor.org/checkResults/devel/bioc-LATEST/derfinderPlot/"><img border="0" src="http://www.bioconductor.org/shields/build/devel/bioc/derfinderPlot.svg" title="build results; click for full report"></a>.

Bioc-release <a href="https://bioconductor.org/developers/how-to/unitTesting-guidelines/#coverage"><img border="0" src="http://www.bioconductor.org/shields/coverage/release/derfinderPlot.svg" title="Test coverage percentage, or 'unknown'"></a>, Bioc-devel <a href="https://codecov.io/github/Bioconductor-mirror/derfinderPlot?branch=master"><img border="0" src="http://www.bioconductor.org/shields/coverage/devel/derfinderPlot.svg" title="Test coverage percentage, or 'unknown'"></a>, Codecov [![codecov.io](https://codecov.io/github/leekgroup/derfinderPlot/coverage.svg?branch=master)](https://codecov.io/github/leekgroup/derfinderPlot?branch=master)

derfinderPlot
=============

Addon package with plotting functions for
[derfinder](http://www.bioconductor.org/packages/derfinder) results.

# Installation instructions

Get R 3.5.x from [CRAN](http://cran.r-project.org/).

```R
## From Bioconductor
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("derfinderPlot")
```

# Vignette

The vignette for this package can be viewed via [Bioconductor's website](http://www.bioconductor.org/packages/derfinderPlot).

# Citation

Use [derfinder's citation](https://github.com/lcolladotor/derfinder#citation) information.


# Testing

Testing on Bioc-devel is feasible thanks to [R Travis](http://docs.travis-ci.com/user/languages/r/) as well as Bioconductor's nightly build.
