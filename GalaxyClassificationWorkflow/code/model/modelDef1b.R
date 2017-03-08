comment <- "final model from MLADS, use miniBatchSize 256"

# training and test dataset no. of IDs
# this is not no. of rows (actual dataset size will be 3x because each ID is represented 3 times)
trainSize <- 100000
testSize <- 10000


# random seed for generating train/test samples
seed <- 12345

# hyperparameters
numIterations <- 100
miniBatchSize <- 256
acceleration <- "gpu"

# optimiser: either sgd or ada
optim <- sgd(learningRate = 0.05, lRateRedRatio = 0.95, lRateRedFreq = 5, momentum = 0.2)

netDefinition <-
    nnlayer_input(
        c(3, 50, 50),
        name = "pixels"
    ) %>%
    nnlayer_conv(
        kernelshape = c(3, 6, 6),
        stride = c(1, 2, 2),
        sharing = c(0, 1, 1),
        activation = "rlinear",
        name = "conv1",
        mapcount = 64
    ) %>%
    nnlayer_norm(
        name = "norm1"
    ) %>%
    nnlayer_pool(
        kernelshape = c(1, 2, 2),
        stride = c(1, 2, 2),
        name = "pool1"
    ) %>%
    nnlayer_conv(
        kernelshape = c(1, 5, 5),
        stride = c(1, 2, 2),
        sharing = c(0, 1, 1),
        activation = "rlinear",
        mapcount = 2,
        name = "conv2"
    ) %>%
    nnlayer_norm(
        name = "norm2"
    ) %>%
    nnlayer_pool(
        c(1, 2, 2),
        stride = c(1, 2, 2),
        name = "pool2"
    ) %>%
    nnlayer_full(
        nodes = 128,
        name = "hid1",
        activation = "rlinear"
    ) %>%
    nnlayer_full(
        nodes = 128,
        name = "hid2",
        activation = "rlinear"
    ) %>%
    nnlayer_output(
        nodes = 13,
        name = "Class",
        activation = "softmax"
    )



