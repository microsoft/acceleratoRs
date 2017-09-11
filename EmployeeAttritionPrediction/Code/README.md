# Prerequisites

* R >= 3.3.1
* rmarkdown >= 1.3

Some other critical R packages for the analysis:

* DMwR >= 0.4.1 Resampling data set by SMOTE technique.
* jiebaR >= 0.8.1 For segmentation of Chinese text.
* tm >= 0.6-2 Pre-processing for text analysis.
* languageR >= 0.1.0 Wrapper functions for text analytics APIs in Microsoft Cognitive Services.
* caretEnsemble >= 2.0.0 Ensemble of caret based models.

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

Template for data analytics can be found in `EmployeeAttritionPrediction.Rmd` 
while that for pipeline operationalization can be found in 
`EmployeeAttritionPredictionOperationalization.Rmd`. The former contains codes
for data exploration, model creation, and model evaluation - more of a "how-to"
on applying data science on attrition prediction problem. The latter is a 
tutorial of operationalizing the analytics with Azure services. A Data Science
VM (DSVM) is used for R analytics, while Azure Container Service is used for
deploying analytics into interactive web-based applications.