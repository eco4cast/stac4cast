#' Get bbox for forecast/scores and collection groups
#'
#' @param site_metadata site metadata provided as path or url
#' @param sites list of unique sites for the group
#'
#' @return list of site lat and lon pairs
#' @export
#'
#'
get_bbox <-function(site_metadata, sites){
  site_df <- readr::read_csv(site_metadata, col_types = cols())

  if (!is.null(sites)){

    site_lat <- sapply(sites,function(i) site_df$latitude[which(site_df[,2] == i)])
    site_lon <- sapply(sites,function(i) site_df$longitude[which(site_df[,2] == i)])

    bbox_coords <- c(min(site_lon), min(site_lat), max(site_lon), max(site_lat))

  } else if (is.null(sites)){
    bbox_coords <- c(min(site_df$longitude),
                       min(site_df$latitude),
                       max(site_df$longitude),
                       max(site_df$latitude))
  }

  return(bbox_coords)
}
