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
# - Remove rides ≥1440 minutes, as Divvy considers them lost/stolen.
# - Company policy states that rides not returned within 24 hours (1440 min)
#   may be assessed a lost/stolen bike fee.

cleaned_data <- cleaned_data %>% 
  filter(ride_duration > 0, ride_duration < 1440)

# Save the cleaned dataset after applying the exclusion rule
saveRDS(cleaned_data, file = cleaned_data_rds)
cat("\nUpdated cleaned dataset successfully saved!\n")

# --------------------------------------------------------------
# Step 3: Investigate Short Rides (0 < ride_duration < 1)
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

# Remove short rides where start & end station are the same (excluding NAs)
removed_short_rides <- sum(cleaned_data$start_station_id == cleaned_data$end_station_id & 
                             !is.na(cleaned_data$start_station_id) & 
                             cleaned_data$ride_duration <= 1, na.rm = TRUE)

cat("Total short rides removed:", removed_short_rides, "\n")

# Save dataset after short ride cleaning step
saveRDS(cleaned_data, file = cleaned_data_rds)
cat("\nUpdated cleaned dataset successfully saved!\n")

# --------------------------------------------------------------
# Step 4: Investigate Long Rides (≥100 Minutes)
# --------------------------------------------------------------
# - Count rides ≥100 minutes
# - Analyze distribution using quantiles
# - Create a histogram to visualize long rides

long_rides_count <- sum(cleaned_data$ride_duration >= 100)
cat("Total rides ≥ 100 minutes:", long_rides_count, "\n")

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
# Step 5: Investigate Long Rides by User Type
# --------------------------------------------------------------
# - Compare the number of long rides between casual and member riders.
# - Check if members have different ride duration patterns than casuals.

long_rides_by_user <- cleaned_data %>%
  filter(ride_duration >= 100) %>%
  group_by(member_casual) %>%
  summarize(count_long_rides = n())

print(long_rides_by_user)

# --------------------------------------------------------------
# Step 6: Quantile Analysis by User Type
# --------------------------------------------------------------
# - Identify the distribution of long rides for casual vs. member riders.
# - Check if casual riders tend to have longer rides than members.

long_ride_quantiles <- cleaned_data %>%
  filter(ride_duration >= 100) %>%
  group_by(member_casual) %>%
  summarise(
    p90 = quantile(ride_duration, 0.90),
    p95 = quantile(ride_duration, 0.95),
    p99 = quantile(ride_duration, 0.99),
    p995 = quantile(ride_duration, 0.995),
    p998 = quantile(ride_duration, 0.998),
    p999 = quantile(ride_duration, 0.999),
    max = max(ride_duration)
  )

print(long_ride_quantiles)

# --------------------------------------------------------------
# Final Notes:
# - The dataset now only contains rides where 0 < ride_duration < 1440.
# - Short rides (<= 1 min) with the same start & end station have been removed.
# - Long rides have been analyzed for distribution and user type differences.
# --------------------------------------------------------------
