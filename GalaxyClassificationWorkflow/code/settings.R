# Application settings file.
# File content was generated on 10-Mar-17 12:11:28 PM.

settings <- as.environment(list())

settings$imgPath <- 'd:/data/galaxyzoo/img'

settings$procImgPath <- 'd:/data/galaxyzoo/processed'

settings$deployDbConnStr <- if(file.exists("code/deployDbConnStr.txt")) readLines("code/deployDbConnStr.txt")[1] else NULL

settings$deployCred <- if(file.exists("code/deployCred.txt")) readLines("code/deployCred.txt") else NULL

