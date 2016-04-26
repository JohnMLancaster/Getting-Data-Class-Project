########################################################################################
#####                                                                              #####
#####  Create tidy merged dataset from UCI HAR Test & Train Datasets               #####
#####                                                                              #####
#####  Author:  John Lancaster                                                     #####
#####  Date:    24 April 2016                                                      #####
#####  Purpose: attach observation number, subjuct identifier & activity           #####
#####           file. Attach names to datasets using NAMES() function.             #####
########################################################################################
  
#load useful packages - submit stops after library statements so comment them out
#library(dplyr)
#library(plyr)
#library(tools)


## load the activity label and test datasets 
activitylabels <- read.table("./activity_labels.txt")
x_test <- read.table("./test/x_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

## rename column of activitylabels, y_test, and subject_test vectors
names(activitylabels) <- c("id", "activity")
names(y_test) <- "id"
names(subject_test) <- "subject"

## add observation id as row number to x_test, y_test and subject_test
x_test <- mutate(x_test, obs = row(x_test)[,2], datasource = "TEST")
y_test <- mutate(y_test, obs = row(y_test))
subject_test <- mutate(subject_test, obs = row(subject_test))

## merge activiey labels onto y_test
y_test = merge(y_test, activitylabels)
y_test <- select(y_test, obs:activity)
#head(y_test)

## get vector of variable names from provided features.txt 
features <- read.table("./features.txt")
tempnames <- c("obs", tolower(features[,2]), "datasource", "activity", "subject")

## merge x_test, y_test and subject_test into test observations table then store
test_ds <- merge(x_test, y_test)
test_ds <- merge(test_ds, subject_test)
#head(test_ds)
write.csv(test_ds, "./test_ds.csv")
rm(x_test, y_test, subject_test)
ls()

########################################################################################
## repeat for training dataset
## load the activity label and test datasets 
x_train <- read.table("./train/x_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

## rename column of y_test, subject_test
names(y_train) <- "id"
names(subject_train) <- "subject"

## add observation id as row number to x_test, y_test and subject_test
x_train <- mutate(x_train, obs = row(x_train)[,2], datasource = "TRAIN")
y_train <- mutate(y_train, obs = row(y_train))
subject_train <- mutate(subject_train, obs = row(subject_train))

## merge activiey labels onto y_test
y_train = merge(y_train, activitylabels)
y_train <- select(y_train, obs:activity)
#head(y_train)

## merge x_test, y_test and subject_test into test observations table then store
train_ds <- merge(x_train, y_train)
train_ds <- merge(train_ds, subject_train)
#head(train_ds)
write.csv(train_ds, "./train_ds.csv")
rm(x_train, y_train, subject_train)
ls()

## bind the test and train datasets together and save the resulting har_ds
har_ds = rbind(test_ds, train_ds)
names(har_ds) <- tempnames
#head(har_ds) ; tail (har_ds)
write.csv(har_ds, "./har_ds.csv")
rm(test_ds, train_ds, activitylabels)

## subset har_ds to the id, mean and std variables
har_keep <- grepl("-mean|-std|^obs$|^activity$|^subject$|^datasource$", names(har_ds)) & !grepl("meanfreq|meanFreq", names(har_ds))
harstatistics_ds <- har_ds[,har_keep]


## remove "-" and "()" from variables names
varnames <- gsub("-", "", names(harstatistics_ds))
varnames <- gsub("[()]", "", varnames)
varnames <- gsub("acc", "linearaccel", varnames)
varnames <- gsub("gyro", "angularvelocity", varnames)
varnames <- gsub("mag", "magnitude", varnames)
varnames <- gsub("-x", "x", varnames)
varnames <- gsub("-y", "y", varnames)
varnames <- gsub("-z", "z", varnames)
names(harstatistics_ds) <- varnames

## one last check of hsstatistics_ds
names(harstatistics_ds) ; head(harstatistics_ds) ; tail(harstatistics_ds) 
write.csv(harstatistics_ds, "./harstatistics_ds.csv")
rm(har_ds, har_keep)

## get the mean of all variables by activity
h2 <- group_by(harstatistics_ds, activity)
harMeans_ds <- ddply(h2, 'activity', summarize,tbodylinearaccelmeanx_byactivity = mean(tbodylinearaccelmeanx))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearaccelmeany_byactivity = mean(tbodylinearaccelmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearaccelmeanz_byactivity = mean(tbodylinearaccelmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearaccelstdx_byactivity = mean(tbodylinearaccelstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearaccelstdy_byactivity = mean(tbodylinearaccelstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearaccelstdz_byactivity = mean(tbodylinearaccelstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tgravitylinearaccelmeanx_byactivity = mean(tgravitylinearaccelmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tgravitylinearaccelmeany_byactivity = mean(tgravitylinearaccelmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tgravitylinearaccelmeanz_byactivity = mean(tgravitylinearaccelmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tgravitylinearaccelstdx_byactivity = mean(tgravitylinearaccelstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tgravitylinearaccelstdy_byactivity = mean(tgravitylinearaccelstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tgravitylinearaccelstdz_byactivity = mean(tgravitylinearaccelstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearacceljerkmeanx_byactivity = mean(tbodylinearacceljerkmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearacceljerkmeany_byactivity = mean(tbodylinearacceljerkmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearacceljerkmeanz_byactivity = mean(tbodylinearacceljerkmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearacceljerkstdx_byactivity = mean(tbodylinearacceljerkstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearacceljerkstdy_byactivity = mean(tbodylinearacceljerkstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearacceljerkstdz_byactivity = mean(tbodylinearacceljerkstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocitymeanx_byactivity = mean(tbodyangularvelocitymeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocitymeany_byactivity = mean(tbodyangularvelocitymeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocitymeanz_byactivity = mean(tbodyangularvelocitymeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocitystdx_byactivity = mean(tbodyangularvelocitystdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocitystdy_byactivity = mean(tbodyangularvelocitystdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocitystdz_byactivity = mean(tbodyangularvelocitystdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocityjerkmeanx_byactivity = mean(tbodyangularvelocityjerkmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocityjerkmeany_byactivity = mean(tbodyangularvelocityjerkmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocityjerkmeanz_byactivity = mean(tbodyangularvelocityjerkmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocityjerkstdx_byactivity = mean(tbodyangularvelocityjerkstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocityjerkstdy_byactivity = mean(tbodyangularvelocityjerkstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocityjerkstdz_byactivity = mean(tbodyangularvelocityjerkstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearaccelmagnitudemean_byactivity = mean(tbodylinearaccelmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearaccelmagnitudestd_byactivity = mean(tbodylinearaccelmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tgravitylinearaccelmagnitudemean_byactivity = mean(tgravitylinearaccelmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tgravitylinearaccelmagnitudestd_byactivity = mean(tgravitylinearaccelmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearacceljerkmagnitudemean_byactivity = mean(tbodylinearacceljerkmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodylinearacceljerkmagnitudestd_byactivity = mean(tbodylinearacceljerkmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocitymagnitudemean_byactivity = mean(tbodyangularvelocitymagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocitymagnitudestd_byactivity = mean(tbodyangularvelocitymagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocityjerkmagnitudemean_byactivity = mean(tbodyangularvelocityjerkmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,tbodyangularvelocityjerkmagnitudestd_byactivity = mean(tbodyangularvelocityjerkmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearaccelmeanx_byactivity = mean(fbodylinearaccelmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearaccelmeany_byactivity = mean(fbodylinearaccelmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearaccelmeanz_byactivity = mean(fbodylinearaccelmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearaccelstdx_byactivity = mean(fbodylinearaccelstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearaccelstdy_byactivity = mean(fbodylinearaccelstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearaccelstdz_byactivity = mean(fbodylinearaccelstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearacceljerkmeanx_byactivity = mean(fbodylinearacceljerkmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearacceljerkmeany_byactivity = mean(fbodylinearacceljerkmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearacceljerkmeanz_byactivity = mean(fbodylinearacceljerkmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearacceljerkstdx_byactivity = mean(fbodylinearacceljerkstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearacceljerkstdy_byactivity = mean(fbodylinearacceljerkstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearacceljerkstdz_byactivity = mean(fbodylinearacceljerkstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodyangularvelocitymeanx_byactivity = mean(fbodyangularvelocitymeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodyangularvelocitymeany_byactivity = mean(fbodyangularvelocitymeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodyangularvelocitymeanz_byactivity = mean(fbodyangularvelocitymeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodyangularvelocitystdx_byactivity = mean(fbodyangularvelocitystdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodyangularvelocitystdy_byactivity = mean(fbodyangularvelocitystdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodyangularvelocitystdz_byactivity = mean(fbodyangularvelocitystdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearaccelmagnitudemean_byactivity = mean(fbodylinearaccelmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodylinearaccelmagnitudestd_byactivity = mean(fbodylinearaccelmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodybodylinearacceljerkmagnitudemean_byactivity = mean(fbodybodylinearacceljerkmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodybodylinearacceljerkmagnitudestd_byactivity = mean(fbodybodylinearacceljerkmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodybodyangularvelocitymagnitudemean_byactivity = mean(fbodybodyangularvelocitymagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodybodyangularvelocitymagnitudestd_byactivity = mean(fbodybodyangularvelocitymagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodybodyangularvelocityjerkmagnitudemean_byactivity = mean(fbodybodyangularvelocityjerkmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'activity', summarize,fbodybodyangularvelocityjerkmagnitudestd_byactivity = mean(fbodybodyangularvelocityjerkmagnitudestd)))

## get the mean of all variables by subject
h2 <- group_by(harstatistics_ds, subject)
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearaccelmeanx_bysubject = mean(tbodylinearaccelmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearaccelmeany_bysubject = mean(tbodylinearaccelmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearaccelmeanz_bysubject = mean(tbodylinearaccelmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearaccelstdx_bysubject = mean(tbodylinearaccelstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearaccelstdy_bysubject = mean(tbodylinearaccelstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearaccelstdz_bysubject = mean(tbodylinearaccelstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tgravitylinearaccelmeanx_bysubject = mean(tgravitylinearaccelmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tgravitylinearaccelmeany_bysubject = mean(tgravitylinearaccelmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tgravitylinearaccelmeanz_bysubject = mean(tgravitylinearaccelmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tgravitylinearaccelstdx_bysubject = mean(tgravitylinearaccelstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tgravitylinearaccelstdy_bysubject = mean(tgravitylinearaccelstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tgravitylinearaccelstdz_bysubject = mean(tgravitylinearaccelstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearacceljerkmeanx_bysubject = mean(tbodylinearacceljerkmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearacceljerkmeany_bysubject = mean(tbodylinearacceljerkmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearacceljerkmeanz_bysubject = mean(tbodylinearacceljerkmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearacceljerkstdx_bysubject = mean(tbodylinearacceljerkstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearacceljerkstdy_bysubject = mean(tbodylinearacceljerkstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearacceljerkstdz_bysubject = mean(tbodylinearacceljerkstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocitymeanx_bysubject = mean(tbodyangularvelocitymeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocitymeany_bysubject = mean(tbodyangularvelocitymeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocitymeanz_bysubject = mean(tbodyangularvelocitymeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocitystdx_bysubject = mean(tbodyangularvelocitystdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocitystdy_bysubject = mean(tbodyangularvelocitystdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocitystdz_bysubject = mean(tbodyangularvelocitystdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocityjerkmeanx_bysubject = mean(tbodyangularvelocityjerkmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocityjerkmeany_bysubject = mean(tbodyangularvelocityjerkmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocityjerkmeanz_bysubject = mean(tbodyangularvelocityjerkmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocityjerkstdx_bysubject = mean(tbodyangularvelocityjerkstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocityjerkstdy_bysubject = mean(tbodyangularvelocityjerkstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocityjerkstdz_bysubject = mean(tbodyangularvelocityjerkstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearaccelmagnitudemean_bysubject = mean(tbodylinearaccelmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearaccelmagnitudestd_bysubject = mean(tbodylinearaccelmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tgravitylinearaccelmagnitudemean_bysubject = mean(tgravitylinearaccelmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tgravitylinearaccelmagnitudestd_bysubject = mean(tgravitylinearaccelmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearacceljerkmagnitudemean_bysubject = mean(tbodylinearacceljerkmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodylinearacceljerkmagnitudestd_bysubject = mean(tbodylinearacceljerkmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocitymagnitudemean_bysubject = mean(tbodyangularvelocitymagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocitymagnitudestd_bysubject = mean(tbodyangularvelocitymagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocityjerkmagnitudemean_bysubject = mean(tbodyangularvelocityjerkmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,tbodyangularvelocityjerkmagnitudestd_bysubject = mean(tbodyangularvelocityjerkmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearaccelmeanx_bysubject = mean(fbodylinearaccelmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearaccelmeany_bysubject = mean(fbodylinearaccelmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearaccelmeanz_bysubject = mean(fbodylinearaccelmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearaccelstdx_bysubject = mean(fbodylinearaccelstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearaccelstdy_bysubject = mean(fbodylinearaccelstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearaccelstdz_bysubject = mean(fbodylinearaccelstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearacceljerkmeanx_bysubject = mean(fbodylinearacceljerkmeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearacceljerkmeany_bysubject = mean(fbodylinearacceljerkmeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearacceljerkmeanz_bysubject = mean(fbodylinearacceljerkmeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearacceljerkstdx_bysubject = mean(fbodylinearacceljerkstdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearacceljerkstdy_bysubject = mean(fbodylinearacceljerkstdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearacceljerkstdz_bysubject = mean(fbodylinearacceljerkstdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodyangularvelocitymeanx_bysubject = mean(fbodyangularvelocitymeanx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodyangularvelocitymeany_bysubject = mean(fbodyangularvelocitymeany)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodyangularvelocitymeanz_bysubject = mean(fbodyangularvelocitymeanz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodyangularvelocitystdx_bysubject = mean(fbodyangularvelocitystdx)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodyangularvelocitystdy_bysubject = mean(fbodyangularvelocitystdy)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodyangularvelocitystdz_bysubject = mean(fbodyangularvelocitystdz)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearaccelmagnitudemean_bysubject = mean(fbodylinearaccelmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodylinearaccelmagnitudestd_bysubject = mean(fbodylinearaccelmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodybodylinearacceljerkmagnitudemean_bysubject = mean(fbodybodylinearacceljerkmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodybodylinearacceljerkmagnitudestd_bysubject = mean(fbodybodylinearacceljerkmagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodybodyangularvelocitymagnitudemean_bysubject = mean(fbodybodyangularvelocitymagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodybodyangularvelocitymagnitudestd_bysubject = mean(fbodybodyangularvelocitymagnitudestd)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodybodyangularvelocityjerkmagnitudemean_bysubject = mean(fbodybodyangularvelocityjerkmagnitudemean)))
harMeans_ds <- merge(harMeans_ds, ddply(h2, 'subject', summarize,fbodybodyangularvelocityjerkmagnitudestd_bysubject = mean(fbodybodyangularvelocityjerkmagnitudestd)))

#write hatMeans_ds to work directory and clean up
write.csv(harMeans_ds, "./harMerans_ds.csv")
rm(h2)


