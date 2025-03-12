# 08_eda_preliminary_general_exploration
# This script makes a preliminary general exploration and analysis of 
# ride duration, ride type, and rider type.

# Load configurations and variables
source("config.R")

# Load most recent cleaned dataset
cleaned_data <- readRDS(cleaned_data_rds) 

#----------------------------------------------------------
# Step 1: Evaluate Rider Type Distribution
#----------------------------------------------------------
# Compute percentage of casual members
# Compute percentage of members


# Compute Rider Counts
member_count <- sum(cleaned_data$member_casual == "member")
casual_count <- sum(cleaned_data$member_casual == "casual")
total_accounts <- member_count + casual_count

# Display Summary Statistics
cat("\nSummary of Rider Accounts:\n")
cat(sprintf("Casual Riders: %d (%.2f%%)\n", casual_count, 
            (casual_count / total_accounts) * 100))
cat(sprintf("Member Riders: %d (%.2f%%)\n", member_count, 
            (member_count / total_accounts) * 100))
cat(sprintf("Total Riders: %d\n", total_accounts))

# Create a Data Frame for Plotting
account_counts <- data.frame(
  account_type = c("Casual", "Member"),
  count = c(casual_count, member_count)
)

# Plot Bar Chart of rider type distribution
p <- ggplot(account_counts, aes(x = account_type, 
                                y = count, fill = account_type)) +
  geom_bar(stat = "identity", width = 0.6) +  # Adjust width for aesthetics
  geom_text(aes(label = count), vjust = -0.5, size = 5, fontface = "bold") +  
  labs(
    title = "Distribution of Casual vs. Member Riders",
    x = "Account Type",
    y = "Number of Riders",
    fill = "Account Type"
  ) +
  scale_fill_manual(values = c("Casual" = "skyblue", "Member" = "darkblue")) +  
  theme_light() +  
  expand_limits(y = max(account_counts$count) * 1.1) +  
  theme(plot.margin = margin(10, 10, 10, 10))

# Display the Plot
print(p)

#----------------------------------------------------------
# Step 2: Ride Duration Comparison of Casual vs Member
#----------------------------------------------------------
# Compare the summary of each rider type with each other.

# Study the summary of ride_duration of casual riders vs annual member riders
casual_summary <- 
  summary(cleaned_data$ride_duration[cleaned_data$member_casual=="casual"])
member_summary <- 
  summary(cleaned_data$ride_duration[cleaned_data$member_casual == "member"])

print(casual_summary)
print(member_summary)

# NOTE:
# Casual riders' summary shows a higher value at each statistic except on the 
# max. Looking at the mean, the casual riders take longer rides than member 
# riders on average. 

# Create a data frame with the summary statistics
summary_data <- data.frame(
  Statistic = rep(names(casual_summary),2),
  Value = c(as.numeric(casual_summary), as.numeric(member_summary)),
  Rider_Type = rep(c("Casual", "Member"), each = length(casual_summary))
)

# Exclude "Max" and "Min" statistic from the data
summary_data <- summary_data %>% 
  filter(Statistic != "Max.") %>% 
  filter(Statistic != "Min.")

# Create the dodge bar graph with labels
ggplot(summary_data, aes(x = Statistic, y = Value, fill = Rider_Type)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_text(aes(label = round(Value, 2)), 
            position = position_dodge(width = 0.8), 
            vjust = -0.3, size = 4) + # Adjust vjust for padding
  scale_fill_manual(values = c("Casual" = "skyblue", "Member" = "darkblue")) +
  labs(title = "Ride Duration Summary by Rider Type (Excluding Max and Min)",
       x = "Summary Statistic",
       y = "Ride Duration (Minutes)") +
  theme_light()



# Box plot of the summaries of casual vs member ride durations
ggplot(cleaned_data, aes(x = member_casual, y = ride_duration, fill = member_casual)) +
  geom_boxplot() + 
  scale_y_log10() +  # Apply log scale to y-axis
  labs(
    title = "Ride Duration Comparison (Log Scale)",
    x = "Account Type",
    y = "Log Ride Duration (minutes)"
  ) +
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "darkblue")) + 
  theme_light()


