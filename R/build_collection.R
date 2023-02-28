

build_collection <- function(id,
                             links = NULL,
                             title,
                             assets = build_assets(tnail_object, tnail_title, parquet_uri, p_title, p_description),
                             extent = NULL,
                             keywords = NULL,
                             providers = NULL,
                             summaries = NULL,
                             description = NULL,
                             item_assets = NULL,
                             tables = NULL,
                             extensions = NULL,
                             publications = NULL) {

  collection_list <- list(id = id,
                          type = "Collection",
                          links = NULL,
                          title = title,
                          assets = assets, #REMEMBER TO COLLAPSE NULLS
                          extent = extent,
                          license = "proprietary",
                          keywords = keywords,
                          providers = providers,
                          summaries = summaries,
                          description = description,
                          item_assets = item_assets,
                          region = "eastus",
                          stac_version = '1.0.0',
                          tables = tables,
                          group_id = 'FLARE_forecast_id', ##just a placeholder for now
                          #container = 'container_name', ##placeholder
                          stac_extensions = list(0 = "https://stac-extensions.github.io/scientific/v1.0.0/schema.json",
                                                 1 = "https://stac-extensions.github.io/item-assets/v1.0.0/schema.json",
                                                 2 = 	"https://stac-extensions.github.io/table/v1.2.0/schema.json"),
                          publications = publications
                          #storage_account = 'account_name', #placeholder
                          #short_description = "description"
  )

  return(collection_list)
}



build_links <- function(){ # this needs to be more flexible in the future -- for loop or similar

links_list <- list(0 = list(rel = "items", type = NA, href = NA),
                   1 = list(rel = "parent", type = NA, href = NA),
                   2 = list(rel = "root", type = NA, href = NA),
                   3 = list(rel = "self", type = NA, href = NA),
                   4 = list(rel = "cite-as", href = NA),
                   5 = list(rel = "cite-as", href = NA),
                   6 = list(rel = "about", href = NA, type = NA, title = NA),
                   7 = list(rel = "license", href = NA, type = NA, title = NA),
                   8 = list(rel = "describedby", href = NA, title = NA,type = NA))

return(test_list)
}

build_assets <- function(tnail_object, tnail_title, parquet_uri, p_title, p_description){ ## come back to later

  assets_list <- list(thumbnail = build_thumbnail(tnail_title,tnail_title),
                     parquet_items = build_parquet(parquet_uri, p_title, p_description))

  return(assets_list)
}


build_thumbnail <- function(tnail_object,title){ #assuming thubmail is an image

  thumbnail_list <- list(href = tnail_object,
                         type = "image/png",
                         roles = list('0' = "thumbnail"),
                         title = title)
  return(thumbnail_list)
}

build_parquet <- function(parquet_uri, title, description){ #assuming a parquet file

  parquet_list <- list(href = parquet_uri,
                         type = "application/x-parquet",
                         roles = list('0' = "stac-items"),
                         title = title,
                         description = description)
  return(parquet_list)
}


build_extent <- function(){

  extent_list <- list(spatial = list())

  return(test_list)
}

build_keywords <- function(){
  test_list <- list()

  return(test_list)
}

build_providers <- function(){

  test_list <- list()

  return(test_list)
}

build_summaries <- function(){

  test_list <- list()

  return(test_list)
}

build_item_assets <- function(){

  test_list <- list()

  return(test_list)
}


build_table_columns <- function(){

  test_list <- list()

  return(test_list)
}

build_stac_extensions <- function(){

  test_list <- list()

  return(test_list)
}

build_publications <- function(){

  test_list <- list()

  return(test_list)
}

write_stac <- function(x, path, ...){
  jsonData <- jsonlite::toJSON(x)
  jsonlite::write_json(jsonData, path, ...)
}
