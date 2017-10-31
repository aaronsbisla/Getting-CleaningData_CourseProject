# Course Project

#Downloading & unpacking files
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "UCIdata.zip"))
unzip(zipfile = "UCIdata.zip")
library(data.table)

#adding labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2]<- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#retrieve mean & std
featuresWanted<- grep("(mean|std)\\(\\)", features[,2])
featuresWanted.names <- features[featuresWanted, 2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names<- gsub('[-()]','', featuresWanted.names)
featuresWanted.names

#loading train datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities<- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects<- read.table("UCI HAR Dataset/train/subject_train.txt")
train <-cbind(trainSubjects, trainActivities, train)
train

#loading test datasets
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)
test

#merge datasets
mergedData<- rbind(train, test)
colnames(mergedData)<- c("subject", "activity", featuresWanted.names)
mergedData

#convert activities and subjects to factors
mergedData$activity <- factor(mergedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
mergedData$subject<- as.factor(mergedData$subject)
mergedData.melt <- melt(mergedData, id = c("subject", "activity"))
mergedData.mean<- dcast(mergedData.melt, subject + activity ~ variable, mean)
write.table(mergedData.mean, "tidyData.txt", row.names =FALSE, quote = FALSE )
