skip_if_offline("db.vespawatch.be")
test_that("get_vespadb_obs() returns tibble with the expected fields", {
  vespadb_obs <-
    get_vespadb_obs(municipality_id = 211,
                    min_observation_datetime = "2025-07-01T00:00:00",
                    max_observation_datetime = "2025-07-5T00:00:00")
  expect_s3_class(vespadb_obs, "tbl_df")
  expect_type(vespadb_obs, "list")
  expect_named(
    vespadb_obs,
    c(
      "id",
      "created_datetime",
      "modified_datetime",
      "location",
      "source",
      "source_id",
      "nest_height",
      "nest_size",
      "nest_location",
      "nest_type",
      "observation_datetime",
      "eradication_date",
      "municipality",
      "queen_present",
      "moth_present",
      "province",
      "images",
      "municipality_name",
      "notes",
      "eradication_result",
      "wn_id",
      "wn_validation_status",
      "anb",
      "visible",
      "wn_cluster_id",
      "nest_status",
      "duplicate_nest",
      "other_species_nest",
      "created_by_first_name",
      "modified_by_first_name"
    )
  )
})

test_that("get_vespadb_obs() returns error when bad query field is entered", {
  expect_error(
    get_vespadb_obs(not_a_query_field = "some value"),
    regexp = "All query parameters need to be supported by the API"
  )
})

test_that("get_vespadb_obs() can return query result that requires paging", {
  expect_s3_class(
    get_vespadb_obs(min_observation_datetime = "2025-06-01T00:00:00",
                    max_observation_datetime = "2025-06-05T00:00:00"),
    "tbl_df"
  )
})

test_that("get_vespadb_obs() supports authentication to see non public fields", {

})
