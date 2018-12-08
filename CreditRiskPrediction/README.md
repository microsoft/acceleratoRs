# Data Science Accelerator - Credit Risk Prediction

The intention of this AcceleratoR is to provide material as a
kickstart for a data scientist initiating a project in credit risk
prediction, first using R and then extending this with using Microsoft
R for any size datasets. The supplied smalle example random dataset is
used to illustrate the process. It can *not* be used to provide actual
financial insights as it is a randomly generated dataset. A data
scientist can first replicate the process using the dataset supplied
here and then replace the datasets with their own actual datasets and
replicate the processing, tuning it to suit their own needs, as the
starting point for the advanced development of machine learning
models for credit risk prediction.

## Introduction

Credit Risk Scoring is a classic but increasingly important operation
in banking as banks continue to carefully monitor risk when lending
for mortgages, credit cards, or commercial purposes. The industry
remains very competitive.  Accurate credit risk scoring enables a bank
to predict the likelihood of default on a transaction. This will in
turn help evaluate the potential risk posed by lending money to
consumers and to mitigate losses due to bad debt as well as determine
who qualifies for a loan, at what interest rate, what credit limits,
and even to determine which customers may be interested in extended
products.

Many banks nowadays are driving innovation to enhance risk
management. Typically banks are exploring opportunities to segment
millions of active credit card customers to improve risk scoring to
then identify opportunities to offer increased limits, for
example. Using advanced analytics for credit risk scoring exends
traditional scorecard building and modelling with machine learning
ensembles. Beyond this they are also pursuing innovations with
customer oriented aggregation of transactions, multi-dimensional
customer segmentation, and conceptual clustering to identify multiple
segments across which to understand bank customers.

This repository contains three folders:

- **Data** This contains random artificial sample data with which we
  can demonstrate the process.
  
- **Code** This contains the R code and modelling process using R
  markdown files which can be converted to various formats, including
  pdf, html, ipynb, etc.
  
- **Docs** This contains miscellaneous documents including a blog post
    and installation instructions.

## Business domain

Finance and risk analysis, credit risk prediction.

## Data science problem

Normally credit risk prediction is categorized as a classification
problem: given the customer transaction records and their demographic
data, the task is to predict whether the consumer will default on a
transaction in the near future, what is the default likelihood, and
which factors are most likely to cause the default. Given this
knowledge business can make decisions to improve their performance.

## Data understanding

In the data-driven credit risk prediction model two types of data are
normally taken into consideration.

1. **Transaction data** The transaction records cover transaction_id,
account id, transaction date, transaction amount, merchant industry,
etc. This transaction-level data is usually aggregated to provide
transaction statistics and financial behavior information at the
customer account level.

2. **Demographic and bank account information** This type of data
captures the characteristics of the individual customer or account
credit bureau, such as age, sex, income, and credit limit. They are
generally static or change little over time.

## Feature Engineering

1. Customer-oriented transaction aggregation is conducted to generate
features which capture transaction dimensions at industry level and
emphasize customer financial behaviors.
   
2. Binning analytics are optionally chosen to recode variables, thus
eliminating the effect of extreme values.

## Modeling

1. Traditional logistic regression model with L1 regularization are
built as a baseline.
   
2. Machine learning models, such as gradient boosting and random
forest, or their meta-ensembles, are fine tuned to compare the
performance and choose an apporiate model to deploy.
   
3. An innovative AI approach using a evolutionary hotspot method is
also being pursued and will be incorporated in a future release. This
method builds multiple segmentations to build unique profiles for each
customer from which we can reason about the customer's behaviours.

## Scalability

**Faster and scalable credit risk models** are built using the
state-of-the-art machine learning algorithms provided by the
`MicrosoftML` package.

## Operationalization

An **R model based web service for credit risk prediction** is
published and consumed by using the `mrsdeploy` package that ships
with Microsoft R Client and R Server 9.1.

## Application Development

A **Credit Risk Application through a REST API** is developed by
integrating the published web service with a shiny framework.
 