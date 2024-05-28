#' Build the model items within each variable group
#'
#' @param model_list list of unique models for each variable
#' @return JSON code for model items
#' @export
#'
generate_variable_model_items <- function(model_list){


  #var_values <- variables

  x <- purrr::map(model_list, function(i)
    list(
      "rel" = 'item',
      'type'= 'application/json',
      'href' = paste0('./models/',i,'.json'))
  )

  return(x)
}
