FROM r-base:latest

MAINTAINER Le Zhang "zhle@microsoft.com"

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev \
    libxml2-dev 

# Download and install shiny server

RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny', 'ggplot2', 'dplyr', 'magrittr', 'caret', 'caretEnsemble', 'kernlab', 'randomForest', 'xgboost', 'DT', 'DMwR', 'markdown', 'mlbench', 'devtools', 'XML', 'gridSVG', 'pROC', 'plotROC', 'scales'), repos='http://cran.rstudio.com/')" 

RUN R -e "library(devtools);devtools::install_github('sachsmc/plotROC')"

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY /myapp /srv/shiny-server/

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

RUN chmod +x /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
