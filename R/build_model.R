#' Build the Model JSONS for catalog
#'
#' @param model_id list of unique model variables
#' @param team_name model team name
#' @param model_description model description provided in registration metadata
#' @param start_date min date of model forecasts
#' @param end_date max date of model forecasts
#' @param var_values unique variables in the model
#' @param duration_names unique duration values in the model
#' @param site_values unique sites in the model
#' @param model_documentation documentation to describe the model, provided as text
#' @param destination_path path for saving the json file
#' @param aws_download_path path for s3 data download
#' @param collection_name name of stac collection
#' @param thumbnail_image_name name of thumbnail image
#' @param table_schema schema of data table, accessed through s3
#' @param table_description table that includes descriptions of data columns
#'
#' @export
#'
#'
build_model <- function(model_id,
                        team_name,
                        model_description,
                        start_date,
                        end_date,
                        var_values,
                        duration_names,
                        site_values,
                        site_table,
                        model_documentation,
                        destination_path,
                        aws_download_path,
                        collection_name,
                        thumbnail_image_name,
                        table_schema,
                        table_description,
                        full_var_df,
                        code_web_link) {


  preset_keywords <- list("Forecasting", config$project_id)
  variables_string <- paste(var_values, collapse = ", ")
  variables_reformat <- as.list(var_values)
  site_reformat <- paste(site_values, collapse = ", ")

  aws_asset_link <- paste0("s3://anonymous@",
                           aws_download_path,
                           "/model_id=", model_id,
                           "?endpoint_override=",config$endpoint)

  aws_asset_description <- paste0("Use `arrow` for remote access to the database. This R code will return results for forecasts of the variable by the specific model .\n\n### R\n\n```{r}\n# Use code below\n\nall_results <- arrow::open_dataset(",aws_asset_link,")\ndf <- all_results |> dplyr::collect()\n\n```
       \n\nYou can use dplyr operations before calling `dplyr::collect()` to `summarise`, `select` columns, and/or `filter` rows prior to pulling the data into a local `data.frame`. Reducing the data that is pulled locally will speed up the data download speed and reduce your memory usage.\n\n\n")

  meta <- list(
    "stac_version"= "1.0.0",
    "stac_extensions"= list('https://stac-extensions.github.io/table/v1.2.0/schema.json'),
    "type"= "Feature",
    "id"= model_id,
    "bbox"=
      list(list(as.numeric(catalog_config$bbox$min_lon),
                as.numeric(catalog_config$bbox$max_lat),
                as.numeric(catalog_config$bbox$max_lon),
                as.numeric(catalog_config$bbox$max_lat))),
    "geometry"= list(
      "type"= catalog_config$site_type,
      "coordinates"=  stac4cast::get_site_coords(site_metadata = site_table, sites = site_values)
    ),
    "properties"= list(
      #'description' = model_description,
      "description" = glue::glue('

    model info: {model_description}

    Sites: {site_reformat}

    Variables: {variables_string}
'),
      "start_datetime" = start_date,
      "end_datetime" = end_date,
      "providers"= c(stac4cast::generate_authors(metadata_table = model_documentation),list(
        list(
          "url"= catalog_config$host_url,
          "name"= catalog_config$host_name,
          "roles"= list(
            "host"
          )
        )
      )
      ),
      "license"= "CC0-1.0",
      "keywords"= c(preset_keywords, variables_reformat),
      "table:columns" = stac4cast::build_table_columns_full_bucket(table_schema, table_description)
      #"table:columns" = build_table_columns_full_bucket(table_schema, table_description)
    ),
    "collection"= collection_name,
    "links"= list(
      list(
        "rel"= "collection",
        'href' = '../collection.json',
        "type"= "application/json",
        "title"= model_id
      ),
      list(
        "rel"= "root",
        'href' = '../../../catalog.json',
        "type"= "application/json",
        "title"= "Forecast Catalog"
      ),
      list(
        "rel"= "parent",
        'href' = '../collection.json',
        "type"= "application/json",
        "title"= model_id
      ),
      list(
        "rel"= "self",
        "href" = paste0(model_id,'.json'),
        "type"= "application/json",
        "title"= "Model Forecast"
      ),
      list(
        "rel"= "item",
        "href" = code_web_link,
        "type"= "text/html",
        "title"= "Link for Model Code"
        )),
    "assets"= stac4cast::generate_model_assets(full_var_df, aws_download_path, code_web_link)#,
    #pull_images(theme_id,model_id,thumbnail_image_name)
  )


  dest <- destination_path
  json <- file.path(dest, paste0(model_id, ".json"))

  jsonlite::write_json(meta,
                       json,
                       pretty=TRUE,
                       auto_unbox=TRUE)
  stac4cast::stac_validate(json)

  rm(meta)
}
