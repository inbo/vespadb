# vespadb-importR A package to access the public vespa-db api using R.

## What is vespa-db

vespa-db is a database created by [vespawatch](https://vespawatch.be/en/) to make *Vespa velutina* **nest** observations available in as near as real time as possible.

The platform contains observations from different sources, but currently only new observations are added from [waarnemingen.be)[<https://waarnemingen.be/>]. In order for an observation to be included in vespa-db, it needs to have the following properties:

-   It has to currently be **identified** to *Vespa velutina* or a subspiecies thereof.
-   It has to have the activity: **Nest** (no observations of individuals are included)
-   It has to be **validated** by a validator, which means it has to have a photo. Automatically validated (based on location and likelyhood) observations are not included.

## How did this package come to be

This package was initially written by @PietrH in the context of importing historical data into vespa-db. For matching and validation purposes it was convenient to wrap the api into functions so imports and matching could be quickly tested. This original code resides in the private repository: inbo/vespaR.

Later on a need arose to query the vespa-db api again, and the original code was moved here for more broad resuse.

## Installation

You can install the development version directly from Github:
```r
# install.packages("devtools")
devtools::install_github("inbo/vespadbImportR")
```
