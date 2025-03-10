# 07_cleaning_eda_analyze_ride_duration_to_make_cleaning_decision
# --------------------------------------------------------------
# This script evaluates the ride duration extremes to identify invalid or 
# erroneous data. The focus is on:
# 1. Ride durations under 1 minute (potential docking errors or short trips)
# 2. Long ride durations (100+ minutes) to assess natural cutoffs
# 3. Applying a final cleaning rule: Keeping only 0 < ride_duration < 1440
# --------------------------------------------------------------

# Step 1: Load Configuration and Dataset
source("config.R")
cleaned_data <- readRDS(cleaned_data_rds) # Load the most current cleaned data

# --------------------------------------------------------------
# Step 2: Remove Invalid Ride Durations
# --------------------------------------------------------------
# - Exclude negative ride durations.
# - Remove rides >= 1440 minutes, as Divvy considers them lost/stolen.
# - Company policy states that rides not returned within 24 hours (1440 min)
#   may be assessed a lost/stolen bike fee.

cleaned_data <- cleaned_data %>% 
  filter(ride_duration > 0, ride_duration < 1440)

# Save the cleaned dataset after applying the exclusion rule
saveRDS(cleaned_data, file = cleaned_data_rds)
cat("\nUpdated cleaned dataset successfully saved!\n")

# --------------------------------------------------------------
# Step 3: Evaluate Ride Duration to Explore Lower and Upper Bounds
# --------------------------------------------------------------
# Objective:
# - Evaluate the overall distribution of ride_duration to identify patterns.
# - Assess the summary statistics for short rides (0 < x < 1 minute).
# - Examine the distribution of rides from 20+ to 130+ minutes.
# - Use quantile analysis (90% to 100%) to determine a reasonable upper bound.


# Analyze overall ride distribution
cat("\nSummary Statistics: Ride Duration (Full Dataset)\n")
print(summary(cleaned_data$ride_duration))

# Analyze rides 0 < x < 1
cat("\nSummary Statistics: Short Rides (<1 minute)\n")
print(summary(cleaned_data$ride_duration[cleaned_data$ride_duration < 1 ]))

# Count the number of riders in different long duration ranges
cat("\nNumber of Rides Greater Than X Minutes:\n")
cat(" > 20 min:", sum(cleaned_data$ride_duration > 20), "\n")
cat(" > 30 min:", sum(cleaned_data$ride_duration > 30), "\n")
cat(" > 40 min:", sum(cleaned_data$ride_duration > 40), "\n")
cat(" > 50 min:", sum(cleaned_data$ride_duration > 50), "\n")
cat(" > 60 min:", sum(cleaned_data$ride_duration > 60), "\n")
cat(" > 70 min:", sum(cleaned_data$ride_duration > 70), "\n")
cat(" > 80 min:", sum(cleaned_data$ride_duration > 80), "\n")
cat(" > 90 min:", sum(cleaned_data$ride_duration > 90), "\n")
cat(" > 100 min:", sum(cleaned_data$ride_duration > 100), "\n")
cat(" > 130 min:", sum(cleaned_data$ride_duration > 130), "\n") 

# Ride Duration Quantiles for Extended Rides (90% - 100%)
cat("\nRide Duration Quantiles for Extended Rides (90%-100%)...\n")
print(quantile(cleaned_data$ride_duration, 
               probs = c(0.90, 0.95, 0.99, 0.995, 0.998, 0.999, 1)))

# --------------------------------------------------------------
# Step 4: Investigate Rides (0 < ride_duration < 1)
# --------------------------------------------------------------
# - Count the total number of rides ≤ 1 minute
# - Identify how many have the same start and end station (potential errors)
# - Remove these short rides where start & end station are identical

cat("\nTotal rides ≤ 1 min:", sum(cleaned_data$ride_duration <= 1), "\n")

summary(cleaned_data$ride_duration[cleaned_data$ride_duration <= 1])

# Count short rides where start & end station are the same
same_station_rides <- sum(cleaned_data$start_station_id[cleaned_data$ride_duration <= 1] == 
                            cleaned_data$end_station_id[cleaned_data$ride_duration <= 1], na.rm=TRUE)

cat("Short rides where start & end station are the same:", same_station_rides, "\n")

# Remove short rides where start and end stations are the same (excluding NAs)
cleaned_data <- cleaned_data %>% 
  filter(!(start_station_id==end_station_id & !is.na(start_station_id) & 
             ride_duration <= 1))

cat("Total short rides removed:", same_station_rides, "\n")

# Confirm that there are no more rides <= 1 min that have the same start and end
# station id.
cat("\nVerify the presence/absence of rides with the same start and end station ID.\n")
sum(cleaned_data$start_station_id == cleaned_data$end_station_id & 
      !is.na(cleaned_data$start_station_id) &
      cleaned_data$ride_duration <=1, na.rm=TRUE)

# Save dataset after short ride cleaning step
saveRDS(cleaned_data, file = cleaned_data_rds)
cat("\nUpdated cleaned dataset successfully saved!\n")

# --------------------------------------------------------------
# Step 5: Investigate Extended Rides (>= 130 Minutes)
# --------------------------------------------------------------
# - Count rides >= 130 minutes
# - Analyze distribution using quantiles
# - Create a histogram to visualize long rides

extended_rides_count <- sum(cleaned_data$ride_duration >= 130)
cat("Total rides >= 130 minutes:", extended_rides_count, "\n")

total_rides <- nrow(cleaned_data)
cat("Total rides in the dataset:", total_rides, "\n")

# Analyze ride duration quantiles for long rides (90th to 100th percentile)
cat("\nRide duration quantiles for long rides (90%-100%)...\n")
print(quantile(cleaned_data$ride_duration, 
               probs = c(0.90, 0.95, 0.99, 0.995, 0.998, 0.999, 1)))

# Histogram of long ride durations (100+ min)
ggplot(cleaned_data %>% filter(ride_duration >= 100), aes(x = ride_duration)) +
  geom_histogram(binwidth = 10, fill = "red") +
  xlim(100, 1440) +
  labs(title = "Long Ride Duration Distribution (≥100 min)", 
       x = "Ride Duration (mins)", y = "Count")


# --------------------------------------------------------------
# Final Notes:
# - The dataset now only contains rides where 0 < ride_duration < 1440.
# - Short rides (<= 1 min) with the same start & end station have been removed.
# - Identified 130+ minutes as possible upper boundary. 
# --------------------------------------------------------------
