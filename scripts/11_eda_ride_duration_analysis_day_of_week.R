# 11_eda_ride_duration_analysis_day_of_week
# This script continues our analysis of ride duration after the day_of_week
# column is created. This will now tackle the analysis of rides based on
# hour of day and day of the week.

# Load configurations and variables.
source("config.R")

# Check if sim_processed_data exists in memory; load from RDS if missing
if (!exists("cleaned_data")) {
  cleaned_data <- readRDS(cleaned_data_rds)
} 

# Compute ride duration summary by day of week for casual riders
casual_summary <- cleaned_data %>% 
  filter(member_casual == "casual") %>% 
  group_by(day_of_week) %>% 
  summarise(
    Min = min(ride_duration, na.rm = TRUE),
    Q1 = quantile(ride_duration, 0.25, na.rm = TRUE),
    Median = median(ride_duration, na.rm = TRUE),
    Mean = mean(ride_duration, na.rm = TRUE),
    Q3 = quantile(ride_duration, 0.75, na.rm = TRUE),
    Max = max(ride_duration, na.rm = TRUE),
    .groups = "drop"
  ) %>% 
  mutate(member_casual = "casual")

# Compute ride duration summary by day of week for member riders
member_summary <- cleaned_data %>%
  filter(member_casual == "member") %>%
  group_by(day_of_week) %>%
  summarise(
    Min = min(ride_duration, na.rm = TRUE),
    Q1 = quantile(ride_duration, 0.25, na.rm = TRUE),
    Median = median(ride_duration, na.rm = TRUE),
    Mean = mean(ride_duration, na.rm = TRUE),
    Q3 = quantile(ride_duration, 0.75, na.rm = TRUE),
    Max = max(ride_duration, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(member_casual = "member")

# Combine the summaries
ride_duration_summary <- bind_rows(casual_summary, member_summary)

# Display summary as a table
pander(ride_duration_summary, 
       caption = "Ride Duration Summary by Day of the Week (Casual vs. Member)")

# Analysis of medians each day of the week
median_ride_duration_summary <- ride_duration_summary %>% 
  select(day_of_week, Median, member_casual)

# Ensure correct ordering of day_of_week
median_ride_duration_summary$day_of_week <- factor(
  median_ride_duration_summary$day_of_week, 
  levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
)

# Ensure member_casual is treated as a factor
median_ride_duration_summary$member_casual <- factor(
  median_ride_duration_summary$member_casual, 
  levels = c("casual", "member")
)

# Create the bar plot
plot_median_duration <- ggplot(median_ride_duration_summary, 
                               aes(x = day_of_week, y = Median, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.6) +  # Use dodge for side-by-side bars
  geom_text(aes(label = round(Median, 1)), 
            position = position_dodge(width = 0.6), vjust = -1.2, size = 5, 
            fontface = "bold") +  
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "lightgreen")) + 
  labs(
    title = "Median Ride Duration by Day of the Week",
    x = "Day of the Week",
    y = "Median Ride Duration (minutes)",  
    fill = "Rider Type"
  ) +
  expand_limits(y = max(median_ride_duration_summary$Median) * 1.15) +
  theme_light() +
  theme(
    plot.margin = margin(15,15,15,15),
    text = element_text(size = 14),
    legend.title = element_text(size = 12),
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_blank()
  )

# Display the plot
print(plot_median_duration)

# Save the plot
ggsave(filename = file.path(visualization_dir, "median_ride_duration_by_day.png"), 
       plot = plot_median_duration, width = 8, height = 6, dpi = 300)


# Compute ride percentages within each rider type
day_of_week_percent <- cleaned_data %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(count = n(), .groups = "drop") %>% 
  group_by(member_casual) %>% 
  mutate(percentage = (count / sum(count)) * 100) %>% 
  ungroup()

# Print summary table
print(day_of_week_percent)


# Create a grouped bar chart for ride percentage per day
plot_ride_percentage <- ggplot(day_of_week_percent, 
                               aes(x = day_of_week, y = percentage, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.6) +  # Dodge for side-by-side bars
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "lightgreen")) +  # Custom colors
  scale_y_continuous(labels = scales::percent_format(scale = 1), 
                     breaks = seq(0, max(day_of_week_percent$percentage), 
                                  by = 2)) +  # Convert y-axis to percentage
  labs(
    title = "Percentage of Rides by Day of the Week",
    x = "Day of the Week",
    y = "Percentage of Total Rides (Within Each Rider Type)",
    fill = "Rider Type"
  ) +
  theme_light() +
  theme(
    plot.margin = margin(15, 15, 15, 15),
    text = element_text(size = 14),
    legend.title = element_text(size = 12),
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5,
                              margin = margin(b=15)),
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_blank()
  )

