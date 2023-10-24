#' Build the Authors for asset items
#'
#' @param metadata_table table created from model registration metadata
#'
#' @export
#'
generate_authors <- function(metadata_table){

  x <- list(list('url' = 'pending',
                 'name' = 'pending',
                 'roles' = list("producer",
                                "processor",
                                "licensor"))
  )
}
