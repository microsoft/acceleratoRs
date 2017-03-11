# Galaxy classification: a data science workflow with Microsoft R Server 9

This is the repo for the data science workflow demo presented at Microsoft Ignite 2017. This demo showcases a number of features released as part of Microsoft R Server 9, combined into an example workflow for classifying galaxy images:
* MicrosoftML, a powerful package for machine learning
* Easy deployment of models using SQL Server R Services
* Creating web service APIs with R Server Operationalisation (previously known as DeployR)

You can see a video of the presentation on [Channel 9](https://channel9.msdn.com/events/Ignite/Australia-2017/DA334), and the slide deck itself is at [docs/galaxy-ignite.pptx](docs/galaxy-ignite.pptx).

The original data for the demo was obtained from the Sloan Digital Sky Survey (http://www.sdss.org). To avoid spamming the SDSS website, the data has been copied to Azure blob storage. See [cite.md](cite.md) for a list of acknowledgements and citations.


## Setting up the backend

For a description of the steps required, see [setup.md](setup.md).


## Running the demo

Once you've setup the backend, carry out the following steps to run the demo.

1. Run `code/dataprep/downloadCatalog.R` to download the galaxy catalog.

2. Run `code/dataprep/downloadImages.R`. This will download a zip archive containing the individual galaxy images, and then extract them.

3. Run `code/dataprep/processImages.R` to process the images for analysis. (This will take a while.)

4. Run `code/dataprep/genDataset.R` to create the analysis dataset. This is a data frame that contains the _names_ of the image files that will be used by the modelling functions, not the image data as such.

5. (Optional) Modify `code/model/trainModel.R` to fit only the specific neural network model you want to keep. As supplied, the script will fit three models which are minor variations on each other.

6. Run `code/model/trainModel.R` to fit the chosen model(s).

7. Run `code/deploy/deploySqlModel.R`. This will serialise the model(s) to SQL Server, and also create a stored procedure for scoring new data.

8. Run `code/deploy/deployModel.R` to create a web service that will call the SQL stored procedure.

9. (Optional) Run `code/testing/testApi.R` to test that everything works.

10. (Optional, if you have [autorest](https://www.nuget.org/packages/autorest/) installed) Run `autorest -CodeGenerator <yourLanguage> -Input "<path-to-demo>\data\output\swagPredictGalaxyClass.json"` to generate code to consume the API.

10. At the R prompt, run the shiny frontend:

``` r
library(shiny)
runApp("code/frontend")
```

## More information

* [About Microsoft R Server](https://msdn.microsoft.com/en-us/microsoft-r/rserver)
* [Team Data Science Process](https://github.com/Azure/Microsoft-TDSP)
* [Sloan Digital Sky Survey](http://www.sdss.org/)
* [Galaxy Zoo](https://www.galaxyzoo.org/)
* [Mapping the Universe with SQL Server](https://blogs.technet.microsoft.com/dataplatforminsider/2016/03/10/mapping-the-universe-with-sql-server/) -- in-depth article on Technet



