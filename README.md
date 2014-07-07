derfinderPlot
=============

Addon package with plotting functions for
[derfinder](https://github.com/lcolladotor/derfinder) results.

# Installation instructions

Get R 3.1 or newer from [CRAN](http://cran.r-project.org/).

```S
## If needed
install.packages("devtools")

## Pre-requisites from CRAN
install.packages(c("ggplot2", "reshape2", "plyr", "RColorBrewer", "scales"))

## Pre-requisites from Bioconductor
source("http://bioconductor.org/biocLite.R")
biocLite(c("IRanges", "GenomicRanges", "bumphunter", "biovizBase", "ggbio",
    "TxDb.Hsapiens.UCSC.hg19.knownGene", "GenomeInfoDb"))

## derfinderPlot itself
library("devtools")
install_github("lcolladotor/derfinderPlot")
```

# Citation

Use [derfinder's citation](https://github.com/lcolladotor/derfinder#citation) information.
