library(shiny)
#library(ggmap)
#library(mapproj)

ForestPrediction<-function(treecount, train, rowthreshold){
  
  library(knitr)
  library(caret)
  library(rpart)
  library(randomForest)
  library(e1071)
  set.seed(500)
  
  trainset <- read.csv("./pml-training.csv", header=TRUE, sep=",", na.strings=c("NA",""))
  testset <- read.csv("./pml-testing.csv", header=TRUE, sep=",", na.strings=c("NA",""))
  trainset <- trainset[,-1] #Remove the id column 
  
  inTrain <- createDataPartition(trainset$classe, p=train, list=FALSE)
  training <- trainset[inTrain,]
  validating <- trainset[-inTrain,]
  
  keep <- c((colSums(!is.na(training[,-ncol(training)])) >= rowthreshold*nrow(training)))
  training   <-  training[,keep]
  validating <- validating[,keep]
  
  testset <- testset[,-1] # Remove the first column that represents a ID Row
  testset <- testset[ , keep] # Keep the same columns of training dataset
  testset <- testset[,-ncol(testset)] # Remove the problem ID
  
  # Coerce testset dataset to the same class and structure of the training dataset 
  testing <- rbind(training[100, -59] , testset) 
  # Apply the ID Row to row.names and 100 for dummy row from testing dataset 
  row.names(testing) <- c(100, 1:20)
  
  model <- randomForest(classe~.,data=training, ntree=treecount)
  o.model<-model
  
  accuracy<-c(as.numeric(predict(model,newdata=validating[,-ncol(validating)])==validating$classe))
  accuracy<-sum(accuracy)*100/nrow(validating)
  p2 <- predict(model, validating)
  outOfSampleError.accuracy <- sum(p2 == validating$classe)/length(p2)
  o.outOfSampleAccuracy <- outOfSampleError.accuracy
  o.outOfSampleError <- 1 - outOfSampleError.accuracy
  #outOfSampleError
  
  o.predictions <- predict(model,newdata=testing[-1,])
  #print(predictions)
  #length(predictions)
  
  
  o.importance<-importance(model)
  
  o.confusionMat<-confusionMatrix(predict(model,newdata=validating[,-ncol(validating)]),validating$classe)
  
  #o.rplot <- plot(model, log ="y", lwd = 2, main = "Random forest accuracy")
  
  output <- list(predict = o.predictions, error =o.outOfSampleAccuracy,importance = o.importance, confusion = o.confusionMat, model=o.model)
  
  
  return(output)
  
  
}

shinyServer(function(input, output) {


  
  
  modelset <- reactive({
    ForestPrediction(treecount=input$trees,train = input$trainingsplit, rowthreshold = input$missingdata) 
    
  })
  
  
  

  output$plot <- renderPlot({
    input$process
    
    withProgress(message = 'Making prediction. Please wait', value = 0.1, {
    
    isolate(
      plot(modelset()$model, log ="y", lwd = 2, main = "Random forest accuracy")
    )})},height=400, width="auto")
  
  
  
  output$accuracy <- renderText({
    input$process
    
    withProgress(message = 'Making prediction. Please wait', value = 0.1, {
      
      isolate(
        paste("The out of sample accuracy of the model is ", modelset()$error))
    })})
  
  
  
  
  
  
  
  output$importance <- renderTable({
    input$process
    
    withProgress(message = 'Making prediction. Please wait', value = 0.1, {
      
      isolate(
      modelset()$importance)
    })})

  output$prediction <- renderPrint({
    input$process
    
    withProgress(message = 'Making prediction. Please wait', value = 0.1, {
      
      isolate(
        print(modelset()$predict))
    })})  
  
  output$confusion <- renderPrint({
    input$process
    
    withProgress(message = 'Making prediction. Please wait', value = 0.1, {
      
      isolate(
        print(modelset()$confusion))
    })})    
  
  
  


  
  
  
  
  
  
  
      
})