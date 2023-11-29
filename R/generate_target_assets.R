#' Build the Assets objects for model JSONS
#'
#' @param full_var_df dataframe that contains variable column information (name, full name, duration, duration name)
#' @param aws_path s3 path for accessing model data
#' @export
#'
#'
generate_target_assets <- function(target_groups, thumbnail_link, thumbnail_title){

  thumbnail_asset <- list(
    #"1"= list(
    'thumbnail' = list(
      "href"= thumbnail_link,
      "type"= "image/JPEG",
      "roles" = list('thumbnail'),
      "title"= thumbnail_title)
 #   )
  )

  iterator_list <- 1:length(names(target_groups))

  target_download_assets <- purrr::map(iterator_list, function(i)
     data = list(
      #"data" = list(
        "href" = target_groups[[i]][[1]],
        "type" = "application/x-parquet",
        "title"= paste(names(target_groups)[i],'Target Access'),
        "roles" = list('data'),
        "description"= paste0("This R code will return results for the relevant targets file.\n\n### R\n\n```{r}\n# Use code below\n\nurl <- ",target_groups[[i]]$targets_file,
                              "\ntargets <- readr::read_csv(url, show_col_types = FALSE)\n```")
      )
    #)
  )

  target_assets <- c(thumbnail_asset, target_download_assets)

  return(target_assets)
}
