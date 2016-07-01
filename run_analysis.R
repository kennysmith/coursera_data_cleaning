merge_data <- function(data_dir='UCI HAR Dataset') {
    ######
    #  1. EXTRACT MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
    ######
    # data_dir: Path to the unzipped data
    library(data.table)
    library(stringr)
    
    # Load data
    xtest <- fread(paste0(data_dir, '/test/X_test.txt'))
    ytest <- fread(paste0(data_dir, '/test/y_test.txt'))
    subjectstest <- fread(paste0(data_dir, '/test/subject_test.txt'))
    xtrain <- fread(paste0(data_dir, '/train/X_train.txt'))
    ytrain <- fread(paste0(data_dir, '/train/y_train.txt'))
    subjectstrain <- fread(paste0(data_dir, '/train/subject_train.txt'))
    
    xtest$y <- ytest$V1
    xtest$subject <- subjectstest$V1
    xtrain$y <- ytrain$V1
    xtrain$subject <- subjectstrain$V1
    
    ######
    #  1. MERGE DATA INTO ONE DATASET
    ######
    full_data <- rbind(xtest, xtrain)
    return(full_data)
}
mean_st_dev <- function(full_data) {
    ######
    #  2. EXTRACT MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
    ######
    col_means <- sapply(full_data, mean)
    col_std_devs <- sapply(full_data, sd)
    
    return(data.table(
        "variable" = names(full_data),
        "col_means" = col_means, 
        "col_std_devs" = col_std_devs
        )
        
        )
}

add_activity_labels <- function(full_data, data_dir='UCI HAR Dataset') {
    ######
    #  3. USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATASET
    ######
    library(plyr)
    activities <- data.table(
        read.csv(
            paste0(data_dir, '/activity_labels.txt'), 
            header = FALSE
            )
        )
    activities[, c('ID', 'NAME') := tstrsplit(V1, " ", fixed=TRUE)]
    # Add activity names to ytest
    aname <- activities$NAME
    aid <- activities$ID
    yfactor <- full_data$y
    full_data$activity_name <- mapvalues(yfactor, aid, aname)
    return(full_data)
}

add_variable_labels <- function(full_data, data_dir='UCI HAR Dataset') {
    ######
    #  4. APPROPRIATELY LABELS THE DATASET WITH DESCRIPTIVE VARIABLES
    ######
    feats <- data.table(
        read.csv(
            paste0(data_dir, '/features.txt'),
            header = FALSE,
            sep = " ",
            stringsAsFactors=FALSE
        )
    )
    feat.names <- feats$V2
    feat.names <- c(feat.names, 'y', 'subject', 'activity_name')
    names(full_data) <- feat.names
    return(full_data)
}

labeled_data <- function(data_dir='UCI HAR Dataset') {
    ######
    # Combines the previous 3 data cleaning functions into one function.
    ######
    full_data = merge_data(data_dir)
    full_data = add_activity_labels(full_data, data_dir)
    full_data = add_variable_labels(full_data, data_dir)
    return(full_data)
}

tidy_data <- function(full_data=NULL, data_dir='UCI HAR Dataset') {
    ######
    # 5. CREATE TIDY DATASET WITH AVG OF EACH VAR FOR EACH SUBJECT AND ACTIVITY
    ######
    if(missing(full_data)) {
        full_data = labeled_data()
    }
    subj_act_means =
        full_data %>%
        group_by(subject, activity_name) %>%
        summarise_each(funs(mean))
    return(subj_act_means)
}