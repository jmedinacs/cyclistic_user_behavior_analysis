# 01_cleaning_initial_dataset_exploration
# This script is written as introductory exploration of datasets for familiarity 
# and understanding.
# After initial exploration, the script checks if every column in every dataset 
# contains the same column name. 
# Finally, the script checks if all of the corresponding columns of every
# dataset is of the same data type.

# Load libraries and variables. 
source("config.R")

# Load the first dataset
jan_2024 <- read.csv(file.path(raw_data_dir,"202401-divvy-tripdata.csv"))

#Display the column names and their respective data types.
str(jan_2024)



# Function that checks if all the column names are exactly the same
check_column_names <- function(directory){
  # Compile all the raw dataset into a list
  raw_files <- list.files(path = raw_data_dir, pattern = "*.csv",
                          full.names = TRUE)
  # Read the column names for each file
  column_names_list <- lapply(raw_files, 
                              function(file) colnames(read.csv(file, nrows=1)))
  
  # Check if all datasets have the same column names
  # unique function removes all duplicates except for the first one.
  unique_columns <- unique(column_names_list)
  
  if(length(unique_columns) == 1){ # If all are matching, only 1 left in the list
    print(" All datasets have consistent column names.")
  }else{
    print("Column name mismatch found!")
    # Print each unique column set separately for clarity
    for (i in seq_along(unique_columns)) {
      cat("\nUnique Column Set", i, ":\n")
      print(unique_columns[[i]])
    }
  }
}
# Call the function
check_column_names(raw_data_dir)



# This function checks if all the data types in each column of every dataset
# is the same type. This will print the mismatched data types if found. 
check_data_types <- function(directory) {
  # List all CSV files
  files <- list.files(path = directory, pattern = "*.csv", full.names = TRUE)
  
  # Read and check column data types for each file
  data_types_list <- lapply(files, function(file) {
    df <- read.csv(file, na.strings = c("", "NA"))  # Treat empty strings as NA
    sapply(df, class)  # Get data types
  })
  
  # Check if all datasets have consistent data types
  unique_data_types <- unique(data_types_list)
  
  if (length(unique_data_types) == 1) {
    print("All datasets have consistent data types.")
  } else {
    print("Data type mismatch detected! Showing unique data types:")
    print(unique_data_types)
  }
}

# Run the function
check_data_types(raw_data_dir)
