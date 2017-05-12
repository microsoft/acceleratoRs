# ----------------------------------------------------------------------------
# Data wrangling in Spark standalone mode.
# ----------------------------------------------------------------------------

# libraries to use.

library(SparkR)
library(RevoScaleR)
library(dplyr)
library(magrittr)
library(ggplot2)
library(readr)

# data sources.

data_url <- "https://zhledata.blob.core.windows.net/mldata/air_1per.xdf"

# data preparation.

# data_dir <- file.path(getwd(), "demo/data")
data_dir <- getwd()

# system("hadoop fs -ls /home/zhle/demo/data") # necessary for standalone mode?

data_xdf_path     <- file.path(data_dir, "air_data.xdf")
data_csv_path     <- file.path(data_dir, "air_data.csv")
data_parquet_path <- file.path(data_dir, "air_data_parquet")

download.file(data_url, destfile=data_xdf_path)

rxDataStep(inData=data_xdf_path, 
           outFile=data_csv_path, 
           overwrite=TRUE)

# initialize spark session.

sc <- sparkR.session(
  sparkPackages="com.databricks:spark-csv_2.10:1.3.0"
)

setLogLevel("OFF")

# data preparation - convert csv to parquet.

sdf_air <- read.df(data_csv_path, 
                   source="com.databricks.spark.csv", 
                   header="true", 
                   inferSchema="true")

SparkR::cache(sdf_air) # cache into memory.
SparkR::count(sdf_air) # count number of rows.

write.df(df=sdf_air, 
         path=data_parquet_path, 
         "parquet", 
         "overwrite")

sdf_air <- read.df(data_parquet_path, source="parquet") # write data into parquet format.

printSchema(sdf_air)

SparkR::cache(sdf_air) 
SparkR::count(sdf_air)

head(sdf_air)

# create a SQL context for manipulating the Spark data frames.

createOrReplaceTempView(sdf_air, "air")
stable_air <-  SparkR::sql("SELECT a.DayofMOnth, a.DayOfWeek, a.Origin, a.Dest, a.DepTime, a.ArrDel15 FROM air a")  
createOrReplaceTempView(stable_air, "stable_air")

SparkR::cache(stable_air) 
SparkR::count(stable_air)

head(SparkR::sql("show tables"))

# sample 30% data from all.

sdf_air_sampled <- SparkR::sample(stable_air,
                                  withReplacement=FALSE, 
                                  fraction=0.3,
                                  seed=123)

# convert the data into local R data frame for visualization.

df_air_sampled <- SparkR::as.data.frame(sdf_air_sampled)

glimpse(df_air_sampled)

df_air_sampled %<>% 
  filter(as.character(ArrDel15) != "NA") %>%
  mutate(DepTime=as.numeric(DepTime), ArrDel15=as.factor(ArrDel15)) %>%
  na.omit()

ggplot(data=df_air_sampled, aes(x=DayOfWeek, y=DepTime)) +
  geom_boxplot()

# ----------------------------------------------------------------------------
# Put the processed data onto storage account.
# ----------------------------------------------------------------------------

# load AzureSMR library.

library(AzureSMR)
library(jsonlite)

context <- createAzureContext(tenantID=TID, clientID=CID, authKey=KEY)

# convert data frame to json.

js_air_sampled <- toJSON(df_air_sampled)

write(js_air_sampled, file=file.path(data_dir, "processed_data.json"))

# create a blob to preserve data.

AzureSMR::azurePutBlob(context,
                       blob="processed_data.json",
                       contents=js_air_sampled,
                       storageAccount=SA_ACCOUNT,
                       storageKey=SA_KEY,
                       container=SA_CONTAINER,
                       resourceGroup=RG)