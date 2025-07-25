#' Login to VespaDB API to fetch fields that are not publicly available
#'
#' This function allows you to login to the API and returns the required
#' csrftoken needed to fetch information that is not publicly available.
#'
#' @param username The username to login with, if not provided it will
#'  be read from the environment variable `VESPADB_USER`. If that is not set,
#'  you will be prompted to enter their username.
#' @param password The password to login with, if not provided it will
#' be read from the environment variable `VESPADB_PWD`. If that is not set,
#' you will be prompted to enter their password.
#' @param domain The domain to login to. Default is "production" for the UAT
#'   environment.
#'
#' @return The path to an authentication cookie.
#'
#' @examples
#' \dontrun{
#' get_vespadb_obs(municipality = 215,
#'                           auth = login_vespadb("username",
#'                                                "password"))
#' }
#' @export
login_vespadb <- function(username, password, domain = c("production", "uat")){
  api_url <- switch(rlang::arg_match(domain),
                    uat = "https://uat-db.vespawatch.be/login/",
                    production = "https://db.vespawatch.be/login/")

  if(missing(username)) {
    if (Sys.getenv("VESPADB_USER") != "") {
      username <- Sys.getenv("VESPADB_USER")
      cli::cli_alert_info("Found credentials for {username}")
    } else {
      username <- readline(prompt = "Please enter your vespadb username: ")
    }
  }

  if(missing(password)){
    if (Sys.getenv("VESPADB_PWD") != "") {
      password <- Sys.getenv("VESPADB_PWD")
    } else {
      password <- askpass::askpass()
    }
  }

  assertthat::assert_that(assertthat::is.string(username))
  assertthat::assert_that(assertthat::is.string(password))

  # Set path to store cookie on
  path_to_cookie <- tempfile()

  # Perform login POST request
  response <-
    httr2::request(api_url) %>%
    httr2::req_method("POST") %>%
    httr2::req_body_json(list(username = username, password = password)) %>%
    httr2::req_retry() %>%
    httr2::req_cookie_preserve(path = path_to_cookie) %>%
    httr2::req_perform()



  # Return error if login wasn't successful
  httr2::resp_check_status(response)

  invisible(path_to_cookie)
}
