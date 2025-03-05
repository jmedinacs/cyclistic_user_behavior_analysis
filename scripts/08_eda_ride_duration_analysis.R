# 08_eda_ride_duration_analysis
# This script contains the full EDA of the ride duration column and how it 
# pertains to casual versus annual membership riders.

# Load configurations and variables
source("config.R")

# Load most recent cleaned dataset
cleaned_data <- readRDS(cleaned_data_rds) 

# This section computes and compares the membership count

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

# Plot Bar Chart
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

# Save the Plot
ggsave(filename = file.path(output_dir, "casual_vs_member_distribution.png"), 
       plot = p, width = 8, height = 6, dpi = 300)

cat("\nPlot saved successfully!\n")


# Study the summary of ride_duration of casual riders vs annual member riders
summary(cleaned_data$ride_duration[cleaned_data$member_casual=="casual"])
summary(cleaned_data$ride_duration[cleaned_data$member_casual == "member"])



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
  theme_minimal()




# Calculate the average ride duration for each user type
avg_ride_duration <- cleaned_data %>%
  group_by(member_casual) %>%
  summarise(avg_duration = mean(ride_duration))

# Create a bar chart to compare the average ride duration
ggplot(avg_ride_duration, aes(x = member_casual, y = avg_duration, fill = member_casual)) +
  geom_bar(stat = "identity", width = 0.6) +
  geom_text(aes(label = round(avg_duration, 2)), vjust = -0.5, size = 5, fontface = "bold") +
  labs(
    title = "Average Ride Duration by User Type",
    x = "User Type",
    y = "Average Ride Duration (minutes)",
    fill = "User Type"
  ) +
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "darkblue")) +
  theme_minimal() +
  expand_limits(y = max(avg_ride_duration$avg_duration) * 1.15) +  # Adds space above bars
  theme(
    plot.title = element_text(hjust = 0.5, margin = margin(b = 10)),  # Adds space below title
    plot.margin = margin(20, 20, 20, 20)  # Adds overall padding
  )



# Visualization of member rides by category (binned duration)

# Summarize ride category counts and percentages for use in visualization
ride_category_counts <- cleaned_data %>% 
  group_by(ride_category) %>% 
  summarise(count=n()) %>% 
  mutate(percent=round((count/sum(count))*100,2))

# Create a bar plot with count lables and percentage labels
ggplot(ride_category_counts, aes(x=ride_category,y=count,fill=ride_category)) +
  geom_bar(stat = "identity") + # Using the actual counts
  geom_text(aes(label=paste0(count,"(",percent,"%)")),
            vjust=-0.5, size=5, fontface="bold") +
  labs(
    title="Ride Duration Categories",
    x="Ride Duration Category",
    y="Number of Rides",
    fill="Ride Duration"
  ) +
  theme_minimal() +
  expand_limits(y=max(ride_category_counts$count)*1.1) 
# Line above adds space above the bars for labels









unique(cleaned_data$rideable_type)
table(cleaned_data$rideable_type)


table(cleaned_data$rideable_type[cleaned_data$member_casual=="casual"])
table(cleaned_data$rideable_type[cleaned_data$member_casual=="member"])

table(cleaned_data$member_casual)



