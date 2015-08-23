# Getting and Cleaning Data Course Project
<p> This README.md file explains all steps required to acomplish the results expected
by the Course Project defined at Getting and Cleaning Data Course - Data Science Specialization by John Hopkins at Coursera</p>

## Introduction
<p> The Course Project aims to validade the ability to recover and clean data for different sources. To do so, a R script was written to perform such tasks and, at the end of its execution, provides the output file with the result.</p>

<p> This project was developed and made available as expected and all files are stored on the Github repository at <a href="https://www.github.com/ceacunha/GettingCleaningData"> GettingCleaningData</a>, where you can find:

* README.md - this file
* CodeBook.md - Informative file which describes all variables
* run_analysis.R - R script to perform all tasks
* projectfiles.zip - All data files used within the project
* summarized_results.txt - Output text file with results expected by the assignment

<p> The main purpose of this README.md is to indicate the steps necessary to reproduce the results obtained by this deployed version by anyone. The following section presents the requirements ad step-by-step to archive this goal.</p> 

## Task Execution
<p>The result expected by the Course Project is archieved by the execution of the run_analysis.R script found on the GitHub repository indicated in the previous section. Miminum requirements to perform the acitivities are (i) R environment installed, and (ii) <b>dplyr</b> library installed within that environment.</p>

<p>Once the requirements above are met, one can download the script and run it on the environment. The script defines the following function which must be called to execute all activities and return the output file.</p>

<code>function runAnalysis (workSpc = NULL, fileURL = NULL, outputDir = NULL)</code>

<p> The <i>run_analysis</i> function is defined with 3 optional parameters:</p>
1. <b>workSp</b> - the directory to be considered as workspace. If none is indicated, the script will assume current's R environment as workspace;
2. <b>fileURL</b> - the URL that stores the zip file containing all data for project. If no URL is indicated, the script will assume the URL as of the GitHub repository;
3. <b>outputDir</b> - indicating the directory to store the output file. If no directory is given, the script will assume the workspace as the output directory.

<p> The function has 6 main blocks and will be explained in the following subsctions:</p>
1. Setup
2. Auxiliary Data
3. Test Data
4. Train Data
5. Data Cleaning
6. Output

### Setup
<p>The <b>Setup</b> subsection of the code - market with <i># Setup</i> inside the function - is responsible for (i) establishing the workspace (given the value provided by the <i>wrkSpc</i> parameter), (ii) download data files (taking in consideration the <i>fileURL</i> parameter), and (iii) define the output directory (as indicates the <i>outputDir</i> paramenter).</p>

<p>Although simple, this area create the structure necessary for the R script to operate, reading all data files and return required the output file.</p>

### Auxiliary Data
<p>The <b>Auxiliary Data</b> subsection of the code - market with <i># Auxiliary Data</i> inside the function - is responsible for uploading all auxiliary data used by the script to analyze and process the project's data.</p>

<p>The data considered as auxiliary are: (i) Activity Label and (ii) Measurements. The first is the definition/description of each activity performed by a subject - stored in <i>activity_labels.txt</i> file; the second, Measurements, is the definition of each variable data captured while performing a given activity - stored in <i>features.txt</i> file. Even though the full measurements list consists of 561 variables, for this project, only measurements regarding mean and standard deviation atr considerer, thus, the final measurement list is a subset of the full one.</p>

### Test Data
<p>The <b>Test Data</b> subsection of the code - market with <i># Test Data</i> inside the function - is responsible for uploading all data regarding subjects allocated in the Test Group - as defined by the project.</p>

<p>The data stored by those on the Test Group are divided as followed: (i) Subject, (ii) Exercise and, (iii) Results. The first is the list of subject's ID that performed an activity at a given order - stored in <i>test/subject_test.txt</i> file; the second, Exercise, is the list of Activity's ID that were performed by a subject at a given order - stored in <i>test/y_test.txt</i> file. Finally, Results, is the list containing a set of data captured for each measurement (has indicated in the subsection above - for a activity performed by a subject at a given order.

<p>Therefore, those files are connected in a sense that the first ID on Subject list performed the first ID on Exercise list and captured the first set of measurements on Results list. All lines respect the logic <i>n -> n -> n</i>, where <i>n</i> is the line number.</p>

<p>All data is merged into a single table (<i>serTest</i> variable) to facilitate cleaning and computational processing. Also, due to project's requirements, all data not related to mean and standard deviation are removed.</p>

### Train Data
<p>The <b>Train Data</b> subsection of the code - market with <i># Train Data</i> inside the function - is responsible for uploading all data regarding subjects allocated in the Train Group - as defined by the project.</p>

<p>The data stored by those on the Train Group are divided as followed: (i) Subject, (ii) Exercise and, (iii) Results. The first is the list of subject's ID that performed an activity at a given order - stored in <i>test/subject_test.txt</i> file; the second, Exercise, is the list of Activity's ID that were performed by a subject at a given order - stored in <i>test/y_test.txt</i> file. Finally, Results, is the list containing a set of data captured for each measurement (has indicated in the subsection above - for a activity performed by a subject at a given order.

<p>Therefore, those files are connected in a sense that the first ID on Subject list performed the first ID on Exercise list and captured the first set of measurements on Results list. All lines respect the logic <i>n -> n -> n</i>, where <i>n</i> is the line number.</p>

<p>All data is merged into a single table (<i>serTrain</i> variable) to facilitate cleaning and computational processing. Also, due to project's requirements, all data not related to mean and standard deviation are removed.</p>

### Data Cleaning
<p>The <b>Data Cleaning</b> subsection of the code - market with <i># Data Cleaning</i> inside the function - is responsible for merging, filtering, grouping and calculation execution for extracting tidy data.</p>

<p>Within this section, the data processed in the two previous sections (<i>serTest</i> and <i>serTrain</i>) are merged to form a single experiment data set. Then, the data is grouped by Subject and Exercise in order to comply a project's requirement and performed a mean operation in each data set of measurements by its group to result in the expected output.</p>

<p>The code bellow displays how the merging, group and mean operation were executed to derive the expected result.</p>
<code>
finalResults <- rbind(serTest, serTrain) <br>
finalResults$Exercise_ID <- NULL <br>
summarizedResults <- finalResults %>% group_by(Subject_ID, Exercise_Description) %>% summarise_each(funs(mean))
</code>

### Output
<p>The <b>Output</b> subsection of the code - market with <i># Output</i> inside the function - is responsible writing the resulting file and cleaning memory and directory data used to perform all tasks.</p>

<p>The code bellow displays all steps used to write the output file and clean directory and memory data:</p>
<code>
write.table(summarizedResults, file = paste(outputDir,"summarized_results.txt",sep = "/"), row.names = FALSE)<br>
unlink("./UCI HAR Dataset", recursive = TRUE)<br>
unlink("projectFiles.zip")
</code>