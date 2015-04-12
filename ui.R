library(shiny)
shinyUI(navbarPage(
  title = 'Sports activity prediction',
  
  tabPanel('Documentation',
           tags$h1("Documentation for the activity prediction model"),
           tags$p("This shiny app takes raw data to predict which activity is being performed by 20 different athletes"),
           tags$p("The app cleans the data and performs cross validation of a random forest model to make the prediction"),
           tags$p("On the Input tab you'll find settings for parameters to tune the model"),
           
           tags$ol(
             tags$li("Number of trees in the random forest"), 
             tags$li("The threshold % to remove rows containing missing data"), 
             tags$li("The % to split the traning data into Training & Validation")
           ),
           tags$p("After running the model diagnostics can be viewed along with the prediction on the remaining tabs."),  
           tags$p("It takes approx 1 minute to run the model so please be patient.")      
  ),
  
  
  
  tabPanel('Inputs',
           sliderInput("trees", "Select the number of trees to process in the random forest algorithm", value=200,min=20, max=200, step=20),                
           sliderInput("missingdata", "Select the percentage threshold to discard rows with missing data", value=0.6,min=0, max=1, step=0author.01),                
           sliderInput("trainingsplit", "Select the percentage threshold to split that data into training, validation sets", value=0.6,min=0, max=1, step=0.01),                
           
           h4("When ready press the process button to run the model. It may take a few minutes to process so please be patient."),
           actionButton("process","Process")
           
  ),
  tabPanel('Accuracy', plotOutput('plot'),
                       textOutput('accuracy')
       
           ),
  tabPanel('Field Importance', tableOutput('importance')),
  tabPanel('Confusion Matrix', verbatimTextOutput('confusion')),
  tabPanel('Prediction', verbatimTextOutput('prediction'))
  

))
