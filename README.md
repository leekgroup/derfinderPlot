derfinderPlot [![Build Status](https://travis-ci.org/lcolladotor/derfinderPlot.png?branch=master)](https://travis-ci.org/lcolladotor/derfinderPlot)
=============

Addon package with plotting functions for
[derfinder](https://github.com/lcolladotor/derfinder) results.

# Installation instructions

Get R 3.1.1 or newer from [CRAN](http://cran.r-project.org/).

```R
## From Bioconductor
source('http://bioconductor.org/biocLite.R')
biocLite('derfinderPlot')
```

# Vignette

The vignette for this package can be viewed [here](http://lcolladotor.github.io/derfinderPlot/). If you want to re-build the vignette when installing this package, you will need to use:

```R
## Install building the vignette
install_github('lcolladotor/derfinderPlot', build_vignettes = TRUE)
```

Note that this can take much longer than installing the package without the vignette.

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
