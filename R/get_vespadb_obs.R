#' Query the vespa-db api to get observations
#'
#' Extra query parameters are supported according to the Observation model. More
#' information on the allowed parameters can be fetched via
#' [get_field_definitions()].
#'
#' This function already handles paging, so supplying a page as a parameter is
#' not allowed. For a more low level function to fetch results see
#' [fetch_result()].
#'
#' @param domain Character. The domain to login to. Default is "uat" for the UAT
#'   environment.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Query parameters according to
#'   the observation model.
#' @param auth Character. Path to the authentication cookie to use. By default a
#'   request without authentication is placed (public data only). The
#'   authentication cookie can be created using [login_vespadb()] which returns
#'   the path to the cookie.
#'
#' @return A tibble with the observations from the VespaDB API.
#'
#' @examples
#' # All public records
#' get_vespadb_obs()
#'
#' # Public records from Ghent
#' get_vespadb_obs(municipality_id = 215)
#'
#' # Public and private information from Ghent, only ANB plots
#' get_vespadb_obs(
#'   municipality_id = 215,
#'   anb = "true",
#'   auth = login_vespadb()
#' )
get_vespadb_obs <- function(..., auth = NULL, domain = c("uat","production")) {
  # Set the api to query to either the UAT (testing) instance, or the production
  # instance
  api_url <- switch(rlang::arg_match(domain),
    uat = "https://uat-db.vespawatch.be/observations/",
    production = "https://db.vespawatch.be/observations/"
  )

  # Wrapped by advice from ?rlang::list2()
  {
    query_params <- rlang::list2(...)
  }

  # Check if all query parameters are in the model, don't warn if there are no
  # required fields
  expected_query_parameters <-
    get_params(domain = domain, path = "observations", request_type = "get") %>%
    dplyr::pull("name")

  assertthat::assert_that(
    all(names(query_params) %in% expected_query_parameters),
    msg = glue::glue("All query parameters need to be supported by the API. \n",
      "unsupported: {unsupported_parameters}",
      unsupported_parameters =
        glue::glue_collapse(
          names(query_params)[!names(query_params) %in%
            expected_query_parameters],
          sep = ", ",
          last = " & "
        )
    )
  )

  # Create the responses and perform them sequentially, parallel execution
  # doesn't allow for retries in httr2. Then parse as a tibble.
  
  ## Use the cursor to avoid having to wait longer for high page numbers
  initial_return <- fetch_result(api_url,
                                 .query_params = query_params,
                                 .auth = auth)
  next_page <- initial_return$`next`
  api_out <- list(initial_return)
  # Init the a progress bar
  cli::cli_progress_bar("Fetching observations from vespa-db")
  # Init a counter to avoid append(): faster not to append large objects
  i <- 2 # First page was fetched in initial request
  while(!is.null(next_page)){
    # Request the next page
    api_response <- httr2::request(next_page) %>%
      httr2::req_retry(max_tries = 5,
                       is_transient = \(resp) {
                         # Also retry on bad gateway: seems to be transient.
                         httr2::resp_status(resp) %in% c(429, 500, 502, 503)}) %>%
      httr2::req_perform() %>% 
      httr2::resp_body_json(simplifyVector = TRUE)
    # Store the api_response
    api_out[[i]] <- api_response
    i <- i + 1 # Update the counter
    # Store the cursor for the following request
    next_page <- api_response$`next`
    # Update the progress bar: increment with the returned number of records
    cli::cli_progress_update(force = FALSE,
                             inc = nrow(api_response$results)
                             )
  }
  
  # Get the result objects out
  purrr::map(api_out, purrr::chuck("results")) |>
    purrr::list_rbind() |>
    dplyr::as_tibble()
}
