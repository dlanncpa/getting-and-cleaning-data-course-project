# getting-and-cleaning-data-course-project
Getting and cleaning data course project. The R script, run_analysis.R, performs the following:
1.  Downloads the data set if it does not already exist in the working directory
2.  Reads the test, training, and subject data sets
3.  Combines the test and training data sets and provides the variables with meaningful names
4.  Creates a combined data set keeping only the mean and standard deviation observations
5.  Assigns activity descriptions to the activity IDs
6.  Assigns descriptive names to the variables
7.  Creates an independent data set comprised of the mean of each variable for each activity and subject
8.  Writes the tidy data set to "tidyData.txt"
