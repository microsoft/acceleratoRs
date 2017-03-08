readModel <- function(modelDef)
{
    env <- new.env()
    source(modelDef, local=env)

    trainSize <- env$trainSize
    testSize <- env$testSize

    if(!is.null(env$seed))
        set.seed(env$seed)
    id <- unique(galaxyImages$specobjid)
    trainId <- sample(id, size=trainSize, replace=FALSE)
    testId <- sample(setdiff(id, trainId), size=testSize, replace=FALSE)

    list(comment=env$comment,
        trainId=trainId, testId=testId,
        numIterations=env$numIterations,
        miniBatchSize=env$miniBatchSize,
        acceleration=env$acceleration,
        optim=env$optim,
        netDefinition=env$netDefinition)
}


trainModel <- function(modelDef)
{
    if(is.character(modelDef))
        modelDef <- readModel(modelDef)

    model <- within(modelDef, {
        trainData <- filter(galaxyImages, specobjid %in% modelDef$trainId)
        testData <- filter(galaxyImages, specobjid %in% modelDef$testId)

        time <- system.time({
            model <- rxNeuralNet(galclass ~ pixels, data=trainData,
                type="multiClass", mlTransformVars="path",
                mlTransforms=list(
                    "BitmapLoaderTransform{col=Image:path}",
                    "BitmapScalerTransform{col=bitmap:Image width=50 height=50}",
                    "PixelExtractorTransform{col=pixels:bitmap}"
                ),
                netDefinition=netDefinition,
                optimizer=optim,
                acceleration=acceleration,
                miniBatchSize=miniBatchSize,
                numIterations=numIterations,
                normalize="no", initWtsDiameter=0.1, postTransformCache="Disk"
            )
        })
    })

    class(model) <- "galaxyModel"
    model
}


print.galaxyModel <- function(model, printNetDefinition=FALSE)
{
    cat(model$comment, "\n\n")
    print(model$model)

    cat("\nOptimizer:\n")
    print(model$optim)
    cat("Iterations:", model$numIterations, "\n")
    cat("Mini-batch size:", model$miniBatchSize, "\n")
    cat("Acceleration:", model$acceleration, "\n")
    cat("\nTraining dataset size:", nrow(model$trainData), "\n")
    cat("Test dataset size:", nrow(model$testData), "\n")
    cat("\nTraining time:", model$time[3]/60, "minutes\n")
    if(printNetDefinition)
    {
        cat("\nNetwork definition:\n===================\n")
        print(model$netDefinition)
    }
    invisible(model)
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


predictGalaxyClass <- function(model, ...)
UseMethod("predictGalaxyClass")


predictGalaxyClass.galaxyModel <- function(model, newdata, level=c("high", "low"), ...)
{
    pred <- rxPredict(model$model, newdata, ...)$PredictedLabel
    level <- match.arg(level)
    if(level == "high")
        reclassifyGalaxy(pred)
    else pred
}


evaluateFit <- function(model, ...)
UseMethod("evaluateFit")


evaluateFit.galaxyModel <- function(model, ...)
{
    if(is.character(model))
        model <- model %>% readModel %>% trainModel

    tab <- table(
        model$testData$galclass,
        predictGalaxyClass(model, model$testData, level="low"))
    error <- 1 - sum(diag(tab))/sum(tab)

    obj <- list(tab=tab, error=error)
    class(obj) <- "eval.galaxyModel"
    obj
}


print.eval.galaxyModel <- function(obj)
{
    tab <- obj$tab

    cat("\nLow-level confusion matrix:")
    print(tab)
    err <- 1 - diag(tab)/rowSums(tab)
    cat("\nClass-specific low-level error rates:\n")
    print(err, digits=3)
    cat("\nOverall low-level error rate:", obj$error, "\n")

    classes <- list(
        Ambiguous="A",
        Elliptical=c("Er", "Ei", "Ec"),
        Spiral=c("Se", "Sd", "Sc", "Sb", "Sa"),
        BarredSpiral=c("SBd", "SBc", "SBb", "SBa")
    )
    tab2 <- matrix(nrow=4, ncol=4, dimnames=list(names(classes), names(classes)))
    for(i in names(classes))
    {
        for(j in names(classes))
        {
            iOrig <- classes[[i]]
            jOrig <- classes[[j]]
            tab2[i, j] <- sum(tab[iOrig, jOrig])
        }
    }

    cat("\n\nHigh-level confusion matrix:\n")
    print(tab2)
    err2 <- 1 - diag(tab2)/rowSums(tab2)
    cat("\nClass-specific high-level error rates:\n")
    print(err2, digits=3)
    cat("\nOverall high-level error rate:", 1 - sum(diag(tab2))/sum(tab2), "\n")

    invisible(obj)
}

