source("code/settings.R")

# test that API works
library(mrsdeploy)

remoteLogin("http://localhost:12800", session=FALSE)
#remoteLogin("http://localhost:12800")


# generate dataset from test images
files <- dir("data/testing", pattern="\\.jpg$", full=TRUE)
img <- sapply(files, function(f)
    paste0(as.character(readBin(f, raw(), file.size(f))), collapse=""))


print(getService("apiPredictGalaxyClass", "1.0")$  # method chaining, R6-style
    apiPredictGalaxyClass(files, img)$
    output("pred"))

remoteLogout()

