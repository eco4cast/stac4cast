#' Create publication items
#'
#' @param model_list unique model_ids
#'
#' @return JSON code for model asset items
#' @export
#'
#'

#theme_doi <- config$target_groups$Phenology$theme_doi
#theme_citation <- config$target_groups$Phenology$theme_citation

build_publication_items <- function(var_citation, var_doi){

  if (is.null(var_citation) | is.null(var_doi)){
    t <- array()
    #return(NULL)
  }else{
  doi_list <- c(catalog_config$citation_doi)
  citation_list <- c(catalog_config$citation_text)

  if(length(var_doi) != 0){
    doi_list <- append(doi_list, var_doi)
    citation_list <- append(citation_list, var_citation)
  }

  t <- purrr::map2(doi_list, citation_list, function(.x,.y)
    list(
      "doi" = .x,
      "citation" = .y)
  )
  }

  return(t)
  #}
}
