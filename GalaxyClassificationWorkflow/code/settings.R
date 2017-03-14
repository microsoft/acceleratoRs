# Application settings file.
# File content was generated on 12-Mar-17 11:18:31 PM.

settings <- as.environment(list())

settings$imgPath <- 'data/img'

settings$procImgPath <- 'data/imgProcessed'

settings$deployDbConnStr <- if(file.exists("code/deployDbConnStr.txt")) readLines("code/deployDbConnStr.txt")[1] else NULL

settings$deployCred <- if(file.exists("code/deployCred.txt")) readLines("code/deployCred.txt") else NULL

