#' Build table_columns object for collection using whole s3 bucket
#'
#' @param data_object parquet object used to store data
#' @param description_df dataframe of table column descriptions, one description for each column needed
#'
#' @return JSON code for the table columns asset
#' @export
#
build_table_columns_full_bucket <- function(data_object,description_df, s3_schema_build = TRUE){

if (s3_schema_build == TRUE){
  full_string_list <- strsplit(data_object$ToString(),'\n')[[1]]

  #create initial empty list
  init_list = vector(mode="list", length = data_object$num_cols)

  ## loop through parquet df and description information to build the list
  for (i in seq.int(1,data_object$num_cols)){
    list_items <- strsplit(full_string_list[i],': ')[[1]]
    col_list <- list(name = list_items[1],
                     type = list_items[2],
                     description = description_df[1,list_items[1]])

    init_list[[i]] <- col_list

  }
  return(init_list)

} else if (s3_schema_build == FALSE){

  col_list <- purrr::map(1:ncol(data_object), function(i)
    list(
      name = names(data_object)[i],
      type = sapply(data_object,class)[[i]],
      description = description_df[1,names(data_object)[i]])
  )

}
  ## check if first item is empty (current problem with json)
  if (is.null(init_list[[1]]$type)){
    init_list <- init_list[-1]
  }
}
