

build_collection <- function(id,
                             links = build_links(),
                             title = NULL,
                             assets = NULL,
                             extent = build_extent(),
                             keywords = NULL,
                             providers = NULL,
                             summaries = NULL,
                             description,
                             item_assets = NULL,
                             table_columns = NULL,
                             extensions = NULL,
                             publications = NULL) {

  collection_list <- list(id = id,
                          type = "Collection",
                          links = links,
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
                          table_columns = table_columns, ##need to use table:columns but syntax confused R...fix later
                          stac_extensions = extensions,
                          publications = publications
  )

  ## WRITE COLLECTION LIST INTO JSON FORMAT

  return(collection_list)
}



build_links <- function(parent_link, cite_doi, landing_page){ # this needs to be more flexible in the future -- for loop or similar


links_list <- list(list(rel = "items", type = NA, href = paste0(parent_link,'/api/stac/v1/collections/eco4cast/items')),
                   list(rel = "parent", type = "application/json", href = paste0(parent_link,'/api/stac/v1')),
                   list(rel = "root", type = "application/json", href = paste0(parent_link,'/api/stac/v1')),
                   list(rel = "self", type = "application/json", href = paste0(parent_link,'/api/stac/v1/collections/eco4cast')),
                   list(rel = "cite-as", href = cite_doi),
                   list(rel = "about", href = landing_page, type = 'text/html', title = 'Organization Landing Page'),
                   #list(rel = "license", href = NA, type = NA, title = NA),
                   list(rel = "describedby", href = landing_page, title = 'Organization Landing Page',type = 'text/html'))

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
                         roles = list("stac-items"),
                         title = title,
                         description = description)
  return(parquet_list)
}


build_extent <- function(lat_min, lat_max, lon_min, lon_max, min_date, max_date = NULL){ ##if data through present then set max_date = NULL

  if (is.null(max_date)){
    temporal_list <- list(min_date,'null')
  }else{
    temporal_list <- list(min_date, max_date)
  }

  bbox_list <- list(lon_min,
                    lat_min,
                    lon_max,
                    lat_max)

  extent_list <- list(spatial = list(bbox = bbox_list),
                      temporal = list(interval = temporal_list))

  return(extent_list)
}


build_keywords <- function(keywords){

  keyword_list <- as.list(keywords)

  return(keyword_list)
}

build_providers <- function(data_url, data_name, host_url, host_name){

  data_provider_list <- list(url = data_url,
                             name = data_name,
                             roles = list("producer",
                                          "processor",
                                          "licensor"))
  host_provider_list <- list(url = host_url,
                             name = host_name,
                             roles = list('host'))

  providers_list <- list(data_provider_list,
                         host_provider_list)

  return(providers_list)
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

  pub_list <- list(list(doi = doi,
                   citation = authors))


  return(pub_list)
}

write_stac <- function(x, path, ...){
  jsonData <- jsonlite::toJSON(x)
  jsonlite::write_json(jsonData, path, ...)
}

# build_summaries <- function(){
#
#   test_list <- list()
#
#   return(test_list)
# }
#
# build_item_assets <- function(){
#
#   test_list <- list()
#
#   return(test_list)
# }
