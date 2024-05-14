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

  if ('site_id' %in% names(site_df) == FALSE){
    site_df <- site_df |>
      rename(site_id = field_site_id) ## rename the neon site_id column
  }

  relevant_sites <- sites[which(sites %in% site_df$site_id)]

  site_lat_lon <- lapply(relevant_sites, function(i){c(site_df$longitude[which(site_df$site_id == i)],
                                                       site_df$latitude[which(site_df$site_id == i)])})

  return(site_lat_lon)
}
