
#Importing library

library(dplyr)

filename <- "FinalProject.zip"

# Checking if archieve already exists.

if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists

if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

# Reading the train and test datasets

activity_label = read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features = read.table("./UCI HAR Dataset/features.txt", col.names = c("n", "functions"))

x_test = read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test = read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")

subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_train = read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train = read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#Merging the data

x = rbind(x_train, x_test)
y = rbind(y_train, y_test)
subject = rbind(subject_train, subject_test)
finaldata = cbind(subject, y, x)

#Creating a data by selecting mean  and standard deviation

mean_std = finaldata %>%
    select(subject, code, contains("mean"), contains("std"))

mean_std$code <- activity_label[mean_std$code, 2]

#Naming the columns in the mean_std data 

names(mean_std)[2] = "activity"

names(mean_std) = gsub("Acc", "Acceleromter", names(mean_std))
names(mean_std)<-gsub("Gyro", "Gyroscope", names(mean_std))
names(mean_std)<-gsub("BodyBody", "Body", names(mean_std))
names(mean_std)<-gsub("Mag", "Magnitude", names(mean_std))
names(mean_std)<-gsub("^t", "Time", names(mean_std))
names(mean_std)<-gsub("^f", "Frequency", names(mean_std))
names(mean_std)<-gsub("tBody", "TimeBody", names(mean_std))
names(mean_std)<-gsub("-mean()", "Mean", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("-std()", "STD", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("-freq()", "Frequency", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("angle", "Angle", names(mean_std))
names(mean_std)<-gsub("gravity", "Gravity", names(mean_std))

names(mean_std)

#Creating the final data by calculating mean of each variable

projectdata <- mean_std %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

#Writing the data to text file
write.table(projectdata, "ProjectData.txt", row.name=FALSE)

str(projectdata)

projectdata