# Note:
# Visualization confirms that the Q1, Median, and Q3 of casual rider bloxplot is 
# higher and wider than the member box plot. This does not only confirm that 
# casual riders tend to ride for a longer period of time, it also shows that 
# most member riders tend to have a smaller and more predictable ride duration.




#----------------------------------------------------------
# Step 3: Bike Type Preference Comparison by Rider Type
#----------------------------------------------------------
# Analyze the bike type preference of each group

# Compute the percentage of use of ride type based on rider type.
ride_type_percentage <- cleaned_data %>% 
  group_by(member_casual, rideable_type) %>% 
  summarise(count = n(), .groups="drop") %>% 
  group_by(member_casual) %>% 
  mutate(percent =(count/sum(count))*100) %>% 
  ungroup()

print(ride_type_percentage)
  
# Visualize the rideable_type vs member_casual as a bar graph
ggplot(ride_type_percentage, aes(x = rideable_type, y = percent, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(
    title = "Bike Type Preference by Rider Type (Percentage)",
    x = "Bike Type",
    y = "Percentage By Rider Type",
    fill = "Rider Type"
  ) +
  scale_fill_manual(values=c("casual"="skyblue", member="darkblue")) +
  theme_light() + 
  ylim(0, max(ride_type_percentage$percent) + 5) +
  geom_text(aes(label=sprintf("%.1f%%", percent)),
            position = position_dodge(width = 0.9), vjust = -0.5)


if (!is.numeric(cleaned_data$ride_duration)) {
  cleaned_data$ride_duration <- as.numeric(cleaned_data$ride_duration)
}

# Compute average ride duration per ride type
avg_ride_duration_by_type <- cleaned_data %>%
  group_by(rideable_type) %>%
  summarise(
    avg_duration = mean(ride_duration, na.rm = TRUE),
    median_duration = median(ride_duration, na.rm = TRUE),
    count = n()
  ) %>%
  arrange(desc(avg_duration))  # Sort by average ride duration

# Print results
print(avg_ride_duration_by_type)

# Create a bar chart for visualization
ggplot(avg_ride_duration_by_type, aes(x = rideable_type, y = avg_duration, fill = rideable_type)) +
  geom_col() +
  geom_text(aes(label = round(avg_duration, 2)), vjust = -0.5, size = 5) +  # Add value labels
  labs(
    title = "Average Ride Duration by Bike Type",
    x = "Bike Type",
    y = "Average Ride Duration (Minutes)"
  ) +
  scale_fill_manual(values = c("classic_bike" = "skyblue", "electric_bike" = "darkblue", "electric_scooter" = "gray")) +
  theme_light()


# Compute average and median ride duration per bike type & rider type
avg_ride_duration_by_type <- cleaned_data %>%
  group_by(member_casual, rideable_type) %>%
  summarise(
    avg_duration = mean(ride_duration, na.rm = TRUE),
    median_duration = median(ride_duration, na.rm = TRUE),
    count = n(),
    .groups = "drop"
  ) %>%
  arrange(rideable_type, desc(avg_duration))  # Sort for better visualization

# Print results
print(avg_ride_duration_by_type)

# Create a dodge bar chart for visualization
ggplot(avg_ride_duration_by_type, aes(x = rideable_type, y = avg_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  geom_text(aes(label = round(avg_duration, 2)), 
            position = position_dodge(width = 0.9), 
            vjust = -0.3, size = 4) +  # Add value labels with padding
  labs(
    title = "Average Ride Duration by Bike Type and Rider Type",
    x = "Bike Type",
    y = "Average Ride Duration (Minutes)",
    fill = "Rider Type"
  ) +
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "darkblue")) +
  scale_x_discrete(labels = c("classic_bike" = "Classic Bike", 
                              "electric_bike" = "Electric Bike", 
                              "electric_scooter" = "Electric Scooter")) +
  theme_light() +
  theme(plot.margin = margin(20, 10, 10, 10))  # Add padding to prevent cutoff


#Note:
# - The preference for ride type are nearly identical for both groups, hardly 
# anyone uses a scooter. 
# - Riders have a slight preference for electric bikes more than traditional bikes
# - Cost savings for members due to free unlocks and lower price per minute.
# Save more money on ebikes with a membership! 
# On average, casual riders use classic bikes more than 2x the duration of
# member rider use. Casual riders tend to use ebikes and electric scooters 
# longer than members. 







