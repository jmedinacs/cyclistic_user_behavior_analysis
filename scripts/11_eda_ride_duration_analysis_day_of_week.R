# 11_eda_ride_duration_analysis_day_of_week
# This script continues our analysis of ride duration after the day_of_week
# column is created. This will now tackle the analysis of rides based on
# hour of day and day of the week.

# Load configurations and variables.
source("config.R")

# Load the most recent version of the cleaned_data RDS
cleaned_data <- readRDS(cleaned_data_rds)

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

print(min(cleaned_data$ride_duration))

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
ggsave(filename = file.path(output_dir, "median_ride_duration_by_day.png"), 
       plot = plot_median_duration, width = 8, height = 6, dpi = 300)
