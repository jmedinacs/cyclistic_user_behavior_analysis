# 02_cleaning_merge_dataset_and_convert_missing_values_to_NA
# This script will merge the multiple datasets into one dataset while
# converting missing values into NA for easier identification and error
# handling for computations later on.

# Load all configurations and variables
source("config.R")

# List all csv files from raw_data_dir
raw_files <- list.files(path = raw_data_dir, pattern = "*.csv", 
                        full.names = TRUE)


# Read all CSV files, replace empty/missing data with NA, and combine into one dataset
combined_dataset <- bind_rows(lapply(raw_files, function(file) {
  read.csv(file, na.strings = c("", "NA"))  # Convert "" and "NA" to NA
}))

# Save an RDS version using config.R variable
saveRDS(combined_dataset, file = combined_raw_data_file)

# Save a CSV version dynamically
write.csv(combined_dataset, 
          file = sub(".rds", ".csv", combined_raw_data_file), 
          row.names = FALSE)

