# Load configuration settings and variables
source("config.R")

# Load the most current version of the cleaned_data_rds to ensure accuracy
cleaned_data <- readRDS(cleaned_data_rds)

str(cleaned_data)

summary(cleaned_data$ride_duration)
sum(cleaned_data$ride_duration <= 0)
sum(cleaned_data$ride_duration <= 1)
sum(cleaned_data$ride_duration <= 2)

quantile(cleaned_data$ride_duration, probs = c(0.90, 0.95, 0.99, 0.995, 1))
quantile(cleaned_data$ride_duration, probs = c(0.01, 0.02, 0.03, 0.04, .05))
