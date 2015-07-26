This is an R Markdown document that explains what the run_analysis.R script does and how it can be invoked by any user. 

==================================================================

Getting and Cleaning Data: 
Coursera Course Project
Date: July 26, 2015
Author: HappyPenguinR

Data Source: 
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================

##Background


For this course project, we were provided a link to a dataset called “Human Activity Recognition Using Smartphone Dataset” (Version 1.0). The link is as follows:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The original dataset provided data pertaining to experiments that were conducted with 30 subjects, each performing six activities ((WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a Samsung Galaxy S II smartphone on their waist. The original data was partitioned randomly in two sets, and we were given these two sets as folders called “test”, and “train”. Each folder contained 4 files, of which, our task was to extract the “Activity” data, the “Subject” data, and the “Features” data and create one tidy data set.

Specifically, the project tasks were as follows:


##Project Task


Create one R script called run_analysis.R that does the following:
1. Merges the training and test sets to create one data set
2. Extracts only measurements on the mean and standard deviation
3. Uses descriptive activity names to name the activities in the dataset
4. Appropriately labels the data set with descriptive variable names
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

My approach to the project and a step by step orientation to the code I have written is below.


##Explanation of R-script


###PART ONE: PREP


I used R studio for this Assignment. First I set the working directory and then I downloaded the file from the link provided in the Assignment and loaded it into R.


####Download file from source and load into R


I used the fileUrl set of steps to download the files. The file was a zip file containing several other files within. To unzip the file, I used the unzip function.


####Unzip file


I then used the list.files function to view all the files in the unzipped folder. The unzipped file contained a folder called "UCI HAR Dataset", which in turn contained other folders and files. Since there were nested folders, I used the "recursive = T" command to view the contents of the nested folders.


####View all files in the unzipped folder and use recursive = T to view the nested folders


####Examine files


I then scanned each file to examine what type of data was contained and to get familiar with the components of each dataset. I observed there were two folders, "test" and "train", each holding four files ("X", "y", "subject", and "Inertial Signals"). In addition to the "test" and "train" folders, there were several text files in the UCI HAR Dataset containing labels for the various datasets and columns, and a READMe.txt file orienting me to the datasets. 

Since the project was asking us to extract only measurements related to the mean and std variables, I ignored the Inertial Signals files. Also our Course CTA advised the same.Of the remaining 3 files, my scan of the contents showed that "y" is the Activity (there are 6 activities), "X" is the measurement, and the third dataset is the subject (there are 30 subjects).


####Read each dataset 


I applied the read.table function to read each dataset individually. I applied the command "header = F"" because in examining the txt files, I noticed they didn't have headers. You will notice that I used the "head" function after each line of code to check and see the outcome. I also ran my code line by line to see the result from each line. 

i. Read ("y") datasets
ii. Read subject datasets
iii. Read ("X") datasets

In reading the datasets, I made the following observations:
a) The "y" and "subject" datasets in "test"" each had 2947 rows and 1 column
b) The "y" and "subject" datasets in "train" each had 7352 rows and 1 column
c) The "X" dataset in "test" had 2947 rows and 561 columns, while the same dataset in "train" had 7352 rows and 561 columns


###PART TWO: MERGE


My next step was to merge the six datasets into one. I did this in several steps. 


####Step 1 - Combine test and train databasets using rbind - since we are binding rows. Again I used the "head" function to review the outcome for each data frame. 


First I combined each pair of datasets. This left me with three datasets instead of six. They were "y", "subject", and "X". Each dataset had 10299 rows. The "y" and "subject" datasets both had only one column, while the "X" dataset had 561 columns. 


####Step 2: Merge Activity and Subject into one data frame using cbind since we are binding columns


Since the "y" and "subject" datasets had the same number of rows and columns, my next step was to simply combine those two datasets into one dataset. I used the cbind function since I was combined them into two columns. 


####Step 3: Name the columns of this data frame and view it to confirm


Up to this point, the columns did not have headings. So my next step was the name the columns using colNames. 


####Step 4: Name the 561 columns of the "Measure" dataset using the features.txt file


