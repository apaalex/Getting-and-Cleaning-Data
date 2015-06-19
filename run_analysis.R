setwd("D://acharos//R//UCI HAR Dataset")
library(dplyr)
library(RCurl)


if (!file.info("UCI HAR Dataset")$isdir) {
  dataFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  dir.create("UCI HAR Dataset")
  download.file(dataFile, "UCI-HAR-dataset.zip", method="curl")
  unzip("./UCI-HAR-dataset.zip")
}

#reading in the files#
  X_test<-read.table("test/X_test.txt")
  y_test<-read.table("test/y_test.txt")
  subject_test<-read.table("test/subject_test.txt")
  X_train<-read.table("train/X_train.txt")
  y_train<-read.table("train/y_train.txt")
  subject_train<-read.table("train/subject_train.txt")
  features<-read.table("features.txt")


#merging#
  Xm<-rbind(X_test, X_train)
  ym<-rbind(y_test, y_train)
  subjectm<-rbind(subject_test, subject_train)

#selecting std and mean variables and labeling#
  mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

  Xm <- Xm[, mean_and_std_features]
  names(Xm) <- features[mean_and_std_features, 2]

  activities <- read.table("activity_labels.txt")
  ym[, 1] <- activities[ym[, 1], 2]
  names(ym) <- "activity"

  names(subjectm) <- "subject"
  dataset <- cbind(Xm, ym, subjectm)

#creating and saving 2nd dataset with avgs and means#
  dataset_avg <- aggregate(x=dataset, by=list(activities=dataset$activity, subj=dataset$subject), FUN=mean)
    dataset_avg <- dataset_avg[, !(colnames(dataset_avg) %in% c("subj", "activity"))]
  str(dataset_avg)
  write.table(dataset_avg, 'dataset_avg.txt', row.names = F)
