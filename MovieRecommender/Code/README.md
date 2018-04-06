# Prerequisites

*Place the prerequisites for running the codes*

* R >= 3.3.1
* rmarkdown >= 1.3

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
