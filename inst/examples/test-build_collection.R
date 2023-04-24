## test build collection
test_that("collection builds correctly", {

  #template_folder <- system.file("example", package = "stac4cast")
  #source(file.path(template_folder, "R/test_build_prep.R"))

  source(system.file("examples/R/test_build_prep.R", package="stac4cast"))

  collection_out <- stac4cast::build_collection(id = id_info,
                 links = build_links(href_link = parent_url,
                                     cite_doi = doi_info,
                                     landing_page = landing_page_url),
                 title = title_info,
                 assets = build_assets(thumbnail = build_thumbnail(href = 'https://ecoforecast.org/wp-content/uploads/2019/12/EFI_Logo-1.jpg', title = 'EFI Logo'),
                                       parquet_items = build_parquet(href = 'https://data.ecoforecst.org/forecasts/parquet/aquatics',
                                                                     title = 'Parquet STAC Items',
                                                                     description = 'Placeholder description for parquet items')),
                 extent = build_extent(lat_min = -90,
                                       lat_max = 90,
                                       lon_min = -180,
                                       lon_max = 180,
                                       min_date = '2022-01-01', ##come back to the date values -- need to extract this automatically
                                       max_date = Sys.Date()),
                 keywords = build_keywords(keyword_input),
                 providers = build_providers(data_url = 'https://data.ecoforecst.org',
                                             data_name = 'Ecoforecast Data',
                                             host_url = 'https://ecoforecst.org',
                                             host_name = 'Ecoforecast'),
                 summaries = NULL,
                 description = description_info,
                 item_assets = NULL,
                 table_columns = build_table_columns(data_object = theme_df,
                                                     description_df = description_create),
                 extensions = stac_extensions,
                 publications = build_publications(doi = doi_info,
                                                   citation = author_info)
)

  expect_is(collection_out,"list")

})
