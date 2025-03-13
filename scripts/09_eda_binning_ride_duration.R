# 09_eda_binning_ride_duration
# This script will categorize the ride duration into short (1-7 mins), 
# medium (7-23 mins), and long (>23 mins) to simplify ride duration use in
# some analysis. This will make it less noisy for some comparison and analysis.

# Load configurations and variables
source("config.R")

# Check if sim_processed_data exists in memory; load from RDS if missing
if (!exists("cleaned_data")) {
  cleaned_data <- readRDS(cleaned_data_rds)
} 

#--------------------------------------------------------------------
# Step 1: Review data summary casual vs member
#--------------------------------------------------------------------
# Consider data summary for casual and member to identify possible bin size

casual_summary <- 
  summary(cleaned_data$ride_duration[cleaned_data$member_casual=="casual"])
member_summary <- 
  summary(cleaned_data$ride_duration[cleaned_data$member_casual == "member"])


# Create a data frame with the summary statistics
summary_data <- data.frame(
  Statistic = rep(names(casual_summary),2),
  Value = c(as.numeric(casual_summary), as.numeric(member_summary)),
  Rider_Type = rep(c("Casual", "Member"), each = length(casual_summary))
)

# Convert the data frame to wide format for table display
ride_duration_summary <- tidyr::pivot_wider(
  summary_data,
  names_from = Rider_Type,
  values_from = Value
)

# Display summary table
knitr::kable(ride_duration_summary,
             caption = "Ride Duration Summary by Rider Type",
             digits = 2,
             format = "pipe")



# Based on this table, Q1 is 6.78 for casual, this is a candidate for "short"
# ride threshold bin. Median and mean difference is large and needs 
# further analysis to determine "medium" and "long".

#--------------------------------------------------------------------
# Step 2: Analyze data distribution after 7 minutes
#--------------------------------------------------------------------
# Analyze different thresholds to determine plausible bin size for "medium" and
# "long" rides.


# Define duration thresholds for binning consideration
duration_thresholds <- c(5, 10, 15, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130)

# Compute total number of rides
total_rides <- nrow(cleaned_data)

# Compute the number of rides that are <= each threshold
ride_duration_summary <- data.frame(
  "Duration_Threshold (min)" = duration_thresholds,
  "Number_of_Rides" = sapply(duration_thresholds, function(x) {
    sum(cleaned_data$ride_duration <= x)
  })
)

# Compute the percentage of total rides for each range
ride_duration_summary$Percentage_of_Total <- round(
  (ride_duration_summary$Number_of_Rides / total_rides) * 100, 2
)

# Display the table
knitr::kable(
  ride_duration_summary, 
  caption = "Ride Duration Summary (Cumulative Intervals) with Percentage",
  digits = 2,
  format = "pipe"
)



# Create an Empirical Cumulative Distribution Function (ECDF) plot, to show
# the count of observations falling below each unique value in a dataset. 
# Help identify natural cutoffs of datasets.

ggplot(cleaned_data, aes(x = ride_duration)) + 
  stat_ecdf(geom = "step", color = "blue") + 
  coord_cartesian(xlim = c(0, 100)) +  # Adjust x-axis to focus on shorter rides
  geom_vline(xintercept = c(7, 23, 60), linetype = "dashed", color = "red") +
  labs(
    title = "Cumulative Distribution of Ride Durations (0-100 min)",
    x = "Ride Duration (minutes)",
    y = "Proportion of Rides ≤ X Minutes"
  ) + 
  theme_light()

# 90.19% of the number of rides occur on or before the 30 minute mark, this is
# a good candidate for "medium" rides as it represents a significant amount of 
# data before the growth slows down significantly. 
# Based on the table, the number of ride increase slows down significantly after
# the 60-minute mark, which consists of 97.52% of the data
# Any ride after the 60-minute mark would fall under the "extended" ride.

#--------------------------------------------------------------------
# Step 3: Binning 
#--------------------------------------------------------------------
# Use the identified bin thresholds and create a ride_category column

#Ensure that ride_duration is numeric
cleaned_data <- cleaned_data %>% 
  mutate(ride_duration = as.numeric(ride_duration))

# Set binning thresholds and add the column
cleaned_data <- cleaned_data %>% 
  mutate(ride_category = case_when(
         ride_duration <= 7 ~ "short",
         ride_duration <= 30 ~ "medium",
         ride_duration <= 60 ~ "long",
         TRUE ~ "extended"
  ))

# Convert ride_category into a factor for better plotting and order
cleaned_data <- cleaned_data %>% 
  mutate(
    ride_category = factor(ride_category, 
                           levels=c("short","medium","long","extended"))
  )

table(cleaned_data$ride_category)

ggplot(cleaned_data, aes(x = ride_category, fill = ride_category))+
  geom_bar()+
  labs(
    title = "Distribution of Ride Categories",
    x = "Ride Category",
    y = "Count of Rides"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("short" = "blue", "medium" = "green", 
                               "long" = "orange", "extended" = "red"))



ggplot(cleaned_data, aes(x = ride_category, fill = ride_category)) +
  geom_bar(aes(y = after_stat(count) / sum(after_stat(count)))) + 
  geom_text(
    stat = "count", 
    aes(y = after_stat(count) / sum(after_stat(count)), 
        label = scales::percent(after_stat(count) / sum(after_stat(count)), accuracy = 0.1)),
    vjust = -1.5,  # Move labels higher above bars
    size = 5
  ) + 
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.65)) + 
  labs(
    title = "Proportion of Ride Categories",
    x = "Ride Category",
    y = "Percentage of Total Rides"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("short" = "blue", "medium" = "green", 
                               "long" = "orange", "extended" = "red")) +
  theme(
    plot.margin = margin(20, 20, 50, 20)  
  )

  

#Update the dataset with the added ride_category
saveRDS(cleaned_data, file = cleaned_data_rds)




