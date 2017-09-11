source("global.R")

navbarPage(
  "HR Analytics - model creation",
  tabPanel(
    "About",
    fluidRow(
      column(3, includeMarkdown("about.md")),
      column(6, img(
        class="img-polaroid",
        src=paste0("https://careers.microsoft.com/content/images/services/HomePage_Hero1_Tim.jpg"))
      )
    )
  ),
  
  tabPanel(
    "Model",
    sidebarLayout(
      sidebarPanel(
        # Split ratio for training/testing data.
        
        sliderInput(inputId="ratio",
                    label="Split ratio (%) for training data.",
                    min=0,
                    max=100,
                    value=70),
        
        # SMOTE upsampling percentage.
        
        p("SMOTE is used for balancing data set"),
        
        numericInput(inputId="smoteOver",
                     label="Upsampling percentage in SMOTE for minority class.",
                     value=300),
        
        # SMOTE downsampling percentage.
        
        numericInput(inputId="smoteDown",
                     label="Downsampling percentage in SMOTE for majority class.",
                     value=150),
        
        # Repeats in train control.
        
        p("High-level control for cross-validation in training the model."),
        
        numericInput(inputId="repeats",
                     label="Number of repeats for a k-fold cross-validation.", 
                     min=1,
                     max=3,
                     value=1),
        
        # Number of cross-validations in train control.
        
        numericInput(inputId="number",
                     label="Number of folds in cross-validation.",
                     min=2,
                     max=5,
                     value=1),
        
        # Algorithm for use.
        
        selectInput(inputId="algorithm",
                    label="Machine learning algorithm to use for training a model:",
                    choices=c("SVM", "Random Forest", "XGBoost")),
        
        # Train model
        
        p("Click the button to train a model with the above settings (it may 
          take some time depending on algorithm used for training). After the
          training process, a ROC curve which evaluates model performance on 
          the testing data set is plotted."),
        
        actionButton("goButton", "Train")
        
        # # Export model
        # 
        # p("Export the trained model"),
        # 
        # downloadButton("downloadModel", 
        #                "Download")
      ),
      
      mainPanel(
        
        # Summary of the training data set.
        
        p("It should be noted that the data set is not balanced, which may 
          negatively impact model training if no balancing technique is
          applied."),
        
        verbatimTextOutput("summary"),
        
        # Print table of training data.
        
        tabsetPanel(
          id="dataset",
          tabPanel("HR Demographic data for training", 
                   DT::dataTableOutput("dataTrain"))
        ),
        
        # Plot the model validation results.
        
        plotOutput("plot"),
        
        verbatimTextOutput("auc")
      )
    )
  )
)