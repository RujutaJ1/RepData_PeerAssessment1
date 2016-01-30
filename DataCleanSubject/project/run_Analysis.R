## Step 1 : First Download the Data, and Unzip it. 
#first download the data-  its a heavy download, 
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
getwd()
setwd("F:/Rujuta/Coursera/DataCleanSubject")
download.file(fileurl, destfile="./Data.zip")
unzip("./Data.zip")

## Step 2 
#  In this step we read the relevant files. X_train is the main data. Subject_trainData is the subjectID
# features are the names of the features and activity is the name of the activity for which data was collected. 
# So we read the data, give the names of the features as column names

setwd("./UCI HAR Dataset")
list.files()
features <- read.table("./features.txt")
setwd("./train")
X_traindata <- read.table("./X_train.txt")
XTrainDataSet <- data.table(X_traindata)
y_traindata <- read.table("./y_train.txt")
YTrainData <- data.table(y_traindata)
subject_traindata <- read.table("./subject_train.txt")
SubjectTrainData <- data.table(subject_traindata)
FeatureData <- data.table(features)
names <- as.character(features$V2)
setnames(TrainData, colnames(TrainData), names)

## Step 3
#merge subjectID and Activity name with the test data.
dim(YTrainData)
setnames(YTrainData, "Activity")
dim(SubjectTrainData)
setnames(SubjectTrainData, "SubjectID")
TrainData1 <- cbind(SubjectTrainData,YTrainData, TrainData)
dim(TrainData1)

## Step 4 
## Do the same activity with test data. 

setwd("./test")
list.files()
X_testdata <- read.table("./X_test.txt")
dim(X_testdata)
TestData <- data.table(X_testdata)
setnames(TestData, colnames(TestData), names)
y_testdata <- read.table("./y_test.txt")
YTestData <- data.table(y_testdata)
dim(YTestData)
setnames(YTestData, "Activity")
SUbjectTestData <- fread("./subject_test.txt")
dim(SUbjectTestData)
setnames(SUbjectTestData, "SubjectID")
TestData1 <- cbind(SUbjectTestData,YTestData,TestData)
dim(TestData1)

## Step5 
## combine Test and Train Data. 

MainData <- rbind(TestData1, TrainData1)
dim(MainData)
# So this is the final Data. 

#dim(MainDataTogether)
Step6
#select only the mean and std variables from the data. 

MainDataslice1 <- select(MainData, contains("mean"))
MainDataslice2 <- select(MainData, contains("std"))
MainDataSlice3 <- select(MainData, SubjectID,Activity)
MainDataTogether <- cbind(MainDataSlice3, MainDataslice1, MainDataslice2)

# now to give the activity Lables
ActivityLabels <- c("WALKING","WALKING_UPSTAIRS","WALKING DOWNSTAIRS","SITTING","STANDING","LAYING")
MainDataTogether$Activity <- ordered( MainDataTogether$Activity,levels=c(1,2,3,4,5,6),labels=ActivityLabels)


# Preparing the tidy data set
dim(MainDataTogether)
p <- MainDataTogether[,lapply(.SD, mean), by=SubjectID]
dim(p)
q <- MainDataTogether[, lapply(.SD, mean), by=Activity]
AverageBySubject <- select(p, -Activity)
AverageByActivity <- select(q, -SubjectID)
View(AverageBySubject)
View(AverageByActivity)
write.table(AverageByActivity, file="./DataCleanProjectSubmission_Rujuta.txt", append=FALSE, row.names=FALSE)
write.table(AverageBySubject, file="./DataCleanProjectSubmission_Rujuta.txt", append=TRUE, row.names=FALSE)
# so this is the file that gets uploaded on the github.


