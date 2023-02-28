

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
                             table_columns,
                             #extensions = NULL,
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
                          stac_version = '1.0.0',
                          table_columns = tables, ##need to use table:columns but syntax confused R...fix later
                          group_id = 'FLARE_forecast_id', ##just a placeholder for now
                          stac_extensions = list('0' = "https://stac-extensions.github.io/scientific/v1.0.0/schema.json",
                                                 '1' = "https://stac-extensions.github.io/item-assets/v1.0.0/schema.json",
                                                 '2' = 	"https://stac-extensions.github.io/table/v1.2.0/schema.json"),
                          publications = publications
  )

  ## WRITE COLLECTION LIST INTO JSON FORMAT

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


build_extent <- function(lat_min, lat_max, lon_min, lon_max, min_date, max_date){

  bbox_list <- list('0' = lon_min,
                    '1' = lat_min,
                    '2' = lon_max,
                    '3' = lat_max)

  extent_list <- list(spatial = list(bbox = bbox_list),
                      temporal = list(interval = list('0' = min_date,
                                                      '1' = max_date)))

  return(extent_list)
}

build_keywords <- function(keywords){

  keyword_list <- as.list(keywords)

  return(keyword_list)
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


build_table_columns <- function(parquet_table,description_df){

  init_list = vector(mode="list", length = ncol(parquet_table))


  for (i in seq.int(1,ncol(summary_test))){
    col_list <- list(names(summary_test)[i],summary_test[1,i][[1]],description_df[1,i])
    init_list[[i]] <- col_list
  }

  return(init_list)
}


build_stac_extensions <- function(){

  test_list <- list()

  return(test_list)
}

build_publications <- function(doi,authors){

  pub_list <- list('0' = list(doi = doi,
                              citation = authors))


  return(pub_list)
}

write_stac <- function(x, path, ...){
  jsonData <- jsonlite::toJSON(x)
  jsonlite::write_json(jsonData, path, ...)
}
