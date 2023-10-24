
#' Build the group variable items
#'
#' @param table_schema schema of data table, accessed through s3
#' @param table_description table that includes descriptions of data columns
#' @param start_date table that includes descriptions of data columns
#' @param end_date table that includes descriptions of data columns
#' @param description_string brief description to describe JSON
#' @return JSON code for group variable items
#'
generate_group_variable_items <- function(variables){

  var_values <- variables

  x <- purrr::map(var_values, function(i)
    list(
      "rel" = 'child',
      'type'= 'application/json',
      'href' = paste0(i,'/collection.json'))
  )

  return(x)
}
