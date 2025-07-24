#' This fn also returns invisible obs

get_vespadb_export_s3 <- function(domain = c("uat", "production")) {
  
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
