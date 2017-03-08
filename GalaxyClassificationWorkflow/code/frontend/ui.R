library(shiny)
library(shinyjs)

fluidPage(
    useShinyjs(),

    titlePanel("Galaxy classification"),

    sidebarLayout(
        sidebarPanel(
            fileInput("img", "Choose image file",
                accept=c("image/jpeg", "image/png", "image/bmp"))
        ),
        mainPanel(
            HTML('<output id="list"></output>'),
            tags$hr(),
            h3(textOutput("pred"))
        )
    )
)

