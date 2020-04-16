
<!-- README.md is generated from README.Rmd. Please edit that file -->

# derfinderPlot

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![BioC
status](http://www.bioconductor.org/shields/build/release/bioc/derfinderPlot.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/derfinderPlot)
[![Codecov test
coverage](https://codecov.io/gh/leekgroup/derfinderPlot/branch/master/graph/badge.svg)](https://codecov.io/gh/leekgroup/derfinderPlot?branch=master)
[![R build
status](https://github.com/leekgroup/derfinderPlot/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/leekgroup/derfinderPlot/actions)
<!-- badges: end -->

Addon package with plotting functions for
[derfinder](http://www.bioconductor.org/packages/derfinder) results.

## Documentation

For more information about `derfinderPlot` check the vignettes [through
Bioconductor](http://bioconductor.org/packages/derfinderPlot) or at the
[documentation website](http://leekgroup.github.io/derfinderPlot).

## Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `derfinderPlot` using
from [Bioconductor](http://bioconductor.org/) the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("derfinderPlot")
```

## Citation

Below is the citation output from using `citation('derfinderPlot')` in
R. Please run this yourself to check for any updates on how to cite
**derfinderPlot**.

``` r
print(citation('derfinderPlot'), bibtex = TRUE)
#> 
#> Collado-Torres L, Jaffe AE, Leek JT (2017). _derfinderPlot: Plotting
#> functions for derfinder_. doi: 10.18129/B9.bioc.derfinderPlot (URL:
#> https://doi.org/10.18129/B9.bioc.derfinderPlot),
#> https://github.com/leekgroup/derfinderPlot - R package version 1.21.0,
#> <URL: http://www.bioconductor.org/packages/derfinderPlot>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {derfinderPlot: Plotting functions for derfinder},
#>     author = {Leonardo Collado-Torres and Andrew E. Jaffe and Jeffrey T. Leek},
#>     year = {2017},
#>     url = {http://www.bioconductor.org/packages/derfinderPlot},
#>     note = {https://github.com/leekgroup/derfinderPlot - R package version 1.21.0},
#>     doi = {10.18129/B9.bioc.derfinderPlot},
#>   }
#> 
#> Collado-Torres L, Nellore A, Frazee AC, Wilks C, Love MI, Langmead B,
#> Irizarry RA, Leek JT, Jaffe AE (2017). "Flexible expressed region
#> analysis for RNA-seq with derfinder." _Nucl. Acids Res._. doi:
#> 10.1093/nar/gkw852 (URL: https://doi.org/10.1093/nar/gkw852), <URL:
#> http://nar.oxfordjournals.org/content/early/2016/09/29/nar.gkw852>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {Flexible expressed region analysis for RNA-seq with derfinder},
#>     author = {Leonardo Collado-Torres and Abhinav Nellore and Alyssa C. Frazee and Christopher Wilks and Michael I. Love and Ben Langmead and Rafael A. Irizarry and Jeffrey T. Leek and Andrew E. Jaffe},
#>     year = {2017},
#>     journal = {Nucl. Acids Res.},
#>     doi = {10.1093/nar/gkw852},
#>     url = {http://nar.oxfordjournals.org/content/early/2016/09/29/nar.gkw852},
#>   }
```

Please note that the `derfinderPlot` was only made possible thanks to
many other R and bioinformatics software authors, which are cited either
in the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the derfinderPlot project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Development tools

  - Testing on Bioc-devel is possible thanks to [GitHub actions through
    *\[usethis\](https://CRAN.R-project.org/package=usethis)*](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/).
  - Code coverage assessment is possible thanks to
    [codecov](https://codecov.io/gh).
  - The [documentation
    website](http://leekgroup.github.io/derfinderPlot) is automatically
    updated thanks to
    *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
