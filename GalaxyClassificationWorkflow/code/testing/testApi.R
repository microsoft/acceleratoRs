source("code/settings.R")

# test that API works
library(mrsdeploy)

remoteLogin("http://localhost:12800", username=settings$deployCred[1], password=settings$deployCred[2], session=FALSE)
#remoteLogin("http://localhost:12800", username=settings$deployCred[1], password=settings$deployCred[2], session=TRUE)


files <- dir("data/testing", pattern="\\.jpg$", full=TRUE)[1]
img <- sapply(files, function(f)
    paste0(as.character(readBin(f, raw(), file.size(f))), collapse=""))


print(getService("apiPredictGalaxyClass", "1.0")$  # method chaining, R6-style
    apiPredictGalaxyClass(files, img)$
    output("pred"))

remoteLogout()

