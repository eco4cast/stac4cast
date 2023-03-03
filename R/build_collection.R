

build_collection <- function(id,
                             type = 'Collection',
                             stac_version = '1.0.0',
                             license = 'proprietary',
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
                          type = type,
                          links = links,
                          title = title,
                          assets = assets, #REMEMBER TO COLLAPSE NULLS
                          extent = extent,
                          license = license,
                          keywords = keywords,
                          providers = providers,
                          summaries = summaries,
                          description = description,
                          item_assets = item_assets,
                          stac_version = stac_version,
                          table_columns = table_columns, ##need to use table:columns but syntax confused R...fix later
                          stac_extensions = extensions,
                          publications = publications
  )

  ## WRITE COLLECTION LIST INTO JSON FORMAT

  return(collection_list)
}



build_links <- function(href_link, cite_doi, landing_page){ # this needs to be more flexible in the future -- for loop or similar


links_list <- list(list(rel = "items", type = NA, href = paste0(href_link,'/api/stac/v1/collections/eco4cast/items')),
                   list(rel = "parent", type = "application/json", href = paste0(href_link,'/api/stac/v1')),
                   list(rel = "root", type = "application/json", href = paste0(href_link,'/api/stac/v1')),
                   list(rel = "self", type = "application/json", href = paste0(href_link,'/api/stac/v1/collections/eco4cast')),
                   list(rel = "cite-as", href = cite_doi),
                   list(rel = "about", href = landing_page, type = 'text/html', title = 'Organization Landing Page'),
                   #list(rel = "license", href = NA, type = NA, title = NA),
                   list(rel = "describedby", href = landing_page, title = 'Organization Landing Page',type = 'text/html'))

return(links_list)
}


build_assets <- function(thumbnail = build_thumbnail(), parquet_items = build_parquet()){ ## come back to later

  assets_list <- list(thumbnail = thumbnail,
                     parquet_items = parquet_items)

  return(assets_list)
}


build_thumbnail <- function(href,title){ #assuming thubmail is an image

  thumbnail_list <- list(href = href,
                         type = "image/JPEG",
                         roles = list('0' = "thumbnail"),
                         title = title)
  return(thumbnail_list)
}


build_parquet <- function(href, title = NULL, description = NULL){ #assuming a parquet file

  parquet_list <- list(href = href,
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


build_table_columns <- function(arrow_object,description_df){

  full_string_list <- strsplit(arrow_object[[1]]$ToString(),'\n')[[1]]

  #create initial empty list
  init_list = vector(mode="list", length = arrow_object[[1]]$num_cols)

## loop through parquet df and description information to build the list
  for (i in seq.int(1,arrow_object[[1]]$num_cols)){
    list_items <- strsplit(full_string_list[i],': ')[[1]]
    col_list <- list(name = list_items[1],
                     type = list_items[2],
                     description = description_df[1,i])

    init_list[[i]] <- col_list

  }
  return(init_list)
}

build_stac_extensions <- function(){

  test_list <- list()

  return(test_list)
}

build_publications <- function(doi,citation){

  pub_list <- list(list(doi = doi,
                   citation = citation))


  return(pub_list)
}

write_stac <- function(collection_object, path, ...){
  compact_collection <- purrr::compact(collection_object)
  jsonlite::write_json(compact_collection, path, pretty = TRUE, auto_unbox = TRUE)
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
