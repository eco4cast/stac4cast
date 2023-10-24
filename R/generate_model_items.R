#' Organize the groupings for themes
#'
#' @param inv_bucket name of s3 bucket
#' @param theme theme name
#'
#' @return JSON code for model asset items
#' @export
#'
generate_model_items <- function(model_list){

  x <- purrr::map(model_list, function(i)
    list(
      "rel" = 'item',
      'type'= 'application/json',
      'href' = paste0('model_items/',i,'.json'))
  )

  return(x)
}
