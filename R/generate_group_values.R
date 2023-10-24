#' Generate child items for catalog group items (variable groups)
#'
#' @param group_values list of groups to organize the catalog (variable groups, themes, etc.)
#'
#' @return JSON code for child items
#'
generate_group_values <- function(group_values){

  x <- purrr::map(group_values, function(i)
    list(
      "rel" = "child",
      "type" = "application/json",
      "href" = paste0(i,"/collection.json"),
      "title" = i)
  )

  return(x)
}
