# 🛒 Gold Sales Data Analysis

This project performs advanced SQL-based analysis on a simulated data warehouse composed of sales, product, and customer data. The database follows a dimensional model, using **fact** and **dimension** tables:
- `gold_fact_sales`
- `gold_dim_customers`
- `gold_dim_products`

## 📁 Dataset Overview
| Table              | Description                           |
|--------------------|---------------------------------------|
| `gold_fact_sales`  | Transaction-level sales data          |
| `gold_dim_customers` | Customer profile data               |
| `gold_dim_products` | Product profile and cost data        |

---

## 🔍 Analysis Breakdown

### 1. 📊 Changes Overtime Analysis
Analyze how sales, customers, and quantities evolved over:
- **Yearly**
- **Monthly**
- **Year-Month combinations**

> Techniques: Aggregation with `GROUP BY`, chronological ordering.

### 2. 📈 Cumulative Analysis
Track cumulative sales trends over time using:
- Monthly and yearly total sales
- Moving averages of price

> Techniques: `WINDOW FUNCTION` with `SUM() OVER()`, `AVG() OVER()`

### 3. 🚀 Performance Analysis
Evaluate product performance annually:
- Detect **Above/Below Average** products
- Measure **Year-over-Year** sales difference

> Techniques: `LAG()`, `CASE WHEN`, `AVG() OVER()`, `JOIN` with products

### 4. 🧮 Proportional Analysis
Break down total sales by product category, including:
- Total sales per category
- Percentage share of each category

> Techniques: Common Table Expressions (CTE), `SUM() OVER()`, `ROUND()`

### 5. 🧩 Data Segmentation
Segment products and customers based on:
- **Cost Ranges**: Below 100, 100–500, etc.
- **Customer Lifetime Value**: VIP, Regular, New

> Techniques: `CASE WHEN`, `TIMESTAMPDIFF()`, data cleaning with `NULL`

### 6. 📑 Reporting via SQL Views
Two analytical views are created:
#### ✅ `gold_report_customers`
Includes:
- Demographic segmentation (age group)
- Customer performance (AOV, recency, category)
- Lifetime and activity stats

#### ✅ `gold_report_products`
Includes:
- Product segmentation (category, subcategory)
- Performance classification (High, Mid, Low)
- Metrics like monthly revenue, recency, AOV

> Techniques: `VIEW`, multiple CTE layers, KPI calculations

---

## 🧹 Data Cleaning Actions
- Replaced blank `order_date` and `birthdate` with `NULL` for proper filtering.
- Ensured joins were meaningful by using `LEFT JOIN`.

---

## 🧠 Skills Demonstrated
- SQL for Analytics & Reporting
- Window Functions
- Data Cleaning and Preprocessing
- Customer & Product Segmentation
- Cumulative and Temporal Analysis
- KPI & Performance Classification
- Creating SQL Views for Reporting

---


