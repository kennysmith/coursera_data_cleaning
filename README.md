## READ ME

run_analysis.R requires that you download the UCI HAR Dataset:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.  

Many of these functions require a parameter called `data_dir`, which you should set to point to the location of your local UCI HAR Dataset.  Functions that require `full_data` need as an input the result from the `merge_data` function.

### GETTING TIDY DATA
To get tidy data from this script, simply run `tidy_data()`.

### LIST OF FUNCTIONS
`merge_data(data_dir)`: Returns a data.table object with the x, y and subject data for the train and test datasets in the UCI HAR Dataset.

`mean_st_dev(full_data)`: Returns a data.table object with the mean and standard deviation for each column in the merged data.  

`add_activity_labels(full_data, data_dir)`: Returns full dataset with labels for the activity being performed, according to the named activities given in UCI HAR Dataset/activity_labels.txt.

`add_variable_labels(full_data, data_dir)`: Returns the full dataset but instead of generically labeled `V1`, `V2`, `VX` columns, the columns are labeled according to the names given in UCI HAR Dataset/features.txt.

`labeled_data(data_dir)`: Convenience function, not part of our assignment, that combines combines `merge_data`, `add_activity_labels` and `add_variable_lables` and returns the result.

`tidy_data(labeled_data)`: Needs the output of the `labeled_data` function as an input. Returns a data.table of the original data means, grouped by subject and by activity.

