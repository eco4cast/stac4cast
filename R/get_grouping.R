#' Organize the groupings for themes
#'
#' @param inv_bucket name of s3 bucket
#' @param theme theme name
#'
#' @export
#'
get_grouping <- function(inv_bucket,
                         theme) {

  groups <- duckdbfs::open_dataset(glue::glue("s3://anonymous@{inv_bucket}/catalog?endpoint_override=",config$endpoint)) |>
    dplyr::filter(...1 == "parquet", ...2 == {theme}) |>
    dplyr::select(model_id = ...3, reference_datetime = ...4, date = ...5) |>
    dplyr::mutate(model_id = gsub("model_id=", "", model_id),
                  reference_datetime =
                    gsub("reference_datetime=", "", reference_datetime),
                  date = gsub("date=", "", date)) |>
    dplyr::collect()

}