Next, I needed to name the 561 columns in the combined "X" dataset. The source files had a "features.txt" file which contained the names for each of the 561 columns. I loaded the feature names into a table using the read.table function. The result was a two-column table with the column names in the second column. I then assigned the names in the second column to my combined "X" dataset. 


####Step 5: Pick out only the columns that have the keyword "mean" or "std" using the grepl function


Since the project did not require using all 561 columns, I needed to next subset the "X" dataset to extract only the columns that measured the "mean", and standard deviation ("std"). By google searching, I found the "grepl" function on stackoverflow, and used this function to extract only columns that had either "mean" or "std" mentioned in the headers. I did this in two parts, first subsetting only columns with "mean", and then subsetting columns with "std". Then I combined the two to get one dataset of measurements on "mean" and "std". I initially got a dataset with 10299 rows and 79 columns. 


####Step 6: Eliminate columns with "meanfreq"


Using the "names" function, I viewed the headings of the 79 columns and noticed that it included measurements of "meanfreq". I manually counted the column number where "meanfreq" appeared, and used the subset function again to remove the columns pertaining to "meanfreq". This left me with a dataset "X" that had 10299 rows and now, only 66 columns. 


####Step 7: Merge the Activity and Subject dataset with the "X" dataset using cbind to arrive at one dataset


After getting a clean "X" dataset, which I termed "Measure" in my R-script, I combined this dataset to my previously combined "Activity+Subject" dataset. This left me with a single dataset with all the data I needed for my next steps. 


###PART THREE: Assign descriptive activity names to the Activities 1-6


My next task as per the project was to assign descriptive activity names. Since the source file had a txt file with the descriptive activity names, I did the following:

First, I extracted the activity names from the txt file into a table using the read.table function. Then, I checked the column type using the str function. My Activity column was a set of Integers. I then used the "factor" function to factorize the values in the Activity column. Within my "factorize" function, I also assigned the factorized values to the descriptive activity names I had loaded in from the txt file before. 


###PART FOUR: Label the dataset with descriptive variable names


Next, I had to label the measurement columns with descriptive variable names. No txt file was provided so I simply looked at the names where abbreviations were used, and I substituted these for their full names. Using the original README file, I identified the full names of the abbreviated terms. I used "Accelerator"" for Acc, "Gyroscope"" for Gyro, "Magnitude"" for Mag, "time"" for t, and "freq"" for f. I also replaced "mean" with "MEAN", and "std" with "STD" so that they would jump out clearly in the tidy data set. Since "t" and "f" were letters that also were presented in other parts of column headers, I inserted the... 

I used the gsub function which is used to replace a text within a string. I tried to create just one line of code combining all my replacement requirements, but for some reason it would not work, so I had to list them out individually. 


###PART FIVE: Create tidy dataset


With everything else done, now I was ready to create my tidy dataset.  The project required that we create an independent tidy dataset that contained the average of each variable for each activity and subject. 

I used the reshape2 package as per the video lecture notes and used the melt and dcast functions to create my tidy dataset. 

First I had to install the reshape2 package and run it in R studio. I then melted the dataset and dcast it just for the mean. Since there were 6 activities and 30 subjects, the resulting dataset has to show the average (mean) for each subject against each of the six activities. It is the intersection point of activity, subject, and measurement as per the Course CTA's venn diagram depiction in the discussion forum. Using simple math, I calculated that there should be 180 rows in the resulting dataset (6 activities multiplied by 30 subjects). This is how I verified that the dimensions of my resulting dataset were correct.  


###PART SIX: Create txt file 


Finally, I used the write.table function to create a txt file and loaded it into my working directory. I used the sep = "\t" to separate the columns.


##Acknowledgements


For this Assignment, I referred extensively to the video lectures, the discussion forum started by CTA David Hood (which was extremely helpful). I also used stackoverflow extensively to learn about functions such as gsub and grepl. 

I also noted in the original README file, that use of this dataset must be acknowledged by referencing the following publication [1]. Since we are loading this up onto Github, I am acknowledging the publication [1] below.  

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.


##Note

This submission is for the sole purpose of completing my Assignment for the Coursera program: Getting and Cleaning Data.