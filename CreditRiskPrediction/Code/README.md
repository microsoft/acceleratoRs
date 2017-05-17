# Prerequisites

* R >= 3.3.2
* rmarkdown >= 1.3

Some other critical R packages for the analysis:

* plyr >= 1.8.4; dplyr >= 0.5.0; tidyr >= 0.6.0 Data wrangling.
* glmnet >= 2.0-5 Logistic regression model with L1 and L2 regularization.
* xgboost >= 0.6-4 Extreme gradiant boost model.
* randomForest >= 4.6-12 Random Forest model.
* caretEnsemble >= 2.0.0 Ensemble of caret based models.
* dplyrXdf Out-of-Memory Data wrangling.
* MicrosoftML >= 9.1 Microsoft machine learning models.
* mrsdeploy >= 9.1 R Server Operationalization.

# Use of template

The codes for analytics, embedded with step-by-step instructions, are written in R markdown, and can be run interactively within the code chunks of the markdown file.

Makefile in the folder can be used to produce report in various formats based upon the R markdown script. Suported output formats include

* R - pure R codes,
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

The geneated files can be removed by `make clean` or `make realclean`
