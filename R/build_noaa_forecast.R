#' Build the forecast or scores JSON files
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
#' @param link_items link asset items for collection (child items)
#' @param thumbnail_link link for the thumbnail image
#' @param thumbnail_title title of thumbnail image
#' @param group_sites sites included in the collection
#' @param path_item object used to fill in the download path
#'
#' @return JSON code for child items
#'
#' @export
#'
build_noaa_forecast <- function(table_schema,
                            table_description,
                            start_date,
                            end_date,
                            id_value,
                            description_string,
                            about_string,
                            about_title,
                            theme_title,
                            destination_path,
                            aws_download_path,
                            link_items,
                            thumbnail_link,
                            thumbnail_title,
                            group_sites,
                            path_item

){

  forecast_asset_link <- paste0('"',"s3://anonymous@",
                                aws_download_path,
                                 path_item,
                                "/parquet/0",
                                "?endpoint_override=",config$noaa_endpoint,'"')

  forecast_asset_description <- paste0("Use `arrow` for remote access to the database. This R code will return results for NEON forecasts associated with the forecasting challenge.\n\n### R\n\n```{r}\n# Use code below\n\nall_results <- arrow::open_dataset(",forecast_asset_link,")\ndf <- all_results |> dplyr::collect()\n\n```
       \n\nYou can use dplyr operations before calling `dplyr::collect()` to `summarise`, `select` columns, and/or `filter` rows prior to pulling the data into a local `data.frame`. Reducing the data that is pulled locally will speed up the data download speed and reduce your memory usage.\n\n\n")

  # scores_asset_description <- paste0("Use `arrow` for remote access to the database. This R code will return results for the forecast challenge inventory bucket.\n\n### R\n\n```{r}\n# Use code below\n\nall_results <- arrow::open_dataset(",scores_asset_link,")\ndf <- all_results |> dplyr::collect()\n\n```
  #      \n\nYou can use dplyr operations before calling `dplyr::collect()` to `summarise`, `select` columns, and/or `filter` rows prior to pulling the data into a local `data.frame`. Reducing the data that is pulled locally will speed up the data download speed and reduce your memory usage.\n\n\n")

  forecast_score <- list(
    "id" = id_value,
    "description" = description_string,
    "stac_version"= "1.0.0",
    "license"= "CC0-1.0",
    "stac_extensions"= list("https://stac-extensions.github.io/scientific/v1.0.0/schema.json",
                            "https://stac-extensions.github.io/item-assets/v1.0.0/schema.json",
                            "https://stac-extensions.github.io/table/v1.2.0/schema.json"),
    'type' = 'Collection',
    'links' = c(link_items, #generate_model_items()
                list(
                  list(
                    "rel" = "parent",
                    "type"= "application/json",
                    "href" = '../collection.json'
                  ),
                  list(
                    "rel" = "root",
                    "type" = "application/json",
                    "href" = '../../catalog.json'
                  ),
                  list(
                    "rel" = "self",
                    "type" = "application/json",
                    "href" = 'collection.json'
                  ),
                  list(
                    "rel" = "cite-as",
                    "href" = catalog_config$citation_doi
                  ),
                  list(
                    "rel" = "about",
                    "href" = about_string,
                    "type" = "text/html",
                    "title" = about_title
                  ),
                  list(
                    "rel" = "describedby",
                    "href" = catalog_config$dashboard_url,
                    "title" = catalog_config$dashboard_title,
                    "type" = "text/html"
                  )
                )),
    "title" = theme_title,
    "extent" = list(
      "spatial" = list(
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
        "href" = forecast_asset_link,
        "type"= "application/x-parquet",
        "title"= 'Database Access',
        "roles" = list('data'),
        "description"= forecast_asset_description
      ),
      # 'data' = list(
      #   "href" = scores_asset_link,
      #   "type"= "application/x-parquet",
      #   "title"= 'Scores Inventory Access',
      #   "roles" = list('data'),
      #   "description"= scores_asset_description
      # ),
      'thumbnail' = list(
        "href"= thumbnail_link,
        "type"= "image/JPEG",
        "roles" = list('thumbnail'),
        "title"= thumbnail_title
      )
    )
  )


  dest <- destination_path
  json <- file.path(dest, "collection.json")

  jsonlite::write_json(forecast_score,
                       json,
                       pretty=TRUE,
                       auto_unbox=TRUE)
  stac4cast::stac_validate(json)
}
