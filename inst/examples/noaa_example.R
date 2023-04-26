devtools::load_all("../..")

max_date <- Sys.Date()
min_date <- as.Date("2017-01-01")
site_data <-
  paste0("https://raw.githubusercontent.com/eco4cast/",
         "neon4cast-targets/main/NEON_Field_Site_Metadata_20220412.csv") |>
  readr::read_csv(show_col_types = FALSE)
lat_bbox <- c(min(site_data$field_latitude), max(site_data$field_latitude))
lon_bbox <- c(min(site_data$field_longitude), max(site_data$field_longitude))

extent = build_extent(lat_min = lat_bbox[1],
                      lat_max = lat_bbox[2],
                      lon_min = lon_bbox[1],
                      lon_max = lon_bbox[2],
                      min_date = min_date,
                      max_date = max_date)

doi <- 'https://doi.org/10.1002/fee.2616'
authors <- paste("R Quinn Thomas, Carl Boettiger, Cayelan C Carey,",
                "Michael C Dietze, Leah R Johnson, Melissa A Kenney,",
                "Jason S McLachlan, Jody A Peters, Eric R Sokol,",
                "Jake F Weltzin, Alyssa Willson, Whitney M Woelmer,",
                "Challenge contributors")

table_columns <-
  list(
    list(name = "reference_datetime",
         description = 'ISO 8601(ISO 2019) datetime the forecast starts from (a.k.a. issue time); Only needed if more than one reference_datetime is stored in a single file. Forecast lead time (horizon) is thus datetime minus reference_datetime.',
         type = "string"),
    list(name = "site_id",
         description = 'For forecasts that are not on a spatial grid, use of a site dimension that maps to a more detailed geometry (points, polygons, etc.) is allowable. In general this would be documented in the external metadata (e.g., a look-up table that provides lon and lat);',
         type = "string"),
    list(name = "family",
         description = 'probability distribution. sample trajectories may be denoted "ensemble" or "sample,".  NOAA summary statistics use "spread"',
         type = "string"),
    list(name = "ensemble",
         description = 'ensemble member',
         type = "string"),
    list(name = "variable",
         description = 'abbreviation for variable measured, see <https://github.com/eco4cast/gefs4cast/blob/main/inst/extdata/gefs-selected-bands.csv>',
         type = "string"),
    list(name = "prediction",
         description = 'predicted forecast value for the variable specified',
         type = "double"),
    list(name = "datetime",
         description = 'ISO 8601(ISO 2019) datetime being predicted. This variable was called time before v0.5 of the EFIconvention. For time-integrated variables (e.g., cumulative net primary productivity), one should specify the start_datetime and end_datetime as two variables, instead of the single datetime. If this is not provided the datetime is assumed to be the MIDPOINT of the integration period.',
         type = "datetime")
)

gefs <- build_collection(
  id="neon4cast-gefs",
  title = 'Ecological Forecasting Initiative - NOAA GEFS Forecast Snapshots',
  description = readr::read_file("components/gefs_description.md"),
  keywords = c('Forecasting','Data','Weather', 'NOAA'),
  license = "CC0-1.0",
  extent = extent,
  extensions = list("https://stac-extensions.github.io/scientific/v1.0.0/schema.json",
                    "https://stac-extensions.github.io/item-assets/v1.0.0/schema.json",
                    "https://stac-extensions.github.io/table/v1.2.0/schema.json"),
  links = build_links(root = 'https://data.ecoforecast.org/neon4cast-catalog/stac/v1/catalog.json',
                      parent = 'https://data.ecoforecast.org/neon4cast-catalog/stac/v1/catalog.json',
                      self = 'https://data.ecoforecast.org/neon4cast-catalog/stac/v1/noaa.json',
                      doi = doi,
                      about = 'https://projects.ecoforecast.org/neon4cast-catalog/noaa-catalog.html',
                      example = 'https://projects.ecoforecast.org/neon4cast-catalog/noaa-catalog.html'),
  providers = build_providers(data_url = 'https://www.emc.ncep.noaa.gov/emc/pages/numerical_forecast_systems/gefs.php',
                              data_name = 'NOAA Forecasts',
                              host_url = 'https://registry.opendata.aws/noaa-gefs/',
                              host_name = 'AWS Open Data Registry'),
  publications = build_publications(doi = doi,
                                    citation = authors),
  table_columns = table_columns,
  assets = build_assets(
    thumbnail = build_thumbnail(
      href = 'https://data.ecoforecast.org/neon4cast-catalog/img/gefs_thumbnail.jpg',
      title = 'GEFS temperature forecast thumbnail'),
    parquet_items1 = build_parquet(
      href = "https://sdsc.osn.xsede.org/bio230014-bucket01/noaa/gefs-v12/stage1/",
      title = 'GEFS stage1 collection',
      description = readr::read_file("components/gefs-stage1-description.Rmd")
    ),
    parquet_items2 = build_parquet(
      href = "https://sdsc.osn.xsede.org/bio230014-bucket01/noaa/gefs-v12/stage1-stats/",
      title = 'GEFS stage1-stats collection',
      description = readr::read_file("components/gefs-stage1-stats-description.Rmd")
    ),
    parquet_items3 = build_parquet(
      href = "https://sdsc.osn.xsede.org/bio230014-bucket01/noaa/gefs-v12/cfs/6hrly/00/",
      title = 'CFS collection',
      description = readr::read_file("components/cfs-description.Rmd")
    )
  )
)

write_stac(gefs, "noaa.json")
stac_validate("noaa.json")
