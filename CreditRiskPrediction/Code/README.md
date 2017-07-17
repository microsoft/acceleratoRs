# Prerequisites

* R >= 3.3.2
* rmarkdown >= 1.3

Some other critical R packages for the analysis:

* plyr >= 1.8.4; dplyr >= 0.5.0; tidyr >= 0.6.0 Data wrangling.
* glmnet >= 2.0-5 Logistic regression model with L1 and L2 regularization.
* xgboost >= 0.6-4 Extreme gradiant boost model.
* randomForest >= 4.6-12 Random Forest model.
* caret >= 6.0-73 Classification and regression training.
* caretEnsemble >= 2.0.0 Ensemble of caret based models.

* RevoScaleR >= 9.1 Parallel and chunked data processing and modeling. 
* dplyrXdf >= 0.9.2 Out-of-Memory Data wrangling.
* MicrosoftML >= 9.1 Microsoft machine learning models.

* mrsdeploy >= 9.1 R Server Operationalization.
* shiny >= 1.0.0 Shiny Application.

# Use of template

The code for the analysis, embedded with step-by-step instructions,
are written in R markdown, and can be run interactively within the
code chunks of the markdown file.

Makefile in the folder can be used to produce report in various
formats based upon the R markdown script. Supported output formats
include

* R - pure R code,
* md - markdown, 
* html - html,
* pdf - pdf,
* ipynb - Jupyter notebook,
* docx - Microsoft Word document, and 
* odt - OpenDocument document.

To generate an output of the above format, simply run

```
make <filename>.<supported format>
```

The generated files can be removed by `make clean` or `make realclean`.

We include some of the generated files here for ready access through a
browser from github.

# Manual code execution

The individual .Rmd files can be loaded into RStudio and we can run
through the process step by step in the following order:

* CreditRiskPrediciton.Rmd