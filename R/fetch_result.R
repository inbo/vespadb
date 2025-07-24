#' Fetches the result from a given URL with optional query parameters and
#' authentication.
#'
#' @param url The API endpoint to fetch the result from.
#' @param .query_params Optional query parameters to include in the request.
#' @param .auth Optional path to authentication cookie to use.
#' @param return_request If TRUE, the function returns the request object
#'   instead of the response.
#'
#' @return The response object or the request object if return_request is TRUE.
#'
#' @examples
#' # Fetch result from a URL
#' fetch_result("https://uat-db.vespawatch.be/observations/30608")
#'
#' # Fetch result with query parameters
#' fetch_result("https://uat-db.vespawatch.be/observations/",
#'              .query_params = list(municipality_id = 215))
#' # Return request object instead of response
#' fetch_result("https://uat-db.vespawatch.be/observations/30608",
#'             return_request = TRUE)
#'
fetch_result <- function(url,
                         .query_params = list(),
                         .auth = NULL,
                         return_request = FALSE) {
  request <- httr2::request(url) %>%
    httr2::req_url_query(!!!.query_params,
                         # Found out comma strategy by experimenting with
                         # swagger docs
                         .multi = "comma"
                         ) %>%
    httr2::req_retry(
      retry_on_failure = TRUE,
      max_tries = 4,
      backoff = ~ 1 # always wait one second for a failed request
    ) %>% 
    httr2::req_throttle(capacity = 50,
                        fill_time_s = 60)

  if (!is.null(.auth)) {
    request <- request %>%
      httr2::req_cookie_preserve(path = .auth)
  }

  if (return_request) {
    return(request)
  }

  response <- request %>%
    httr2::req_perform() %>%
    httr2::resp_body_json(simplifyVector = TRUE)
  return(response)
}
