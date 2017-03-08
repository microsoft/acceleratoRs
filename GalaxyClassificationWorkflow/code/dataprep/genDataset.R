source("code/settings.R")
load("data/raw/galaxyCatalog.rdata")

library(dplyr)

imgFiles <- tools::file_path_sans_ext(dir(imgPath, pattern="\\.jpg$"))

galaxyData0 <- galaxyCatalog %>%
    select(specobjid, galclass) %>%
    filter(specobjid %in% imgFiles) %>%
    distinct

# ensure we have one row per unique galaxy ID
if(any(duplicated(galaxyData0$specobjid)))
{
    message("Some galaxies have multiple classes!")
    galaxyData0 <- distinct(galaxyData0, specobjid)
}

# assign class to each galaxy image
angle <- c(0, 45, 90)
galaxyImages <- lapply(angle, function(a) {
    message("doing angle ", a)
    path <- file.path(procImgPath, a)
    files <- dir(path, pattern="\\.jpg$")

    data_frame(specobjid=tools::file_path_sans_ext(files), path=file.path(path, files)) %>%
        inner_join(galaxyData0, by="specobjid")
})


# put everything into one dataframe
# this will contain the path to the image for each galaxy, not the image data itself
galaxyImages <- bind_rows(galaxyImages)

save(galaxyImages, file="data/processed/galaxyImages.rdata")


# store some images for testing the backend API
id <- galaxyImages$specobjid[1:20]
inFiles <- file.path(imgPath, paste0(id, ".jpg"))

file.copy(inFiles, "data/testing")

