skip_if_offline("db.vespawatch.be")
test_that("login_vespadb() returns error on bad username/password", {
  expect_error(
    login_vespadb(username = "not a username", password = "not a pwd"),
    "Invalid username or password. Please try again.",
    fixed = TRUE
  )
})
