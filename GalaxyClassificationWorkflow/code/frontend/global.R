library(mrsdeploy)

# paths are relative to directory this file is in
# login credentials for the mrsdeploy server
deployCred <- readLines("../../code/deployCred.txt")

showImgJs <- paste(readLines("showImg.js"), collapse="\n")

