# Prerequisites

The code is written in Python. Python dependencies are listed as belows

* pyspark, scikit-learn, pandas, numpy 
* azure-cli, azure-cli-ml

# Use of template

## Environment setup

The whole workflow of the demonstration is performed in Azure Machine Learning Workbench.

### Download and set up Azure Machine Learning Workbench

* The first step is to and install AMLW on the local computer. It supports both Windows and MacOS. 
* After a successful installation, one needs to create a workspace under Azure subscription. The easiest way to do so is to go to Azure portal and search for Azure Machine Learning Service, which will then direct to the creation page.
* The newly created workspace will appear in AMLW. Under the workspace, one can initialize a new project. There are several project templates to choose in the library. 
* Visual Studio Team Service is used for agile project management and code version control. A new repo (NOTE the repo should be empty!) can be created and linked to the project in AMLW workspace.

A detailed instruction for such set-up can be found [here](https://docs.microsoft.com/en-us/azure/machine-learning/preview/quickstart-installation).

### Configure compute target

Compute target can be specified in AMLW so that different computing resources can be used elastically for executing tasks such as data pre-processing, model training, etc.

In this demonstration, a [Data Science Virtual Machine](https://docs.microsoft.com/en-us/azure/machine-learning/data-science-virtual-machine/overview) is primarily used for developing and deploying models. 

To configure a DSVM based remote compute target, one needs to firstly spin off a new DSVM under subscription. Then he needs to attache the DSVM within AMLW. 

The simplest way is to open command-line tools within AMLW to configure such attachment, by running

```sh
az ml computetarget attach remotedocker --name "remotevm" --address "remotevm_IP_address" --username "sshuser" --password "sshpassword" 
```

A detailed instruction can be found [here](https://docs.microsoft.com/en-us/azure/machine-learning/preview/experimentation-service-configuration).

NOTE the runtime for computing resource by default supports 
* Python 3.5.2
* Spark 2.1.11
For adding other Python dependencies, one can modify the files of `conda_dependencies.yml` and `spark_dependencies.yml` under `aml_config` directory.

Two files of `[remotevm].compute` and `[remotevm].runconfig` will be automatically created after an attachment of remote DSVM. One can edit these two files to meet the specific requirements of experimentation. 

## Model training

After configuration of compute target, one can run model training on that computing resource. The script of codes can be navigated in AMLW directly. To run a script (say the script is named `myscript.py`), press button `Run` at top of AMLW pane, or submit an experiment by typing command as follows,

```sh
az ml experiment submit -c remotevm myscript.py
```

Following are the codes for training a model.

```python
    def train_recommender(spark, df_rating, **kargs):
        dfs_rating = spark.createDataFrame(df_rating)

        als = ALS(
            maxIter=5,
            seed=0,
            **kargs
        )

        model = als.fit(dfs_rating)

        return model
```
NOTE: 
* AMLW supports visualizing experimentation results of model training with different hyperparameters. So in the actual code parameters of the model trainer (e.g., in our case it is `rank` for Spark collaborative filtering method) can be swept to understand how it affects model performance measured by certain metrics (e.g., RMSE). 
* Model should be trained by using Spark 2.1.11. It can be done by configuring based Docker image for remoting computation to `microsoft/mmlspark:plus-0.7.9` in the file of `[remotevm].runconfig`. 

The following shows an RMSE-vs-rank performance for trained models. 

![RMSE vs Rank](https://github.com/Microsoft/acceleratoRs/blob/master/MovieRecommender/Docs/pics/rmse_rank.png?raw=true)

One important step in this illustrative work is cross validation, where a model is validated against a split of data and then tested on an actual data. This can be simply done by splitting data into more than two sets.

## Service deployment

After model building, it is important to deploy it onto a web service so that it can be easily consumed by other developers. 

This is achieved by creating an image of the pre-built model and deploy it as a Docker container on Azure Container Services. It is made simply by using Azure machine learning command line tools. 

### Setup

Firstly set up a model management account and register a deployment environment.

#### Register Azure services 

Register the following services for deploying model.
```sh
az provider register -n Microsoft.MachineLearningCompute
az provider register -n Microsoft.ContainerRegistry
az provider register -n Microsoft.ContainerService
```

#### Set up deployment environment

For local deployment, set up an environment by doing
```sh
az ml env setup -l [Azure Region, e.g. eastus2] -n [your environment name] [-g [existing resource group]]
```

For cluster deployment (on Azure Container Services), set up an environment by doing
```sh
az ml env setup --cluster -n [your environment name] -l [Azure region e.g. eastus2] [-g [resource group]]
```

Details of setting up environments can be found [here](https://docs.microsoft.com/en-us/azure/machine-learning/preview/deployment-setup-configuration).

### Deployment

Then develop a script for scoring purpose. NOTE two functions of `init()` and `run()` should contained in such score script. In our case, the `init()` and `run()` functions are shonw as follows.

```python
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
```
The `init()` function initializes a Spark environment and loads the pre-trained model (`als_model`). The `run()` function takes user ID as input and generates top 10 (the value of pamater `k`) item recommendations for the given user.

NOTE for illustration purpose the model does not consider cold-start problem for recommendation. This means the given user ID should exist in the training data set.

To define the input schema, one can generate a `service_schema.json` file by adding the following codes into `train.py`.

```python
inputs = {"user_ids": SampleDefinition(DataTypes.NUMPY, np.array([1]))}

generate_schema(
    run_func=run, 
    inputs=inputs, 
    filepath='./service_schema.json'
)
 ```

After the scripts are ready, a web service can be created either locally (by using a Docker container running on local machine) or remotely (by using a Docker container orchestrated by remote Azure Container Services). This can be done by running the command as follows:
```sh
az ml service create realtime --model-file als_model -f score.py -n [service name] -s service_schema.json -r spark-py -c conda_dependencies.yml
```

To test the service, the following command can be run
```sh
az ml service run realtime -i <service id> -d "{\"user_ids\": [1]}"
```
where user ID is 1.

Detailed instructions can be found [here](https://docs.microsoft.com/en-us/azure/machine-learning/preview/model-management-service-deploy)
