source("code/settings.R")
load("data/processed/galaxyCatalog.rdata")


# download image archive from Azure blob storage (originally from SDSS dev site)
# filename of each image matches to specobjid column in catalog
getImages <- function()
{
    # individual images, zipped up @ Azure blob storage
    # originally from Sloan Digital Sky Survey dev website: skyservice.pha.jhu.edu
    imagesUrl <- "https://galaxyzoosample.blob.core.windows.net/galaxyzoo/img.zip"

    destFile <- file.path(settings$imgPath, basename(imagesUrl))
    download.file(imagesUrl, destFile, mode="wb")
    unzip(destFile, exdir=settings$imgPath, junkpaths=TRUE)
    # delete zip to save space, ensure imgPath only contains jpgs
    unlink(destFile)
    invisible(NULL)
}

getImages()

