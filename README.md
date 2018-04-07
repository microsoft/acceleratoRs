# Introduction

**acceleratoRs** are a collection of R/Python based lightweight data science and AI solutions that offer quick start for data scientists to experiment, prototype, and present their data analytics of specific domains.

Each of accelerators shared in this repo is structured following the project template of the [Microsoft Team Data Science Process](https://azure.microsoft.com/en-us/documentation/learning-paths/data-science-process/), in a simplified and accelerator-friendly version. The analytics are scripted in R markdown (Jupyter notebook), and can be used to conveniently yield outputs in various formats (ipynb, PDF, html, etc.). 

# How-to

* To start with a new acceleator project, use `GeneralTemplate` for initialization. The `GeneralTemplate` consists of three parts which are `Code`, `Data`, and `Docs`. 

    * `Code` - Codes of analytics for the data science problem is put
        in the directory. [R markdown](rmarkdown.rstudio.com) is recommended
        for scripting as it is easy to yield pure code as well as report in
        various formats (e.g., PDF, html, etc.) for the convenient of
        presenting.
    * `Data` - Data used for the analytics. It is highly recommended to put
        sample data in the dictory while providing reference to full set of
        it.
    * `Docs` - Normally related documentations, references, and perhaps
        yielded reports will be put in this directory.

* An accelerator should be able to run interactively in an IDE that supports R markdown such as [R Tools for Visual Studio (RTVS)](https://docs.microsoft.com/en-us/visualstudio/rtvs/rmarkdown), RStudio, VS Code with AI extensions. 
* Makefile is by default provided to generate documents of other formats, or alternatively rmarkdown::render can be used for the same purpose. 

# Contributing

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

