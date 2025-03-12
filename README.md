# Cyclistic Customer Behavior Analysis

## **Project Overview**
Cyclistic, a bike-share program in Chicago, is looking to increase **annual membership subscriptions** by converting casual riders into long-term members. The goal of this project is to analyze customer behavior to provide insights that will help Cyclistic **develop a marketing strategy** aimed at encouraging casual riders to purchase annual memberships.

---

## **Business Problem**
### **Objective**
To understand how **annual members and casual riders** use Cyclistic bikes differently and what insights can be leveraged to encourage casual riders to purchase an annual membership.

### **Key Research Questions**
1. **Ride Duration Differences**: How do ride durations differ between casual and member riders?
2. **Time-Based Usage Trends**: When do casual riders use the service most compared to members?
3. **Bike Type Preferences**: Are casual riders more likely to use a specific bike type compared to members?
4. **Marketing Insights**: What ride behaviors suggest opportunities for membership conversion?

### **Excluded from Analysis**
- **Station Popularity & Location-Based Analysis**
  - The dataset **lacks complete station data** for every ride.
  - Station availability is **not uniform**, and **docks per station vary**, making comparisons misleading.
  - Since we **don’t have route tracking data**, we **cannot evaluate where riders went between start and end stations**.
  - Given these limitations, **station-based insights will not be included** in this analysis.

---

## **Data Sources**
- Monthly trip data from **January 2024 - January 2025**.
- Data includes **ride start and end times, bike type, and user type (casual/member)**.
- **Financial information is NOT provided in the dataset** but will be referenced using publicly available pricing details.
- **Original Data Source**: [Divvy Bikes System Data](https://divvybikes.com/system-data) (Divvy Bikes, a subsidiary of Lyft, releases this dataset under a public data-sharing agreement).

---

## **Data Cleaning Process**
The **data cleaning process** ensured accuracy, consistency, and usability for analysis. The full **cleaning log** is available in **[Google Sheets](https://docs.google.com/spreadsheets/d/e/2PACX-1vRsdTcZUKUd6BXzZpSvwYAP8hJBCRDVilBmd9sOeeCMLLNRvnmaT5X8OIv_txawY_CcYy0frfpHOpTK/pubhtml)**.

### **Cleaning Steps:**
- **Column Standardization**
  - Verified **consistent column names** and **data types** across all datasets (Jan 2024 - Jan 2025).

- **Date & Time Processing**
  - Converted `started_at` and `ended_at` into **POSIXct format** for accurate time calculations.

- **Handling Missing Values**
  - Identified that ~20% of data was missing **start_station_name, start_station_id, end_station_name, and end_station_id**.
  - **Decision:** Kept these rows for **ride duration and time-based analysis** but excluded them from any station-related analysis.

- **Ride Duration Calculation & Validation**
  - Computed `ride_duration` using `ended_at - started_at`.
  - Removed invalid rides:
    - **Negative ride durations**
    - **Rides ≥ 1440 minutes** (as Divvy considers them lost/stolen)

- **Outlier Treatment**
  - Set **130 minutes as an upper bound** for ride duration-focused analysis while keeping all data available.

- **Final Cleaned Dataset**
  - The **cleaned dataset** retains all valid rides for analysis, with **outliers flagged but not removed** for flexibility in further exploration.

---

## **Exploratory Data Analysis (EDA)**
🚧 **Work in Progress** 🚧

Next, we will conduct **exploratory data analysis (EDA)** to uncover key behavioral patterns, focusing on:
- Ride duration distribution
- Bike type preferences
- Weekly and hourly ride trends
- Seasonal trends

This section will be updated once EDA is completed.

---

## **Project Deliverables**
1. **Data Cleaning Log**: Complete record of all transformations and decisions made during data preparation.
2. **Exploratory Data Analysis (EDA) Report**: Visualizations and insights into ride duration, bike type usage, and time-based trends.
3. **Final Report**: Business recommendations based on findings, focused on increasing **membership conversions**.

---

## **Next Steps**
- Conduct **EDA** to analyze patterns and validate insights.
- Develop **visualizations** to compare casual vs. member riders.
- Begin structuring **marketing recommendations** based on behavioral insights.

🚀 Stay tuned for updates as we progress toward delivering actionable insights for Cyclistic!

