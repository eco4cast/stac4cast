

#' Build full metadata collection
#'
#' @param id unique identifier for the collection
#' @param type always set to "Collection" for collection items
#' @param stac_version version of STAC to implement
#' @param license collection license. Best to use an SPDX identifier format, <https://spdx.org/licenses/>
#' @param links list of related objects and their relation relationships
#' @param title short title for the collection
#' @param assets dictionary of asset objects that can be downloaded
#' @param extent spatial and temporal extents
#' @param keywords list of keywords describing the collection
#' @param providers all organizations capturing or processing the data or the
#'  hosting provider
#' @param summaries a map of property summaries, either a set of values, a
#;  range of values or a JSON schema
#' @param description detailed multi-line description to fully explain
#'  the collection
#' @param item_assets an optional dictionary of asset objects associated with
#'  the collection that can be downloaded or streamed, each with a unique key
#' @param table_columns column names, type, and description for data table
#' @param extensions a list of extensions the collection implements
#' @param publications list of relevant publication information for the
#'  collection
#'
#' @return a collection list object
#' @export
#'
build_collection <- function(id,
                             type = 'Collection',
                             stac_version = '1.0.0',
                             license = 	"CC0-1.0",
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

  collection_list
}



#' Build the Links field for a collection
#'
#' @param root The actual link in the format of an URL.
#'  Relative and absolute links are both allowed.
#' @param items URL to any items.json
#' @param self URL
#' @param parent URL to parent of self
#' @param doi optional argument to be used in the cite-as link object
#' @param about a URL for describing the relevant organization or group for the collection
#' @param license URL of license
#' @param example URL of an example notebook
#' @export
#'
build_links <- function(root,
                        items = file.path(root, "items.json"),
                        parent,
                        self = root,
                        doi = NULL,
                        license = "https://creativecommons.org/publicdomain/zero/1.0/",
                        about = NULL,
                        example = NULL){
links_list <- list(list(rel = "items", type = "application/json", href = items),
                   list(rel = "parent", type = "application/json", href = parent),
                   list(rel = "root", type = "application/json", href = root),
                   list(rel = "self", type = "application/json", href = self),
                   list(rel = "cite-as", href = doi),
                   list(rel = "about", href = about, type = 'text/html',
                        title = 'Organization Homepage'),
                   list(rel = "license", href = license, type = 'text/html',
                        title = "public domain"),
                   list(rel = "describedby", href = example,
                        title = 'Example Notebook',type = 'text/html'))
  # FIXME drop whole link element for any entries for which href is NULL
  return(links_list)
}


#' Build the Assets object for a collection
#'
#' @param thumbnail list describing the thumbnail object(s) used in the collection
#' @param ... list describing the parquet object(s) used in the collection
#'
#' @export
#'
build_assets <- function(thumbnail = build_thumbnail(),
                         ...){

  assets_list <- list(thumbnail = thumbnail,
                      ...)

  return(assets_list)
}


#' Build the thumbnail list to be used in the build_assets() function
#'
#' @param href the actual link in the format of an URL. Relative and absolute links are both allowed
#' @param title optional title to be used in rendered displays of the link
#'
#' @export
#'
build_thumbnail <- function(href,title){ #assuming thubmail is an image

  thumbnail_list <- list(href = href,
                         type = "image/JPEG",
                         roles = list("thumbnail"),
                         title = title)
  return(thumbnail_list)
}


#' Build the parquet list to be used in the build_assets() function
#'
#' @param href the actual link in the format of an URL. Relative and absolute links are both allowed
#' @param title optional title to be used in rendered displays of the link
#' @param description optional description for the parquet items
#'
#' @export
#'
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
#' @export
#'
build_extent <- function(lat_min, lat_max, lon_min, lon_max,
                         min_date, max_date) {

  dt_format <- function(x){
    x <- as.POSIXlt(x)
    format(x, "%Y-%m-%dT%H:%M:%SZ")
  }
  # if data through present then set max_date = NULL
  if (is.null(max_date)){
    temporal_list <- list(dt_format(min_date),'null')
  } else {
    temporal_list <- list(list(dt_format(min_date),
                               dt_format(max_date)))
  }

  bbox_list <- list(list(lon_min,
                    lat_min,
                    lon_max,
                    lat_max))

  extent_list <- list(spatial = list(bbox = bbox_list),
                      temporal = list(interval = temporal_list))

  return(extent_list)
}





#' Build providers object for the collection
#'
#' @param data_url URL for data provider organization
#' @param data_name data provider organization
#' @param host_url URL for data host
#' @param host_name name of data host
#'
#' @export
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
#' @export
#'
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

#' Build table_columns object for collection
#'
#' @param data_object parquet object used to store data
#' @param description_df dataframe of table column descriptions, one description for each column needed
#'
#' @export
#'
build_table_columns_full_bucket <- function(data_object,description_df){

  full_string_list <- strsplit(data_object$ToString(),'\n')[[1]]

  #create initial empty list
  init_list = vector(mode="list", length = data_object[[1]]$num_cols)

## loop through parquet df and description information to build the list
  for (i in seq.int(1,data_object$num_cols)){
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

#' @export
#'

build_publications <- function(doi,citation){

  pub_list <- list(doi = doi,
                   citation = citation)


  return(pub_list)
}


#' Create and save JSON file for collection
#'
#' @param collection_object full collection list created by the build_collection() function
#' @param path relative or absolute path for the JSON file destination
#' @param ... any additional arguments can be used here
#'

#' @export
#'

write_stac <- function(collection_object, path, ...){
  compact_collection <- compact(collection_object)
  jsonlite::write_json(compact_collection, path,
                       pretty = TRUE, auto_unbox = TRUE)
}


compact <- function (l) {
  Filter(Negate(is.null), l)
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
