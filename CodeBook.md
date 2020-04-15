---
title: "CodeBook.md"
output: html_document
---

### Data and Variables
In the <b>meanstdacceldata.csv</b> file (```meanstddata```), the data values and variable names are largely identical to the raw data set. I've copied the relevant parts of the code book from the raw data set below for reference:

>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

>These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

>tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

>The set of variables that were estimated from these signals are: 

>mean(): Mean value
std(): Standard deviation
meanFreq(): Weighted average of the frequency components to obtain a mean frequency

>Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

>gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The following changes to the code book are noted:

1. "Subject": the numeric identity of the subject whose data is recorded. (The numbers do not have further coded meaning.)
2. "Activity": the activity being performed while the data is being recorded.
3. The raw data set was subsetted, leaving only variables that represent the mean and standard deviation measurements

In the <b>tidymeanstdacceldata.csv</b> file (```condensedtable```), the data has been further manipulated. Each row represents a mean of all measurements taken for a particular subject doing a particular activity. All variable descriptions and units are the same as above.


### Transformations
The meanstdacceldata file (```meanstddata```) had the following transformations from the raw data:

1. The file "features.txt" was converted to a data frame using ```fread()```. This data frame was then converted to a character vector of column names using the $ operation.

2. The files "X_test.txt" and "X_train.txt" were read into data frames using ```fread()```, using the column names produced in step 1. 

3. The files "subject_test.txt" and "subject_train.txt" were read into data frames using ```fread()```, with the name "Subjects" added as a header. Likewise, "y_train.txt" and "y_test.txt" were read into data frames with the label "Activity"
4. The three data frames, of Subjects, Activity, and data, were combined to create test and train data sets.
5. These two data sets were merged to create a single data set.
6. All columns containing the strings ```std``` or ```mean``` were subsetted using ```grepl()```, along with the Subject and Activity columns.
7. The numeric values in the Activity column were substituted with their descriptive labels, with the codebook found in file activity_labels.txt, using ```gsub()```.


The tidymeanstdacceldata file (```condensedtable```) had the following transformations from there:

1. Rows with the same values in the Subject and Activity columns were combined and their values averaged, using the ```aggregate()``` function.