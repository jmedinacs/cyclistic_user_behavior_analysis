# 12_day_of_week_analysis
# This analysis pertains to gaining insight on information pertaining to
# days of the week. 

# Load configurations and variables 
source("config.R")

# Load the most current version of the cleaned_dataset
cleaned_data <- readRDS(cleaned_data_rds)

# Analysis of total rides grouped by day of the week.
day_of_week_counts <- cleaned_data %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(count = n(), .groups = "drop")
  
print(day_of_week_counts)

# Create dodge bar graph for total ride count per day
plot_ride_count <- ggplot(day_of_week_counts, 
                          aes(x = day_of_week, y = count, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.6) +  # Dodge for side-by-side bars
  geom_text(aes(label = scales::comma(count)), 
            position = position_dodge(width = 0.6), 
            vjust = -0.3, size = 5, fontface = "bold") +  
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "lightgreen")) +  # Custom colors
  labs(
    title = "Total Number of Rides by Day of the Week",
    x = "Day of the Week",
    y = "Total Ride Count",
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

# Display the plot
print(plot_ride_count)

# Save the plot to the output folder
ggsave(filename = file.path(output_dir, "ride_count_by_day.png"), 
       plot = plot_ride_count, width = 8, height = 6, dpi = 300)



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
    title = "Hourly Ride Start Trends",
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

# Save the heatmap to the output folder
ggsave(filename = file.path(output_dir, "hourly_ride_heatmap.png"), 
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
  scale_fill_gradient(low = "lightyellow", high = "red") +  # Heatmap color scheme
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

# Save the casual riders' heatmap to the output folder
ggsave(filename = file.path(output_dir, "hourly_ride_heatmap_casual.png"), 
       plot = plot_casual_heatmap, width = 10, height = 6, dpi = 300)


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

# Save the all-riders electric bike heatmap
ggsave(filename = file.path(output_dir, "electric_bike_usage_all.png"), 
       plot = plot_electric_all, width = 10, height = 6, dpi = 300)

# Save the casual-riders electric bike heatmap
ggsave(filename = file.path(output_dir, "electric_bike_usage_casual.png"), 
       plot = plot_electric_casual, width = 10, height = 6, dpi = 300)

