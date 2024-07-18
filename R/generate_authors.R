#' Build the Authors for asset items
#'
#' @param metadata_table table created from model registration metadata
#'
#' @export
#'
generate_authors <- function(model, metadata_table){

  model_info <- metadata_table |>
    filter(model_id == model)

  if (is.na(model_info$`Can we publicly list your name and email as part of the model metadata?`)){

    x <- list(list('url' = 'pending',
                   'name' = 'pending',
                   'roles' = list("producer",
                                  "processor",
                                  "licensor")))

  }else if (model_info$`Can we publicly list your name and email as part of the model metadata?` == 'Yes'){

    #url_info <- model_info$`Contact email`
    url_info <- model_info$`Web link to model code`
    name_info <- model_info$`Contact name`

    x <- list(list('url' = url_info,
                   'name' = name_info,
                   'roles' = list("producer",
                                  "processor",
                                  "licensor")))

  }else{
    x <- list(list('url' = 'pending',
                   'name' = 'pending',
                   'roles' = list("producer",
                                  "processor",
                                  "licensor")))
  }
}
