# CLEANING_convert_character_dates_to_posixct
# THis script will convert the started_at and ended_at columns from character 
# to POSIXct to facilitate computation. 

source("config.R")

# Load the raw data
raw_combined_data <- readRDS(combined_raw_data_file)

convert_dates <- function(df){
  df$started_at <- ymd_hms(df$started_at, tz = timezone)
  df$ended_at <- ymd_hms(df$ended_at, tz = timezone)
  return(df)
}

# Apply the function
processed_data <- convert_dates(raw_combined_data)

# Check if conversion was successful
str(processed_data$started_at)
str(processed_data$ended_at)

# Save an RDS version using config.R variable
saveRDS(processed_data, file = cleaned_data_rds)

# Save a CSV version dynamically
write.csv(processed_data, 
          file = cleaned_data_csv, 
          row.names = FALSE)

temp = readRDS(cleaned_data_rds)
head(temp)
tail(temp)
