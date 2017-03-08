source("code/settings.R")

library(dplyr)


getCatalog <- function(url)
{
    download.file(url, "data/raw/galaxyCatalog.csv.gz", mode="wb")

    # only keep object ID, galaxy label columns
    catalog <- gzfile("data/raw/galaxyCatalog.csv.gz")
    catalogCols <- names(read.csv(catalog, nrow=5))
    colClasses <- setNames(vector("list", length(catCols)), catCols)
    colClasses$dr7objid <- colClasses$specobjid <- colClasses$gz2class <- "character"

    catalog <- gzfile("data/raw/galaxyCatalog.csv.gz")
    read.csv(catalog, colClasses = colClasses) %>%
        filter(as.numeric(specobjid) > 0)
}

galaxyCatalog <- getCatalog(catalogUrl)


getGalaxyClass1 <- function(x)
{
    classes <- c("Er", "Ei", "Ec",              # ellipticals
                 "Se", "Sd", "Sc", "Sb", "Sa",  # spirals
                 "SBd", "SBc", "SBb", "SBa",    # barred spirals
                 "A")                           # ambiguous
    out <- rep(NA_character_, length(x))
    for(cl in classes)
        out[grep(cl, x)] <- cl
    factor(out, levels=classes)
}


getGalaxyClass2 <- function(x)
{
    classes <- list(
        Ambiguous="A",
        Elliptical=c("Er", "Ei", "Ec"),
        Spiral=c("Se", "Sd", "Sc", "Sb", "Sa"),
        BarredSpiral=c("SBd", "SBc", "SBb", "SBa")
    )
    out <- rep(NA_character_, length(x))
    for(i in seq_along(classes))
        out[x %in% classes[[i]]] <- names(classes)[i]
    factor(out, levels=names(classes))
}


galaxyCatalog <- mutate(galaxyCatalog, galclass=getGalaxyClass1(gz2class))

save(galaxyCatalog, file="data/processed/galaxyCatalog.rdata")
