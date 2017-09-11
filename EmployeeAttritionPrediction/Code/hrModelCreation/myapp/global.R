# ------------------------------------------------------------------------------
# R packages needed for the analytics.
# ------------------------------------------------------------------------------

library(caret)
library(caretEnsemble)
library(DMwR)
library(dplyr)
library(ggplot2)
library(markdown)
library(magrittr)
library(mlbench)
library(pROC)
library(plotROC)
library(shiny)

# ------------------------------------------------------------------------------
# Global variables.
# ------------------------------------------------------------------------------

data_url  <- "https://zhledata.blob.core.windows.net/employee/DataSet1.csv"

# ------------------------------------------------------------------------------
# Functions.
# ------------------------------------------------------------------------------

# Load HR demographic data.

loadData <- function() {
  df <- read.csv(data_url)
  
  return(df)
}


# Process data - the same data processing steps apply on the data.

processData <- function(data) {
  
  # 1. Remove zero-variance variables.
  
  pred_no_var <- c("EmployeeCount", "StandardHours")
  data %<>% select(-one_of(pred_no_var))
  
  # 2. Convert Integer to Factor type of data.
  
  int_2_ftr_vars <- c("Education", 
                      "EnvironmentSatisfaction", 
                      "JobInvolvement", 
                      "JobLevel", 
                      "JobSatisfaction", 
                      "NumCompaniesWorked", 
                      "PerformanceRating", 
                      "RelationshipSatisfaction", 
                      "StockOptionLevel")
  data[, int_2_ftr_vars] <- lapply((data[, int_2_ftr_vars]), as.factor)
  
  # 3. Keep the most salient variables. 
  
  least_important_vars <- c("Department", "Gender", "PerformanceRating")
  data %<>% select(-one_of(least_important_vars))
  
  return(data)
} 

# Data split.

splitData <- function(data, ratio) {
  if (!("Attrition" %in% names(data))) 
      stop("No label found in data set.")
  
  train_index <- 
    createDataPartition(data$Attrition,
                        times=1,
                        p=ratio / 100) %>%
    unlist()
  
  data_train <- data[train_index, ]
  data_test  <- data[-train_index, ]
  
  data_split <- list(train=data_train, test=data_test)
  
  return(data_split)
}

# Model training.

trainModel <- function(data, 
                       smote_over,
                       smote_under,
                       method="boot",
                       number=3,
                       repeats=3,
                       search="grid",
                       algorithm="rf") {
  
  # If the training set is imbalanced, SMOTE will be applied.
  
  data %<>% as.data.frame()
  
  data <- SMOTE(Attrition ~ .,
                    data,
                    perc.over=smote_over,
                    perc.under=smote_under)
  
  # Train control.
  
  tc <- trainControl(method=method, 
                     number=number, 
                     repeats=repeats, 
                     search="grid",
                     classProbs=TRUE,
                     savePredictions="final",
                     summaryFunction=twoClassSummary)
  
  # Model training.
  
  model <- train(Attrition ~ .,
                 data,
                 method=algorithm,
                 trControl=tc)
  
  return(model)
}

# Function for predicting attrition based on demographic data.

inference <- function(model, data) {
  if ("Attrition" %in% names(data)) {
    data %<>% select(-Attrition)
  }
  
  labels <- predict(model, newdata=data, type="prob")
  
  return(labels)
}

# Load and pre-process HR data.
  
df_hr <- 
  loadData() %>%
  processData()
