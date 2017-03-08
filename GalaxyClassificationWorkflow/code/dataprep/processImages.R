source("code/settings.R")

library(parallel)


# preprocessing steps:
# - crop by 26% linear dimension
# - rotate by given angle (0, 45, 90 deg)
# - resize to 50x50
processImage <- function(angle, files, chunkSize=10000)
{
    outPath <- file.path(procImgPath, angle)
    if(!dir.exists(outPath)) dir.create(outPath, recursive=TRUE)

    # do this in chunks to allow checkpointing
    n <- length(files)
    nChunks <- n%/%chunkSize + (n%%chunkSize != 0)

    res <- list()
    for(i in seq_len(nChunks))
    {
        message("doing rotation angle ", angle, ", chunk ", i)
        # vector of rows for this chunk
        this <- if(i != nChunks)
            chunkSize*(i - 1) + 1:chunkSize
        else chunkSize*(i - 1) + 1:(n%%chunkSize)

        thisChunk <- files[this]
        res[[i]] <- parSapply(cl, thisChunk, function(f, size, angle, path) {
                ri <- try(imager::load.image(f) %>%
                    cropGalaxy(0.26) %>%
                    rotateGalaxy(angle) %>%
                    resizeGalaxy(c(50, 50)) %>%
                    imager::save.image(file.path(path, basename(f))))
                if(inherits(ri, "try-error"))
                    f
                else "0"
            },
            path=outPath, angle=angle, USE.NAMES=FALSE)
    }
    invisible(res)
}

imgFiles <- dir(imgPath, pattern="\\.jpg$", full=TRUE)
angle <- c(0, 45, 90)

if(!dir.exists(procImgPath)) dir.create(procImgPath, recursive=TRUE)


# do preprocessing in parallel
cl <- makeCluster(3)

# load necessary functions on to slave nodes
invisible(clusterEvalQ(cl, {
    source("code/settings.R")
    source("code/dataprep/processImageFuncs.R")
    library(magrittr)
}))

system.time(res <- lapply(angle, processImage, files=imgFiles))

#all(unlist(res) == "0")

stopCluster(cl)
