#Reading tables and assing names
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./UCI HAR Dataset/features.txt')
activitylabels = read.table('./UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features [,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activitylabels) <- c('activityId','activityType')

#Merges the training and the test sets to create one data set.

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
onedataset <- rbind(merge_train, merge_test)
#Extracts only the measurements on the mean and standard deviation for each measurement. 
columnnames <- colnames(onedataset)

meanstd <- (grepl("activityId" , columnnames) | 
              grepl("subjectId" , columnnames) | 
              grepl("mean.." , columnnames) | 
              grepl("std.." , columnnames) 
            
)

setMeanStd <- onedataset[ , meanstd == TRUE]


#Uses descriptive activity names to name the activities in the data set
setactivitynames <- merge(setMeanStd, activitylabels,
                          by='activityId',
                          all.x=TRUE)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

secondTidydata<- aggregate(. ~subjectId + activityId, setactivitynames, mean)
secondTidydata <- secondTidydata[order(secondTidydata$subjectId, secondTidydata$activityId),]


