#' Show an overview of the available parameters for [get_vespadb_obs()]
#'
#' This function retrieves the parameters that can be used in the
#' [get_vespadb_obs()] function. It will return a tibble with the parameters
#' that can be used in the query.
#'
#' @inheritParams get_params
#' @param ... Additional parameters to internal methods.
#'
#' @return A tibble with the parameters that can be used in the
#' [get_vespadb_obs()] function.
#' @export
#'
#' @examplesIf interactive()
#' get_observation_parameters()
#'
#'
get_observation_parameters <- function(domain = c("production", "uat"),
                           ...) {
  # Set the api to query to either the UAT (testing) instance, or the production
  # instance
  api_url <- switch(rlang::arg_match(domain),
                    uat = "https://uat-db.vespawatch.be/swagger/?format=openapi",
                    production = "https://db.vespawatch.be/swagger/?format=openapi"
  )

  get_params(path = "observations", domain = domain, ...)
}
