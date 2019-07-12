# Data Science Accelerator - Employee Attrition Prediction with Sentiment Analysis

## Overview

Voluntary employee attrition may negatively affect a company in various aspects, i.e., induce labor cost, lose morality of employees, leak IP/talents to competitors, etc. Identifying individual employee with inclination of leaving company is therefore pivotal to save the potential loss. Conventional practices rely on qualitative assessment on factors that may reflect the prospensity of an employee to leave company. For example, studies found that staff churn is correlated with both demographic information as well as behavioral activities, satisfaction, etc. Data-driven techniques which are based on statistical learning methods exhibit more accurate prediction on employee attrition, as by nature they mathematically model the correlation between factors and attrition outcome and maximize the probability of predicting the correct group of people with a properly trained machine learning model.

The repository contains three parts

- **Data** This contains the provided sample data. 
- **Code** This contains the R development code. They are displayed in R markdown files which can yield files of various formats. 
- **Docs** This contains the documents, like blog, installation instructions, etc. 

## Business domain

Human resource analysis, employee attrition prediction, sentiment analysis.

## Data science problem

Normally employee attrition prediction is categorized as a classification problem, that is, given the data that characterize an employee, the task is to predict whether the employee will leave the company in the near future. 

## Data understanding

In the data-driven employee attrition prediction model, normally two types of data are taken into consideration. 

1. First type refers to the demographic and organizational information of an employee such as *age*, *gender*, *title*, etc. The characteristics of this group of data is that **within a certain interval, they don't change or solely increment deterministically over time**. For example, gender may not change for an individual, and other factors such as *years of service* increments every year. 
2. Second type of data is the dynamically involving information about an employee. Recent [studies](http://www.wsj.com/articles/how-do-employees-really-feel-about-their-companies-1444788408) report that *sentiment* is playing a critical role in employee attrition prediction. Classical measures of sentiment include *job satisfaction*, *environment satisfaction*, *relationship satisfaction*, etc. With the machine learning techniques, sentiment patterns can be exploited from daily activities such as text posts on social media for predicting churn inclination.

## Modeling

1. Prediction models are created based on classification algorithms such as random forest. Ensemble method is applied to enhance prediction performance. Resampling techniques (e.g., SMOTE) are applied to deal with imbalance in the training set for model building.
2. Term frequency (TF) or term frequency-inverse document frequency are extracted from text as features for sentiment analysis. Translation or language-specific tokenization methods are used for multi-lingual text analysis.

## Operationalization

The accelerator also contains a tutorial on how to deploy Shiny App web service
with the analytics hosted on a Kubernetes cluster with Azure Container Service.
Two Shiny Apps are developed which provides GUI-based interactive web interface
for doing simply data analytics and model training, respectively.
