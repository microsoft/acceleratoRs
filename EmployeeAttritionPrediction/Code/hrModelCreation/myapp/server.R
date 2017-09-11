source("global.R")

# The actual shiny server function.

shinyServer(function(input, output) {
  
  # Training and testing data.
  
  dataSplit <- reactive({
    df <- splitData(df_hr, input$ratio)
    
    df
  })
  
  # Train a reactive model.
  
  modelTrained <- eventReactive(input$goButton, {
    df <- dataSplit()
    df_train <- df$train
    df_test  <- df$test
    
    if (input$algorithm == "SVM") {
      method <- "svmRadial"
    } else if (input$algorithm == "Random Forest") {
      method <- "rf"
    } else {
      method <- "xgbLinear"
    }
    
    model <- trainModel(data=df_train, 
                        smote_over=input$smoteOver,
                        smote_under=input$smoteDown,
                        method="boot",
                        number=input$number,
                        repeats=input$repeats,
                        search="grid",
                        algorithm=method)
    
    model
  })
  
  # Print summary of data set.
  
  output$summary <- renderPrint({
    df <- dataSplit()

    # str(df$train)
    
    table(df$train$Attrition)
  })
  
  # Print table of training data set.

  output$dataTrain <- DT::renderDataTable({
    df <- dataSplit()
    
    DT::datatable(df$train)
  })
  
  # Plot some general summary statistics for those who are predicted attrition.
  
  output$plot <- renderPlot({
    
    df <- dataSplit()
    df_test <- df$test
    
    # Train a model
    
    model <- modelTrained()
    
    # Use the model for inference on testing data.
    
    results <- inference(model, data=df_test)
    results <- mutate(results, label=df_test$Attrition)
    
    # Plot the ROC curve.
    
    basic_plot <- 
      ggplot(results, 
             aes(m=Yes, d=factor(label, levels=c("No", "Yes")))) +
      geom_roc(n.cuts=0)
    
    basic_plot +
      style_roc(theme=theme_grey) +
      theme(axis.text=element_text(colour="blue")) +
      # annotate("text",
      #          x=.75,
      #          y=.25,
      #          label=paste("AUC =", round(calc_auc(basic_plot)$AUC, 2))) +
      ggtitle("Plot of ROC curve") +
      scale_x_continuous("1 - Specificity", breaks = seq(0, 1, by = .1))
  })
  
  output$auc <- renderPrint({
    
    df <- dataSplit()
    df_test <- df$test
    
    # Train a model
    
    model <- modelTrained()
    
    # Use the model for inference on testing data.
    
    results <- inference(model, data=df_test)
    results <- mutate(results, label=df_test$Attrition)
    
    basic_plot <- 
      ggplot(results, 
             aes(m=Yes, d=factor(label, levels=c("No", "Yes")))) +
      geom_roc(n.cuts=0)
    
    sprintf("AUC of the ROC curve is %f", round(calc_auc(basic_plot)$AUC, 2))
  })
  
  # # Export the trained model.
  # 
  # output$downloadModel <- downloadHandler(
  #   filename = function() {
  #     paste(input$algorithm, "_model", ".rds", sep="")
  #   },
  #   
  #   content = function(file) {
  #     saveRDS(model, file)
  #   }
  # )
})
