# Galaxy classification: a data science workflow with Microsoft R Server 9

This is the repo for the data science workflow demo presented at Microsoft Ignite 2017. This demo showcases a number of features released as part of Microsoft R Server 9, combined into an example workflow for classifying galaxy images:
* MicrosoftML, a powerful package for machine learning
* Easy deployment of models using SQL Server R Services
* Creating web service APIs with R Server Operationalisation (previously known as DeployR)

You can see a video of the presentation on [Channel 9](https://channel9.msdn.com/events/Ignite/Australia-2017/DA334), and the slide deck itself is at [docs/galaxy-ignite.pptx](docs/galaxy-ignite.pptx).

The original data for the demo was obtained from the Sloan Digital Sky Survey (http://www.sdss.org). See [cite.md](cite.md) for a list of acknowledgements and citations. To avoid spamming the SDSS website, the data has been copied to Azure blob storage.


## Setup and configuration

This demo assumes that you have access to a SQL Server instance, and have already setup SQL Server R Services and R Server Operationalisation. For more information about these, see the following MSDN pages:

* [Setting up SQL Server R Services](https://msdn.microsoft.com/en-us/library/mt696069.aspx)
* [Configuring R Server for Operationalisation](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)

The MicrosoftML package can use GPU acceleration to fit neural network models. To enable this, see the help for `MicrosoftML::rxNeuralNet`. In a nutshell, you install the NVidia [CUDA Toolkit 6.5](https://developer.nvidia.com/cuda-toolkit-65) and [cuDNN v2 Library](https://developer.nvidia.com/rdp/cudnn-archive), and then copy some .dlls to the MicrosoftML mxLibs directory. Currently only CUDA acceleration is supported.

You'll also need the following R packages installed, other than those that come with R Server: dplyr, imager, purrr, shiny, shinyjs, RMLtools. All of these are available on CRAN, except for RMLtools which is on Github. You can install this package using devtools:

    install.packages("devtools")
    devtools::install_github("andrie/RMLtools")

The script `code/settings.R` is used to set some configuration options. It will read two additional files which you should put into the `code` directory:

* `deployDbConnStr.txt` containing the ODBC connection string for your SQL Server instance.
* `deployCred.txt` containing your RServe login credentials (for R Server operationalisation).

You should also edit `settings.R` to set the paths where you want the raw and processed galaxy images saved. The image files total about 2.4GB after processing, so make sure you point this to a location that has enough space.

Finally, run the script `code/dataprep/initDataDirs.R`. This will create the `data` directory structure in which model objects, R data frames etc are stored.


## Running the demo

Once you've setup your backend, carry out the following steps to run the demo.

1. Run `code/dataprep/downloadCatalog.R` to download the galaxy catalog.

2. Run `code/dataprep/downloadImages.R`. This will download a zip archive containing the individual galaxy images, and then extract them.

3. Run `code/dataprep/processImages.R` to process the images for analysis. (This will take a while.)

4. Run `code/dataprep/genDataset.R` to create the analysis dataset. This is a data frame that contains the _names_ of the image files that will be used by the modelling functions, not the image data as such.

5. (Optional) Modify `code/model/trainModel.R` to fit only the specific neural network model you want to keep. As supplied, the script will fit three models which are minor variations on each other.

6. Run `code/model/trainModel.R` to fit the chosen model(s). It's highly recommended that you have GPU acceleration enabled (see above).

7. Run `code/deploy/deploySqlModel.R`. This will serialise the model(s) to SQL Server, and also create a stored procedure for scoring new data.

8. Run `code/deploy/deployModel.R` to create a web service that will call the SQL stored procedure.

9. (Optional) Run `code/testing/testApi.R` to test that everything works.

10. At the R prompt, run the shiny frontend:

```
library(shiny)
runApp("code/frontend")
```

## More information

* [About Microsoft R Server](https://msdn.microsoft.com/en-us/microsoft-r/rserver)
* [Team Data Science Process](https://github.com/Azure/Microsoft-TDSP)
* [Sloan Digital Sky Survey](http://www.sdss.org/)
* [Galaxy Zoo](https://www.galaxyzoo.org/)
* [Mapping the Universe with SQL Server](https://blogs.technet.microsoft.com/dataplatforminsider/2016/03/10/mapping-the-universe-with-sql-server/) -- in-depth article on Technet



