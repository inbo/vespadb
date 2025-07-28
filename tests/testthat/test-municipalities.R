test_that("municipalities() returns tibble when no query is passed", {
  skip_if_offline("db.vespawatch.be")

  expect_s3_class(municipalities(), "tbl_df")
  expect_type(municipalities(), "list")
})


test_that("municipalities() returns numeric ids for valid municipality names", {
  skip_if_offline("db.vespawatch.be")

  expect_type(municipalities("Antwerpen"), "integer")
})

test_that("municipalities() returns known correct ids", {
  skip_if_offline("db.vespawatch.be")
  expect_identical(municipalities("Leuven"), 32L)

  random_municipalities <- dplyr::slice_sample(municipalities(), n = 9)

  mapply(
    function(municipality, id) {
      expect_identical(municipalities(municipality), id)
    },
    random_municipalities$municipality,
    random_municipalities$id
  )
})

test_that("municipalities() throws error for invalid municipality name", {
  skip_if_offline("db.vespawatch.be")
  expect_error(
    municipalities("Bromley"),
    regexp = "The following municipalities were not found: Bromley",
    fixed = TRUE
  )
})
