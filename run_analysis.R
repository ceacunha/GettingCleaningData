library(dplyr)

run_analysis <- function (wrkSpc = NULL, fileURL = NULL, outputDir = NULL){
  
  # Setup  
  temp_work <- getwd()
  if(!is.null(wrkSpc)){
    setwd(wrkSpc)
  }
  
  if(is.null(outputDir)){
    outputDir <- getwd()
  }
  
  if(is.null(fileURL)){
    fileURL <- "https://raw.githubusercontent.com/ceacunha/GettingCleaningData/master/projectFiles.zip"
  }
  download.file(url = fileURL, destfile = "projectFiles.zip", method = "curl")
  unzip("projectFiles.zip")
  
  # Auxiliary Data
  activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE, col.names = c("ID", "Exercise_Description"))
  fullMeasurementList <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, col.names = c("Column_Index", "Measurement_Name"), colClasses = c("integer", "character"))
  measurements <- fullMeasurementList[grepl("[Mm]ean|[Ss]td", fullMeasurementList$Measurement_Name),]
  rm(fullMeasurementList)
  
  # Test Data
  subTest <- scan("./UCI HAR Dataset/test/subject_test.txt")
  exeTest <- scan("./UCI HAR Dataset/test/y_test.txt")
  resTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
  resTest <- resTest[,measurements$Column_Index]
  serTest <- cbind(subTest, exeTest, resTest)
  colnames(serTest) <- c("Subject_ID", "Exercise_ID", measurements$Measurement_Name)
  serTest <- merge(serTest, activity_label, by.x = "Exercise_ID", by.y = "ID")
  rm(subTest, exeTest, resTest)
  
  # Train Data
  subTrain <- scan("./UCI HAR Dataset/train/subject_train.txt")
  exeTrain <- scan("./UCI HAR Dataset/train/y_train.txt")
  resTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
  resTrain <- resTrain[,measurements$Column_Index]
  serTrain <- cbind(subTrain, exeTrain, resTrain)
  colnames(serTrain) <- c("Subject_ID", "Exercise_ID", measurements$Measurement_Name)
  serTrain <- merge(serTrain, activity_label, by.x = "Exercise_ID", by.y = "ID")
  rm(subTrain, exeTrain, resTrain)
  rm(activity_label, measurements)
  
  # Data Cleaning
  finalResults <- rbind(serTest, serTrain)
  finalResults$Exercise_ID <- NULL
  summarizedResults <-
    finalResults %>% group_by(Subject_ID, Exercise_Description) %>% summarise_each(funs(mean))
  rm(serTest, serTrain)
  
  # Output
  write.table(summarizedResults, file = paste(outputDir,"summarized_results.txt",sep = "/"), row.names = FALSE)
  
  unlink("./UCI HAR Dataset", recursive = TRUE)
  unlink("projectFiles.zip")
  
  rm(summarizedResults)
  
  setwd(temp_work)
}