# Thumbnails

url <- gefs4cast:::gefs_urls("geavg", Sys.Date()-2)[[1]]
library(terra)
library(tmap)

jpeg("components/gefs_thumbnail.jpg", width = 720, height=361)
rast(url, lyrs=63) |>
  plot(legend=FALSE, axes=FALSE,
       box=FALSE, buffer = FALSE)
dev.off()

# "https://www.neonscience.org/sites/default/files/styles/he/public/image-content-images/8_Aerial_views.png

minio::mc("cp components/gefs_thumbnail.jpg efi/neon4cast-catalog/img/gefs_thumbnail.jpg")

  #
