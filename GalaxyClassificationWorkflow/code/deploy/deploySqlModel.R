source("code/settings.R")
source("code/deploy/initObjectTable.R")

load("data/output/model1.rdata")
load("data/output/model1a.rdata")
load("data/output/model1b.rdata")

library(MicrosoftML)
library(sqlrutils)

# save model objects to database
galaxyModTable <- RxSqlServerData("galaxyModels", connectionString=settings$deployDbConnStr)

initObjectTable("galaxyModels", versionName=NULL, connectionString=settings$deployDbConnStr)

writeGalaxyModel <- function(model, name, table=galaxyModTable)
{
    if(missing(name))
        name <- deparse(substitute(model))
    model <- list(comment=model$comment, model=model$model)
    rxWriteObject(table, name, model)
}

writeGalaxyModel(model1)
writeGalaxyModel(model1a)
writeGalaxyModel(model1b)


# create stored procedure for scoring new data
# assumption: imgData contains serialised image files
# all model logic lives in here
spBasePredictGalaxyClass <- function(model, imgData)
{
    require(MicrosoftML, quietly=TRUE)
    require(magrittr, quietly=TRUE)

    cropGalaxy <- function(x, fraction=0.1)
    {
        ndim <- round(fraction * dim(x))
        imager::crop.borders(x, ndim[1], ndim[2])
    }

    resizeGalaxy <- function(x, ndim=c(50, 50))
    {
        imager::resize(x, ndim[1], ndim[2], dim(x)[3], dim(x)[4],
                       interpolation_type=4)
    }

    reclassifyGalaxy <- function(pred)
    {
        classes <- list(
            Ambiguous="A",
            Elliptical=c("Er", "Ei", "Ec"),
            Spiral=c("Se", "Sd", "Sc", "Sb", "Sa"),
            BarredSpiral=c("SBd", "SBc", "SBb", "SBa")
        )
        predhi <- rep(NA_character_, length(pred))
        for(i in seq_along(classes))
            predhi[pred %in% classes[[i]]] <- names(classes)[i]
        predhi
    }

    # for each image, preprocess the image and store it
    n <- nrow(imgData)
    path <- sapply(seq_len(n), function(i) {
        inFile <- tempfile(fileext=".jpg")
        outFile <- tempfile(fileext=".jpg")

        # reconstruct the image file from a varchar(MAX) column
        img <- strsplit(as.character(imgData$img[[i]]), "")[[1]]
        img <- paste0(img[c(TRUE, FALSE)], img[c(FALSE, TRUE)])
        img <- as.raw(strtoi(img, base=16))
        writeBin(img, inFile)
        
        outFile <- basename(outFile)  # workaround bug in imager::save.image: save to home dir, manually delete on exit
        imager::load.image(inFile) %>% 
            resizeGalaxy(c(424, 424)) %>%  # match dimensions of training images
            cropGalaxy(0.26) %>%
            resizeGalaxy(c(50, 50)) %>%
            imager::save.image(file=outFile)
        outFile
    })
    on.exit(unlink(path))
    imgData <- data.frame(specobjid=imgData$specobjid, galclass=" ", path=path,
        stringsAsFactors=FALSE)

    # get the predicted low-level class from the model
    if(!inherits(model, "galaxyModel"))
        model <- rxReadObject(as.raw(model))
    pred <- rxPredict(model$model, imgData)$PredictedLabel

    # collapse to high-level class
    data.frame(specobjid=imgData$specobjid, predClass=reclassifyGalaxy(pred),
        stringsAsFactors=FALSE)
}


spPredictGalaxyClass <- StoredProcedure(spBasePredictGalaxyClass,
    spName="predictGalaxyClass",
    InputData("imgData",
        defaultQuery="select * from galaxyImgData"),
    InputParameter("model", "raw",
        defaultQuery="select value from galaxyModels where id='model1b'"),
    connectionString=settings$deployDbConnStr,
    filePath="data/output"  # store the generated SQL script in this location
)

registerStoredProcedure(spPredictGalaxyClass, settings$deployDbConnStr)

save(spPredictGalaxyClass, file="data/output/spPredictGalaxyClass.rdata")

