source("code/settings.R")

load("data/output/model1.rdata")
load("data/output/model1a.rdata")
load("data/output/model1b.rdata")
load("data/output/spPredictGalaxyClass.rdata")

library(MicrosoftML)
library(mrsdeploy)

remoteLogin("http://localhost:12800", session=FALSE, username=settings$deployCred[1], password=settings$deployCred[2])


apiObjects <- list(deployDbConnStr=settings$deployDbConnStr, spPredictGalaxyClass=spPredictGalaxyClass)

apiPredictGalaxyClass <- function(id, img)
{
    imgData <- data.frame(specobjid=id, img=img, stringsAsFactors=FALSE)
    sqlImgData <- RxSqlServerData("galaxyImgData", connectionString=apiObjects$deployDbConnStr)
    rxDataStep(imgData, sqlImgData, overwrite=TRUE)

    # remove the table when we're done
    on.exit(rxSqlServerDropTable(sqlImgData))

    sqlrutils::executeStoredProcedure(apiObjects$spPredictGalaxyClass)$data
}

try(deleteService("apiPredictGalaxyClass", "1.0"))
apiGalaxyModel <- publishService("apiPredictGalaxyClass", apiPredictGalaxyClass, apiObjects,
    inputs=list(id="character", img="character"),
    outputs=list(pred="data.frame"),
    v="1.0"
)

writeBin(apiGalaxyModel$swagger(), "data/output/swagPredictGalaxyClass.json")

remoteLogout()

