source("code/settings.R")
source("code/model/trainModelFuncs.R")
load("data/processed/galaxyImages.rdata")

library(MicrosoftML)
library(RMLtools)
library(dplyr)


model1 <- readModel("code/model/modelDef1.R") %>%
    trainModel
save(model1, "data/output/model1.rdata")

print(model1)
evaluateFit(model1)


model1a <- readModel("code/model/modelDef1a.R") %>%
    trainModel
save(model1a, "data/output/model1a.rdata")

print(model1a)
evaluateFit(model1a)


model1b <- readModel("code/model/modelDef1b.R") %>%
    trainModel
save(model1b, "data/output/model1b.rdata")

print(model1b)
evaluateFit(model1b)

