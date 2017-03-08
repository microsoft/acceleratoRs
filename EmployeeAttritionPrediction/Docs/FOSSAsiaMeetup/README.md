# R accelerator for employee attrition with sentiment analysis

This demo presents a walk-through of data science application scenario on employee attrition prediction with sentiment analysis. Basically the walk-through will cover

* A recommended work flow to resolve employee attrition problem with data science techniques. 
* R codes that build and evaluate a predictive model

A bonus script is also provided, which demonstrates how the analytical experiment can be thrown onto remote virtual machines on cloud which are deployed and customized on demand, for parallel computation.
 
## Prerequisites

* Fundamental knowledge of data science and machine learning.
* R >= 3.3.1.
* RStudio IDE >= v0.98
* [AzureSMR](https://github.com/Microsoft/AzureSMR) packages.
* Azure account subscription (free for trial).
* Application in Azure Active Directory with allowed access to the resource group.

## Instructions on demo

1. Codes for demo are embedded in `demo.Rpres` which is an R presentation, and the codes can be locally and interactively run within the .Rpres file but this requires an IDE of RStudio v0.98 or later.
2. Codes for parallel computation on Azure virtual machines are embedded into a R markdown file and the same requirement applies as well.