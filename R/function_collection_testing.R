theme <- "aquatics"
s3 <- arrow::s3_bucket(bucket = paste0("neon4cast-scores/parquet/", theme),
                       endpoint_override = "data.ecoforecast.org",
                       anonymous = TRUE)


t_df <- arrow::open_dataset(s3) %>%
  filter(reference_datetime == '2023-02-27', site_id == 'BARC') %>%
  #distinct() %>%
  collect()


summary_test <- t_df %>% summarise_all(typeof)


description_df <- data.frame(reference_datetime = 'ISO 8601(ISO 2019)datetime the forecast starts from(a.k.a. issuetime); Only needed if more than one reference_datetime is stored in asingle file. Forecast lead time is thusdatetime-reference_datetime. Ina hindcast thereference_datetimewill be earlierthan the time thehindcast was actually produced (seepubDatein Section3). Datetimesare allowed to be earlier than thereference_datetimeif areanalysis/reforecast is run before the start of the forecast period. Thisvariable was calledstart_timebefore v0.5 of theEFI standard.',
                             site_id = 'For forecasts that are not on a spatial grid, use of a site dimension thatmaps to a more detailed geometry (points, polygons, etc.) is allowable.In general this would be documented in the external metadata (e.g., alook-up table that provides lon and lat); however in netCDF this couldbe handled by the CF Discrete Sampling Geometry data model.',
                             datetime = 'ISO 8601(ISO 2019)datetime being predicted; follows CF conventionhttp://cfconventions.org/cf-conventions/cf-conventions.html#time-coordinate. This variable was called time before v0.5of the EFIconvention.For time-integrated variables (e.g., cumulative net primary productivity), one should specify thestart_datetimeandend_datetimeas two variables, instead of the singledatetime.If this is not providedthedatetimeis assumed to be the MIDPOINT of theintegrationperiod.',
                             family = 'For ensembles: “ensemble.” Default value if unspecifiedFor probability distributions: Name of the statistical distributionassociated with the reported statistics. The “sample” distribution issynonymous with “ensemble.”For summary statistics: “summary.”If this dimension does not vary, it is permissible to specifyfamilyas avariable attribute if the file format being used supports this (e.g.,netCDF).',
                             variable = 'aquatic forecast variable',
                             observation = 'observational data',
                             crps = 'crps forecast score',
                             logs = 'logs forecast score',
                             mean = 'mean forecast prediction for all ensemble members',
                             mediam = 'median forecast prediction for all ensemble members',
                             sd = 'standard deviation of all enemble member forecasts',
                             quantile97.5 = 'upper 97.5 percentile value of ensemble member forecasts',
                             quantile02.5 = 'upper 2.5 percentile value of ensemble member forecasts',
                             quantile90 = 'upper 90 percentile value of ensemble member forecasts',
                             quantile10 = 'upper 10 percentile value of ensemble member forecasts',
                             model_id = 'unique identifier for the model used in the forecast',
                             date = 'ISO 8601(ISO 2019)datetime being predicted; follows CF conventionhttp://cfconventions.org/cf-conventions/cf-conventions.html#time-coordinate. This variable was called time before v0.5of the EFIconvention.For time-integrated variables (e.g., cumulative net primary productivity), one should specify thestart_datetimeandend_datetimeas two variables, instead of the singledatetime.If this is not providedthedatetimeis assumed to be the MIDPOINT of theintegrationperiod.'
                             )

init_list = vector(mode="list", length = 17)


for (i in seq.int(1,ncol(summary_test))){
  col_list <- list(names(summary_test)[i],summary_test[1,i][[1]],'test_description')
  init_list[[i]] <- col_list
}
