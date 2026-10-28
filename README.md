#SQL Data Cleaning: Layoffs Dataset

📌 Project Overview
This project focuses on cleaning and preparing a layoffs dataset using SQL. The goal was to transform raw, inconsistent data into a clean and reliable dataset suitable for further analysis and visualization.

Data cleaning is an essential step in the data analysis process, as it helps improve data quality, accuracy, and consistency before extracting meaningful insights.

🎯 Project Objectives
Remove duplicate records from the dataset.
Standardize inconsistent data entries.
Handle null and blank values.
Identify and remove unnecessary or invalid records.
Prepare the dataset for further exploratory data analysis (EDA).
🛠️ Tools & Technologies
SQL — Data cleaning and transformation.
MySQL — Database management and query execution.
GitHub — Project documentation and version control.

🧹 Data Cleaning Process
The project involved the following steps:
1. Data Exploration
Examined the raw dataset to understand its structure.
Reviewed columns, data types, and existing data inconsistencies.
2. Removing Duplicates
Identified duplicate records using SQL queries.
Used window functions such as ROW_NUMBER() to detect duplicates.
Removed duplicate entries to improve data integrity.
3. Standardizing Data
Cleaned inconsistent text values.
Standardized company names, industry categories, and country information where necessary.
Corrected formatting inconsistencies in relevant columns.
4. Handling Null and Blank Values
Identified missing and blank values across relevant columns.
Replaced blank entries with NULL where appropriate.
Populated missing values when reliable information could be inferred from related records.
5. Removing Unnecessary Data
Reviewed records with missing or invalid information.
Removed records that were not useful for the intended analysis.
6. Final Data Validation
Reviewed the cleaned dataset for remaining duplicates and inconsistencies.
Ensured the data was better structured and ready for analysis.

💡 SQL Skills Demonstrated
This project demonstrates practical experience with:
SELECT and WHERE statements
GROUP BY and aggregate functions
UPDATE and DELETE statements
Common Table Expressions (CTEs)
Window functions, including ROW_NUMBER()
TRIM() and string manipulation
Handling NULL values
Data validation and transformation

📂 Project Files
layoffs.csv — Raw layoffs dataset.
Data Cleaning with MYSQL.sql — SQL queries used to clean and transform the dataset.


📊 Project Outcome
The project resulted in a cleaner and more consistent layoffs dataset by addressing duplicate records, inconsistent values, missing information, and data quality issues.

The cleaned dataset can serve as a foundation for exploratory data analysis, business reporting, and further investigation into company layoffs across industries, countries, and time periods.

🚀 Key Takeaways
Gained hands-on experience cleaning real-world data using SQL.
Improved understanding of data quality and data integrity.
Practiced using CTEs and window functions to identify duplicate records.
Developed a structured approach to preparing datasets for analysis.
👤 Author

AwwalTheAnalyst

Aspiring Data Analyst | SQL | Data Cleaning | Data Analysis

⭐ If you find this project useful, feel free to star the repository!
