#' Get parameters for a given path in the vespa-db openAPI docs
#'
#' This function will return you the allowed parameters for a given API call. By
#' default it will return all fields allowed in a [get_vespadb_obs()] query.
#'
#' @param path The endpoint to get the parameters for, only GET endpoints are
#'   supported.
#' @param domain The domain to login to. Default is "uat" for the UAT
#'   environment.
#' @param request_type The type of request to get the parameters for, either
#'   "get" or "post".
#'
#' @return A tibble with the parameters for the given path.
#'
#' @examplesIf interactive()
#' get_params()
get_params <- function(path = "observations",
                       request_type = "get",
                       domain = c("production", "uat")) {
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
