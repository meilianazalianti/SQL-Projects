# Layoffs Analysis

## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Data Cleaning/Preparation](#data-cleaningpreparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Result/Findings](#resultfindings)
- [Recommendation](#recommendations)

  
### Project Overview
This project explores the trend of tech layoffs by cleaning and analyzing a dataset containing layoff events from various companies across the globe. It covers the process of removing duplicates, handling null values, standardizing inconsistent data, and generating key insights on layoff trends over time, by country, company, and industry.


### Data Sources
Layoffs Dataset: This dataset, stored as layoffs.csv, contains information on company layoffs including company name, location, industry, number and percentage of employees laid off, funding stage, and other details.

### Tools
- SQL (MySQL): for data cleaning, transformation, and analysis
- DBMS used: MySQL Workbench 

### Data Cleaning/Preparation
Performed several key cleaning steps:
- Removed duplicate entries using ROW_NUMBER()
- Trimmed extra spaces from text columns
- Standardized inconsistent values (e.g., "Crypto-related" → "Crypto")
- Converted string-formatted dates into proper DATE format
- Filled missing industry values by referencing existing company info
- Dropped rows where both total_laid_off and percentage_laid_off were NULL

### Exploratory Data Analysis
Analyzed the cleaned dataset to uncover insights:
- Top companies and industries with the most layoffs
- Layoffs by year and month
- Countries most affected
- Layoff trends by company stage (e.g., Post-IPO, Seed, Series A)
- Yearly top 5 companies with highest layoffs using window functions
  
### Result/Findings
- The companies with the highest number of layoffs include Amazon, Google, Meta, Salesforce, and Microsoft.
- The most affected industries are Consumer, Retail, Others, Transportation, and Finance.
- Top countries with the highest layoffs are the United States, India, Netherlands, Sweden, and Brazil.
- Layoffs peaked in 2022 with over 160,000 employees affected, followed by a slight drop in 2023 (125,677). The lowest was in 2021 (15,823).
- Company with the highest layoffs each year:
  - 2020: Uber
  - 2021: Bytedance
  - 2022: Meta
  - 2023: Google
- A noticeable trend shows that tech giants dominate layoff statistics, suggesting industry-wide restructuring or cost-cutting in response to post-pandemic shifts and over-hiring during the tech boom of 2020–2021.
 
  
### Recommendations
- Strategic Workforce Planning: Companies should avoid aggressive over-hiring during periods of rapid growth and instead align hiring with long-term, sustainable goals to reduce the risk of mass layoffs.
- Reskilling Initiatives: Industries heavily affected by layoffs, such as Consumer and Retail, should invest in employee upskilling programs to increase workforce adaptability and long-term resilience.
