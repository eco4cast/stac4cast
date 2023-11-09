#' Get coordinates for model sites
#'
#' @param site_metadata site metadata provided as path or url
#' @param sites list of unique sites for the model
#'
#' @return list of site lat and lon pairs
#' @export
#'
get_site_coords <- function(site_metadata, sites){

  site_df <- readr::read_csv(site_metadata, col_types = cols())

  site_lat_lon <- lapply(sites, function(i) c(site_df$longitude[which(site_df[,2] == i)], site_df$latitude[which(site_df[,2] == i)]))

  return(site_lat_lon)
}
