# Getting and Cleaning Data Course Project
<p> This README.md file explains all steps required to acomplish the results expected
by the Course Project defined at Getting and Cleaning Data Course - Data Science Specialization by John Hopkins at Coursera</p>

## Introduction
<p> The Course Project aims to validade the ability to recover and clean data for different sources in roder to provide a analytical power. To do so, a R script is required to perform such tasks and, at the end of its execution, provide the output file with the expected result. </p>

<p> This project was delivered as expected and all files are stored on the Github repo at <a href="https://www.github.com/ceacunha/GettingCleaningData"> GettingCleaningData</a>, where you can find:

* README.md - this file
* run_analysis.R - R script to perform all tasks
* projectfiles.zip - All data files used within the project
* summarized_results.txt - Output text file with results expected by the assignment

<p> The main purpose of this README.md is to indicate the steps necessary to reproduce the results obtained by this deployed version by anyone. The following section presents the requirements to archive this goal</p> 

## Task Execution
<p>The result expected by the Course Project is archieved by the execution of the run_analysis.R script found on the GitHub repository indicated in the previous section. Miminum requirements to perform the acitivities are (i) R environment installed, and (ii) <b>dplyr</b> library installed within that environment.</p>

<p>Once the requirements above are met, one can download the script and run it on the environment. The script defines the following function which must be called to execute all activities and return the output file.</p>

<code>function runAnalysis (workSpc = NULL, fileURL = NULL, outputDir = NULL)</code>

<p> The <i>run_analysis</i> function is defined with 3 optional parameters:</p>
1. <b>workSp</b> - the directory in which must be directed the workspace. If none is indicated, the script will assume current's R environment as workspace;
2. <b>fileURL</b> - the URL that stores the zip file containing all data for project. If no URL is indicated, the script will assume the URL of the GitHub repository;
3. <b>outputDir</b> - indicating the directory to store the output file. If no directory is given, the script will assume the workspace as the output directory.

<p> The function has 6 main blocks and will be explained in the following subsctions:</p>
1. Setup
2. Auxiliary Data
3. Test Data
4. Train Data
5. Data Cleaning
6. Output

### Setup

<code>
</code>

### Auxiliary Data

<code>
activity_label <- read.table("activity_labels.txt",header = FALSE, col.names = c("ID", "Exercise_Description"))
fullMeasurementList <- read.table("features.txt", header = FALSE, col.names = c("Column_Index", "Measurement_Name"), colClasses = c("integer", "character"))
measurements <- fullMeasurementList[grepl("[Mm]ean|[Ss]td", fullMeasurementList$Measurement_Name),]
</code>

### Test Data

<code>
subTest <- scan("./test/subject_test.txt")
exeTest <- scan("./test/y_test.txt") 
resTest <- read.table("./test/X_test.txt")
resTest <- resTest[,measurements$Column_Index]
serTest <- cbind(subTest, exeTest, resTest)
colnames(serTest) <- c("Subject_ID", "Exercise_ID", measurements$Measurement_Name)
serTest <- merge(serTest, activity_label, by.x = "Exercise_ID", by.y = "ID")
</code>

### Train Data

<code>
subTrain <- scan("./train/subject_train.txt")
exeTrain <- scan("./train/y_train.txt") 
resTrain <- read.table("./train/X_train.txt")
resTrain <- resTrain[,measurements$Column_Index]
serTrain <- cbind(subTrain, exeTrain, resTrain)
colnames(serTrain) <- c("Subject_ID", "Exercise_ID", measurements$Measurement_Name)
serTrain <- merge(serTrain, activity_label, by.x = "Exercise_ID", by.y = "ID")
</code>

### Data Cleaning

<code>
finalResults <- rbind(serTest, serTrain) <br>
finalResults$Exercise_ID <- NULL <br>
summarizedResults <- finalResults %>% group_by(Subject_ID, Exercise_Description) %>% summarise_each(funs(mean))
</code>

### Output

<code>
write.table(summarizedResults, file = "summarized_results.txt", row.names = FALSE)
</code>

## Conclusion