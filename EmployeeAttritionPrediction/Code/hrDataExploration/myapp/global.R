# ------------------------------------------------------------------------------
# R packages needed for the analytics.
# ------------------------------------------------------------------------------

library(shiny)
library(dplyr)
library(magrittr)
library(ggplot2)
library(markdown)
library(scales)

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

# Load HR data and pre-trained model.
  
df_hr <- loadData()