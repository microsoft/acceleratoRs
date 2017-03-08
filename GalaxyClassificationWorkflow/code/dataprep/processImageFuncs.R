cropGalaxy <- function(x, fraction=0.1)
{
    ndim <- round(fraction * dim(x))
    imager::crop.borders(x, ndim[1], ndim[2])
}


resizeGalaxy <- function(x, ndim=c(50, 50))
{
    imager::resize(x, ndim[1], ndim[2], dim(x)[3], dim(x)[4],
                   interpolation_type=4)
}


rotateGalaxy <- function(x, angle=0)
{
    z <- imager::imrotate(x, angle)
    ndim <- (dim(z) - dim(x))/2
    imager::crop.borders(z, ndim[1], ndim[2])
}


# not used
flattenGalaxy <- function(x)
{
    matrix(as.vector(x), nrow = 1)
}


