#' Get the municipality ids.
#'
#' This function either returns a complete overview of all municipality ids. Or
#' if one or more municipalities are passed, the id's for these municipalities.
#'
#' @param municipalities (Optional) A character vector of municipality names. If
#'   this is not provided, all municipalities will be returned as a tibble with
#'   their ids.
#'
#' @return Either a numeric vector of ids, or if no argument is passed, a tibble
#'   with all municipalities and their id.
#' @export
#'
#' @examples
#' municipalities("Gent")
#' municipalities(c("Gent", "Kortrijk"))
#' municipalities()
municipalities <- function(municipalities = NULL,
                           domain = c("production", "uat")) {
  api_url <- switch(rlang::arg_match(domain),
    production = "https://db.vespawatch.be",
    uat = "https://uat.db.vespawatch.be"
  )

  # Fetch all municipalities
  municipalities_overview <- httr2::request(api_url) %>%
    httr2::req_url_path_append("municipalities") %>%
    httr2::req_perform() %>%
    httr2::resp_body_json(simplifyVector = TRUE)

  if (is.null(municipalities)) {
    dplyr::relocate(municipalities_overview,
      municipality = name,
      .before = "id"
    ) %>%
      dplyr::as_tibble() # for pretty printing
  } else {
    assertthat::assert_that(all(municipalities %in% municipalities_overview$name),
    msg = glue::glue(
      "The following municipalities were not found: {setdiff(municipalities, municipalities_overview$name)}"
    ))

    dplyr::filter(municipalities_overview, .data$name %in% municipalities) %>%
      dplyr::pull(id)
  }
}
