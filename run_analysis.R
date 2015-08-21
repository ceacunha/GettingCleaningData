# initialize necessary library
library(dplyr)

# auxiliary data
activity_label <- read.table("activity_labels.txt",header = FALSE, col.names = c("ID", "Exercise_Description"))
fullMeasurementList <- read.table("features.txt", header = FALSE, col.names = c("Column_Index", "Measurement_Name"), colClasses = c("integer", "character"))
measurements <- fullMeasurementList[grepl("[Mm]ean|[Ss]td", fullMeasurementList$Measurement_Name),]
rm(fullMeasurementList)

# retrieving information about subjects allocated to Test Group
subTest <- scan("./test/subject_test.txt")
exeTest <- scan("./test/y_test.txt") 
resTest <- read.table("./test/X_test.txt")
resTest <- resTest[,measurements$Column_Index]
serTest <- cbind(subTest, exeTest, resTest)
colnames(serTest) <- c("Subject_ID", "Exercise_ID", measurements$Measurement_Name)
serTest <- merge(serTest, activity_label, by.x = "Exercise_ID", by.y = "ID")
rm(subTest, exeTest, resTest)

# retrieving information about subjects allocated to Train Group
subTrain <- scan("./train/subject_train.txt")
exeTrain <- scan("./train/y_train.txt") 
resTrain <- read.table("./train/X_train.txt")
resTrain <- resTrain[,measurements$Column_Index]
serTrain <- cbind(subTrain, exeTrain, resTrain)
colnames(serTrain) <- c("Subject_ID", "Exercise_ID", measurements$Measurement_Name)
serTrain <- merge(serTrain, activity_label, by.x = "Exercise_ID", by.y = "ID")
rm(subTrain, exeTrain, resTrain)

# freeing memory from data
rm(activity_label, measurements)

# merging results
finalResults <- rbind(serTest, serTrain)
finalResults$Exercise_ID <- NULL
finalResults <- group_by(finalResults, Subject_ID, Exercise_Description)
rm(serTest, serTrain)

summarizedResults <- summarise_each(finalResults, funs(mean))

write.table(summarizedResults, file = "summarized_results.txt", row.names = FALSE)