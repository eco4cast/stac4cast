#' Extract and save thumbnail images for catalog
#'
#' @param theme theme to use for thumbnail
#' @param m_id model id to use for thumbnail
#' @param image_name image name
#'
#' @return JSON code for image asset
#' @export
#'
pull_images <- function(theme, m_id, image_name){

  info_df <- arrow::open_dataset(info_extract$path(glue::glue("{theme}/model_id={m_id}/"))) |>
    collect()

  sites_vector <- sort(unique(info_df$site_id))

  base_path <- catalog_config$base_image_path

  image_assets <- purrr::map(sites_vector, function(i)
    #url_validator <- Rcurl::url.exists(file.path(base_path,theme,m_id,i,image_name))
    list(
      "href"= file.path(base_path,theme,m_id,i,image_name),
      "type"= "image/png",
      "title"= paste0('Latest Results for ', i),
      "description"= 'Image from s3 storage',
      "roles" = list('thumbnail')
    )
  )

  ## check if image rendered successfully on bucket. If not remove from assets
  item_remove <- c()

  if (image_name == 'latest_scores.png'){
    for (item in seq.int(1:length(image_assets))){
      url_validator = RCurl::url.exists(image_assets[[item]]$href)
      if(url_validator == FALSE){
        print(paste0('Removing ', image_assets[[item]]$title))
        item_remove <- append(item_remove,item)
      }
    }
    if (length(item_remove) > 0){
      image_assets <- image_assets[-item_remove]
    }
  }

  return(image_assets)

}
