test_that("get_vespadb_export() returns a tibble", {
  skip_if_offline("db.vespawatch.be")

  expect_s3_class(
    get_vespadb_export(domain = "production"),
    "tbl_df"
  )
  expect_type(
    get_vespadb_export(domain = "production"),
    "list"
  )
})

test_that("get_vespadb_export() should not return visible == FALSE records",{
  skip_if_offline("db.vespawatch.be")

  # No visible column should be included.
  expect_false(
    "visible" %in% colnames(get_vespadb_export(domain = "production"))
  )
})
