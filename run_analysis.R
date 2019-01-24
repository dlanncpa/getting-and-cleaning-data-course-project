# Download the file and create a directory called tidydata.

if (!file.exists("./tidydata")) {
    dir.create("./tidydata")
}

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./tidydata/data.zip", method = "curl")

# Unzip the file.

unzip(zipfile = "./tidydata/data.zip", exdir = "./tidydata")
dataPath<-file.path("./tidydata", "UCI HAR Dataset")

# Determine what files are in the unzipped directory.

# Project requirement 1.Merge the training and test sets to create one data set.
# Read the data sets.

x_test<-read.table(file.path(dataPath, "test", "X_test.txt"), header = FALSE)
x_train<-read.table(file.path(dataPath, "train", "X_train.txt"), header = FALSE)
y_test<-read.table(file.path(dataPath, "test", "y_test.txt"), header = FALSE)
y_train<-read.table(file.path(dataPath, "train", "y_train.txt"), header = FALSE)
subject_test<-read.table(file.path(dataPath, "test", "subject_test.txt"), header = FALSE)
subject_train<-read.table(file.path(dataPath, "train", "subject_train.txt"), header = FALSE)

# Combine the test and train datasets by rows.

x<-rbind(x_test, x_train)
y<-rbind(y_test, y_train)
subject<-rbind(subject_test, subject_train)

# Give the data variables meaningful names.

names(y)<-c("activity")
names(subject)<-c("subject")

# Read the features table and use V2 as variable names of x.

features<-read.table(file.path(dataPath, "features.txt"), header = FALSE)
names(x)<-features$V2

# Combine x, y, and subject into one data frame.

y_subject<-cbind(y, subject)
combinedData<-cbind(y_subject, x)

# Project requirement 2. Extracts only the measurements on the mean and standard deviation for each
# measurement.

mean_std<-c(as.character(features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]), "activity", "subject")
combinedData<-subset(combinedData, select = mean_std)

# Project requirement 3. Uses descriptive activity names to name the activities in the data set.

library(plyr)
activityNames<-read.table(file.path(dataPath, "activity_labels.txt"), header = FALSE)
names(activityNames)<-c("activity", "activityLabel")
combinedData<-join(combinedData, activityNames, by = "activity", match = "first")
combinedData<-combinedData[, -1]

# Project requirement 4. Appropriately labels the data set with descriptive variale names.

names(combinedData)<-gsub("^t", "time", names(combinedData))
names(combinedData)<-gsub("^f", "frequency", names(combinedData))
names(combinedData)<-gsub("Acc", "Acceleration", names(combinedData))
names(combinedData)<-gsub("Gyro", "AngularVelocity", names(combinedData))
names(combinedData)<-gsub("Mag", "Magnitude", names(combinedData))
names(combinedData)<-gsub("BodyBody", "Body", names(combinedData))

# Project requiremet 5. From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.

tidyDataSet<-aggregate(combinedData, by = list(combinedData$subject, combinedData$activityLabel), FUN = mean)
tidyDataSet$subject<-NULL
tidyDataSet$activityLabel<-NULL
names(tidyDataSet)[1]<-"Subject"
names(tidyDataSet)[2]<-"Activity"

# Write the tidy data set to a text file.

write.table(tidyDataSet, file = "tidyData.txt")