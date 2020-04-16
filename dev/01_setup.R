## Create the dev directory
dir.create('dev')
file.create('dev/01_setup.R')
rstudioapi::navigateToFile('dev/01_setup.R')

## Ignore the dev directory
system('echo dev >> .Rbuildignore')

## Remove travis
unlink('.travis.yml')

## GitHub tests
usethis::use_github_action('check-standard')
usethis::use_github_action("test-coverage")

## pkgdown setup
usethis::use_pkgdown()
usethis::use_github_action('pkgdown')

## Support files
usethis::use_readme_rmd() ## Edit with original README.md contents
# usethis::use_news_md()
usethis::use_tidy_coc()
usethis::use_tidy_contributing()


usethis::use_tidy_support()
## Update
support <- readLines('.github/SUPPORT.md')
support <- gsub('\\[community.rstudio.com\\]\\(https://community.rstudio.com/\\), and/or StackOverflow', 'the [Bioconductor Support Website](https://support.bioconductor.org/) using the appropriate package tag', support)
writeLines(support, '.github/SUPPORT.md')

## Use my own ISSUE template, modified from https://github.com/lcolladotor/osca_LIIGH_UNAM_2020
file.copy(from = '~/Dropbox/code/derfinderPlot/.github/ISSUE_TEMPLATE', to = '.github/ISSUE_TEMPLATE')
usethis::use_lifecycle_badge('Stable')
usethis::use_bioc_badge()

## Tests
usethis::use_coverage()

## GitHub badges
usethis::use_github_actions_badge()
usethis::use_github_actions_badge('test-coverage')
usethis::use_github_actions_badge('pkgdown')


