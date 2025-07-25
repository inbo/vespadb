test_that("get_observation_parameters() returns a tibble", {
  skip_if_offline("db.vespawatch.be")
  expect_s3_class(get_observation_parameters(), "tbl_df")
})

test_that("get_observation_parameters() returns the expected fields", {
  skip_if_offline("db.vespawatch.be")
  expected_fields <- c(
    "name",
    "in",
    "description",
    "required",
    "type",
    "format",
    "default",
    "items",
    "example",
    "maxItems",
    "minItems"
  )

  expect_named(get_observation_parameters(), expected_fields)
})
