# 03_cleaning_convert_character_dates_to_posixct
# This script will convert the started_at and ended_at columns from character 
# to POSIXct to facilitate computation. 

# Load libraries and variables
source("config.R")

# Load the raw data
raw_combined_data <- readRDS(combined_raw_data_file)

# Function to convert the character dates intom POSIXct
convert_dates <- function(df){
  df$started_at <- ymd_hms(df$started_at, tz = timezone)
  df$ended_at <- ymd_hms(df$ended_at, tz = timezone)
  return(df)
}

# Apply the function
processed_data <- convert_dates(raw_combined_data)

# Check if conversion was successful
message("Conversion successful.")
print("started_at column preview")
str(processed_data$started_at)
print("ended_at column preview")
str(processed_data$ended_at)

# Save an RDS version using config.R variable
saveRDS(processed_data, file = cleaned_data_rds)

# Confirmation message
message("RDS file saved successfully!")

# CSV not saved at this time. Final version will be saved as CSV at project's end
