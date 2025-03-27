# 10_eda_day_of_week_column
# This script identifies the day of the week each ride started_at occurs
# and create a column for it. This will be used for analysis that involves
# identifying peak days of the week.

# Load configuration and variables
source("config.R")

# Check if sim_processed_data exists in memory; load from RDS if missing
if (!exists("cleaned_data")) {
  cleaned_data <- readRDS(cleaned_data_rds)
} 


# Trial
sample_date <- as.POSIXct("2024-02-25 14:30:00")
wday(sample_date, label = TRUE, abbr = FALSE)

# Apply the function to the entire dataset
cleaned_data <- cleaned_data %>% 
  mutate(day_of_week = wday(started_at, label = TRUE, abbr = FALSE))

# Verify that the column was added
str(cleaned_data)

# Save the updated dataset
saveRDS(cleaned_data, file = cleaned_data_rds)
write.csv(cleaned_data, file = cleaned_data_csv, row.names = FALSE)
