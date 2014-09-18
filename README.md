derfinderPlot [![Build Status](https://travis-ci.org/lcolladotor/derfinderPlot.png?branch=master)](https://travis-ci.org/lcolladotor/derfinderPlot)
=============

Addon package with plotting functions for
[derfinder](https://github.com/lcolladotor/derfinder) results.

# Installation instructions

Get R 3.1.1 or newer from [CRAN](http://cran.r-project.org/).

```R
## If needed
install.packages('devtools')

## Pre-requisites from CRAN
install.packages(c('ggplot2', 'reshape2', 'plyr', 'RColorBrewer', 'scales', 
    'testthat'))

## Pre-requisites from Bioconductor
source('http://bioconductor.org/biocLite.R')
biocLite(c('IRanges', 'GenomicRanges', 'bumphunter', 'biovizBase', 'ggbio',
    'TxDb.Hsapiens.UCSC.hg19.knownGene', 'GenomeInfoDb'))

## derfinder
library('devtools')
install_github('lcolladotor/derfinder@master')
# More details at https://github.com/lcolladotor/derfinder/blob/master/README.md

## derfinderPlot itself
install_github('lcolladotor/derfinderPlot')
```

# Citation

Use [derfinder's citation](https://github.com/lcolladotor/derfinder#citation) information.


# Travis CI

This package is automatically tested thanks to [Travis CI](travis-ci.org) and [r-travis](https://github.com/craigcitro/r-travis). If you want to add this to your own package use:

```R
## Use devtools to create the .travis.yml file
library('devtools')
use_travis('yourPackage')

## Read https://github.com/craigcitro/r-travis/wiki to configure .travis.yml appropriately

## Add a status image by following the info at http://docs.travis-ci.com/user/status-images/
```
