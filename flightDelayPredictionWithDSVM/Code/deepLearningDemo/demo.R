# -----------------------------------------------------------------------------
# Get data processed in Spark.
# -----------------------------------------------------------------------------

library(AzureSMR)
library(jsonlite)
library(dplyr)
library(magrittr)

context <- createAzureContext(tenantID=TID, clientID=CID, authKey=KEY)

# get remote blob of the data processed previously in Spark.

js_processed <- AzureSMR::azureGetBlob(context, 
                                       blob="processed_data.json",
                                       type="text", 
                                       storageAccount=SA_ACCOUNT,
                                       storageKey=SA_KEY,
                                       container=SA_CONTAINER,
                                       resourceGroup=RG)

# take a look at the processed data.

df_processed <- 
  fromJSON(js_processed) %>%
  mutate(DayOfWeek=as.factor(DayOfWeek),
         DayofMonth=as.integer(DayofMonth),
         Origin=as.factor(Origin),
         Dest=as.factor(Dest),
         DepTime=as.numeric(DepTime),
         ArrDel15=ifelse(ArrDel15 == "TRUE", 1, 0)) %T>%
         {head(.) %>% print()}

# -----------------------------------------------------------------------------
# Modeling training with Microsoft Neural Network algorithm with and without GPU acceleration
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

# score model and plot roc curve.

scores <- rxPredict(model_nn1, 
                    data=df_test, 
                    suffix="WithoutGPU",
                    extraVarsToWrite=names(df_test))

scores <- rxPredict(model_nn2,
                    data=scores,
                    suffix="WithGPU",
                    extraVarsToWrite=names(scores))

roc <- rxRoc(actualVarName="ArrDel15", 
             predVarNames=grep("Probability", 
                               names(scores), 
                               value=TRUE),
             data=scores)

auc <- rxAuc(roc)

# save model into a RData object.

models <- list(model_nn2, model_nn1)

model_optimal <- models[[which(auc == max(auc))]]
