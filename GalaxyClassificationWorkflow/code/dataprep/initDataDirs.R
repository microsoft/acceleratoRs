source("code/settings.R")

# create data directory tree (part of regular TDSP folder structure)
dir.create("data", showWarnings = FALSE)
dir.create("data/output", showWarnings = FALSE)
dir.create("data/processed", showWarnings = FALSE)
dir.create("data/raw", showWarnings = FALSE)
dir.create("data/testing", showWarnings = FALSE)


# separate locations for big downloads
if(!dir.exists(settings$imgPath)) dir.create(settings$imgPath, recursive=TRUE)
if(!dir.exists(settings$procImgPath)) dir.create(settings$procImgPath, recursive=TRUE)