# Display the percentage-based plot
print(plot_ride_percentage)

ggsave(filename = file.path(visualization_dir, "percentage_rides_by_day.png"), 
       plot = plot_ride_percentage, width = 10, height = 6, dpi = 300)


# Analysis of hourly bike use during the week as a heatmap

# Extract hour of the day from ride start time
cleaned_data <- cleaned_data %>%
  mutate(start_hour = hour(started_at))  # Extract hour (0-23)

# Summarize total ride counts by hour and day of week
hourly_rides_summary <- cleaned_data %>%
  group_by(day_of_week, start_hour) %>%
  summarise(ride_count = n(), .groups = "drop")

# Create a heatmap using ggplot
plot_hourly_heatmap <- ggplot(hourly_rides_summary, 
                              aes(x = start_hour, y = fct_rev(day_of_week), fill = ride_count)) +
  geom_tile(color = "white") +  # Adds gridlines
  scale_fill_gradient(low = "lightyellow", high = "red") +  # Heatmap color scheme
  scale_x_continuous(breaks = seq(0, 23, by = 2)) + # Show labels at intervals of 2 hours
  labs(
    title = "Hourly Ride Start Trends (all riders)",
    x = "Hour of the Day",
    y = "Day of the Week",
    fill = "Ride Count"
  ) +
  theme_light() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    text = element_text(size = 14),
    axis.text.y = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    panel.grid.major = element_blank(),  
    panel.grid.minor = element_blank()
  )

# Display the heatmap
print(plot_hourly_heatmap)

ggsave(filename = file.path(visualization_dir, "hourly_ride_heatmap.png"), 
       plot = plot_hourly_heatmap, width = 10, height = 6, dpi = 300)



# Casual riders heatmap 
# Filter dataset for only casual riders
casual_rides_summary <- cleaned_data %>%
  filter(member_casual == "casual") %>%
  group_by(day_of_week, start_hour) %>%
  summarise(ride_count = n(), .groups = "drop")

# Generate the heatmap for casual riders
plot_casual_heatmap <- ggplot(casual_rides_summary, 
                              aes(x = start_hour, y = fct_rev(day_of_week), fill = ride_count)) +
  geom_tile(color = "white") +  # Adds gridlines for readability
  scale_fill_gradient(low = "lightyellow", high = "red",) +  # Heatmap color scheme
  scale_x_continuous(breaks = seq(0, 23, by = 2)) +  # Adjust x-axis to show every 2 hours
  labs(
    title = "Hourly Ride Start Trends (Casual Riders Only)",
    x = "Hour of the Day",
    y = "Day of the Week",
    fill = "Ride Count"
  ) +
  theme_light() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    text = element_text(size = 14),
    axis.text.y = element_text(size = 12),
    axis.text.x = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

# Display the heatmap
print(plot_casual_heatmap)

ggsave(filename = file.path(visualization_dir, "casual_rider_hourly_heatmap.png"), 
       plot = plot_casual_heatmap, width = 10, height = 6, dpi = 300)


# Side-By-Side Heatmap
# Combine heatmaps side by side
combined_heatmaps <- plot_hourly_heatmap + plot_casual_heatmap + 
  plot_layout(ncol = 2) + 
  plot_annotation(title = "Comparison of Hourly Ride Trends",
                  theme = theme(plot.title = element_text(hjust = 0.5, size = 18, face = "bold")))

# Display the combined plot
print(combined_heatmaps)

# Save the combined heatmap to file
ggsave(filename = file.path(visualization_dir, "hourly_heatmaps_combined.png"), 
       plot = combined_heatmaps, width = 16, height = 7, dpi = 300)




# Electric bike usage heatmap
electric_data <- cleaned_data %>% 
  filter(rideable_type == "electric_bike")
# All Riders
# Summarize electric bike rides by day_of_week and start_hour for all riders
electric_rides_all <- electric_data %>% 
  group_by(day_of_week, start_hour) %>% 
  summarise(ride_count = n(), .groups = "drop")

