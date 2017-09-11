---
title: "about"
author: "Le Zhang"
date: "August 24, 2017"
output: html_document
---

### Employee Attrition Prediction

This is a demonstration on a case study of employee attrition prediction. 
Data science and machine learning development process often consists of multiple
steps. Containerizing each of the steps help modularize the whole process and 
thus making it easier for DevOps.

For simplicity reason, the demo process is merely composed of two steps, which are
data exploration and model creation. 

This web-based app is to show how to create a model on the data. The training
candidature algorithms include Support Vector Machine (SVM), Random Forest, and
Extreme Gradient Boosting (XGBoost). For illustration purpose, only a few high-
level parameters are allowed to set.

#### R accelerator

The end-to-end tutorial of the R based template for data processing, model 
training, etc. (we call it "acceleratoR") can be found [here](https://github.com/Microsoft/acceleratoRs/blob/master/EmployeeAttritionPrediction).

#### Operationalization

Operationalization of the case on Azure cloud (i.e., data exploration, model creation, 
model management, model deployment, etc.) with [Azure Data Science VM](https://docs.microsoft.com/en-us/azure/machine-learning/machine-learning-data-science-provision-vm) 
[Azure Storage](https://azure.microsoft.com/en-us/services/storage/), [Azure Container Service](https://azure.microsoft.com/en-us/services/container-service/), etc., can be found [here](https://github.com/Microsoft/acceleratoRs/blob/master/EmployeeAttritionPrediction).
