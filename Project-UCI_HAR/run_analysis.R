## 1. Merges the training and the test sets to create one data set.
x_test<-read.table("./test/X_test.txt")
x_train<-read.table("./train/X_train.txt")

y_test<-read.table("./test/y_test.txt")
y_train<-read.table("./train/y_train.txt")

subject_test<-read.table("./test/subject_test.txt")
subject_train<-read.table("./train/subject_train.txt")

x<-rbind(x_test,x_train)
y<-rbind(y_test,y_train)
subject<-rbind(subject_test,subject_train)

## 2. Extracts only the measurements on the mean and standard deviation 
## for each measurement.
index_mean<-grep("mean",feature$V2)
index_std<-grep("std",feature$V2)
index<-sort(c(index_mean,index_std))
x<-x[,index]

## 3. Uses descriptive activity names to name the activities in 
## the data set
activity_labels<-read.table("activity_labels.txt")
for (i in 1:dim(y)[1]){
  y[i,1]<-as.character(activity_labels[which(y[i,1]==activity_labels[1]),2])
}

## 4. Appropriately labels the data set with descriptive variable names.
temp<-gsub("-","",feature$V2[index])
names(x)<-gsub("[][!#$%()*,.:;<=>@^_`|~.{}]", "", temp)
names(y)<-c("activity")
names(subject)<-c("subject")

## 5. From the data set in step 4, creates a second, independent tidy 
## data set with the average of each variable for each activity and each subject.
total<-cbind(y,subject,x)
final<-aggregate(total,by=list(total$activity,total$subject),mean)
final<-final[-3:-4]
names(final)[1]<-"activity"
names(final)[2]<-"subject"
write.table(final,file="tidy.txt",row.names=FALSE)
