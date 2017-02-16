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
