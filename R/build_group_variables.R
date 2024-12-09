#' Build the Model JSONS for catalog
#'
#' @param table_schema schema of data table, accessed through s3
#' @param table_description table that includes descriptions of data columns
#' @param start_date table that includes descriptions of data columns
#' @param end_date table that includes descriptions of data columns
#' @param id_value title for json file
#' @param description_string brief description to describe JSON
#' @param about_string string that contains the "about" asset information
#' @param about_title title to describe the "about" asset information
#' @param theme_title title for JSON (Forecast/Scores)
#' @param destination_path path for saving the JSON file
#' @param aws_download_path path for s3 data download
#' @param group_var_items list of variables for the group, called within generate_variable_model_items()
#' @param thumbnail_link link for the thumbnail image
#' @param thumbnail_title title for the thumbnail image
#' @param group_var_vector vector of variables that belong in a group
#' @param group_sites unique sites included in the group
#'
#' @export
#'
build_group_variables <- function(table_schema,
                                  table_description,
                                  start_date,
                                  end_date,
                                  id_value,
                                  description_string,
                                  about_string,
                                  about_title,
                                  dashboard_string,
                                  dashboard_title,
                                  theme_title,
                                  destination_path,
                                  aws_download_path,
                                  group_var_items,
                                  thumbnail_link,
                                  thumbnail_title,
                                  group_var_vector,
                                  single_var_name,
                                  group_duration_value,
                                  group_sites,
                                  citation_values,
                                  doi_values
){

  if (is.null(group_var_vector)){  ## building var json

    aws_asset_link <-  paste0('"',"s3://anonymous@",
                              aws_download_path,
                              "/project_id=", config$project_id,
                              "/duration=", group_duration_value,
                              "/variable=", single_var_name,
                              "?endpoint_override=",config$endpoint,'"')

    aws_href_link <- paste0('"',"s3://anonymous@",
                            aws_download_path,
                            "/project_id=", config$project_id,
                            "/duration=", duration_value,
                            "/variable=", single_var_name,
                            "?endpoint_override=",config$endpoint,'"')

    aws_asset_description <- paste0("Use `arrow` for remote access to the database. This R code will return results for forecasts of the variable by the specific model .\n\n### R\n\n```{r}\n# Use code below\n\nall_results <- arrow::open_dataset(",aws_asset_link,")\ndf <- all_results |> dplyr::collect()\n\n```
       \n\nYou can use dplyr operations before calling `dplyr::collect()` to `summarise`, `select` columns, and/or `filter` rows prior to pulling the data into a local `data.frame`. Reducing the data that is pulled locally will speed up the data download speed and reduce your memory usage.\n\n\n")


    forecast_score <- list(
      "id" = id_value,
      "description" = description_string,
      "stac_version"= "1.0.0",
      "license"= "CC0-1.0",
      "stac_extensions"= list("https://stac-extensions.github.io/table/v1.2.0/schema.json"),
      'type' = 'Collection',
      #"sci:publications" = NULL,
      'links' = c(group_var_items,#generate_group_variable_items(variables = group_var_values)
                  list(
                    list(
                      "rel" = "parent",
                      "type"= "application/json",
                      "href" = '../collection.json'
                    ),
                    list(
                      "rel" = "root",
                      "type" = "application/json",
                      "href" = '../collection.json'
                    ),
                    list(
                      "rel" = "self",
                      "type" = "application/json",
                      "href" = 'collection.json'
                    ),
                    list(
                      "rel" = "cite-as",
                      "href" = catalog_config$citation_doi_link
                    ),
                    list(
                      "rel" = "about",
                      "href" = about_string,
                      "type" = "text/html",
                      "title" = about_title
                    ),
                    list(
                      "rel" = "describedby",
                      "href" = dashboard_string,
                      "title" = dashboard_title,
                      "type" = "text/html"
                    )
                  )),
      "title" = theme_title,
      "extent" = list(
        "spatial" = list(
          #'bbox' = list(list(stac4cast::get_bbox(site_metadata = catalog_config$site_metadata_url, sites = group_sites)))),
          'bbox' = list(stac4cast::get_bbox(site_metadata = catalog_config$site_metadata_url, sites = group_sites))),
        "temporal" = list(
          'interval' = list(list(
            paste0(start_date,"T00:00:00Z"),
            paste0(end_date,"T00:00:00Z"))
          ))
      ),
      "table:columns" = stac4cast::build_table_columns_full_bucket(table_schema, table_description),
      #"table:columns" = build_table_columns_full_bucket(table_schema, table_description),
      'assets' = list(
        'data' = list(
          "href" = aws_href_link,
          "type"= "application/x-parquet",
          "title"= 'Database Access',
          "roles" = list('data'),
          "description"= aws_asset_description
        ),
        'thumbnail' = list(
          "href"= thumbnail_link,
          "type"= "image/JPEG",
          "roles" = list('thumbnail'),
          "title"= thumbnail_title
        )
      )
    )

     }else{ ## building group json

      aws_asset_link <-  paste0('"',"s3://anonymous@",
                              aws_download_path,
                              #"/model_id=", model_id,
                              "?endpoint_override=",config$endpoint,'"')

    aws_href_link <- paste0("s3://anonymous@",
                            aws_download_path,
                            #"/model_id=", model_id,
                            "?endpoint_override=",config$endpoint)

    group_var_vector <- paste0('"', paste(group_var_vector, collapse='", "'), '"')
    aws_asset_description <- paste0("Use `arrow` for remote access to the database. This R code will return results for the NEON Ecological Forecasting Aquatics theme.\n\n### R\n\n```{r}\n# Use code below\n\nall_results <- arrow::open_dataset(",aws_asset_link,")\ndf <- all_results |>\n dplyr::filter(variable %in% c(", group_var_vector,")) |>\n dplyr::collect()\n\n```
       \n\nYou can use dplyr operations before calling `dplyr::collect()` to `summarise`, `select` columns, and/or `filter` rows prior to pulling the data into a local `data.frame`. Reducing the data that is pulled locally will speed up the data download speed and reduce your memory usage.\n\n\n")


    forecast_score <- list(
      "id" = id_value,
      "description" = description_string,
      "stac_version"= "1.0.0",
      "license"= "CC0-1.0",
      "stac_extensions"= list("https://stac-extensions.github.io/scientific/v1.0.0/schema.json",
                              "https://stac-extensions.github.io/table/v1.2.0/schema.json"),
      'type' = 'Collection',
      "sci:doi" = catalog_config$citation_doi,
      "sci:publications" = stac4cast::build_publication_items(citation_values, doi_values),
      #"sci:publications" = NULL,
      'links' = c(group_var_items,#generate_group_variable_items(variables = group_var_values)
                  list(
                    list(
                      "rel" = "parent",
                      "type"= "application/json",
                      "href" = '../collection.json'
                    ),
                    list(
                      "rel" = "root",
                      "type" = "application/json",
                      "href" = '../collection.json'
                    ),
                    list(
                      "rel" = "self",
                      "type" = "application/json",
                      "href" = 'collection.json'
                    ),
                    list(
                      "rel" = "cite-as",
                      "href" = catalog_config$citation_doi_link
                    ),
                    list(
                      "rel" = "about",
                      "href" = about_string,
                      "type" = "text/html",
                      "title" = about_title
                    ),
                    list(
                      "rel" = "describedby",
                      "href" = dashboard_string,
                      "title" = dashboard_title,
                      "type" = "text/html"
                    )
                  )),
      "title" = theme_title,
      "extent" = list(
        "spatial" = list(
          #'bbox' = list(list(stac4cast::get_bbox(site_metadata = catalog_config$site_metadata_url, sites = group_sites)))),
          'bbox' = list(stac4cast::get_bbox(site_metadata = catalog_config$site_metadata_url, sites = group_sites))),
        "temporal" = list(
          'interval' = list(list(
            paste0(start_date,"T00:00:00Z"),
            paste0(end_date,"T00:00:00Z"))
          ))
      ),
      "table:columns" = stac4cast::build_table_columns_full_bucket(table_schema, table_description),
      #"table:columns" = build_table_columns_full_bucket(table_schema, table_description),
      'assets' = list(
        'data' = list(
          "href" = aws_href_link,
          "type"= "application/x-parquet",
          "title"= 'Database Access',
          "roles" = list('data'),
          "description"= aws_asset_description
        ),
        'thumbnail' = list(
          "href"= thumbnail_link,
          "type"= "image/JPEG",
          "roles" = list('thumbnail'),
          "title"= thumbnail_title
        )
      )
    )

    }

  dest <- destination_path
  json <- file.path(dest, 'collection.json')

  jsonlite::write_json(forecast_score,
                       json,
                       pretty=TRUE,
                       auto_unbox=TRUE)
  #stac4cast::stac_validate(json)
}
