#!/bin/bash

# install R libraries.

sudo mkdir /etc/skel/R
sudo mkdir /etc/skel/R/lib
sudo Rscript -e 'library(devtools);library(withr);withr::with_libpaths(new="/etc/skel/R/lib/", install(c("DMwR", "caretEnsemble", "pROC", "jiebaR")));withr::with_libpaths(new="/etc/skel/R/lib/", install_url("https://github.com/yueguoguo/Azure-R-Interface/raw/master/utils/msLanguageR_0.1.0.tar.gz"))'

# Copy /etc/skel to home directory of all users.

USR=$(ls /home | grep user)

for u in ${USR}; do
  DBASE="/home/$u/"
  
  cp -rf /etc/skel/R ${DBASE}/
done 

# Start the Rstudio Server

rstudio-server start