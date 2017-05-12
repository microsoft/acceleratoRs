# Data Science Accelerator - Credit Risk Prediction

## Introduction

Credit Risk Scoring is a classic but increasingly important operation in banking as banks are becoming far more risk careful when lending for mortgages or commercial purposes, in an industry known for fierce competition and the global financial crisis. With an accurate credit risk scoring model a bank is able to predict the likelihood of default on a transaction. This will in turn help evaluate the potential risk posed by lending money to consumers and to mitigate losses due to bad debt, as well as determine who qualifies for a loan, at what interest rate, and what credit limits, and even determine which customers are likely to bring in the most revenue through a variety of products.

Many banks nowadays are driving innovation to enhance risk management. For example, a largest bank in one of the Asian countries by market capitalization is exploring opportunities to segment a millions of active credit card customer population to improve risk scoring to then identify opportunities to offer increased limits. Using advanced analytics for credit risk scoring involves traditional scorecard building and modelling, and extends to machine learning and ensemble, but will also pursue an innovation on customer oriented aggregation of transactions, multi-dimensional customer segmentation and conceptual clustering to identify multiple segments across which to understand bank customers.

The repository contains three parts

- **Data** This contains the provided sample data. 
- **Code** This contains the R development code. They are displayed in R markdown files which can yield files of various formats. 
- **Docs** This contains the documents, like blog, installation instructions, etc. 

## Business domain

Finance and Risk analysis, credit risk prediction.

## Data science problem

Normally credit risk prediction is categorized as a classification problem, that is, given the transaction records and demographic data, the task is to predict whether the consumer will default on a transaction in the near future, what is the default likelihood and which factors are most likely to cause the default. 

## Data understanding

In the data-driven credit risk prediction model, normally two types of data are taken into consideration. 

1. **Transaction data** The transaction records covering account id, transaction date, transaction amount, merchant industry, ect. This transaction-level data could be dynamically aggregated and then provide transaction statistics and financial behavior information at account level.
2. **Demographic and bank account information** This type of data show the characteristics of individual customer or account credit bureau, such as age, sex, income, and credit limit. They are static and never change or solely increment deterministically over time.

## Feature Engineering

1. Customer-oriented transaction aggregation are conducted to generate features which capture transaction dimensions at industry level and emphasize customer financial behaviors.
2. Binning analytics are optionally choosen to recode variables, thus eliminating the effect of extreme values.

## Modeling

1. Traditional logistic regression model with L1 regularization are built as a baseline.
2. Machine learning models, such as gradiant boosting and random forest, or their ensembles, are fine tuned to compare the performance at various aspects. 
3. Innovative convolutionary hotspot method will be pursued in the near future.