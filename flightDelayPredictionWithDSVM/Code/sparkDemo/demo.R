# ----------------------------------------------------------------------------
# Data pre-processing in Spark standalone mode.
# 
# This is a simplified version of codes from https://github.com/Azure/Azure-MachineLearning-DataScience/tree/master/Misc/StrataSanJose2017/Code/SparkR. 
# ----------------------------------------------------------------------------

# libraries to use.

library(SparkR)
library(RevoScaleR)
library(dplyr)
library(magrittr)
library(readr)
library(AzureSMR)
library(jsonlite)

# data sources.

data_url <- "https://zhledata.blob.core.windows.net/mldata/air_1per.xdf"

# data preparation.

data_dir <- getwd()

data_xdf_path     <- file.path(data_dir, "air_data.xdf")
data_csv_path     <- file.path(data_dir, "air_data.csv")
data_parquet_path <- file.path(data_dir, "air_data_parquet")

download.file(data_url, 
              destfile=data_xdf_path, 
              mode="wb")

RevoScaleR::rxDataStep(inData=data_xdf_path, 
                       outFile=data_csv_path, 
                       overwrite=TRUE)

# initialize spark session.

sc <- SparkR::sparkR.session(
  sparkPackages="com.databricks:spark-csv_2.10:1.3.0"
)

SparkR::setLogLevel("OFF")

# data preparation - convert csv to parquet.

sdf_air <- SparkR::read.df(data_csv_path, 
                   source="com.databricks.spark.csv", 
                   header="true", 
                   inferSchema="true")

SparkR::cache(sdf_air) # cache into memory.
SparkR::count(sdf_air) # count number of rows.

SparkR::write.df(df=sdf_air, 
         path=data_parquet_path, 
         "parquet", 
         "overwrite")

sdf_air <- SparkR::read.df(data_parquet_path, source="parquet") # write data into parquet format.

SparkR::printSchema(sdf_air)

# create a SQL context for manipulating the Spark data frames.

SparkR::createOrReplaceTempView(sdf_air, "air")
stable_air <-  SparkR::sql("SELECT a.DayofMOnth, a.DayOfWeek, a.Origin, a.Dest, a.DepTime, a.ArrDel15 FROM air a")  
SparkR::createOrReplaceTempView(stable_air, "stable_air")

head(SparkR::sql("show tables"))

# sample 30% data from all.

sdf_air_sampled <- SparkR::sample(stable_air,
                                  withReplacement=FALSE, 
                                  fraction=0.3,
                                  seed=123)

# convert the data into local R data frame for visualization.

df_air_sampled <- SparkR::as.data.frame(sdf_air_sampled)

dplyr::glimpse(df_air_sampled)

df_air_sampled %<>% 
  dplyr::filter(as.character(ArrDel15) != "NA") %>%
  dplyr::mutate(DepTime=as.numeric(DepTime), ArrDel15=as.factor(ArrDel15))

# close Spark session.

SparkR::sparkR.session.stop()

# Put the processed data onto storage account.

context <- AzureSMR::createAzureContext(tenantID=TID, clientID=CID, authKey=KEY)

# convert data frame to json.

js_air_sampled <- jsonlite::toJSON(df_air_sampled)

# create a blob to preserve data.

AzureSMR::azurePutBlob(context,
                       blob="processed_data.json",
                       contents=js_air_sampled,
                       storageAccount=SA_ACCOUNT,
                       storageKey=SA_KEY,
                       container=SA_CONTAINER,
                       resourceGroup=RG)