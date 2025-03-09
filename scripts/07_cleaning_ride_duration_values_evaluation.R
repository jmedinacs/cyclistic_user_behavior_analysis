# CLEANING_EDA_analyze_ride_duration_to_make_cleaning_decision
# This script evaluates the ride duration extremities to evaluate the presence 
# of invalid and/or erroneous data. 
# Focus is on evaluating ride duration under 1 minute and suspiciously long 
# ride duration (800 minutes and over)

# Step 1: Load configuration settings and dataset
source("config.R")
cleaned_data <- readRDS(cleaned_data_rds) # Load the most current cleaned data

# Step 2: Overview of Ride Duration data
cat("\nChecking ride duration distribution...\n")
str(cleaned_data) # Review the structure of the dataset
summary(cleaned_data$ride_duration) # Check key statistics 

# Step 3: Identify potential anomalies
cat("\n Checking count of rides <= 0, <= 1, and <= 2 minutes...\n")
cat("Total rides <= 0 min:", sum(cleaned_data$ride_duration <= 0),"\n")
cat("Total rides <= 1 min:", sum(cleaned_data$ride_duration <= 1),"\n")
cat("Total rides <= 2 min:", sum(cleaned_data$ride_duration <= 2),"\n")

# Step 4: Quantile analysis to identify outliers and data significance 
cat("\nRide duration quantiles (90%-100%)...\n")
print(quantile(cleaned_data$ride_duration, 
               probs = c(0.90, 0.95, 0.99, 0.995,0.998,0.999, 1)))
sum(cleaned_data$ride_duration > 800)


cat("\nRide duration quantiles (1%-5%)...\n")
print(quantile(cleaned_data$ride_duration, 
               probs = c(0.01, 0.02, 0.03, 0.04, .05)))

# Step 5: Visualizing Ride Duration distributions
cat("\n Plotting ride duration histograms...\n")

# Full dataset histogram
hist(cleaned_data$ride_duration,
     breaks= 100,
     main = "Ride Duration Distribution (Full Dataset)",
     col = "skyblue",
     border = "black",
     xlab = "Ride Duration (minutes",
     ylab = "Ride Count")

# Short rides (0-10 minutes)
hist(cleaned_data$ride_duration[cleaned_data$ride_duration > 0 & cleaned_data$ride_duration <= 10],
     breaks = seq(0, 10, 0.5),
     main = "Short Ride Duration Distribution (0-10 min)",
     xlab = "Ride Duration (half-minute interval)",
     ylab = "Count of Rides",
     col = "skyblue",
     border = "black")    

# Long rides (>100 minutes)
hist(cleaned_data$ride_duration[cleaned_data$ride_duration > 100],
     breaks = 100,
     main = "Long Ride Duration Distribution (>100 min)",
     xlab = "Ride Duration (minutes)",
     ylab = "Count of Rides",
     col = "skyblue",
     border = "black")

# Step 6: Investigate short rides (0 - 1 minute)
cat("\nInvestigating short rides less than a minute...\n")
short_rides <- cleaned_data %>% filter(ride_duration > 0 & ride_duration < 1)

# Count rides with the same start & end station
same_station_rides <- 
  sum(short_rides$start_station_id == short_rides$end_station_id, na.rm=TRUE)

# Identify short rides with missing start station id, end station id, or both
only_missing_start <- 
  sum(is.na(short_rides$start_station_id) & !is.na(short_rides$end_station_id))
only_missing_end <- 
  sum(!is.na(short_rides$start_station_id) & is.na(short_rides$end_station_id))
missing_both <- 
  sum(is.na(short_rides$start_station_id) & is.na(short_rides$end_station_id))

# Print findings
cat("\nBreakdown of Missing Station Data for Short Rides (0-1 min):\n")
cat("Total short rides (0-1 min):", nrow(short_rides), "\n")
cat("Short rides where start & end station are the same:", same_station_rides, "\n")
cat("Short rides missing ONLY start station ID:", only_missing_start, "\n")
cat("Short rides missing ONLY end station ID:", only_missing_end, "\n")
cat("Short rides missing BOTH start & end station IDs:", missing_both, "\n")

