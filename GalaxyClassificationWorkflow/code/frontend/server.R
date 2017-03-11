library(shiny)

function(input, output, session)
{
    remoteLogin("http://localhost:12800", session=FALSE, username=deployCred[1], password=deployCred[2])
    api <- getService("apiPredictGalaxyClass", "1.0")

    shinyjs::runjs(showImgJs)
    
    output$pred <- renderText({
        if(is.null(input$img))
            return("")
        name <- input$img$name
        file <- input$img$datapath
        img <- paste0(as.character(readBin(file, raw(), file.size(file))), collapse="")

        on.exit(file.remove(file))

        out <- api$
            apiPredictGalaxyClass(name, img)$
            output("pred")
        as.character(out[1, 2, drop=TRUE])
    })

    session$onSessionEnded(remoteLogout)
}
