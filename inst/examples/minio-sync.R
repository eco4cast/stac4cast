library(minio)
minio::mc("cp gefs.json efi/neon4cast-catalog/stac/v1/gefs.json")
minio::mc("cp noaa.json efi/neon4cast-catalog/stac/v1/noaa.json")

minio::mc("cp efi-catalog.json efi/neon4cast-catalog/stac/v1/catalog.json")


#"https://data.ecoforecast.org/neon4cast-catalog/gefs_collection.json"
