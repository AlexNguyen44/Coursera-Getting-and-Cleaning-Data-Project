---
title: "Code book for Coursera Getting and Cleaning Data Course Project"
output: html_document
---

## Introduction
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Experiment

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
*Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
*Triaxial Angular velocity from the gyroscope. 
*A 561-feature vector with time and frequency domain variables. 
*Its activity label. 
*An identifier of the subject who carried out the experiment.

## Source Data
Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The dataset includes the following files:

* README.txt  
* features_info.txt: Shows information about the variables used on the feature vector.  
* features.txt: List of all features.  
* activity_labels.txt: Links the class labels with their activity name.  
* train/X_train.txt: Training set.  
* train/y_train.txt: Training labels.  
* test/X_test.txt: Test set.  
* test/y_test.txt: Test labels.  

The following files are available for the train and test data. Their descriptions are equivalent. 

* train/subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

## Variables
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ  
* tGravityAcc-XYZ  
* tBodyAccJerk-XYZ  
* tBodyGyro-XYZ  
* tBodyGyroJerk-XYZ  
* tBodyAccMag  
* tGravityAccMag    
* tBodyAccJerkMag  
* tBodyGyroMag  
* tBodyGyroJerkMag  
* fBodyAcc-XYZ  
* fBodyAccJerk-XYZ  
* fBodyGyro-XYZ  
* fBodyAccMag  
* fBodyAccJerkMag  
* fBodyGyroMag  
* fBodyGyroJerkMag  
 
The measured variables of interest for the Coursera course project are:

* mean(): Mean value  
* std(): Standard deviation  

The full set of variables that were estimated from these signals can be found in the features_info.txt in the data provided by the download above.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean  
* tBodyAccMean  
* tBodyAccJerkMean  
* tBodyGyroMean  
* tBodyGyroJerkMean  


## Assignment
Students are to create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Data Cleaning Procedure
The full R script used to clean the data described can be found in the run_analysis.R file in the same repo.

### Step 0: Obtain the Data and Read into R
If the data does not already exist in the current working directory, the file is downloaded from the provided url and then unzipped.

```{r eval = FALSE}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipname <- "dataset.zip"
filename <- "UCI HAR Dataset"

if (!file.exists(filename)) {
        download.file(fileURL, zipname, method = "curl")
        unzip(zipname)
}

```

The files in the "UCI HAR Dataset" (excluding the Inertial Signals data) are then read into R with read.table().

```{r eval = FALSE}
# Read in activity labels and features
activityLabel <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
feature <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

# Read in test data
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
testResult <- read.table("UCI HAR Dataset/test/X_test.txt")
testLabel <- read.table("UCI HAR Dataset/test/y_test.txt")

# Read in train data
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainResult <- read.table("UCI HAR Dataset/train/X_train.txt")
trainLabel <- read.table("UCI HAR Dataset/train/y_train.txt")
```

### Step 1: Merge train and test data to create one data set
The subject ids, activity labels, and measured values from both the train and test dataset are merged to form a single table.

```{r eval = FALSE}
test <- cbind(testSubject, testLabel, testResult)
train <- cbind(trainSubject, trainLabel, trainResult)
mergeData <- rbind(test, train)

colnames(mergeData) <- c("subject", "activity", feature[, 2])
```

### Step 2: Extract only mean and standard deviation data
Only the columns with activity labels containing "mean" and "std" are desired in the analysis, so the dataset is subsetted accordingly.

```{r eval = FALSE}
# Create index of columns to be kept
colIndex <- grep("subject|activity|mean|std", colnames(mergeData))

# Subset mean and std data
mergeData <- mergeData[, colIndex]
```

### Step 3: Use descriptive activity names
At this point, the activity column contains numerical values between 1 and 6 to indicate a variety of activities performed by the test subjects. These numbers are replaced by character strings that appropriately describe those activities.

```{r eval = FALSE}
mergeData$activity <- factor(mergeData$activity, levels = activityLabel[, 1],
                             labels = activityLabel[, 2])
```

### Step 4: Label data set with descriptive variable names
To make the data more easily interpretable, the variable names are modified to eliminate abbreviations and special characters such as parentheses and dashes.

```{r eval = FALSE}
colNamesNew <- colnames(mergeData)

# Remove dashes and parentheses
colNamesNew <- gsub("[-()]", "", colNamesNew)

# Replace abbreviations with descriptive names
colNamesNew <- gsub("^t", "time", colNamesNew)
colNamesNew <- gsub("^f", "frequency", colNamesNew)
colNamesNew <- gsub("Acc", "Acceleration", colNamesNew)
colNamesNew <- gsub("Mag", "Magnitude", colNamesNew)
colNamesNew <- gsub("Gyro", "Gyroscope", colNamesNew)
colNamesNew <- gsub("Freq", "Frequency", colNamesNew)
colNamesNew <- gsub("std", "StandardDeviation", colNamesNew)

# Other minor fixes to labels
colNamesNew <- gsub("mean", "Mean", colNamesNew)
colNamesNew <- gsub("BodyBody", "Body", colNamesNew)

# Assign column names to merged data set
colnames(mergeData) <- colNamesNew
```

### STEP 5: Create second, tidy data set with the average for each activity and subject
After the remaining data are grouped by subject id and then activity, the mean of each variable is calculated.

```{r eval = FALSE}
# Calculate means of all variables, grouped by subject, then activity
mergeDataMeans <- mergeData %>%
        group_by(subject, activity) %>%
        summarize_all(funs(mean))
```

The resulting "tidy"" dataset is then exported to a .txt file.
```{r eval = FALSE}
write.table(mergeDataMeans, file = "tidyData.txt", row.names = FALSE, quote = FALSE)
```







