## Setup

### Backend configuration

This demo assumes that you have access to a SQL Server instance, and have already setup SQL Server R Services and R Server Operationalisation. For more information about these, see the following MSDN pages:

* [Setting up SQL Server R Services](https://msdn.microsoft.com/en-us/library/mt696069.aspx)
* [Configuring R Server for Operationalisation](https://msdn.microsoft.com/en-us/microsoft-r/operationalize/configuration-initial)

You'll also need to ensure that the R Server Operationalisation accounts can access the database. See your database administrator for help if you are using a shared SQL Server instance.


### R configuration

The MicrosoftML package can use GPU acceleration to fit neural network models, and this is highly recommended. To enable this, see the help for `MicrosoftML::rxNeuralNet`. In a nutshell, you install the NVidia [CUDA Toolkit 6.5](https://developer.nvidia.com/cuda-toolkit-65) and [cuDNN v2 Library](https://developer.nvidia.com/rdp/cudnn-archive), and then copy some .dlls to the MicrosoftML mxLibs directory. Currently only CUDA acceleration is supported.

The demo uses the following R packages, other than those that come with R Server:

* [dplyr](https://cloud.r-project.org/package=dplyr)
* [imager](https://cloud.r-project.org/package=imager)
* [purrr](https://cloud.r-project.org/package=purrr)
* [shiny](https://cloud.r-project.org/package=shiny)
* [shinyjs](https://cloud.r-project.org/package=shinyjs)
* [RMLtools](https://github.com/andrie/RMLtools)

All of these are available on CRAN, except for RMLtools which is on Github. You can install this package using devtools:
``` r
install.packages("devtools")
devtools::install_github("andrie/RMLtools")
```
In addition the imager package and its dependencies must also be installed into a location accessible by SQL Server R Services, so that they are available to R code running inside a stored procedure.


### Project settings

The script `code/settings.R` is used to set project options. It will read two additional files which you should put into the `code` directory:

* `deployDbConnStr.txt` containing the ODBC connection string for your SQL Server instance.
* `deployCred.txt` containing your RServe login credentials (for R Server operationalisation).

You should also edit `settings.R` to set the paths where you want the raw and processed galaxy images saved. The image files total about 2.4GB after processing, so make sure you point this to a location that has enough space.

Finally, run the script `code/dataprep/initDataDirs.R`. This will create the `data` directory structure in which model objects, R data frames etc are stored.

