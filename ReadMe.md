---
title: "ReadMe.md"
output: html_document
---

## Getting and Cleaning Data Course Project

The script in this repo is used to transform the raw accelerometer data [found here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) into two tables. This ReadMe file is organized by the steps requested in this assignment.


### Step 1: Generating one data set from test and training data

First, I generated the Subject and Activity columns for both the training and test data:

```
subjecttrain <- fread("./train/subject_train.txt", col.names = "Subject")
subjecttest <- fread("./test/subject_test.txt", col.names = "Subject")
activitytrain <- fread("./train/y_train.txt", col.names = "Activity")
activitytest <- fread("./test/y_test.txt", col.names = "Activity")
```

Then, I created a vector of the provided feature names, which will serve as the column names for each table. The "features.txt" file originally had two columns, so I subsetted only the second column with the actual names:

```
columnlabels <- fread("./features.txt")
columnlabels <- columnlabels$V2
```

Next, I created one table each for the training data ("traindata") and testing data ("testdata"). I started by reading in the raw data with ```fread()```, labeling the raw data columns with the vector of column names. I then combined these two tables with my Subject and Activity columns, created earlier, using ```cbind()```: 

```
traindata <- fread("./train/X_train.txt", col.names = columnlabels)
traindata <- cbind(subjecttrain, activitytrain, traindata)

testdata <- fread("./test/X_test.txt", col.names = columnlabels)
testdata <- cbind(subjecttest, activitytest, testdata)

```

Finally, I merged these two tables with ```rbind()``` because the column names were already identical:
```
combineddata <- rbind(traindata, testdata)
```
Of note, this table fulfills Step 4 as well, because each of the variable names describes the data contained within it.

### Step 2: extract only columns of the mean or standard deviation accelerometer measurements

To identify which columns contained "mean" or "std" in the name, I used ```grepl()``` to generate a logical vector from my original vector of variable names, columnlabels. I then added two "TRUE" values to the beginning of this new logical vector to represent the "Subject" and "Activity" columns, which I want to keep. Finally, I used the ```which()``` function to create a numeric vector, ```meanstdcols```, of indices for my desired columns:

```
meanstdcols <- which(c(TRUE, TRUE, (grepl("std", columnlabels) | grepl("mean", columnlabels)) == TRUE))
```

Then, I just used this vector of indices to take a subset of mean/std measurements from my merged table:

```
meanstddata <- combineddata[,..meanstdcols]
```

The data frame ```meanstddata``` is my subsetted table.

### Step 3: label the activity names in the table

For this step, I used the provided codebook (activity_labels.txt) to identify which numbers in the Activity column corresponded to which action. Then, I used gsub() to find and replace all numbers in this column with their proper label:
```
meanstddata$Activity <- gsub("1", "Walking", meanstddata$Activity)
meanstddata$Activity <- gsub("2", "Walking Upstairs", meanstddata$Activity)
meanstddata$Activity <- gsub("3", "Walking Downstairs", meanstddata$Activity)
meanstddata$Activity <- gsub("4", "Sitting", meanstddata$Activity)
meanstddata$Activity <- gsub("5", "Standing", meanstddata$Activity)
meanstddata$Activity <- gsub("6", "Laying", meanstddata$Activity)
```

### Step 4: label data set with descriptive variable names

My table already fulfills the requirement of this step. I renamed the Subject and Activity columns before adding them to my data table; see the first block of code in this document.

### Step 5: create a second, independent tidy data set with the averages for each activity/subject pair

Starting with my ```meanstddata``` data frame, that was tidy except for the duplicate entries, I used the ```aggregate``` function to group all the rows with the same subject/activity, and perform the ```mean()``` function on them all. (Note: I removed columns 1/2 from ```meanstddata``` because the ```aggregate()``` function automatically adds two more columns with the new groups.)
```
condensedtable <- aggregate(meanstddata[,-(1:2)], by = list(meanstddata$Subject, meanstddata$Activity), mean, na.rm = TRUE)
```

Finally, I renamed the first two columns from Group.1 and Group.2 (output from ```aggregate()```) to Subject and Activity. This left me with my final tidy data set, ```condensedtable```.

```
library(dplyr)
condensedtable <- rename(condensedtable, Subject = Group.1, Activity = Group.2)
```

Both these tables were written to the current file directory as csv files:
```
write.table(meanstddata, "./meanstdacceldata.csv")
write.table(condensedtable, "./tidymeanstdacceldata.csv")
```