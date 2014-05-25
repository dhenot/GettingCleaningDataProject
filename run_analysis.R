downloadRawDataFile <- function() {
    ## This function downloads the zip file containing the raw data set
    
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI HAR Dataset.zip")
}

generateTidyDataFile <- function(zipfile="UCI HAR Dataset.zip") {
    ## This function processes the raw data set from the zip file "zipfile"
    ## into a clean and synthetic data table and writes it into a text file
    
    # Read a vector of all feature names
    features <- read.table(unz(zipfile, "UCI HAR Dataset/features.txt"),
                           stringsAsFactors=FALSE)[[2]]
    
    # Build an index vector to select only the mean ("*-mean()*") and
    # standard deviation ("*-std()*") of the features
    selectedFeatures <- grep("-(mean|std)\\(", features)
    
    # Reduce the vector of feature names to those selected and tidy them
    features <- features[selectedFeatures]
    features <- sub("\\(\\)", "", features)
    features <- gsub("-", "\\.", features)
    
    # Read the test and train data and extract the columns for the selected features
    x.test <- read.table(unz(zipfile, "UCI HAR Dataset/test/X_test.txt"))[selectedFeatures]
    x.train <- read.table(unz(zipfile, "UCI HAR Dataset/train/X_train.txt"))[selectedFeatures]
    
    # Combine train and test rows into a single table and assign column names
    data <- rbind(x.train, x.test)
    names(data) <- features
    
    # Read the activity names and clean up
    activitynames <- tolower(read.table(unz(zipfile, "UCI HAR Dataset/activity_labels.txt"),
                                        stringsAsFactors=FALSE)[[2]])
    activitynames <- sub("_", "\\.", tolower(activitynames))
    
    # Read the activity vectors for train and test data
    y.test <- read.table(unz(zipfile, "UCI HAR Dataset/test/y_test.txt"))[[1]]
    y.train <- read.table(unz(zipfile, "UCI HAR Dataset/train/y_train.txt"))[[1]]
    
    # Combine train and test activity vectors and use descriptive activity names
    # (Note we combine in the same order as data tables above so row indexes are
    # compatible)
    activity <- factor(c(y.train, y.test), labels=activitynames)
    
    # Read subject vectors for train and test data
    subject.test <- read.table(unz(zipfile, "UCI HAR Dataset/test/subject_test.txt"))[[1]]
    subject.train <- read.table(unz(zipfile, "UCI HAR Dataset/train/subject_train.txt"))[[1]]
    
    # Combine train and test subject vectors
    # (Note we combine in the same order as data tables above so row indexes are
    # compatible)
    subject <- c(subject.train, subject.test)
    
    # Append subject and activity columns into the data table
    fulldata <- cbind(subject, activity, data)
    
    # Reduce the data to the means of the variables for every (subject, activity) pair
    meandata <- fulldata
    meandata$activity <- as.numeric(meandata$activity) # Drop the factor labels to enable colMeans on the column
    
    # Aggregate the data, grouping by subject and activity, taking the average of each group
    # (we exclude the subject and activity columns as they are recreated by aggregate as
    # grouping columns that we can rename afterwards)
    meandata <- aggregate(fulldata[, -1:-2], by=list(fulldata$subject, fulldata$activity), mean)
    colnames(meandata)[1:2] <- c("subject", "activity")
    
    # Output the clean data set to file
    write.table(meandata, "AveragesBySubjectActivity.txt", row.names=FALSE)
}