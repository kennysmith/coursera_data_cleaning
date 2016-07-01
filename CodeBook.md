## Codebook for run_analysis.R

run_analysis.R requires that you download the UCI HAR Dataset:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.  

For a full description of this data, please see here:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Many of these functions require a parameter called `data_dir`, which you should set to point to the location of your local UCI HAR Dataset.  Functions that require `full_data` need as an input the result from the `merge_data` function.