# Validate: Check if the three categories add up to the number of missing cases
total_missing_any <- only_missing_start + only_missing_end + missing_both
cat("\nTotal Short Rides with Any Missing Station Data:", total_missing_any, "\n")
cat("Percentage of Short Rides with Any Missing Station Data:", 
    round((total_missing_any / nrow(short_rides)) * 100, 2), "%\n")


# Step 6B: Count Rides Over Different Long Duration Thresholds
cat("\nCounting long rides beyond certain duration thresholds...\n")
cat("Rides > 500 minutes:", sum(cleaned_data$ride_duration > 500), "\n")
cat("Rides > 800 minutes:", sum(cleaned_data$ride_duration > 800), "\n")
cat("Rides > 1000 minutes:", sum(cleaned_data$ride_duration > 1000), "\n")
cat("Rides > 1500 minutes:", sum(cleaned_data$ride_duration > 1500), "\n")


# Step 6C: Quantile Analysis to Identify Outliers in Long Rides
cat("\nChecking ride duration quantiles to justify long ride cutoff...\n")
print(quantile(cleaned_data$ride_duration, 
               probs = c(0.90, 0.95, 0.99, 0.995, 0.998, 0.999, 1)))


# Step 6D: Histogram of Long Ride Durations
cat("\nVisualizing long ride duration distribution...\n")
hist(cleaned_data$ride_duration[cleaned_data$ride_duration > 100],
     breaks = 100,
     main = "Long Ride Duration Distribution (>100 min)",
     xlab = "Ride Duration (minutes)",
     ylab = "Count of Rides",
     col = "skyblue",
     border = "black")


# Step 6E: Investigate long rides (800 minutes and greater)
cat("\nInvestigating long rides (>800)...\n")
long_rides <- cleaned_data %>%  filter(ride_duration > 800)

# Count rides with the same start and end station
same_station_long_rides <- sum(long_rides$start_station_id == 
                                long_rides$end_station_id, na.rm=TRUE)

# Count rides with missing station IDS
only_missing_start_long <- 
  sum(is.na(long_rides$start_station_id) & !is.na(long_rides$end_station_id))
only_missing_end_long <- 
  sum(!is.na(long_rides$start_station_id) & is.na(long_rides$end_station_id))
missing_both_long <- 
  sum(is.na(long_rides$start_station_id) & is.na(long_rides$end_station_id))

# Validate: These three categories should sum up to total missing cases
total_missing_any_long <- only_missing_start_long + only_missing_end_long + missing_both_long

# Print findings
cat("\nBreakdown of Missing Station Data for Long Rides (>800 min):\n")
cat("Total rides over 800 minutes:", nrow(long_rides), "\n")
cat("Long rides where start & end station are the same:", 
    same_station_long_rides, "\n")
cat("Long rides missing ONLY start station ID:", 
    only_missing_start_long, "\n")
cat("Long rides missing ONLY end station ID:", 
    only_missing_end_long, "\n")
cat("Long rides missing BOTH start & end station IDs:", 
    missing_both_long, "\n")
cat("\nTotal Long Rides with Any Missing Station Data:", 
    total_missing_any_long, "\n")
cat("Percentage of Long Rides with Any Missing Station Data:", 
    round((total_missing_any_long / nrow(long_rides)) * 100, 2), "%\n")


# Step 7: Apply Ride Duration Filtering (Final Cleaned Data)
cat("\nApplying final ride duration filter to create the new cleaned dataset...\n")
cleaned_data <- cleaned_data %>% filter(ride_duration > 1, ride_duration <= 800)

# Step 8: Save the Official Cleaned Dataset
saveRDS(cleaned_data, file = cleaned_data_rds)


cat("\nFinal cleaned dataset successfully saved!\n")

