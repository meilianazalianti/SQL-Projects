# 🛒 Gold Sales Data Analysis

This project performs advanced SQL-based analysis on a simulated data warehouse composed of sales, product, and customer data. The database follows a dimensional model, using **fact** and **dimension** tables:
- `gold_fact_sales`
- `gold_dim_customers`
- `gold_dim_products`

## Dataset Overview
| Table              | Description                           |
|--------------------|---------------------------------------|
| `gold_fact_sales`  | Transaction-level sales data          |
| `gold_dim_customers` | Customer profile data               |
| `gold_dim_products` | Product profile and cost data        |

---

## Analysis Breakdown

### 1. Changes Overtime Analysis
Analyze how sales, customers, and quantities evolved over:
- **Yearly**
- **Monthly**
- **Year-Month combinations**

> Techniques: Aggregation with `GROUP BY`, chronological ordering.

### 2. Cumulative Analysis
Track cumulative sales trends over time using:
- Monthly and yearly total sales
- Moving averages of price

> Techniques: `WINDOW FUNCTION` with `SUM() OVER()`, `AVG() OVER()`

### 3. Performance Analysis
Evaluate product performance annually:
- Detect **Above/Below Average** products
- Measure **Year-over-Year** sales difference

> Techniques: `LAG()`, `CASE WHEN`, `AVG() OVER()`, `JOIN` with products

### 4. Proportional Analysis
Break down total sales by product category, including:
- Total sales per category
- Percentage share of each category

> Techniques: Common Table Expressions (CTE), `SUM() OVER()`, `ROUND()`

### 5. Data Segmentation
Segment products and customers based on:
- **Cost Ranges**: Below 100, 100–500, etc.
- **Customer Lifetime Value**: VIP, Regular, New

> Techniques: `CASE WHEN`, `TIMESTAMPDIFF()`, data cleaning with `NULL`

### 6. Reporting via SQL Views
Two analytical views are created:
#### `gold_report_customers`
Includes:
- Demographic segmentation (age group)
- Customer performance (AOV, recency, category)
- Lifetime and activity stats

#### `gold_report_products`
Includes:
- Product segmentation (category, subcategory)
- Performance classification (High, Mid, Low)
- Metrics like monthly revenue, recency, AOV

> Techniques: `VIEW`, multiple CTE layers, KPI calculations

---
## Key Findings
1. Annual Performance Summary
The year 2013 consistently shows the highest performance across key metrics:
- Total Sales: Highest in 2013.
- Total Customers: Highest in 2013.
- Total Quantity: Highest in 2013.
This indicates a peak in overall business activity during this specific year.

2. Monthly Performance Summary
Aggregating data across all years, December stands out as the strongest month:
- Total Sales: Highest in December.
- Total Customers: Highest in December.
- Total Quantity: Highest in December.
This suggests a strong seasonal pattern, likely driven by holiday shopping or year-end promotions.

3. Proportional Analysis: Category Contribution
   
| Category    | Contribution to Total Sales |
|-------------|----------------------------|
| Bikes       | 96.46%                     |
| Accessories | 2.39%                      |
| Clothing    | 1.16%                      |

The Bikes category overwhelmingly dominates total sales, contributing over 96%, while Accessories and Clothing account for a minimal share. This highlights a strong product dependency on bikes and may suggest opportunities for diversification or focused strategies to grow the other categories.


---
## Recommendations
- Boost December sales with targeted promos and increased inventory, as December consistently marks the peak sales month.
- Focus on Bikes as core product (96% sales) and explore bundling with Accessories and Clothing.
- Review Accessories and Clothing performance, considering promotional strategies or product changes due to their low sales contribution.
- Analyze 2013 success factors to replicate winning strategies.
---

## Skills Demonstrated
- SQL for Analytics & Reporting
- Window Functions
- Data Cleaning and Preprocessing
- Customer & Product Segmentation
- Cumulative and Temporal Analysis
- KPI & Performance Classification
- Creating SQL Views for Reporting

---


