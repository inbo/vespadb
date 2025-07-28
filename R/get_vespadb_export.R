#' get_vespadb_export
#'
#' This function returns all observations from the VespaDB API export.
#'
#' Daily around 4 AM a export is created from the VespaDB API and stored in S3.
#' This function retrieves the latest export from S3 and returns it as a tibble.
#'
#' This function is useful for getting a snapshot of the data in the VespaDB API
#' or for getting a large amount of data.
#'
#' @param domain The domain to query. Either "uat" for the testing instance, or
#'  "prod" for the production instance.
#'
#' @return A tibble with the observations from the VespaDB API export.
#'
#' @examples
#' \dontrun{
#' # Get the latest export from the VespaDB API
#' get_vespadb_export_s3()
#' # Get the latest export from the VespaDB API in the production instance
#' get_vespadb_export_s3(domain = "production")
#' }
#'
#' @export

get_vespadb_export <- function(domain = c("production", "uat")) {

  api_url <- switch(rlang::arg_match(domain),
                    uat = "https://uat-db.vespawatch.be/observations/",
                    production = "https://db.vespawatch.be/observations/"
  )

  httr2::request(api_url) |>
    httr2::req_url_path_append("export") |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::chuck("export_id") |>
    (\(export_id) {
      httr2::request(api_url) |>
        httr2::req_url_path_append("export_status") |>
        httr2::req_url_query(export_id = export_id)
    })() |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_progress() |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::chuck("download_url") |>
    readr::read_csv(show_col_types = FALSE,
                    progress = FALSE
                    )
}
