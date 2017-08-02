# Prerequisites

* R >= 3.3.2
* rmarkdown >= 1.3

Some other critical R packages for the analysis:

* dplyr                 Missing value treatment with Filter.
* zoo                   Missing value treatment with locf method.
* forecast              Time series forecasting.
* hts                   Hierarchical time series forecasting.
* fpp                   Time Series cross validation.
* foreach               Run for loop in parallel.
* RevoScaleR            Parallel computing with rxExec. 

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

