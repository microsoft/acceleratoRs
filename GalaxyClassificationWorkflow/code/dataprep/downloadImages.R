source("code/settings.R")
load("data/processed/galaxyCatalog.rdata")


# download image archive from Azure blob storage (originally from SDSS dev site)
# filename of each image matches to specobjid column in catalog
getImages <- function(url)
{
    # save downloaded zip to parent dir -- zip has path embedded in it
    imgPath <- dirname(imgPath)
    destFile <- file.path(imgPath, "img.zip")
    download.file(url, destFile, mode="wb")
    unzip(destFile, exdir = imgPath)
    invisible(NULL)
}

getImages(imagesUrl)

