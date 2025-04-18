#' Build the Assets objects for model JSONS
#'
#' @param full_var_df dataframe that contains variable column information (name, full name, duration, duration name)
#' @param aws_path s3 path for accessing model data
#' @export
#'
#'
generate_model_assets <- function(full_var_df, aws_path, model_code_link, site_values){

  metadata_json_asset <- list(
    "1"= list(
      'type'= 'application/json',
      'title' = 'Model Metadata',
      'href' = paste0("https://", config$endpoint,"/", config$model_metadata_bucket,"/",m,".json"),
      'description' = paste0("Use `jsonlite::fromJSON()` to download the model metadata JSON file. This R code will return metadata provided during the model registration.
      \n\n### R\n\n```{r}\n# Use code below\n\nmodel_metadata <- jsonlite::fromJSON(",paste0('"','https://', config$endpoint,'/', config$model_metadata_bucket,'/',m,'.json"'),")\n\n")
    ),
    "2" = list(
      'type'= 'text/html',
      'title' = 'Link for Model Code',
      'href' = model_code_link,
      'description' = "The link to the model code provided by the model submission team"
    ),
    "3" = list(
      'type'= 'text/plain',
      'title' = 'Model Sites',
      'href' = config$site_table_link,
      'description' = site_values
    )
  )

  iterator_list <- 1:nrow(full_var_df)

  model_data_assets <- purrr::map(iterator_list, function(i)
    list(
      'type'= 'application/x-parquet',
      'title' = paste0('Database Access for',' ', full_var_df$var_duration_name[i]),
      'href' = paste0("s3://anonymous@",
                      aws_path,
                      "/project_id=", full_var_df$project_id[i],
                      "/duration=", full_var_df$duration[i],
                      "/variable=", full_var_df$variable[i],
                      "/model_id=", m,
                      "?endpoint_override=",config$endpoint),
      'description' = paste0("Use `R` or `Python` code for remote access to the database. This code will return results for this variable and model combination.\n\n### R\n\n```{r}\n# Use code below\n\nall_results <- arrow::open_dataset(",paste0('"',"s3://anonymous@",
                                                                                                                                                                                                                                          aws_path,
                                                                                                                                                                                                                                          "/project_id=", full_var_df$project_id[i],
                                                                                                                                                                                                                                          "/duration=", full_var_df$duration[i],
                                                                                                                                                                                                                                          "/variable=", full_var_df$variable[i],
                                                                                                                                                                                                                                          "/model_id=", m,
                                                                                                                                                                                                                                          "?endpoint_override=",config$endpoint,'"'),")\ndf <- all_results |> dplyr::collect()\n\n```
       \n\nYou can use dplyr operations before calling `dplyr::collect()` to `summarise`, `select` columns, and/or `filter` rows prior to pulling the data into a local `data.frame`. Reducing the data that is pulled locally will speed up the data download speed and reduce your memory usage.\n\n\n### Python\n\n```{python}# Use code below\nimport ibis\ncon = ibis.duckdbf.connect()\ncon.raw_sql(f'''\nCREATE OR REPLACE SECRET secret (\nTYPE S3,\nENDPOINT '",config$endpoint,"',\nURL_STYLE 'path'\n\n''');\npath = ",paste0('"',"s3://",aws_path,"/project_id=", full_var_df$project_id[i],"/duration=", full_var_df$duration[i],"/variable=", full_var_df$variable[i],"/model_id=", m,'"'),"\ncon.read_parquet(path + \"/**\")")
    )
  )

  model_assets <- c(metadata_json_asset, model_data_assets)

  return(model_assets)
}
