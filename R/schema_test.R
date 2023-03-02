test_df <- theme_df


full_string_list <- strsplit(theme_df[[1]]$ToString(),'\n')[[1]]


init_list = vector(mode="list", length = theme_df[[1]]$num_cols)

for (i in seq.int(1,theme_df[[1]]$num_cols)){
  list_items <- strsplit(full_string_list[i],': ')[[1]]
  col_list <- list(name = list_items[1],
                   type = list_items[2])

  init_list[[i]] <- col_list

}
