library(jsonlite)
library(tidyverse)
library(arrow)


source('/home/rstudio/stac4cast/R/build_collection.R')

## define function arguments not found elsewhere

id_info <- 'efi-aquatics' #just a placeholder

title_info <- 'Ecological Forecasting Initiative - Aquatics Forecasts'

description_info <- 'description placeholder' #may be able to use something from the preprint

keyword_input <- c('Forecasting','Data','Ecology') ##just an example -- change these later

doi_info <- 'https://www.doi.org/10.22541/essoar.167079499.99891914/v1'
author_info <- 'Thomas, R.Q., C. Boettiger, C.C. Carey, M.C. Dietze, L.R. Johnson, M.A. Kenney, J.S. Mclachlan, J.A. Peters, E.R. Sokol, J.F. Weltzin, A. Willson, W.M. Woelmer, and Challenge Contributors. The NEON Ecological Forecasting Challenge. Accepted at Frontiers in Ecology and Environment. Pre-print'

stac_extensions <- list("https://stac-extensions.github.io/scientific/v1.0.0/schema.json",
                        "https://stac-extensions.github.io/item-assets/v1.0.0/schema.json",
                        "https://stac-extensions.github.io/table/v1.2.0/schema.json")


parent_url <- 'https://data.ecoforecst.org/forecasts/parquet/aquatics'
landing_page_url <- 'https://projects.ecoforecast.org/neon4cast-catalog/aquatics-catalog.html'

## initialize dataframes for table metadata and column descriptions

#neon4cast-forecasts/parquet/aquatics/model_id=flareGLM/reference_datetime=2023-02-24

theme <- "aquatics"
reference_datetime <- '2023-02-24'
site_id <- 'BARC'
model_id <- 'flareGLM'
variable_name <- 'temperature'

s3 <- arrow::s3_bucket(bucket = paste0("neon4cast-forecasts/parquet/",theme),  ## this will speed up if you use above path for forecast (subset within path)
                       endpoint_override = "data.ecoforecast.org",
                       anonymous = TRUE)


theme_df <- arrow::open_dataset(s3) %>%
  filter(variable == variable_name, site_id == site_id, model_id == model_id, reference_datetime == reference_datetime) #%>% ##this used to just download data as quickly as possible -- need to revisit
#collect()

date_extent <-  arrow::open_dataset(s3) %>%
    summarise(min = min(date),
              max = max(date)) %>%
    collect()

description_create <- data.frame(datetime = 'ISO 8601(ISO 2019)datetime the forecast starts from (a.k.a. issue time); Only needed if more than one reference_datetime is stored in asingle file. Forecast lead time is thus datetime-reference_datetime. Ina hindcast the reference_datetimewill be earlierthan the time thehindcast was actually produced (seepubDatein Section3). Datetimesare allowed to be earlier than thereference_datetimeif areanalysis/reforecast is run before the start of the forecast period. Thisvariable was calledstart_timebefore v0.5 of theEFI standard.',
                                 site_id = 'For forecasts that are not on a spatial grid, use of a site dimension thatmaps to a more detailed geometry (points, polygons, etc.) is allowable.In general this would be documented in the external metadata (e.g., alook-up table that provides lon and lat); however in netCDF this couldbe handled by the CF Discrete Sampling Geometry data model.',
                                 family = 'For ensembles: “ensemble.” Default value if unspecifiedFor probability distributions: Name of the statistical distributionassociated with the reported statistics. The “sample” distribution issynonymous with “ensemble.”For summary statistics: “summary.”If this dimension does not vary, it is permissible to specifyfamilyas avariable attribute if the file format being used supports this (e.g.,netCDF).',
                                 parameter = 'ensemble member',
                                 variable = 'aquatic forecast variable',
                                 prediction = 'predicted forecast value',
                                 date = 'ISO 8601(ISO 2019)datetime being predicted; follows CF conventionhttp://cfconventions.org/cf-conventions/cf-conventions.html#time-coordinate. This variable was called time before v0.5of the EFIconvention.For time-integrated variables (e.g., cumulative net primary productivity), one should specify thestart_datetimeandend_datetimeas two variables, instead of the singledatetime.If this is not providedthedatetimeis assumed to be the MIDPOINT of theintegrationperiod.'
                                 #observation = 'observational data',
                                 #crps = 'crps forecast score',
                                 #logs = 'logs forecast score',
                                 #mean = 'mean forecast prediction for all ensemble members',
                                 #mediam = 'median forecast prediction for all ensemble members',
                                 #sd = 'standard deviation of all enemble member forecasts',
                                 #quantile97.5 = 'upper 97.5 percentile value of ensemble member forecasts',
                                 #quantile02.5 = 'upper 2.5 percentile value of ensemble member forecasts',
                                 #quantile90 = 'upper 90 percentile value of ensemble member forecasts',
                                 #quantile10 = 'upper 10 percentile value of ensemble member forecasts',
                                 #model_id = 'unique identifier for the model used in the forecast',
                                 #date = 'ISO 8601(ISO 2019)datetime being predicted; follows CF conventionhttp://cfconventions.org/cf-conventions/cf-conventions.html#time-coordinate. This variable was called time before v0.5of the EFIconvention.For time-integrated variables (e.g., cumulative net primary productivity), one should specify thestart_datetimeandend_datetimeas two variables, instead of the singledatetime.If this is not providedthedatetimeis assumed to be the MIDPOINT of theintegrationperiod.'
)


## find min and max dates --update later
# theme_df %>%
#   # find min and max
#   summarise(min = min(date),
#             max = max(date))


##### BUILD COLLECTION BY CALLING FUNCTION
collection <- build_collection(id = id_info,
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


write_stac(collection, file.path(getwd(),'output.json'))

