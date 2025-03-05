# 09_eda_binning_ride_duration
# This script will categorize the ride duration into short (1-7 mins), 
# medium (7-23 mins), and long (>23 mins) to simplify ride duration use in
# some analysis. This will make it less noisy for some comparison and analysis.

# Load configurations and variables
source("config.R")

# Load the most current dataset
cleaned_data <- readRDS(cleaned_data_rds)

# Create a new column for ride duration category
cleaned_data$ride_category <- case_when(
  cleaned_data$ride_duration >= 1 & cleaned_data$ride_duration <7 ~ "short",
  cleaned_data$ride_duration >= 7 & cleaned_data$ride_duration < 23 ~"medium", 
  cleaned_data$ride_duration >=23 ~ "long"
)

# Convert ride_category to a factor for better plotting 
cleaned_data$ride_category <- factor(cleaned_data$ride_category,
                                     levels=c("short","medium","long"))

# Verify category counts
table(cleaned_data$ride_category)

# Save the updated dataset
saveRDS(cleaned_data, file = cleaned_data_rds)
write.csv(cleaned_data, file = cleaned_data_csv, row.names = FALSE)

