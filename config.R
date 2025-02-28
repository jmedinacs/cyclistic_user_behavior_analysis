# Load required packages
library(here)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(knitr)
library(lubridate)

# Define base project directory, location of config.R considered base location
project_dir <- here::here()

# Define paths for raw and processed data
data_dir <- file.path(project_dir, "data")
raw_data_dir <- file.path(data_dir, "raw")
processed_data_dir <- file.path(data_dir, "processed")

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

# Define paths for processed dataset storage
combined_raw_data_file <- file.path(processed_data_dir, "cyclistic_combined_raw.rds")
cleaned_data_csv <- file.path(processed_data_dir, "cyclistic_cleaned.csv")
cleaned_data_rds <- file.path(processed_data_dir, "cyclistic_cleaned.rds")
cleaned_data_file <- file.path(processed_data_dir, "cyclistic_cleaned.csv")

# Define analysis parameters
time_bin_size <- 2  # Bin time-of-day into 2-hour intervals
timezone = "America/Chicago"

# Debug flag for printing directory paths
show_paths <- FALSE  # Set to TRUE to print paths

if (show_paths) {
  print(paste("Project Directory:", project_dir))
  print(paste("Raw Data Directory:", raw_data_dir))
  print(paste("Processed Data Directory:", processed_data_dir))
  print(paste("Scripts Directory:", scripts_dir))
  print(paste("Reports Directory:", reports_dir))
  print(paste("Output Directory:", output_dir))
}
