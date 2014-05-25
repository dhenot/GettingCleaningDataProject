GettingCleaningDataProject
==========================

Project assignment for the Getting and Cleaning Data course.

This file explains how to use the `run_analysis.R` script to extract a simplified
and cleaner data table out of the _Human Activity Recognition Using Smartphones_
data set described at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Loading the script

You should place the `run_analysis.R` in the folder you will use for the analysis
and set this folder as the current folder of the R session by using the
`setwd(dir)` function, then load the script with the `source` function :

```
source("run_analysis.R")
```

This will define two new functions :

* `downloadRawDataFile()`
* `generateTidyDataFile()`

## Downloading the raw data set

There are two options to retrieve the raw data set :

* You can run :

```
downloadRawDataFile()
```

to automaticaly download the zip file from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
into a _UCI HAR Dataset.zip_ file in the current folder, or

* download the zip file yourself and put it in the current folder.

## Generating the tidy data set

When you have the zip file of the raw data set in the current folder you can
generate the tidy data set by running the `generateTidyDataFile()` function.

If the raw data set was downloaded with the `downloadRawDataFile()` function then
no parameter is needed :

```
generateTidyDataFile()
```

On the other hand if you downloaded manualy the zip file you need to pass its
name to the function, for example :

```
generateTidyDataFile("rawdata.zip")
```

The output table is written in the `AveragesBySubjectActivity.txt` file which
can be easily reloaded in R with :

```
data <- read.table("AveragesBySubjectActivity.txt", header=TRUE)
```

## Composition of the generated data set

For more information on the output data set and its variables,
see the `CodeBook.md` file.
