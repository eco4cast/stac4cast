

#' Build full metadata collection
#'
#' @param id unique identifier for the collection
#' @param type always set to "Collection" for collection items
#' @param stac_version version of STAC to implement
#' @param license collection license
#' @param links list of related objects and their relation relationships
#' @param title short title for the collection
#' @param assets dictionary of asset objects that can be downloaded
#' @param extent spatial and temporal extents
#' @param keywords list of keywords describing the collection
#' @param providers all organizations capturing or processing the data or the hosting provider
#' @param summaries a map of property summaries, either a set of values, a range of values or a JSON schema
#' @param description detailed multi-line description to fully explain the collection
#' @param item_assets an optional dictionary of asset objects associated with the collection that can be downloaded or streamed, each with a unique key
#' @param table_columns column names, type, and description for data table
#' @param extensions a list of extensions the collection implements
#' @param publications list of relevant publication information for the collection
#'
#' @return
#' @export
#'
#' @examples
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



#' Build the Links field for a collection
#'
#' @param href_link The actual link in the format of an URL. Relative and absolute links are both allowed.
#' @param cite_doi optional argument to be used in the cite-as link object
#' @param landing_page a URL for describing the relevant organization or group for the collection
#'
#' @return
#' @export
#'
#' @examples
build_links <- function(href_link, cite_doi = NULL, landing_page){ # this needs to be more flexible in the future -- for loop or similar


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


#' Build the Assets object for a collection
#'
#' @param thumbnail list describing the thumbnail object(s) used in the collection
#' @param parquet_items list describing the parquet object(s) used in the collection
#'
#' @return
#' @export
#'
#' @examples
build_assets <- function(thumbnail = build_thumbnail(), parquet_items = build_parquet()){ ## come back to later

  assets_list <- list(thumbnail = list(thumbnail),
                     parquet_items = list(parquet_items))

  return(assets_list)
}


#' Build the thumbnail list to be used in the build_assets() function
#'
#' @param href the actual link in the format of an URL. Relative and absolute links are both allowed
#' @param title optional title to be used in rendered displays of the link
#'
#' @return
#' @export
#'
#' @examples
build_thumbnail <- function(href,title){ #assuming thubmail is an image

  thumbnail_list <- list(href = href,
                         type = "image/JPEG",
                         roles = list('0' = "thumbnail"),
                         title = title)
  return(thumbnail_list)
}


#' Build the parquet list to be used in the build_assets() function
#'
#' @param href the actual link in the format of an URL. Relative and absolute links are both allowed
#' @param title optional title to be used in rendered displays of the link
#' @param description optional description for the parquet items
#'
#' @return
#' @export
#'
#' @examples
build_parquet <- function(href, title = NULL, description = NULL){ #assuming a parquet file

  parquet_list <- list(href = href,
                         type = "application/x-parquet",
                         roles = list("stac-items"),
                         title = title,
                         description = description)
  return(parquet_list)
}


#' Build Extent object for collection
#'
#' @param lat_min minimum latitude for site bounding box
#' @param lat_max maximum latitude for site bounding box
#' @param lon_min minimum longitude for site bounding box
#' @param lon_max maximum longitude for site bounding box
#' @param min_date minimum date of data
#' @param max_date maximum data of data
#'
#' @return
#' @export
#'
#' @examples
build_extent <- function(lat_min, lat_max, lon_min, lon_max, min_date, max_date){ ##if data through present then set max_date = NULL

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


#' Build keywords object for collection
#'
#' @param keywords list of keywords to be describe the collection
#'
#' @return
#' @export
#'
#' @examples
build_keywords <- function(keywords){

  keyword_list <- as.list(keywords)

  return(keyword_list)
}


#' Build providers object for the collection
#'
#' @param data_url URL for data provider organization
#' @param data_name data provider organization
#' @param host_url URL for data host
#' @param host_name name of data host
#'
#' @return
#' @export
#'
#' @examples
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


#' Build table_columns object for collection
#'
#' @param data_object parquet object used to store data
#' @param description_df dataframe of table column descriptions, one description for each column needed
#'
#' @return
#' @export
#'
#' @examples
build_table_columns <- function(data_object,description_df){

  full_string_list <- strsplit(data_object[[1]]$ToString(),'\n')[[1]]

  #create initial empty list
  init_list = vector(mode="list", length = data_object[[1]]$num_cols)

## loop through parquet df and description information to build the list
  for (i in seq.int(1,data_object[[1]]$num_cols)){
    list_items <- strsplit(full_string_list[i],': ')[[1]]
    col_list <- list(name = list_items[1],
                     type = list_items[2],
                     description = description_df[1,list_items[1]])

    init_list[[i]] <- col_list

  }
  return(init_list)
}


#' Build publication object for collection
#'
#' @param doi doi for publications that are relevant to the collection
#' @param citation full citation for publications that are relevant to the collection
#'
#' @return
#' @export
#'
#' @examples
build_publications <- function(doi,citation){

  pub_list <- list(list(doi = doi,
                   citation = citation))


  return(pub_list)
}


#' Create and save JSON file for collection
#'
#' @param collection_object full collection list created by the build_collection() function
#' @param path relative or absolute path for the JSON file destination
#' @param ... any additional arguments can be used here
#'
#' @return
#' @export
#'
#' @examples
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
# build_stac_extensions <- function(){
#
#   test_list <- list()
#
#   return(test_list)
# }
