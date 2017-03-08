# this file should be idempotent -- running it multiple times has the same effect as running it once

# galaxy catalog database @ Azure blob storage
catalogUrl <- "https://galaxyzoosample.blob.core.windows.net/galaxyzoo/zoo2MainSpecz.csv.gz"

# individual images, zipped up @ Azure blob storage
# originally from Sloan Digital Sky Survey dev website: skyservice.pha.jhu.edu
imagesUrl <- "https://galaxyzoosample.blob.core.windows.net/galaxyzoo/img.zip"


# location to save raw images
imgPath <- "d:/data/galaxyzoo/img"

# location to save processed images
procImgPath <- "d:/data/galaxyzoo/processed"

# connection string for SQL operationalisation/deployment
deployDbConnStr <- if(file.exists("code/deployDbConnStr.txt")) readLines("code/deployDbConnStr.txt")[1] else NULL

# credentials for mrsdeploy
# this should be a two-line file, with the login username and password
deployCred <- local({
    cred <- readLines("code/deployCred.txt")
    list(username=cred[1], password=cred[2])
})

