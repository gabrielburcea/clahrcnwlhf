library(clahrcnwlhf)
context("Linking diagnostics")

test_that("prev.spell and next.spell columns are correctly created by nearest_spells",{

  load("datafortesting/bundle_link_test_data.Rda")

  # Set up correct results - note this based on the test file created by create_bundle_link_test_dataset
  # in test_bundle_linking.R
  correct_results <- bundle_link_test_data
  correct_results$prev.spell <- NA
  correct_results$next.spell <- NA

  correct_results[correct_results$PseudoID == 1217659, "prev.spell"] <- 179895
  correct_results[correct_results$PseudoID == 1132437, "prev.spell"] <- 108960
  correct_results[correct_results$PseudoID == 1241298, "prev.spell"] <- 199432
  correct_results[correct_results$PseudoID == 1062983, "prev.spell"] <- NA

  correct_results[correct_results$PseudoID == 1217659, "next.spell"] <- 179896
  correct_results[correct_results$PseudoID == 1132437, "next.spell"] <- 108961
  correct_results[correct_results$PseudoID == 1241298, "next.spell"] <- NA
  correct_results[correct_results$PseudoID == 1062983, "next.spell"] <- 51934

  bundles_with_nearest_spells <- nearest_spells(bundles = bundle_link_test_data, episodes = clahrcnwlhf::emergency_adms)

  # Check the output columns exist
  expect_match(colnames(bundles_with_nearest_spells), "prev.spell", all = FALSE)
  expect_match(colnames(bundles_with_nearest_spells), "next.spell", all = FALSE)

  # Check the values returned in these columns are correct
  expect_equal(bundles_with_nearest_spells[bundles_with_nearest_spells$PseudoID == 1217659, "prev.spell"], correct_results[correct_results$PseudoID == 1217659, "prev.spell"])
  expect_equal(bundles_with_nearest_spells[bundles_with_nearest_spells$PseudoID == 1132437, "prev.spell"], correct_results[correct_results$PseudoID == 1132437, "prev.spell"])
  expect_equal(bundles_with_nearest_spells[bundles_with_nearest_spells$PseudoID == 1241298, "prev.spell"], correct_results[correct_results$PseudoID == 1241298, "prev.spell"])
  expect_equal(bundles_with_nearest_spells[bundles_with_nearest_spells$PseudoID == 1062983, "prev.spell"], correct_results[correct_results$PseudoID == 1062983, "prev.spell"])

  expect_equal(bundles_with_nearest_spells[bundles_with_nearest_spells$PseudoID == 1217659, "next.spell"], correct_results[correct_results$PseudoID == 1217659, "next.spell"])
  expect_equal(bundles_with_nearest_spells[bundles_with_nearest_spells$PseudoID == 1132437, "next.spell"], correct_results[correct_results$PseudoID == 1132437, "next.spell"])
  expect_equal(bundles_with_nearest_spells[bundles_with_nearest_spells$PseudoID == 1241298, "next.spell"], correct_results[correct_results$PseudoID == 1241298, "next.spell"])
  expect_equal(bundles_with_nearest_spells[bundles_with_nearest_spells$PseudoID == 1062983, "next.spell"], correct_results[correct_results$PseudoID == 1062983, "next.spell"])

})


test_that("bundle.in.spell column is correctly created by bundle_in_spell",{

  load("datafortesting/bundle_link_test_data.Rda")

  # Set up correct results - note this based on the test file created by create_bundle_link_test_dataset
  # in test_bundle_linking.R
  correct_results <- bundle_link_test_data
  correct_results$bundle.in.spell <- NA
  correct_results[correct_results$PseudoID == 1217659, "bundle.in.spell"] <- TRUE
  correct_results[correct_results$PseudoID == 1132437, "bundle.in.spell"] <- TRUE
  correct_results[correct_results$PseudoID == 1241298, "bundle.in.spell"] <- TRUE
  correct_results[correct_results$PseudoID == 1062983, "bundle.in.spell"] <- NA
  correct_results[correct_results$PseudoID == 1076292, "bundle.in.spell"] <- FALSE

  # Run the bundle_in_spell function
  bundles_with_in_spell <- bundle_in_spell(bundle_link_test_data)

  # Check the output column exists
  expect_match(colnames(bundles_with_in_spell), "bundle.in.spell", all = FALSE)

  # Check the values returned in these columns are correct
  expect_equal(bundles_with_in_spell[bundles_with_in_spell$PseudoID == 1217659, "bundle.in.spell"], correct_results[correct_results$PseudoID == 1217659, "bundle.in.spell"])
  expect_equal(bundles_with_in_spell[bundles_with_in_spell$PseudoID == 1132437, "bundle.in.spell"], correct_results[correct_results$PseudoID == 1132437, "bundle.in.spell"])
  expect_equal(bundles_with_in_spell[bundles_with_in_spell$PseudoID == 1241298, "bundle.in.spell"], correct_results[correct_results$PseudoID == 1241298, "bundle.in.spell"])
  expect_equal(bundles_with_in_spell[bundles_with_in_spell$PseudoID == 1062983, "bundle.in.spell"], correct_results[correct_results$PseudoID == 1062983, "bundle.in.spell"])
  expect_equal(bundles_with_in_spell[bundles_with_in_spell$PseudoID == 1076292, "bundle.in.spell"], correct_results[correct_results$PseudoID == 1076292, "bundle.in.spell"])

})


test_that("bundle_spell_lag function returns lag distributions",{

  load("datafortesting/bundle_link_test_data.Rda")

  # TODO: Write correct results here
  # ...

  # Run the function
  ldist <- bundle_spell_lag(bundles = bundle_link_test_data)

  # Check result has a column called "frequency"
  expect_match(colnames(ldist), "frequency", all = FALSE)

  # TODO: Write expectations on results here
  # ...

})