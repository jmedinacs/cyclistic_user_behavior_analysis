# 🚲 Google Data Analytics Capstone Project: Cyclistic Customer Access Analysis

This project is part of the **Google Data Analytics Professional Certificate Capstone**. It aims to analyze bike-share data from **Cyclistic** to provide actionable insights for increasing customer memberships.

---

## 📌 Project Overview

This repository documents and demonstrates the author's ability to:
- 🧹 **Clean**: Prepare and process raw data for analysis.
- 📊 **Analyze**: Uncover trends, patterns, and user behavior insights.
- 📈 **Visualize**: Create meaningful visualizations to support findings.
- 📝 **Report**: Communicate results clearly and effectively through structured reporting.
- 💡 **Recommend**: Propose data-driven strategies to solve a given business problem.

---

## 🎯 Business Problem

Cyclistic is seeking to increase its membership subscriptions. The objective of this analysis is to uncover insights from historical ride data that can inform strategies for converting casual riders into long-term members.

### 🔍 Business Task:
> **What are the significant differences in how casual riders and annual members use Cyclistic bikes, and how can we convince casual riders to become annual members?**

---

## 🔍 Data Source

The dataset used for this project comes from [**Divvy Bikes**](https://divvybikes.com/system-data), a bike-share service operating in Chicago. The data is used in accordance with the [Divvy Bikes Data License Agreement](https://divvybikes.com/data-license-agreement).

---

## 📂 Download the Cleaned Dataset

Due to GitHub's file size limitations, the cleaned and combined dataset is hosted on **Google Drive**.

➡️ [Download Cleaned Dataset](https://drive.google.com/file/d/1Sy7tbEqrMH42J0hrRB24qPHF75l1qxY6/view?usp=sharing)

### 📥 Steps to Use:
1. Download the dataset from the link above.
2. Place the downloaded file in the `cleaned_data/` folder inside the project directory.
3. Run the analysis scripts as instructed in the repository documentation.

---

## 🛠️ Tools and Technologies

- **R**: Data cleaning, transformation, and analysis
- **R Markdown**: Documentation of analysis steps and insights
- **Google Sheets**: Logging data cleaning decisions and tracking progress
- **Tableau**: Advanced visualizations and dashboards
- **Git & GitHub**: Version control and project collaboration

---

## 🛠️ Data Cleaning Process

The dataset underwent several cleaning steps to ensure accuracy and consistency:

- ✅ Verified that all datasets had consistent column names and data types.
- 🗑️ Removed duplicate records based on `ride_id`, `started_at`, and `ended_at`.
- 🕒 Converted date and time columns to the correct `POSIXct` format.
- 📍 Handled missing values in latitude and longitude by cross-referencing station names.
- 📆 Removed rides with corrupted or invalid timestamps.

For a full breakdown of the data cleaning process and versioned logs, refer to the detailed [Cleaning Log](https://docs.google.com/spreadsheets/d/your-google-sheet-id) hosted on Google Sheets.

---
### 📚 Citation

If you use this data or refer to this project, please cite the dataset as follows:

> Divvy Bikes. (n.d.). *Divvy Bike Sharing Data.* Retrieved from [https://divvybikes.com/system-data](https://divvybikes.com/system-data)

Additionally, acknowledge the usage terms by linking to the [Divvy Bikes Data License Agreement](https://divvybikes.com/data-license-agreement).
---

## 🚀 How to Use This Repository

### 📥 Clone the Repository

1. **Clone this repository:**
   ```bash
   git clone https://github.com/jmedinacs/cyclistic_user_analysis.git
