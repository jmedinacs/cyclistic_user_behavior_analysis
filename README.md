# Cyclistic Rider Behavior Analysis

**Author**: John Paul Medina  
**Date**: March 2025  
**Role**: Data Analyst / Data Scientist  
**Project Type**: Capstone Portfolio Project  
**Tools Used**: R, ggplot2, dplyr, tidyr, lubridate, Google Sheets, Git/GitHub  

---

## Objective

Analyze rider behavior from a Chicago-based bike-share service to identify **behavioral differences between casual riders and annual members**, and develop **data-driven recommendations to increase membership conversion**.

---

## Key Insights

- Casual riders take **31–72% longer rides** than members on average.
- Casual riders are most active on **weekends**, but also ride during **weekday commute hours**, suggesting they include **local residents**.
- Both rider types **prefer eBikes**, especially for **medium-length rides**.
- Ridership is **highly seasonal**, peaking in **late summer**.

---

## Recommendations

1. **Market cost savings** of membership pricing over casual per-ride cost. 
2. **Market cost savings** of membership rates for frequent **eBike** usage. 
3. **Plan marketing campaigns and promotions** around **seasonal** trends.

---

## 🗂️ Data Overview

- Source: [Divvy Trip Data](https://divvybikes.com/system-data)
- Period: **January 2024 – January 2025**
- 5.9M+ records with:
  - Start and end times
  - Ride duration
  - Bike type (classic, electric, scooter)
  - Rider type (casual/member)

---

## 🧹 Data Cleaning

- Unified column names and formats
- Converted timestamps to POSIXct
- Calculated `ride_duration` in minutes
- Removed negative durations and extreme outliers (≥ 1440 mins)
- Checked for data type consistency across the twelve separate raw datasets.
- Checked for missing values and converted them to NA 
- Identified appropriate intervals for ride category (short, medium, long, and extended)
- Binned rides based on identified intervals


📑 **Cleaning Log** (Google Sheets):  
[Data Cleaning Log (Google Sheets)](https://docs.google.com/spreadsheets/d/e/2PACX-1vRsdTcZUKUd6BXzZpSvwYAP8hJBCRDVilBmd9sOeeCMLLNRvnmaT5X8OIv_txawY_CcYy0frfpHOpTK/pubhtml)

🧼 **Cleaning Log (R Markdown)**:  
[Cleaning Log HTML](https://jmedinacs.github.io/cyclistic_user_behavior_analysis/cleaning_log_cyclistic_user_behavior_analysis.html)

---

## 🔍 Exploratory Data Analysis (EDA)

- Ride duration summary stats and distributions
- Weekly and hourly ride heatmaps
- Seasonal usage trends (month-by-month)
- Bike type preference by rider type and ride length

📊 **EDA Report (R Markdown)**:  
[EDA Report HTML](https://jmedinacs.github.io/cyclistic_user_behavior_analysis/eda_log_cyclistic_user_behavior_analysis.html)

---

## 📄 Final Report

Includes executive summary, business recommendations, visuals, and links to logs and supporting documents (with code).

📘 [Download Final Report (PDF)](https://jmedinacs.github.io/cyclistic_user_behavior_analysis/Cyclistic-Rider-Behavior-Analysis-Final-Report.pdf)


---

## ✅ Skills Demonstrated

- Data wrangling & preprocessing
- Exploratory data analysis
- Visualization & storytelling with ggplot2
- Business problem-solving
- Project documentation (Markdown + R Markdown)
- Git/GitHub version control

---

## 📁 Project Structure

```
cyclistic_user_behavior_analysis/
├── data/              # Contains raw and processed data folders that stores the original data and newly processed data
├── visualization      # Visualization of data from cleaning and EDA phase
├── reports/           # Final PDF report, cleaning and eda markdown and HTML files
├── scripts/           # Modular R scripts for analysis
└── README.md          # Project overview (this file)
```

---

## ⚙️ How to Use This Project

### 1. Clone the Repository
```bash
git clone https://github.com/jmedinacs/cyclistic_user_behavior_analysis.git
cd cyclistic_user_behavior_analysis
```

### 2. Open in RStudio
Open the `.Rproj` file in RStudio for full project support and reproducible paths.

### 3. Set Up Environment with `config.R`

All package loading, folder paths, and project settings are modularized in [`config.R`](config.R).  
It runs automatically when sourcing any script.

To install required packages manually, run:

```r
install.packages(c(
  "here", "tidyverse", "ggplot2", "dplyr", "knitr", "lubridate",
  "pander", "forcats", "scales", "kableExtra", "patchwork"
))
```

> Optional: Set `show_paths <- TRUE` in `config.R` to print project paths for debugging.

### 4. Run the Analysis

- Run scripts in `scripts/` in numerical order.
- Outputs will be saved to `output/` and `visualization/`.
- Review final deliverables in the `reports/` folder.

### 5. View Project Logs

These logs include full **R code chunks**, **step-by-step analysis**, and commentary written in **R Markdown**. They demonstrate data wrangling, visualization, and interpretation in context.

- 📄 [Cleaning Log (HTML)](https://jmedinacs.github.io/cyclistic_user_behavior_analysis/cleaning_log_cyclistic_user_behavior_analysis.html) – Includes raw data inspection, timestamp parsing, and missing value strategy
- 📊 [EDA Log (HTML)](https://jmedinacs.github.io/cyclistic_user_behavior_analysis/eda_log_cyclistic_user_behavior_analysis.html) – Includes ride duration, time trends, bike preference, and visual insights
- 📋 [Full Spreadsheet Log (Google Sheets)](https://docs.google.com/spreadsheets/d/e/2PACX-1vRsdTcZUKUd6BXzZpSvwYAP8hJBCRDVilBmd9sOeeCMLLNRvnmaT5X8OIv_txawY_CcYy0frfpHOpTK/pubhtml)

---

## 🚀 About the Author

John Paul Medina is a former mathematics and computer science teacher with 16 years of experience translating complex ideas into clear, accessible, and actionable information. He holds a Bachelor of Arts in Mathematics and a Bachelor of Science in Computer Science with a concentration in AI and Robotics, bringing a strong analytical and technical foundation to his work in data.

Now transitioning into data analytics and data science, John combines analytical thinking, creative problem-solving, and cross-functional communication. He’s known for tackling complex challenges with grit and clarity, and for being the kind of teammate who not only delivers results but uplifts those around him.

This project is part of his professional portfolio and career pivot into data-driven impact.


📧 Contact: 
- [GitHub](https://github.com/jmedinacs)  
- [LinkedIn](https://linkedin.com/in/jpmedinacs)

---