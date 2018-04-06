from azureml.api.schema.dataTypes import DataTypes
from azureml.api.schema.sampleDefinition import SampleDefinition
from azureml.api.realtime.services import generate_schema

from azureml.logging import get_azureml_logger

from azure.storage.blob import BlockBlobService, PublicAccess, ContentSettings

import numpy as np
import pandas as pd
import sys
import os
import time
import shutil

import pyspark
from pyspark.ml.recommendation import ALS, ALSModel
from pyspark.ml.evaluation import RegressionEvaluator

from sklearn.model_selection import train_test_split

# YOU DID NOT SEE THESE!
STORAGE = "zhledata"
KEY = "E2DU4rvVMHgRu7oeuT3VnL8PCEdeKew57uRSx3BUWX4RYTro9sX5LHuV+qD9fg42R9KiL0LpFrxzwENOG1lOMQ=="
CONTAINER = "models"

def get_spark():
    # Initialize Spark session.
    try:
        from pyspark import SparkContext
        from pyspark import SparkConf
        from pyspark.sql import SparkSession
    except ImportError as e:
        print("Error importing Spark Modules", e)
        sys.exit(1)
    try:
        conf = SparkConf()
        conf.setAppName("RecommendPy")
        spark = pyspark.sql.SparkSession.builder.config(conf=conf).getOrCreate()
        print("Spark Version Required >2.1; actual: " + str(spark.version))
        sc = spark.sparkContext
    except ImportError as e:
        print("Error initializing Spark", e)
        sys.exit(1)

    return spark

def get_rating_data():
    url_rating = "https://zhledata.blob.core.windows.net/recsys/movielens100k.csv"

    df_rating = pd.read_csv(url_rating)
    df_rating = df_rating.iloc[:, 0:3]
    df_rating.columns = ['user', 'item', 'rating']

    return df_rating

def get_movie_data():
    url_movie = "https://zhledata.blob.core.windows.net/recsys/movielens/movies.csv"

    df_movie = pd.read_csv(url_movie)
    df_movie = df_movie.iloc[:, 0:2]
    df_movie.columns = ['item', 'title']

    return df_movie

def create_training_data(df_rating, df_movie, movie_list):
    df_rating_preference = df_movie[df_movie['title'].isin(movie_list)]

    # Arrange input data as user rating data frame and append it into other rating records.
    # NOTE: we assume explicit ratings for this case, and the input movies be default have ratings of 5.

    user_id = df_rating.user.max().item() + 1
    count_of_ratings = df_rating_preference.shape[0]

    df_rating_preference['rating'] = pd.Series(
        np.repeat(5, count_of_ratings),
        index=df_rating_preference.index
    )

    df_rating_preference['user'] = pd.Series(
        np.repeat(user_id, count_of_ratings),
        index=df_rating_preference.index
    )

    df_rating_preference['rating'] = df_rating_preference['rating'].astype(float)
    df_rating_preference = df_rating_preference[['user', 'item', 'rating']]

    df_rating = df_rating.append(df_rating_preference)

    return df_rating

def split_data(df_rating, testing_ratio):
    df_train, df_test, user_train, user_test = \
        train_test_split(df_rating, df_rating['user'], test_size=0.25, random_state=1234)

    return df_train, df_test

def train_recommender(spark, df_rating, **kargs):
    dfs_rating = spark.createDataFrame(df_rating)

    als = ALS(
        maxIter=5,
        seed=0,
        **kargs
    )

    model = als.fit(dfs_rating)

    return model
    
def evaluate_rmse(model, dfs_true):
    predictions = model.transform(dfs_true)

    evaluator = RegressionEvaluator(
        metricName="rmse", 
        labelCol="rating",
        predictionCol="prediction"
    )

    rmse = evaluator.evaluate(predictions.na.drop())

    print("Root-mean-square error = " + str(rmse))

    return rmse

def save_model(model, model_path, model_name):
    os.makedirs(model_path, exist_ok=True)
    model_file = model_path + "/" + model_name

    model.write().overwrite().save(model_file)

    print(os.listdir(model_path))

    print("Model saved at {}".format(model_file))

def pack_model(file_name):
    shutil.make_archive(
        file_name, 
        "zip",
        base_dir=file_name 
    )

def unpack_model(file_name):
    shutil.unpack_archive(
        file_name, 
        extract_dir=".",
        format="zip",
    )

def upload_to_blob(account, key, container, blob, file):
    block_blob_service = BlockBlobService(
        account_name=account, 
        account_key=key
    )
    
    block_blob_service.create_blob_from_path(
        container,
        blob,
        file
    )

def download_from_blob(account, key, container, blob, file):
    block_blob_service = BlockBlobService(
        account_name=account, 
        account_key=key
    )

    generator = block_blob_service.list_blobs(container)

    block_blob_service.get_blob_to_path(container, blob, file)

def load_model(model_path):
    model = ALSModel.load(model_path)

    return model

def score_recommender(model, k, user_id):
    rec_items = model.recommendForAllUsers(k)

    recs = rec_items \
        .where(rec_items.user == user_id) \
        .select("recommendations.item") \
        .collect()

    return recs

def get_recommended_movies(recs, df_movie):
    df_movie_rec = df_movie[df_movie['item'].isin(recs[0][0])]

    return df_movie_rec.title
