library(mrsdeploy)

# paths are relative to directory this file is in
# login credentials for the mrsdeploy server
deployCred <- local({
    cred <- readLines("../../code/deployCred.txt")
    list(username=cred[1], password=cred[2])
})

showImgJs <- paste(readLines("showImg.js"), collapse="\n")

