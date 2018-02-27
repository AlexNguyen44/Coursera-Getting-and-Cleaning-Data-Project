library(dplyr)

## STEP 0A: Download data, if needed

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipname <- "dataset.zip"
filename <- "UCI HAR Dataset"

if (!file.exists(filename)) {
        download.file(fileURL, zipname, method = "curl")
        unzip(zipname)
}


## Step OB: Read data into R

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


## STEP 1: Merge train and test data to create one data set

test <- cbind(testSubject, testLabel, testResult)
train <- cbind(trainSubject, trainLabel, trainResult)
mergeData <- rbind(test, train)

colnames(mergeData) <- c("subject", "activity", feature[, 2])


## STEP 2: Extract only mean and standard deviation data

# Create index of columns to be kept
colIndex <- grep("subject|activity|mean|std", colnames(mergeData))

# Subset mean and std data
mergeData <- mergeData[, colIndex]


## STEP 3: Use descriptive activity names

mergeData$activity <- factor(mergeData$activity, levels = activityLabel[, 1],
                             labels = activityLabel[, 2])


## STEP 4: Label data set with descriptive variable names

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


## STEP 5: Create second, tidy data set with average for each activity and subject

# Calculate means of all variables, grouped by subject, then activity
mergeDataMeans <- mergeData %>%
        group_by(subject, activity) %>%
        summarize_all(funs(mean))

# Export tidy data to txt file with write.table()
write.table(mergeDataMeans, file = "tidyData.txt", row.names = FALSE, quote = FALSE)
