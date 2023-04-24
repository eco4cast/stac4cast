
#' stac validate
#'
#' @param x path or url for the json file that is being validated
#' @details requires `reticulate`
#' @export
#'
stac_validate <- function(x){

  requireNamespace("reticulate", quietly = TRUE)
  if(!reticulate::py_module_available("stac_validator")) {
    reticulate::py_install('stac-validator')
  }

  stac <- reticulate::import("stac_validator",
                             as="stac",
                             delay_load = TRUE)

  out = stac$stac_validator$StacValidate(x,extensions=TRUE)

  if (out$run()){
    return(TRUE)
  }else{
    message('Schema validation found the following issues')
    message(paste('Error Type:',out$message[[1]]$error_type))
    message(paste('Error Message:',out$message[[1]]$error_message))
  }
}
