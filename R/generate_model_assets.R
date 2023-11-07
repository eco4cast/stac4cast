#' Build the Assets objects for model JSONS
#'
#' @param m_vars list of unique model variables
#' @param m_duration list of unique model duration periods
#' @param aws_path s3 path for accessing model data
#' @export
#'
#'
generate_model_assets <- function(m_vars, m_duration, aws_path){

  metadata_json_asset <- list(
    "1"= list(
      'type'= 'application/json',
      'title' = 'Model Metadata',
      'href' = paste0("https://", config$endpoint,"/", config$model_metadata_bucket,"/",m,".json"),
      'description' = paste0("Use `jsonlite::fromJSON()` to download the model metadata JSON file. This R code will return metadata provided during the model registration.
      \n\n### R\n\n```{r}\n# Use code below\n\nmodel_metadata <- jsonlite::fromJSON(",paste0('"','https://', config$endpoint,'/', config$model_metadata_bucket,'/',m,'.json"'),")\n\n")
    )
  )

  iterator_list <- 1:length(m_vars)

  model_data_assets <- purrr::map(iterator_list, function(i)
    list(
      'type'= 'application/x-parquet',
      'title' = paste0('Database Access for',' ',m_vars[i]),
      'href' = paste0("s3://anonymous@",
                      aws_path,
                      "/parquet/duration=P1D/variable=", m_vars[i],
                      "/model_id=", m,
                      "?endpoint_override=",config$endpoint),
      'description' = paste0("Use `arrow` for remote access to the database. This R code will return results for this variable and model combination.\n\n### R\n\n```{r}\n# Use code below\n\nall_results <- arrow::open_dataset(",paste0("s3://anonymous@",
                                                                                                                                                                                                                                          aws_path,
                                                                                                                                                                                                                                          "/parquet/duration=P1D/variable=", m_vars[i],
                                                                                                                                                                                                                                          "/model_id=", m,
                                                                                                                                                                                                                                          "?endpoint_override=",config$endpoint),")\ndf <- all_results |> dplyr::collect()\n\n```
       \n\nYou can use dplyr operations before calling `dplyr::collect()` to `summarise`, `select` columns, and/or `filter` rows prior to pulling the data into a local `data.frame`. Reducing the data that is pulled locally will speed up the data download speed and reduce your memory usage.\n\n\n")
    )
  )

  model_assets <- c(metadata_json_asset, model_data_assets)

  return(model_assets)
}