# Create the heatmap for all riders using electric bikes
plot_electric_all <- ggplot(electric_rides_all, 
                            aes(x = start_hour, y = fct_rev(day_of_week), fill = ride_count)) +
  geom_tile(color = "white") +  # Adds white borders for clarity
  scale_fill_gradient(low = "lightyellow", high = "red") +  # Color gradient for ride count
  scale_x_continuous(breaks = seq(0, 23, by = 2)) +         # X-axis labels every 2 hours
  labs(
    title = "Hourly Electric Bike Usage (All Riders)",
    x = "Hour of the Day",
    y = "Day of the Week",
    fill = "Ride Count"
  ) +
  theme_light() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    text = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12)
  )

# Display the plot
print(plot_electric_all)

ggsave(filename = file.path(visualization_dir, "electric_bike_heatmap_all.png"), 
       plot = plot_electric_all, width = 10, height = 6, dpi = 300)






# Casual Riders Only Electric Bike Heatmap
# Filter for casual riders only from the electric bike data
electric_data_casual <- electric_data %>% 
  filter(member_casual == "casual")

# Summarize electric bike rides by day_of_week and start_hour for casual riders
electric_rides_casual <- electric_data_casual %>% 
  group_by(day_of_week, start_hour) %>% 
  summarise(ride_count = n(), .groups = "drop")

# Create the heatmap for casual riders using electric bikes
plot_electric_casual <- ggplot(electric_rides_casual, 
                               aes(x = start_hour, y = fct_rev(day_of_week), fill = ride_count)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightyellow", high = "red") +
  scale_x_continuous(breaks = seq(0, 23, by = 2)) +
  labs(
    title = "Hourly Electric Bike Usage (Casual Riders Only)",
    x = "Hour of the Day",
    y = "Day of the Week",
    fill = "Ride Count"
  ) +
  theme_light() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    text = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12)
  )

# Display the casual riders' heatmap
print(plot_electric_casual)

ggsave(filename = file.path(visualization_dir, "electric_bike_heatmap_casual.png"), 
       plot = plot_electric_casual, width = 10, height = 6, dpi = 300)



# Extract the month and create a summary dataset
monthly_rides <- cleaned_data %>%
  mutate(month = month(started_at, label = TRUE, abbr = FALSE)) %>%  # Extract full month name
  group_by(member_casual, month) %>%
  summarise(ride_count = n(), .groups = "drop") %>%
  mutate(month = factor(month, levels = month.name))  # Ensure correct order (Jan–Dec)

# Convert to wide format and add a total column
monthly_rides_table <- monthly_rides %>%
  pivot_wider(names_from = member_casual, values_from = ride_count) %>%
  mutate(
    Total = casual + member,  # Sum casual and member rides
    Percentage = (Total / sum(Total)) * 100  # Calculate percentage of total rides
  )

# Print the table with percentage
knitr::kable(
  monthly_rides_table, 
  caption = "Monthly Ride Counts by Rider Type (With Totals and Percentage)",
  digits = 1,
  format = "pipe"  
)



# Create the line graph for monthly trends
plot_monthly_trends <- ggplot(monthly_rides, aes(x = month, y = ride_count, group = member_casual, color = member_casual)) +
  geom_line(linewidth = 1.2) +  # Line thickness
  geom_point(size = 3) +   # Add markers at each month
  scale_y_continuous(labels = scales::label_number(scale = 1e-6, suffix = "M")) +  # Format Y-axis as 1M, 2M, etc.
  scale_color_manual(values = c("casual" = "skyblue", "member" = "lightgreen")) +  # Set colors
  labs(
    title = "Monthly Ride Trends (Casual vs. Members)",
    x = "Month",
    y = "Total Ride Count",
    color = "Rider Type"
  ) +
  theme_light() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis for readability
    text = element_text(size = 14)
  )

# Display the graph
print(plot_monthly_trends)

# Save the plot as an image
ggsave(filename = file.path(visualization_dir, "monthly_ride_trends.png"), 
       plot = plot_monthly_trends, width = 10, height = 6, dpi = 300)


# Compute ride category proportions within each rider type
ride_category_percent <- cleaned_data %>%
  group_by(member_casual, ride_category) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(member_casual) %>%
  mutate(percent = (count / sum(count)) * 100)  # Convert counts to percentages

