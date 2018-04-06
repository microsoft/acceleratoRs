import numpy as np
import pandas as pd
import sys
import os
import time
import shutil

import pyspark

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

def load_model(model_path):
    from pyspark.ml.recommendation import ALSModel

    model = ALSModel.load(model_path)

    return model

def get_movie_data():
    url_movie = "https://zhledata.blob.core.windows.net/recsys/movielens/movies.csv"

    df_movie = pd.read_csv(url_movie)
    df_movie = df_movie.iloc[:, 0:2]
    df_movie.columns = ['item', 'title']

    return df_movie

def create_scoring_data(user_id, df_movie):
    movie_ids = df_movie.item

    df_scoring = pd.DataFrame({
        'user': pd.Series([user_id] * len(movie_ids)),
        'item': movie_ids
    })
    
    print(df_scoring.head(20))

    return df_scoring

def score_recommender(spark, model, df_movie, k, user_id):
    from pyspark.sql.window import Window
    from pyspark.sql.functions import row_number, col

    # rec_items = model.recommendForAllUsers(k)

    df_scoring = create_scoring_data(user_id, df_movie)

    dfs_scoring = spark.createDataFrame(df_scoring)

    dfs_predictions = model.transform(dfs_scoring) 
    dfs_predictions = dfs_predictions.dropDuplicates(['user', 'item', 'prediction'])

    window = Window.orderBy(dfs_predictions['prediction'].desc())

    df_topk = dfs_predictions \
        .select('*', row_number().over(window).alias('row_number')) \
        .filter(col('row_number') <= k) \
        .drop('row_number', 'prediction', 'rating') \
        .toPandas()

    recs = list(df_topk.item)

    print(recs)

    return recs

def get_recommended_movies(recs, df_movie):
    df_movie_rec = df_movie[df_movie['item'].isin(recs)]

    return df_movie_rec.title

def init():
    global spark, model

    spark = get_spark()

    model = load_model("als_model")

def run(user_ids):
    k = 10
    user_id = np.asscalar(user_ids[0])

    df_movie = get_movie_data()

    try:
        rec_ids = score_recommender(spark, model, df_movie, k, user_id)

        rec_movies = list(get_recommended_movies(rec_ids, df_movie))

        print("The recommended {} movies for user {} are {}".format(k, user_id, rec_movies))

        return rec_movies
    except Exception as e:
        return (str(e))

if __name__ == "__main__":
    init()

    run(np.array([10]))
