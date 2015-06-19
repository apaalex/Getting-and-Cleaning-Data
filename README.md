---
title: "ReadMe.md"
output: html_document
---

README for JHU's "Getting and Cleaning Data" course project
=====================================
###Purpose
Describing the run_analysis script and what it does

###Data
See the Codebook.md for more info

###Project Goal
Overview: In general, the R script called run_analysis.R does the following:

    1.Merges the training and test sets to create one data set

    2.Extracts only the measurements on the mean and standard deviation for each measurement

    3.Uses descriptive activity names to name the activites in the data set

    4.Appropriately labels the data set with descriptive variable names

    5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

###Specifics:

preperation steps: setting working directory and loading packages that will be used
```
setwd("D://acharos//R//UCI HAR Dataset")
library(dplyr)
library(RCurl)
```

downloading the data set and unzipping it in my working directory
```
if (!file.info("UCI HAR Dataset")$isdir) {
  dataFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  dir.create("UCI HAR Dataset")
  download.file(dataFile, "UCI-HAR-dataset.zip", method="curl")
  unzip("./UCI-HAR-dataset.zip")
}
```
reading in all the files that will be used
```
  X_test<-read.table("test/X_test.txt")
  y_test<-read.table("test/y_test.txt")
  subject_test<-read.table("test/subject_test.txt")
  X_train<-read.table("train/X_train.txt")
  y_train<-read.table("train/y_train.txt")
  subject_train<-read.table("train/subject_train.txt")
  features<-read.table("features.txt")
```
creating 3 merged datasets
1.Xm that combines X_test and X_train
2. ym that does the same for the y datasets
3.same for teh subject datasets
```
  Xm<-rbind(X_test, X_train)
  ym<-rbind(y_test, y_train)
  subjectm<-rbind(subject_test, subject_train)
```
before merging the 3 just generated subdatasets to one final datasets we will focus on each variable that includes std or mean in its name, assuming that these will provide us only with the variables that calculate a standard deviation or a mean. also for this to work properly we have to label the variables with their feature names instead of the V1:V561 labels that were present. first off the xm data set gets labelled. then ym gets descriptive activity labels
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING
while subject is really just an integer from 1:30 (30 test jsubjects)
```
  mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

  Xm <- Xm[, mean_and_std_features]
  names(Xm) <- features[mean_and_std_features, 2]

  activities <- read.table("activity_labels.txt")
  ym[, 1] <- activities[ym[, 1], 2]
  names(ym) <- "activity"

  names(subjectm) <- "subject"
```
ready for the merge via the cbind function.
```
  dataset <- cbind(Xm, ym, subjectm)
```
the dataset_avg aggregates the values for each variable of each combination of activity/subject and calculates the mean thus presenting 6lines per subject (6 activities) * 30 subjects =180 lines with mean values of 66variables
```
#creating and saving 2nd dataset with avgs and means#
  dataset_avg <- aggregate(x=dataset, by=list(activities=dataset$activity, subj=dataset$subject), FUN=mean)
    dataset_avg <- dataset_avg[, !(colnames(dataset_avg) %in% c("subj", "activity"))]
  str(dataset_avg)
  write.table(dataset_avg, 'dataset_avg.txt', row.names = F)
```  
in the end the avg:dataset dataframe gets exported to a txt file
