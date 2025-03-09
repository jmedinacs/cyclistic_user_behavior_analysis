# 06_cleaning_ride_duration_column
# This script will compute the ride duration based on started_at and 
# ended_at POSIXct values and add a column. 

# Load configuration settings and variables
source("config.R")

# Load the most current version of the cleaned_data_rds to ensure accuracy
cleaned_data <- readRDS(cleaned_data_rds)

# Function that calculates the ride duration in terms of minutes
calculate_ride_duration <- function(df){
  df$ride_duration <- as.numeric(difftime(df$ended_at, df$started_at,
                                          units="mins"))
  
  # Flag invalid duration of negative or zero minutes
  df$invalid_duration <- df$ride_duration <= 0
  
  # Count the number of flagged rows
  num_invalid <- sum(df$invalid_duration)
  
  cat("Found", num_invalid, "rides with invalid durations(<=0 minutes.\n")
  cat("invalid rides flagged but not removed. \n")
  
  return(df)
}

# Use the function
cleaned_dataset <- calculate_ride_duration(cleaned_data)

# Verify that ride_duration and invalid_duration values are correct
head(cleaned_dataset)

# Verify ride_duration and invalid_duration data type.
str(cleaned_dataset)

# Save an RDS version using config.R variable
saveRDS(cleaned_dataset, file = cleaned_data_rds)

message("Updated cleaned_data RDS has been saved.")


