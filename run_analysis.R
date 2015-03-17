setwd("D:/Users/Ian/SkyDrive/Documents/Studying/Coursera/Getting and Cleaning Data")

#   The purpose of this script is to
#   Step 1: Merge the two data sets
#   Step 2: Assign "friendly names to each column derived from the "activity labels" file
#   Step 3: Generate the mean and SD of each measurement 
############################################

#step 0: set assign variables
fpHeaders<- "features.txt"
fpTest<-"X_test.txt"
fpTrain<-"X_train.txt"
fpActivity<-"activity_labels.txt"
fpTestSubjects<-"subject_test.txt"
fpTestLabels<-"y_test.txt"

fpTrainSubjects<-"D:/Users/Ian/SkyDrive/Documents/Studying/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt"
fpTrainLabels<-"D:/Users/Ian/SkyDrive/Documents/Studying/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt"

#Step 1
#Load the column headings
dsHaeding <- read.delim(fpHeaders,header = FALSE)

vecHeading<- as.vector(dsHaeding[[1]],mode='character')

#this vector is the fixed width of every column
wd<-rep(16, 561)

#Colclass was not needed
vecColcLass <- c(rep("numeric",561))

#Read the main 2 file
dtTest <- read.fwf(fpTest,widths = wd, header = FALSE,col.names = vecHeading )
dsTrain<- read.fwf(fpTrain,widths = wd, header = FALSE,col.names = vecHeading )

#Now get the activities
dsActivity<-read.delim(fpActivity,header = FALSE, sep = " ", col.names = c("ActivityID", "ActivityName"))

#Load the test subjects and activities
dsTestSubjects<-read.table(fpTestSubjects, header = FALSE, col.names = c("Subject"))
dsTestLabel<-read.table(fpTestLabels, header = FALSE, col.names = c("ActivityID"))

#Repeat for train
dsTrainSubjects<-read.table(fpTrainSubjects, header = FALSE, col.names = c("Subject"))
dsTrainLabel<-read.table(fpTrainLabels, header = FALSE, col.names = c("ActivityID"))


#LINK ACTIVITY NAME
dsTestWithActivity<-merge(dsTestLabel, dsActivity,by="ActivityID")
dsTrainWithActivity<-merge(dsTrainLabel, dsActivity,by="ActivityID")

#LINK SUBJECTS TO RAW DATA
dsTestwithSubject<- cbind(dtTest,dsTestSubjects,dsTestWithActivity)
dsTrainwithSubject<- cbind(dsTrain,dsTrainSubjects,dsTrainWithActivity)


#Create a single data frame of both sources
dsMerge<-rbind(dsTestwithSubject,dsTrainwithSubject)

#For the column heading find only the columns with mean & std

vecmean<- grep("mean()",vecHeading)
vecstd<- grep("std()",vecHeading)
vecFilter<- c(vecmean,vecstd,562,564)


#Now filter the main dataset on only the columns required
dsFilteredMerge <- dsMerge[vecFilter]

summary(dsFilteredMerge) #To Test

#Heavy lifting done, last step is the average per group
dsOutput<-aggregate(dsFilteredMerge[, 1:79], list(dsFilteredMerge$Subject,dsFilteredMerge$ActivityName ), mean)

write.table(dsOutput, file = "output.txt",row.names = F)

