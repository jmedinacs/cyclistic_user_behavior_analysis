# CLEANING_trim_spaces_on_char_columns
# Remove starting, trailing, and repeated white spaces in the char columns.

# LOad configurations and variables.
source("config.R")

# Load cleaned dataset
df <- readRDS(cleaned_data_rds)

# Standardize all character columns: Trim whitespace
char_cols <- c("ride_id", "rideable_type", "start_station_name", 
               "start_station_id", "end_station_name", "end_station_id", 
               "member_casual")

df[char_cols] <- lapply(df[char_cols], trimws)

# Ensure `member_casual` is fully standardized (lowercase)
df$member_casual <- tolower(df$member_casual)

# Save the final cleaned dataset
saveRDS(df, file = cleaned_data_rds)
write.csv(df, file = cleaned_data_csv, row.names = FALSE)

cat("\nFinal Cleaning Step Completed: Trimmed whitespace & standardized text columns.\n")
