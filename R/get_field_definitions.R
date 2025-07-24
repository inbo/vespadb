#' Get field definitions
#'
#' This function retrieves the field definitions for the vespa-db Observations
#' API schema
#'
#' @param domain The domain to query. Either "uat" for the testing instance, or
#'   "prod" for the production instance.
#' @param check_required Logical indicating whether to check if any fields are
#'   required. If no required fields are in the definition a warning is
#'   returned.
#'
#' @return A tibble with the field definitions.
#'
#' @examples
#' \dontrun{
#' # complete field definitions
#' get_field_definitions("prod")
#' get_field_definitions()
#'}
#'
#' @importFrom magrittr %>%
get_field_definitions <- function(domain = c("uat", "production"),
                                  check_required = TRUE){
  # Set the api to query to either the UAT (testing) instance, or the production
  # instance
  api_url <- ifelse(domain == rlang::arg_match(domain),
                    yes = "https://uat-db.vespawatch.be/swagger/?format=openapi",
                    no = "https://db.vespawatch.be/swagger/?format=openapi")

  ## Fetch Observation Definitions
  ### httr2 to enable retries and response caching
  obs_defs <-
    httr2::request(api_url) %>%
    httr2::req_retry(max_tries = 3) %>%
    httr2::req_cache(path = tempdir(),
                     max_age = 10 * 60) %>% # cache for 10 minutes
    httr2::req_perform() %>%
    httr2::resp_body_json()

  ## List required fields
  required_fields <-
    obs_defs %>%
    purrr::pluck("definitions", "Observation", "required") %>%
    unlist()

  if(is.null(required_fields) & check_required){
    warning("No required fields defined in Observation definitions!.")
  }

  ## Parse field definitions
  field_definitions <-
    jsonlite::read_json(api_url) %>%
    purrr::chuck("definitions", "Observation", "properties") %>%
    purrr::map(dplyr::as_tibble) %>%
    purrr::map2(., names(.), ~ dplyr::mutate(.x, field = .y)) %>%
    dplyr::bind_rows() %>%
    dplyr::group_by(dplyr::across(-enum)) %>%
    dplyr::summarise(enum = list(enum), .groups = "drop") %>%
    dplyr::mutate(required = field %in% required_fields) %>%
  ## Add R types
    dplyr::mutate(r_type = dplyr::case_match(type,
                                    "string" ~ "character",
                                    "boolean" ~ "logical",
                                    "object" ~ "list",
                                    "integer" ~ "integer",
                                    .default = NA_character_
    ))

  ## Return the field definitions

  return(field_definitions)
}
