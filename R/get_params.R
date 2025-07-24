#' Get parameters for a given path in the vespa-db openAPI docs
#'
#' @param path The endpoint to get the parameters for, only GET endpoints are
#'   supported.
#' @param domain The domain to login to. Default is "uat" for the UAT environment.
#'
#' @return A tibble with the parameters for the given path.
#'
#' @examples
#' get_params()
get_params <- function(path = "observations",
                       request_type = "get",
                       domain = c("uat", "production")) {
  api_url <- switch(rlang::arg_match(domain),
    uat = "https://uat-db.vespawatch.be/swagger/?format=openapi",
    production = "https://db.vespawatch.be/swagger/?format=openapi"
  )

  assertthat::assert_that(tolower(request_type) %in% c("get", "post"))

  # Add braces to path as API expects
  path <- paste0("/", path, "/")

  # Set request type to lower
  request_type <- tolower(request_type)

  # Read the openAPI docs and get the parameters
  parameters <- httr2::request(api_url) %>%
    httr2::req_retry(max_tries = 5) %>%
    httr2::req_perform() %>%
    httr2::resp_body_json(simplifyVector = TRUE) %>%
    purrr::chuck("paths", "/observations/", request_type, "parameters")

  return(dplyr::as_tibble(parameters))
}
