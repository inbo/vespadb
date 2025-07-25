
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vespadbImportR

<!-- badges: start -->

[![Project Status: WIP - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![R-CMD-check](https://github.com/inbo/vespadbImportR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/inbo/vespadbImportR/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/inbo/vespadbImportR/graph/badge.svg)](https://app.codecov.io/gh/inbo/vespadbImportR)
<!-- badges: end -->

## What is vespa-db

vespa-db is a database created by
[vespawatch](https://vespawatch.be/en/) to make *Vespa velutina*
**nest** observations available in as near as real time as possible.

The platform contains observations from different sources, but currently
only new observations are added from
\[waarnemingen.be)\[<https://waarnemingen.be/>\]. In order for an
observation to be included in vespa-db, it needs to have the following
properties:

- It has to currently be **identified** to *Vespa velutina* or a
  subspiecies thereof.
- It has to have the activity: **Nest** (no observations of individuals
  are included)
- It has to be **validated** by a validator, which means it has to have
  a photo. Automatically validated (based on location and likelyhood)
  observations are not included.

## How did this package come to be

This package was initially written by @PietrH in the context of
importing historical data into vespa-db. For matching and validation
purposes it was convenient to wrap the api into functions so imports and
matching could be quickly tested. This original code resides in the
private repository: inbo/vespaR.

Later on a need arose to query the vespa-db api again, and the original
code was moved here for more broad reuse.

## Installation

You can install the development version of vespadbImportR from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("inbo/vespadbImportR")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(vespadbImportR)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