# Create a grouped bar chart for ride categories per rider type
plot_ride_category_trend <- ggplot(ride_category_percent, aes(x = ride_category, y = percent, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +  # Adjust width for spacing
  geom_text(aes(label = sprintf("%.1f%%", percent)),  # Format as percentage
            position = position_dodge(width = 0.7), vjust = -0.3, size = 5, fontface = "bold") +
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "darkblue")) +
  labs(
    title = "Ride Duration Categories by Rider Type (Percentage)",
    x = "Ride Category",
    y = "Percentage of Rides Within Rider Type",
    fill = "Rider Type"
  ) +
  scale_y_continuous(labels = scales::percent_format(scale = 1)) +  # Format Y-axis as %
  theme_light() +
  expand_limits(y = max(ride_category_percent$percent) * 1.1) +  # Adds space above bars
  theme(
    plot.margin = margin(20, 20, 20, 20),  # Adds padding
    text = element_text(size = 14),
    legend.title = element_text(size = 12),
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5, margin = margin(b = 15)),  # Padding below title
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_blank()
  )

print(plot_ride_category_trend)

# Save the plot as an image
ggsave(filename = file.path(visualization_dir, "ride_category_trend.png"), 
       plot = plot_ride_category_trend, width = 10, height = 6, dpi = 300)


# Compute ride category proportions for each bike type within rider type
ride_category_bike_type <- cleaned_data %>%
  group_by(member_casual, rideable_type, ride_category) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(member_casual, rideable_type) %>%
  mutate(percent = (count / sum(count)) * 100)  # Convert counts to percentages

# Visualization 1: Ride Category by Bike Type and Rider Type
plot_ride_category_bike <- ggplot(ride_category_bike_type, 
                                  aes(x = ride_category, y = percent, fill = rideable_type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +  
  scale_fill_manual(values = c("classic_bike" = "blue", "electric_bike" = "orange", "electric_scooter" = "red")) +
  labs(
    title = "Ride Duration Categories by Bike Type and Rider Type",
    x = "Ride Category",
    y = "Percentage of Rides Within Rider Type",
    fill = "Bike Type"
  ) +
  facet_wrap(~member_casual) +  # Separate casual and member riders
  scale_y_continuous(labels = scales::percent_format(scale = 1)) +  
  theme_light() +
  expand_limits(y = max(ride_category_bike_type$percent) * 1.1) +  
  theme(
    plot.margin = margin(20, 20, 20, 20),
    text = element_text(size = 14),
    legend.title = element_text(size = 12),
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5, margin = margin(b = 15)),
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_blank()
  )

print(plot_ride_category_bike)

# Save the plot
ggsave(filename = file.path(visualization_dir, "ride_category_by_bike_type.png"), 
       plot = plot_ride_category_bike, width = 10, height = 6, dpi = 300)

# ------------------------------
# Visualization 2: Medium Rides Breakdown by Bike Type
# ------------------------------

# Filter data for medium rides only
medium_rides <- cleaned_data %>%
  filter(ride_category == "medium") %>%
  group_by(member_casual, rideable_type) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(member_casual) %>%
  mutate(percent = (count / sum(count)) * 100)  

# Create visualization for medium rides
plot_medium_rides <- ggplot(medium_rides, aes(x = rideable_type, y = percent, fill = rideable_type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.6) +  
  geom_text(aes(label = sprintf("%.1f%%", percent)),  
            position = position_dodge(width = 0.6), vjust = -0.3, size = 5, fontface = "bold") +
  scale_fill_manual(values = c("classic_bike" = "blue", "electric_bike" = "orange", "electric_scooter" = "red")) +
  labs(
    title = "Medium Ride Duration Breakdown by Bike Type",
    x = "Bike Type",
    y = "Percentage of Medium Rides",
    fill = "Bike Type"
  ) +
  facet_wrap(~member_casual) +  # Separate casual and member riders
  scale_y_continuous(labels = scales::percent_format(scale = 1)) +  
  theme_light() +
  expand_limits(y = max(medium_rides$percent) * 1.1) +  
  theme(
    plot.margin = margin(20, 20, 20, 20),
    text = element_text(size = 14),
    legend.title = element_text(size = 12),
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5, margin = margin(b = 15)),
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_blank()
  )

print(plot_medium_rides)

# Save the plot
ggsave(filename = file.path(visualization_dir, "medium_rides_by_bike_type.png"), 
       plot = plot_medium_rides, width = 10, height = 6, dpi = 300)

