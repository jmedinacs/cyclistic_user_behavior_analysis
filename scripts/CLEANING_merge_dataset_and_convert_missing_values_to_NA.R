# CLEANING_merge_dataset_and_convert_missing_values_to_NA
# This script will merge the multiple datasets into one dataset while
# converting missing values into NA for easier identification and error
# handling for computations later on.

# Load all configurations and variables
source("config.R")

# List all csv files from raw_data_dir
raw_files <- list.files(path = raw_data_dir, pattern = "*.csv", 
                        full.names = TRUE)

# Read all the files and replace empty data into NA
cyclistic_combined_raw <- lapply(raw_files, function(file){
  df <- read.csv(file, na.strings = c("", "NA"))  # Convert "" and "NA" to NA
  return(df)
})

# Combine all datasets into one dataset
combined_dataset <- bind_rows(cyclistic_combined_raw)

# Save an RDS version using config.R variable
saveRDS(combined_dataset, file = combined_raw_data_file)

# Save a CSV version dynamically
write.csv(combined_dataset, 
          file = sub(".rds", ".csv", combined_raw_data_file), 
          row.names = FALSE)

