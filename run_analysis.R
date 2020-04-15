#Download and unzip file
setwd("./UCI HAR Dataset")

##Step 1: merge data sets
#Get subject/activity vectors
library(data.table)
subjecttrain <- fread("./train/subject_train.txt", col.names = "Subject")
subjecttest <- fread("./test/subject_test.txt", col.names = "Subject")
activitytrain <- fread("./train/y_train.txt", col.names = "Activity")
activitytest <- fread("./test/y_test.txt", col.names = "Activity")

#Create dataframe of train data:
#First get column labels
columnlabels <- fread("./features.txt")
columnlabels <- columnlabels$V2
#Then load data
traindata <- fread("./train/X_train.txt", col.names = columnlabels)
#Then merge subject/activity labels with data frame
traindata <- cbind(subjecttrain, activitytrain, traindata)

#Create dataframe of test data:
testdata <- fread("./test/X_test.txt", col.names = columnlabels)
testdata <- cbind(subjecttest, activitytest, testdata)

#Combine data:
combineddata <- rbind(traindata, testdata)


##Step 2: extract only mean and std from each set
meanstdcols <- which(c(TRUE, TRUE, (grepl("std", columnlabels) | grepl("mean", columnlabels)) == TRUE))
meanstddata <- combineddata[,..meanstdcols]

##Step 3: name the activities in the data set
meanstddata$Activity <- gsub("1", "Walking", meanstddata$Activity)
meanstddata$Activity <- gsub("2", "Walking Upstairs", meanstddata$Activity)
meanstddata$Activity <- gsub("3", "Walking Downstairs", meanstddata$Activity)
meanstddata$Activity <- gsub("4", "Sitting", meanstddata$Activity)
meanstddata$Activity <- gsub("5", "Standing", meanstddata$Activity)
meanstddata$Activity <- gsub("6", "Laying", meanstddata$Activity)

##Step 4: done previously (see Step 1)--column names in meanstddata are descriptive

##Step 5: average repeated subject/activity entries
condensedtable <- aggregate(meanstddata[,-(1:2)], by = list(meanstddata$Subject, meanstddata$Activity), mean, na.rm = TRUE)
library(dplyr)
condensedtable <- rename(condensedtable, Subject = Group.1, Activity = Group.2)

write.table(condensedtable, "./tidymeanstdacceldata.txt", row.name=FALSE)
View(condensedtable)