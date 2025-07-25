test_that("get_field_definitions() returns a tibble with the right columns", {
  skip_if_offline("db.vespawatch.be")
  expect_type(get_field_definitions(), "list")
  expect_s3_class(get_field_definitions(), "tbl_df")
  expect_named(
    get_field_definitions(),
    c(
      "title",
      "type",
      "readOnly",
      "field",
      "description",
      "format",
      "x-nullable",
      "maxLength",
      "maximum",
      "minimum",
      "minLength",
      "enum",
      "required",
      "r_type"
    )
  )
})
