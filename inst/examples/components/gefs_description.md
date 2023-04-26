The [Ecological Forecasting Initiative](https://ecoforecast.org) extracts and distributes the forecasts produced by NOAA's 35-day, 31-ensemble member forecast system for [25 variables](https://github.com/eco4cast/gefs4cast/blob/main/inst/extdata/gefs-selected-bands.csv)  at surface-height for [81 NEON sites](https://www.neonscience.org/field-sites). Forecasts are provided each day at midnight UTC, dating back from 2017-01-01 to present. These data are extracted from millions of individual GRIB2 files in the NOAA AWS catalog and distributes as a set of high-performance parquet databases partitioned on `reference_datetime` and `site_id` hosted by the [Open Storage Network](https://www.openstoragenetwork.org/).


Please note that for measurements pertaining to fluxes, such as accumulated precipitation, these are given for the 6-hr period prior to the `datetime` for horizons divisible by 6, and for a 3-hr period for others.


EFI provides several distinct products derived from GEFS forecasts covering different use cases and different versions. 

- GEFS Version 12 data covers forecasts produced since 2020-09-24.

- GEFS Version 11 data covers forecasts produced between 2017-01-01 and 2020-09-23, and includes only 21 ensemble members, a uniform 6 hr sampling interval, and extends only 16 days into the future.

- `stage1` provides raw data for 25 selected surface variables at NEON sites, extracted for all ensemble members. Please note that forecasts of the first 10 days (240 hours) use a 3 hr interval, while forecasts of days 11 through 35 days use a 6 hr interval (for v12). 

- `stage1-stats` provides the same data coverage drawn from the average and spread data (`geavg` and `gespr`).  This product is only available for v12, though summary statistics can also be calculated across ensemble by the user.

- `pseudo` series constructs "pseudo-measurements" from the initial values or nearest forecasts made at each site for each datetime.  Because NOAA releases new forecasts every 6 hours, this are comprised of the 0-horizon values at midnight (00), 06, 12, 18 hours each day, along with 3hr and 6hr horizon forecasts, which contain necessary information for calculating flux (accumulation) variables not included on the 0-horizon forecasts. This data extraction forms the input data for the `stage3` product, which provides a more easily used format.  These historical predictions can be useful in model fitting / model calibration in lieu of actual meterological measurements.  (While less accurate than ground truth measurements, these allows a modeler to avoid systematic bias from switching on training with measured data to predictions based on NOAA-model forecasts). 

All data are provided as-is without guarantee of accuracy. Please
consult original data products and generation scripts for details.
