library(minio)
minio::mc("cp noaa.json efi/neon4cast-catalog/stac/v1/collections/noaa.json")


minio::mc("cp efi-catalog.json efi/neon4cast-catalog/stac/v1/catalog.json")

