
test_that("stac_validate", {
  ex <- paste0("https://raw.githubusercontent.com/",
               "radiantearth/stac-spec/master/examples/",
               "extended-item.json")

  skip_if_not(reticulate::py_module_available("stac_validator"))

  valid <- stac_validate(ex)
  expect_true(valid)

})
