library(minio)
minio::mc("cp noaa.json efi/neon4cast-catalog/stac/v1/collections/noaa.json")

minio::mc("cp aquatics.json efi/neon4cast-catalog/stac/v1/collections/aquatics.json")
minio::mc("cp terrestrial.json efi/neon4cast-catalog/stac/v1/collections/terrestrial.json")
minio::mc("cp beetles.json efi/neon4cast-catalog/stac/v1/collections/beetles.json")
minio::mc("cp phenology.json efi/neon4cast-catalog/stac/v1/collections/phenology.json")

minio::mc("cp efi-catalog.json efi/neon4cast-catalog/stac/v1/catalog.json")


minio::mc("cp components/BONA_Twr.jpg efi/neon4cast-catalog/img/BONA_Twr.jpg")
