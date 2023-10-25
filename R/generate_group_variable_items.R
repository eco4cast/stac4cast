
#' Build the group variable items
#'
#' @param variables unique variables for group
#' @export
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
