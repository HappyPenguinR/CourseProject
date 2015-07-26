#Project: Create one R script called run_analysis.R that does the following:
#1. Merges the training and test sets to create one data set
#2. Extracts only measurements on the mean and standard deviation
#3. Uses descriptive activity names to name the activities in the dataset
#4. Appropriately labels the data set with descriptive variable names
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

#PART ONE: PREP
#set working directory

#download file from source and load into R
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "ucihar.zip", method = "curl")
list.files()

#unzip file
unzip(zipfile = "ucihar.zip")

#view all files in the unzipped folder and use recursive = T to view the nested folders
list.files("UCI HAR Dataset", recursive=T)

#examine files
#In examining the files, it looks like there are two folders, "test", and "train", each holding 4 files
#For the purpose of this project, we are not using the Inertial.Signals file because of the focus of this work being only on the mean and std
#Of the remaining 3 files, "y" is the Activity (there are 6 activities), "X" is the measurement, and the third dataset is the subject (there are 30 subjects)

#Read each dataset - and user header = F because in examining the txt files, they don't have headers

#i. Activity
activity_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", header = F)
head(activity_test)
activity_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = F)
head(activity_train)

#ii - Subject
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = F)
head(subject_test)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = F)
head(subject_train)

#iii - Measurement
measure_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = F)
head(measure_test)
measure_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = F)
head(measure_train)

#PART TWO: MERGE
#We are now ready to start the process of merging the datasets into one dataset

#Step 1: Combine test and train databasets using rbind - since we are binding rows
combined_activity <- rbind(activity_test, activity_train)
combined_subject <- rbind(subject_test, subject_train)
combined_measure <- rbind(measure_test, measure_train)
head(combined_activity)
head(combined_subject)
head(combined_measure)

#Step 2: Merge Activity and Subject into one data frame using cbind since we are binding columns
partial_one <- cbind(combined_activity, combined_subject)
head(partial_one)

#Step 3: Name the columns of this data frame and view it to confirm 
colnames(partial_one) <- c("Activity", "Subject")
head(partial_one)

#Step 4: Name the 561 columns of the "Measure" dataset using the features.txt file
#Read the features.txt into a table first
names4measured <- read.table("./UCI HAR Dataset/features.txt", head=F)
head(names4measured)

#Assign names from the table to the 561 columns in the combined "measure" dataset
names(combined_measure) <- names4measured$V2
head(combined_measure)

#Pick out only the columns that have the keyword "mean" or "std" using the grepl function
subset_measure_mean <- combined_measure[, grepl("mean", names(combined_measure))]
subset_measure_std <- combined_measure[, grepl("std", names(combined_measure))]
head(subset_measure_mean)
head(subset_measure_std)

#Step 5: Combine the mean and std subsets into one data frame using cbind
subset_measure <- cbind(subset_measure_mean, subset_measure_std)
head(subset_measure)
names(subset_measure)

#since we used the keyword "mean" before, it also included meanfreq, which we should eliminate
#eliminate columns with meanfreq
subset_measure1 <- subset_measure[, -c(24:26, 30:32, 36:38, 40, 42, 44, 46)]
names(subset_measure1)

#Merge the Activity and Subject dataset with the Measure dataset using cbind to arrive at one dataset
one_dataset <- cbind(partial_one, subset_measure1)
head(one_dataset)

#PART THREE: Assign descriptive activity names to the Activities 1-6

#Extract the activity names from the txt file into a table
names4activity <- read.table("./UCI HAR Dataset/activity_labels.txt", head=F)
head(names4activity)

#check the column type for Activity using str and the factorize the Activity column
str(one_dataset)
one_dataset$Activity <- factor(one_dataset$Activity, labels = names4activity$V2)
head(one_dataset)
names(one_dataset)

#PART FOUR: Label the dataset with descriptive variable names

#Use gsub function which replaces text within a string for all "Measure" columns
# Identified the following names from the readme.txt file
# Acc: Accelerometer; Gyro = Gyroscope; Mag = Magniture, t and f represent the two domains of t=time and f=freq
# I would also like the mean and std to stand out for easy identification in the tidy dataset
# so I'd like to make mean = MEAN, and std = STD
names(one_dataset) <- gsub("^t", "time", names(one_dataset))
names(one_dataset) <- gsub("^f", "freq", names(one_dataset))
names(one_dataset) <- gsub("Acc", "Accelerometer", names(one_dataset))
names(one_dataset) <- gsub("Gyro", "Gyroscope", names(one_dataset))
names(one_dataset) <- gsub("Mag", "Magnitude", names(one_dataset))
names(one_dataset) <- gsub("std()", "STD", names(one_dataset))
names(one_dataset) <- gsub("mean()", "MEAN", names(one_dataset))
names(one_dataset) <- gsub("BodyBody", "Body", names(one_dataset))
names(one_dataset)

#PART FIVE: Create tidy dataset

#use reshape2 package and the melt and dcast functions
#install reshape2 package and run it
one_dataset_melt <- melt(one_dataset, id=c("Activity", "Subject"), measure.vars = c(3:68))
head(one_dataset_melt, n=3)
TidyData <- dcast(one_dataset_melt, Activity + Subject ~ variable,mean)
TidyData
names(TidyData)


#PART SIX: Create txt file 

#Write to txt using write.table function and put it into a file in the working directory for posting
write.table(TidyData, file = "TidyData.txt", sep = "\t", row.names = F)





