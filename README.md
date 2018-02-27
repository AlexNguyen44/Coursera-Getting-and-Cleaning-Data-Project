# Coursera Getting and Cleaning Data Course Project

This repository contains the R code and necessary documentation specified by the course project in the "Getting and Cleaning Data" class offered by Coursera.

## Files
`CodeBook.md` gives a full description of the assignment, the data, the variables of interest, and the R script used to create a tidy data set.  

`run_analysis.R` contains the code that accomplishes the following:    

1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

This code will also download the dataset described in the Code book if it is not already present in the working directory.

`tidyData.txt` contains the resulting output of the `run_analysis.R` code.