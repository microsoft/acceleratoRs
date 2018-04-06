from score import run
from utils import *

if __name__ == "__main__":
    # Pretending I give the recommender my preference list.
    
    movie_list = [
        "Toy Story (1995)",
        "Jumanji (1995)",
        "Grumpier Old Men (1995)",
        "Waiting to Exhale (1995)",
        "Father of the Bride Part II (1995)"
    ]

    # Initialize Spark environment.

    spark = get_spark()

    # Prepare data.

    df_rating = create_training_data(
        get_rating_data(),
        get_movie_data(),
        movie_list
    )

    print("My user ID is {}".format(str(df_rating.user.max())))

    df_training, df_testing = split_data(df_rating, 0.25)

    # Validation (log into AMLW for visualization)

    run_logger = get_azureml_logger() 

    rank = 30
    if len(sys.argv) > 1:
        rank = float(sys.argv[1])

    run_logger.log("Rank of latent factors.", rank)

    model = train_recommender(
        spark, 
        df_training, 
        rank=rank)

    rmse = evaluate_rmse(model, spark.createDataFrame(df_testing))

    run_logger.log("RMSE", rmse)

    # Save model.

    save_model(model, ".", "als_model")

    # Pack model.

    pack_model("als_model")

    # Upload model onto blob

    upload_to_blob(
        account=STORAGE, 
        key=KEY, 
        container=CONTAINER, 
        blob="als_model.zip", 
        file="als_model.zip"
    )

    # schema

    inputs = {"user_ids": SampleDefinition(DataTypes.NUMPY, np.array([1]))}

    generate_schema(
        run_func=run, 
        inputs=inputs, 
        filepath='./service_schema.json'
    )
