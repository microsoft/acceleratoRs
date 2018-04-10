# Data Science Accelerator - *Spark based movie recommender*

## Overview

The accelerator is to illustrate how to efficiently build a movie recommendation system within 30 minutes!

The repository contains three parts

- **Data** Schemas and references to sample data used in the accelerator. 
- **Code** Codes for training and scoring a movie recommender.
- **Docs** Documents helping to build a recommender with Azure Machine Learning Service.

## Business domain

Recommendation (e-commerce, entertainment, retail, etc.).

## Data science problem

The problem a recommendation system tries to resolve is

**Given historical observations of user preferences (i.e., ratings) on a set of items, how to predict and generate a set of items that the users will like most probably.**

## Data understanding

Typically data in a recommendation system has a schema of 
|user|item|rating|[timestamp]|
where user, item, and rating refer to user ID, item ID, and ratings given by a user towards an item.

## Modeling

A recommender is built by using Spark built-in collaborative filtering algorithm, which is a matrix factorization typed algorithm that is regularized by alternating least squares technique.

## Solution architecture

The whole recommendation solution consists of Azure services such as Azure Data Science Virtual Machine, Azure blob storage, Azure Container Registry, Azure Container Services, etc. The building process is completed with Azure Machine Learning Service. 