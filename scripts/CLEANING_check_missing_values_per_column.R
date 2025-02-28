# CLEANING_check_missing_values_per_column
# This script functions as a way to explore the data by tracking which 
# columns have missing data. 

# Load configuration settings and variables
source("config.R")

# Load the most current version of the cleaned_data_rds to ensure accuracy
df <- readRDS(cleaned_data_rds)

# Function that counts the missing values per column
missing_values_summary <- function(df) {
  missing_counts <- sapply(df, function(x) sum(is.na(x)))
  
  # Convert it to a data frame for better readability
  missing_summary <- data.frame(Column = names(missing_counts),
                                Missing_Count = missing_counts)
  
  # Sort by highest missing values first
  missing_summary <- missing_summary[order(-missing_summary$Missing_Count),]
  
  return(missing_summary)
}

missing_summary <- missing_values_summary(df)

print(missing_summary)
