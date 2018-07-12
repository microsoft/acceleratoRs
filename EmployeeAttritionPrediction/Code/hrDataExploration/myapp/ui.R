source("global.R")

navbarPage(
  "HR Analytics - data exploration",
  tabPanel(
    "About",
    fluidRow(
      column(3, includeMarkdown("about.md")),
      column(
        6,
        img(class="img-polaroid",
            src=paste0("https://zhledata.blob.core.windows.net/employee/forest.jpg"))
      )
    )
  ),
  tabPanel(
    "Data",
    sidebarLayout(
      sidebarPanel(
        # Variables to select for displayed demographic data.
        
        checkboxGroupInput(
          "show_vars", 
          "Columns in HR data set to show:",
          names(df_hr),
          selected=names(df_hr)
        ),
        
        # Button
        downloadButton("hrData", "Download")
      ),
      
      mainPanel(
        tabsetPanel(
          id="dataset",
          tabPanel("HR Demographic data", DT::dataTableOutput("hrtable"))
        )
      )
    )
  ),
  tabPanel(
    "Plot",
    
    h4("Select employees of attrition or non-attrition to visualize."),
    
    checkboxGroupInput(
      "att_vars",
      "Attrition or not:",
      c("Yes", "No"),
      selected=c("Yes", "No")),
    
    fluidRow(
      column(
        4, 
        h4("Count of discrete variable."),
        plotOutput("plot3"),
        
        checkboxGroupInput(
          "disc_vars",
          "Job roles:",
          unique(df_hr$JobRole),
          selected=unique(df_hr$JobRole)[1:5])
      ),
      
      column(
        4, 
        h4("Distribution of continuous variable."),
        plotOutput("plot"),
        
        selectInput(
          "plot_vars",
          "Variable to visualize:",
          names(select_if(df_hr, is.integer)),
          selected=names(select_if(df_hr, is.integer)))
      ),
      
      column(
        4, 
        h4("Comparison on certain factors."),
        plotOutput("plot2"),
        
        # Years of service.

        sliderInput(
          "years_service",
          "Years of service:",
          min=1,
          max=40,
          value=c(2, 5)),
        
        # Job level.
        
        sliderInput(
          "job_level",
          "Job level:",
          min=1,
          max=5,
          value=3
        ),
        
        checkboxGroupInput(
          "job_roles",
          "Job roles:",
          unique(df_hr$JobRole),
          selected=unique(df_hr$JobRole)[1:5])
      )
    )
  )
)