setwd("./data")
if(!file.exists("./data")){dir.create("./data")}
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile="./data/dataset.zip")
unzip(zipfile="./data/dataset.zip",exdir="./data")
#1.1Reading files
#1.1.1 Reading training tables
x_train<-read.table("./data/UCI HAR Dataset/train/x_train.txt")
y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
#1.1.2Reading testing tables
x_test<-read.table("./data/UCI HAR Dataset/test/x_test.txt")
y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
#1.1.3 Reading feature vector
features<-read.table('./data/UCI HAR Dataset/features.txt')
#1.1.4 Reading activity labels
activityLabels=read.table('./data/UCI HAR Dataset/activity_labels.txt')
#1.2 assigning column names
colnames(x_train)<-features[,2]
colnames(y_train)<-"activityId"
colnames(subject_train)<-"subjectId"

colnames(x_test)<-features[,2]
colnames(y_test)<-"activityId"
colnames(subject_test)<-"subjectId"
colnames(activityLabels)<-c('activityId','activityType')
#1.3merging all data in one set
mrg_train<-cbind(y_train,subject_train,x_train)
mrg_test<-cbind(y_test,subject_test,x_test)
setAllInone<-rbind(mrg_train,mrg_test)
dim(setAllInone)
#2.1 Reading column names
colnames<-colnames(setAllInone)
#create vector for defining Id,mean and standard deviation
mean_and_std<-(grepl("activityId",colnames)|
                 grepl("subjectId",colnames)|
                 grepl("mean..",colnames)|
                 grepl("std..",colnames)
               )
#2.3 making necessary subset fron setallinone
setforMeanAndStd<-setAllInone[,mean_and_std==TRUE]
# step 3.Uses descriptive activity names to name the activities in the data set
setWithActivityNames<-merge(setforMeanAndStd,activityLabels,by='activityId',all.x=TRUE)
#step 4.Done in steps,see 1.3,2.2,2.3
#step 5.creates a second ,independent tidy data set with average of each activity
#5.1 making a second tidy data set
secTidyset<-aggregate(.~subjectId + activityId, setWithActivityNames,mean)
secTidyset<-secTidyset[order(secTidyset$subjectId,secTidyset$activityId),]
#writing second tidy data set in txt file
write.table(secTidyset,"secTidySet.txt",row.names=FALSE)