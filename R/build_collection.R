

build_collection <- function(id,
                             links = NULL,
                             title,
                             assets = NULL,
                             extent = NULL,
                             keywords = NULL,
                             providers = NULL,
                             summaries = NULL,
                             description,
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
                          container = 'container_name', ##placeholder
                          stac_extensions = extensions,
                          publications = publications,
                          storage_account = 'account_name', #placeholder
                          short_description = "description"
  )

  return(collection_list)
}



build_links <- function(){

test_list <- list()

return(test_list)
}

build_asset <- function(){

  test_list <- list()

  return(test_list)
}

build_extent <- function(){

  test_list <- list()

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


build_tables <- function(){

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
