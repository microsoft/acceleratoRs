source("global.R")

# The actual shiny server function.

shinyServer(function(input, output) {
  

  # Plot a table of the HR data.
  
  output$hrtable <- DT::renderDataTable({
    DT::datatable(df_hr[, input$show_vars, drop=FALSE])
  })
  
  # Downloadable csv of selected dataset. 
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
  
  # Plot some general summary statistics for those who are predicted attrition.
  
  output$plot3 <- renderPlot({
    if (identical(input$att_vars, "Yes")) {
      df_hr %<>% filter(as.character(Attrition) == "Yes") 
    } else if (identical(input$att_vars, "No")) {
      df_hr %<>% filter(as.character(Attrition) == "No") 
    } else if (identical(input$att_vars, c("Yes", "No"))) {
      df_hr
    } else {
      df_hr <- df_hr[0, ]
    }
    
    df_hr <- filter(df_hr, JobRole %in% input$disc_vars)
    
    ggplot(df_hr, aes(JobRole, fill=Attrition)) +
      geom_bar(aes(y=(..count..)/sum(..count..)), 
               position="dodge",
               alpha=0.6) +
      scale_y_continuous(labels=percent) +
      xlab(input$disc_vars) +
      ylab("Percentage") +
      theme_bw() +
      ggtitle(paste("Count for", input$disc_vars))
  })
  
  output$plot <- renderPlot({
    if (identical(input$att_vars, "Yes")) {
      df_hr %<>% filter(as.character(Attrition) == "Yes") 
    } else if (identical(input$att_vars, "No")) {
      df_hr %<>% filter(as.character(Attrition) == "No") 
    } else if (identical(input$att_vars, c("Yes", "No"))) {
      df_hr
    } else {
      df_hr <- df_hr[0, ]
    }
    
    df_hr_final <- select(df_hr, one_of("Attrition", input$plot_vars))
    
    ggplot(df_hr_final, 
           aes_string(input$plot_vars, 
                      color="Attrition",
                      fill="Attrition")) +
      geom_density(alpha=0.2) +
      theme_bw() +
      xlab(input$plot_vars) +
      ylab("Density") +
      ggtitle(paste("Estimated density for", input$plot_vars))
  })
  
  # Monthly income, service year, etc.
  
  output$plot2 <- renderPlot({
    if (identical(input$att_vars, "Yes")) {
      df_hr %<>% filter(as.character(Attrition) == "Yes") 
    } else if (identical(input$att_vars, "No")) {
      df_hr %<>% filter(as.character(Attrition) == "No") 
    } else if (identical(input$att_vars, c("Yes", "No"))) {
      df_hr
    } else {
      df_hr <- df_hr[0, ]
    }
    
    df_hr <- filter(df_hr, 
                    YearsAtCompany >= input$years_service[1] &
                      YearsAtCompany <= input$years_service[2] &
                      JobLevel < input$job_level &
                      JobRole %in% input$job_roles)
    
    ggplot(df_hr,
           aes(x=factor(JobRole), y=MonthlyIncome, color=factor(Attrition))) +
      geom_boxplot() +
      xlab("Job Role") +
      ylab("Monthly income") +
      scale_fill_discrete(guide=guide_legend(title="Attrition")) +
      theme_bw() +
      theme(text=element_text(size=13), legend.position="top")
  })
})
