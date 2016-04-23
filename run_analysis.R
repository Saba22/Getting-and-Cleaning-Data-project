## read files into data tables
> dataActivityTest <- read.table("Y_test.txt", header = FALSE)
> dataActivityTrain <- read.table("Y_train.txt", header = FALSE)
> dataSubjectTrain <- read.table("subject_train.txt", header = FALSE)
> dataSubjectTest <- read.table("subject_test.txt", header = FALSE)
> dataFeaturesTest <- read.table("X_test.txt", header = FALSE)
> dataFeaturesTrain <- read.table("X_train.txt", header = FALSE)

## merge by row binding Activity and Subject data
> dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
> dataActivity <- rbind(dataActivityTrain, dataActivityTest)
> dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

## rename "subject" and "activity" variables
> names(dataSubject) <- c("subject")
> names(dataActivity) <- c("activity")
> dataFeaturesNames <- read.table("features.txt", header = FALSE)
> names(dataFeatures) <- dataFeaturesNames$V2
> dataCombine <- cbind(dataSubject, dataActivity)
> Data <- cbind(dataFeatures, dataCombine)
> subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
> selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity")
> Data <- subset(Data, select = selectedNames)

> activityLabels <- read.table("activity_labels.txt", header = FALSE)

## factorize activity and subject
> Data$activity <- factor(Data$activity)
> Data$activity <- factor(Data$activity, labels = as.character(activityLabels$V2))

> names(Data) <- gsub("^t", "time", names(Data))
> names(Data) <- gsub("^f", "frequency", names(Data))
> names(Data) <- gsub("Acc", "Accelerometer", names(Data))
> names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
> names(Data) <- gsub("Mag", "Magnitude", names(Data))
> names(Data) <- gsub("BodyBody", "Body", names(Data))

> library(plyr)

> Data2 <- aggregate(. ~subject + activity, Data, mean)
> Data2 <- Data2[order(Data2$subject, Data2$activity),]
> write.table(Data2, file = "tidydata.txt", row.name = FALSE)
