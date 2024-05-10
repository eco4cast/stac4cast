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

    if ('site_id' %in% names(site_df) == FALSE){
      site_df <- site_df |>
        rename(site_id = field_site_id) ## rename the neon site_id column
    }

    site_lat <- site_df |>
      filter(site_id %in% sites) |>
      select(latitude)

    site_lon <- site_df |>
      filter(site_id %in% sites) |>
      select(longitude)

    #site_lat <- site_df[which(site_df[,2] == sites), 'latitude']
    #site_lon <- site_df[which(site_df[,2] == sites), 'longitude']

    #site_lat <- sapply(sites,function(i) site_df$latitude[which(site_df[,2] == i)])
    #site_lon <- sapply(sites,function(i) site_df$longitude[which(site_df[,2] == i)])

    bbox_coords <- c(min(site_lon$longitude), min(site_lat$latitude), max(site_lon$longitude), max(site_lat$latitude))

  } else if (is.null(sites)){
    bbox_coords <- c(min(site_df$longitude),
                       min(site_df$latitude),
                       max(site_df$longitude),
                       max(site_df$latitude))
  }

  return(bbox_coords)
}
