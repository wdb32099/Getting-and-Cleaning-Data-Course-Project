#Import Test Data
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
x_test<-read.table("UCI HAR Dataset/test/x_test.txt")
TESTDATA<-cbind(subject_test,y_test,x_test)

#Import Train Data
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
x_train<-read.table("UCI HAR Dataset/train/x_train.txt")
TRAINDATA<-cbind(subject_train,y_train,x_train)

#Combine Test and Train Data
RawData<-rbind(TESTDATA,TRAINDATA)

#Import the names of the measurements as Character
measurenames<-read.table("UCI HAR Dataset/features.txt")
measurenames$V2<-as.character(measurenames$V2)

#Define the column names for the RawData
colnames(RawData)<-c("Subject","Activity",measurenames[,2])

#Extract only the measurements on the mean and standard deviation for each measurement
ExtData<-RawData[,c(1,2,grep(pattern = "mean",colnames(RawData)),grep(pattern = "std",colnames(RawData)))]
ExtData<-ExtData[,-c(grep(pattern = "Freq",colnames(ExtData)))]

#Uses descriptive activity names to name the activities in the data set
ExtData$Activity[ExtData$Activity==1]<-"WALKING"
ExtData$Activity[ExtData$Activity==2]<-"WALKING_UPSTAIRS"
ExtData$Activity[ExtData$Activity==3]<-"WALKING_DOWNSTAIRS"
ExtData$Activity[ExtData$Activity==4]<-"SITTING"
ExtData$Activity[ExtData$Activity==5]<-"STANDING"
ExtData$Activity[ExtData$Activity==6]<-"LAYING"

#creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(reshape2)
ExtData1<-melt(ExtData,id=c("Subject","Activity"),measure.vars=colnames(ExtData)[3:68])
AvgData<-dcast(ExtData1, Subject + Activity ~ variable, mean)
AvgData
