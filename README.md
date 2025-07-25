
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

## Examples

There are two options to get data out of vespa-db. The fastest way is to
fetch the most recent export file. This file is generated every day at
around 4AM Brussels time.

``` r
library(vespadbImportR)
get_vespadb_export_s3()
#> Warning: One or more parsing issues, call `problems()` on your data frame for details,
#> e.g.:
#>   dat <- vroom(...)
#>   problems(dat)
#> # A tibble: 22,653 × 27
#>       id observation_datetime latitude longitude province     municipality anb  
#>    <dbl> <dttm>                  <dbl>     <dbl> <chr>        <chr>        <lgl>
#>  1 14861 2025-04-11 10:59:00      51.0      3.38 West-Vlaand… Wingene      FALSE
#>  2 14862 2025-04-11 00:00:00      51.1      4.62 Antwerpen    Nijlen       FALSE
#>  3 14863 2025-04-11 11:14:00      51.2      4.43 Antwerpen    Antwerpen    FALSE
#>  4 14865 2025-04-10 13:57:00      50.9      2.90 West-Vlaand… Ieper        FALSE
#>  5 14866 2025-04-10 00:00:00      51.2      3.20 West-Vlaand… Brugge       FALSE
#>  6 14867 2025-04-10 20:29:00      50.8      4.92 Vlaams Brab… Tienen       FALSE
#>  7 14868 2025-04-10 20:01:00      51.1      3.56 Oost-Vlaand… Lievegem     FALSE
#>  8 14869 2025-04-10 18:53:00      50.9      5.38 Limburg      Hasselt      FALSE
#>  9 14870 2025-04-10 17:40:00      51.1      4.46 Antwerpen    Kontich      FALSE
#> 10 14871 2025-04-10 16:07:00      50.9      4.36 Vlaams Brab… Grimbergen   FALSE
#> # ℹ 22,643 more rows
#> # ℹ 20 more variables: nest_status <chr>, eradication_date <date>,
#> #   eradication_result <chr>, images <chr>, nest_type <chr>,
#> #   nest_location <chr>, nest_height <chr>, nest_size <chr>,
#> #   queen_present <lgl>, moth_present <lgl>, duplicate_nest <lgl>,
#> #   other_species_nest <lgl>, notes <lgl>, source <chr>, source_id <dbl>,
#> #   wn_id <dbl>, wn_validation_status <chr>, wn_cluster_id <dbl>, …
```

Alternativly you can also send queries to the database direclty and get
live data back. This is much slower.

``` r
get_vespadb_obs(
  municipality_id = 201,
  min_observation_datetime = "2025-07-01T00:00:00"
)
#> # A tibble: 4 × 30
#>      id created_datetime    modified_datetime   location$type source   source_id
#>   <int> <chr>               <chr>               <chr>         <chr>    <lgl>    
#> 1 40568 2025-07-06T02:00:06 2025-07-07T08:14:14 Point         Waarnem… NA       
#> 2 40937 2025-07-09T02:00:05 2025-07-18T01:30:00 Point         Waarnem… NA       
#> 3 41113 2025-07-11T02:00:04 2025-07-11T02:00:08 Point         Waarnem… NA       
#> 4 42445 2025-07-23T02:00:14 2025-07-23T02:00:17 Point         Waarnem… NA       
#> # ℹ 25 more variables: location$coordinates <list>, nest_height <chr>,
#> #   nest_size <chr>, nest_location <chr>, nest_type <chr>,
#> #   observation_datetime <chr>, eradication_date <chr>, municipality <int>,
#> #   queen_present <lgl>, moth_present <lgl>, province <int>, images <list>,
#> #   municipality_name <chr>, notes <lgl>, eradication_result <chr>,
#> #   wn_id <int>, wn_validation_status <chr>, anb <lgl>, visible <lgl>,
#> #   wn_cluster_id <lgl>, nest_status <chr>, duplicate_nest <lgl>, …
```
