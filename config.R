# Load required package
library(here)

# Define base project directory, location of config.R considered base location
project_dir <- here::here()

# Define paths for raw and processed data
raw_data_dir <- file.path(project_dir, "data", "raw")
processed_data_dir <- file.path(project_dir, "data", "processed")

# Define paths for scripts, reports, and outputs
scripts_dir <- file.path(project_dir, "scripts")
reports_dir <- file.path(project_dir, "reports")
output_dir <- file.path(project_dir, "output")

# Create directories if they don’t exist
dir.create(raw_data_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(processed_data_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(scripts_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(reports_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Define dataset filenames
raw_data_file <- file.path(raw_data_dir, "cyclistic_jan2024.csv")
cleaned_data_file <- file.path(processed_data_dir, "cyclistic_cleaned.csv")

# Define analysis parameters
time_bin_size <- 2  # Bin time-of-day into 2-hour intervals

# Print directories to confirm setup
print(paste("Project Directory:", project_dir))
print(paste("Raw Data Directory:", raw_data_dir))
print(paste("Processed Data Directory:", processed_data_dir))
print(paste("Scripts Directory:", scripts_dir))
print(paste("Reports Directory:", reports_dir))
print(paste("Output Directory:", output_dir))
