

build_collection <- function(title,
                             links = build_links(),
                             assets = NULL,
                             extent) {

  list(id = id,
       type = "Collection",
       title = title,
       assets = assets,  #REMEMBER TO COLLAPSE NULLS
       )
}

build_links <- function(){


}

build_asset <- function(){


}

write_stac <- function(x, path, ...){
 jsonlite::write_json(x, path, ...)
}
