
==================================================================
STUDY

Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

==================================================================

DATA PROCESSING OF TIDY DATA FILES PROVIDED

The raw data from the UCI HAR Dataset is processed as follows:

	1.  Raw test datasets are read into data tables in R
	2.  Variables for y_test, subject_test and activity_labels are named
	3.  Activity labels are joined to y_test on the key "id"
	4.  Primary key, obs, is appended to x_test, y_test and subject_test tables as the row number 
	5.  X_test, y_test, and subject_test are joined on the key "obs" to create test_ds. Data source variable is added to allow an audit trail.
	6.  Test_ds is stored in the working directory
	7.  Steps 1 - 6 are repeated for the raw training datasets. The resultant dataset is train_ds
	8.  Test_ds and train_ds are appended together to create har_ds
	9.  Tidy variable names are created for har_ds
   10.  Har_ds variables are subsetted to the variables obs, activity, subject, datasource, and those with the mean and standard deviation 
        statistics to create harstatistics_ds
   11.  Harstatistics_ds is stored in the working directory
   12.  The harstatistics_ds is summarized by activity and subject by taking the mean of each active variable. The means by activity and subject 
        are meagered together to create the final output file harMeans_ds.
   13.  HarMeans_ds is stored in the working directory.

After execution the harstatistics_ds and harMeans_ds datasets will be resident in your R session. The scripts will also produce comma-delimited text files
in the working directory for your use. These are: test_ds.csv, train_ds,csv, har_ds,csv, harstatistics_ds.csv, harMeans_ds.csv. 
   
==================================================================

==================================================================
REPLICATING THE DATA PROCESSING

This processing can be replicated by exewcuting the two provided R scripts (InvokingLibraries.R and run_analysis.R) in your environment. The execution steps are:

	1.  Fork the repo and copy it to a directory on your machine
	2.  Open R studio
	3.  Use setwd() to point R to your working directory containing the provided files. This is where the output files will be written.
	4.  Open the script InvokeLibraries.R using either the SOURCE function or copy it into your session. Execute InvokeLibraries.R
	5.  Open the script run_analysis.R using either the SOURCE function or copy it into your session. Execute run_analysis.R

==================================================================

==================================================================
MATERIALS PROVIDED IN THE REPO

	1.  Raw datasets downloaded from UCI HAR website 
	2.  README.md (this file) - copntains instructions and explanations of experiment
	3.  Codebooks for tidy datasets. These are provided in EXCEL and tab-delinmited text formats (markdown files)  
	

==================================================================
ORIGINAL STUDY DESIGN AND DATA COLLECTION METHODILOGY

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its 
embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments 
have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was 
selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 
sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a 
Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a 
filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency 
domain. See 'features_info.txt' for more details. 

For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


==================================================================

RAW DATA PROVIDED

The dataset includes the following files:
- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row 
   shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 


Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly 
Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial 
use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
