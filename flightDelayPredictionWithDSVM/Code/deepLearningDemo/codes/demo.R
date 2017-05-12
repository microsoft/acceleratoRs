# -----------------------------------------------------------------------------
# Remote to spark demo.
# -----------------------------------------------------------------------------

library(AzureSMR)
library(jsonlite)
library(dplyr)
library(magrittr)

# authentication with credentials.

source("demo/codes/credentials.R")

context <- createAzureContext(tenantID=TID, clientID=CID, authKey=KEY)

# get remote blob of the data processed previously in Spark.

js_processed <- AzureSMR::azureGetBlob(context, 
                                       blob="processed_data.json",
                                       type="text", 
                                       storageAccount=SA_ACCOUNT,
                                       storageKey=SA_KEY,
                                       container=SA_CONTAINER,
                                       resourceGroup="dldemo")

# take a look at the processed data.

df_processed <- 
  fromJSON(js_processed) %>%
  mutate(DayOfWeek=as.factor(DayOfWeek),
         Origin=as.factor(Origin),
         Dest=as.factor(Dest)) %T>%
         {head(.) %>% print()}

# -----------------------------------------------------------------------------
# Modeling training with Microsoft Neural Network algorithm with GPU acceleration
# -----------------------------------------------------------------------------

library(mrsdeploy)
library(MicrosoftML)

# split data into training and testing sets.

index <- sample(1:nrow(df_processed), round(0.7 * nrow(df_processed)))

df_train <- df_processed[index, ]
df_test  <- df_processed[-index, ]

# train a neural network model.

var_names <- rxGetVarNames(df_train)
dep_name  <- "ArrDel15"
ind_names <- var_names[which(var_names != dep_name)]

formu <- paste(dep_name, "~", paste(ind_names, collapse=" + "))

# without GPU acceleration. 

model_nn1 <- rxNeuralNet(formu,
                         data=df_train,
                         type="binary", 
                         acceleration="sse", 
                         optimizer=adaDeltaSgd(),
                         numIterations=30) 

# with GPU acceleration.

model_nn2 <- rxNeuralNet(formu,
                         data=df_train,
                         type="binary", 
                         acceleration="gpu", 
                         optimizer=adaDeltaSgd(),
                         numIterations=30, 
                         miniBatchSize=256)

# random forest model.

model_rf <- rxFastForest(formu,
                         data=df_train,
                         type="binary")

model_lr <- rxLogit(formu,
                    data=df_train)

# score model and plot roc curve.

scores <- rxPredict(model_nn1, 
                    data=df_test, 
                    suffix="WithoutGPU",
                    extraVarsToWrite=names(df_test))

scores <- rxPredict(model_nn2,
                    data=scores,
                    suffix="WithGPU",
                    extraVarsToWrite=names(scores))

scores <- rxPredict(model_rf,
                    data=scores,
                    suffix="RandomForest",
                    extraVarsToWrite=names(scores))

roc <- rxRoc(actualVarName="ArrDel15", 
             predVarNames=grep("Probability", 
                               names(scores), 
                               value=TRUE),
             data=scores)

plot(roc)

auc <- rxAuc(roc)

# save model into a RData object.

models <- list(model_rf, model_nn2, model_nn1)

model_optimal <- models[[which(auc == max(auc))]]

save(model_optimal, file="demo/data/model.RData")

# -----------------------------------------------------------------------------
# Deploy model as a real-time web services.
# -----------------------------------------------------------------------------

end_point <- "appdemo.southeastasia.cloudapp.azure.com"

# authentication on the remote MRS.

remoteLogin(deployr_endpoint=paste0("http://", end_point, ":12800"),
            session=TRUE, 
            username="admin", 
            password=PWD)

# pause() in the remote session to switch back to local R session.

save.image(file="demo/data/image.RData")

putLocalFile("demo/data/image.RData")

# resume() switch to remote session and load the saved image where credentials are contained.

# load("image.RData")

# authenticate again at remote session (remote session disabled).

mrsdeploy::remoteLogin(deployr_endpoint=paste0("http://", end_point, ":12800"),
                       session=FALSE,
                       username="admin",
                       password=PWD)

# pause() to switch back to local R session to publish a real time service with the trained model on the remote app server.

# wrap the model into a function for publish.

delayPrediction <- function(DayOfMonth, 
                            DayOfWeek,
                            Origin,
                            Dest,
                            DepTime) {
  
  # NOTE column of ArrDel15 is provided due to the requirement of MML model.
  
  newdata <- data.frame(DayofMOnth=DayOfMonth,
                        DayOfWeek=as.factor(DayOfWeek),
                        Origin=as.factor(Origin),
                        Dest=as.factor(Dest),
                        DepTime=DepTime,
                        ArrDel15=as.integer(0))
  
  rxPredict(model_optimal, newdata)$PredictedLabel
}

# publish the model as a real time web service.

publishService(name="DelayPrediction",
               model=model_optimal,
               code=delayPrediction,
               inputs=list(DayOfMonth="integer",
                           DayOfWeek="character",
                           Origin="character",
                           Dest="character",
                           DepTime="numeric"),
               outputs=list(ArrDel15="integer"),
               # model=model_lr,
               v="0.0.1",
               alias="DPModel") 

# consume the web service.

listServices()

delay_pred_api <- getService(name="DelayPrediction", v="0.0.1")

# test with testing data.

df_test_1 <- df_test[sample(nrow(df_test), 1), ]

# use the web service for prediction.

air_delay_prediction <- delay_pred_api$DPModel(df_test_1$DayofMOnth,
                                               as.character(df_test_1$DayOfWeek),
                                               as.character(df_test_1$Origin),
                                               as.character(df_test_1$Dest),
                                               df_test_1$DepTime)

# predicted label.

print(air_delay_prediction$outputParameters$ArrDel15)