# 08_eda_preliminary_general_exploration
# This script makes a preliminary general exploration and analysis of 
# ride duration, ride type, and rider type.

# Load configurations and variables
source("config.R")

# Check if sim_processed_data exists in memory; load from RDS if missing
if (!exists("cleaned_data")) {
  cleaned_data <- readRDS(cleaned_data_rds)
} 

#----------------------------------------------------------
# Step 1: Evaluate Rider Type Distribution
#----------------------------------------------------------
# Compute percentage of casual members
# Compute percentage of members


# Compute Rider Counts
member_count <- sum(cleaned_data$member_casual == "member")
casual_count <- sum(cleaned_data$member_casual == "casual")
total_accounts <- member_count + casual_count

# Create a summary table
rider_type_summary <- data.frame(
  Rider_Type = c("Causal Riders", "Member Riders", "Total Riders"),
  Count = c(casual_count, member_count, total_accounts),
  Percentage = c(
    (casual_count / total_accounts) * 100,
    (member_count / total_accounts) * 100,
    100
  )
)

# Print the result as a formatted table
knitr::kable(rider_type_summary,
             caption = "Rider Type Distribution",
             digits = 2,
             format = "pipe")




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

# Exclude "Max" and "Min" statistics from the data
summary_data <- summary_data %>% 
  filter(Statistic %in% c("1st Qu.", "Median", "Mean", "3rd Qu."))

# Ensure correct ordering of statistics
summary_data$Statistic <- factor(summary_data$Statistic,
                                 levels = c("1st Qu.", "Median", "Mean", "3rd Qu."))

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

# Compute the percentage of use of ride type based on rider type.
ride_type_percentage <- cleaned_data %>% 
  group_by(member_casual, rideable_type) %>% 
  summarise(count = n(), .groups="drop") %>% 
  group_by(member_casual) %>% 
  mutate(percent = (count / sum(count)) * 100) %>% 
  ungroup()

# Create a formatted table for better readability
knitr::kable(
  ride_type_percentage,
  caption = "Bike Type Usage by Rider Type (Percentage Breakdown)",
  digits = 2,
  format = "pipe"
)

# Visualizing bike type usage
ggplot(ride_type_percentage, aes(x = rideable_type, y = percent, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(
    title = "Bike Type Preference by Rider Type (Percentage)",
    x = "Bike Type",
    y = "Percentage By Rider Type",
    fill = "Rider Type"
  ) +
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "darkblue")) +
  theme_light() + 
  ylim(0, max(ride_type_percentage$percent) + 5) +
  geom_text(aes(label = sprintf("%.1f%%", percent)),
            position = position_dodge(width = 0.9), vjust = -0.5)


#----------------------------------------------------------
# Step 4: Ride Duration by Bike Type & Rider Type
#----------------------------------------------------------

# Compute average ride duration per bike type **and** rider type
avg_ride_duration_by_type <- cleaned_data %>%
  group_by(member_casual, rideable_type) %>%
  summarise(
    avg_duration = mean(ride_duration, na.rm = TRUE),
    median_duration = median(ride_duration, na.rm = TRUE),
    count = n(),
    .groups = "drop"
  ) %>%
  group_by(member_casual) %>% 
  mutate(percent_of_rider_type = (count / sum(count)) * 100) %>% 
  ungroup() %>%
  arrange(rideable_type, desc(avg_duration))  # Sort for better visualization

# Table: Average Ride Duration per Bike Type and Rider Type (With Percentages)
knitr::kable(
  avg_ride_duration_by_type %>% select(-count),  # Remove count column since we now use percentage
  caption = "Average Ride Duration by Bike Type and Rider Type (Percentage of Rider Type)",
  digits = 2,
  format = "pipe"
)

# Dodge Bar Chart: Ride Duration per Bike Type and Rider Type
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


#----------------------------------------------------------
# 🔍 Key Insights:
#----------------------------------------------------------
# - The **preference for ride type is nearly identical** for both groups.
# - **Electric bikes** are slightly more popular than classic bikes.
# - **Casual riders use classic bikes almost twice as long as members do.**
# - **Casual riders also tend to take longer rides on e-bikes** than members.
# - Possible marketing strategy: Highlight the **cost difference for long rides** 
#   between membership pricing and casual ride pricing.
# - Consider a **bike reservation feature for members** where they can 
#   reserve a bike for a short period at a minimal cost.








