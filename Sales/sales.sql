USE datawarehouseanalytics;

-- Changes Overtime Analysis

SELECT order_date,sales_amount
FROM gold_fact_sales
WHERE order_date != ''
ORDER BY order_date;

SELECT YEAR(order_date) AS order_year,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_cust,
SUM(quantity) AS total_quantity
FROM gold_fact_sales
WHERE order_date != ''
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

SELECT MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_cust,
SUM(quantity) AS total_quantity
FROM gold_fact_sales
WHERE order_date != ''
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);

SELECT YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_cust,
SUM(quantity) AS total_quantity
FROM gold_fact_sales
WHERE order_date != ''
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date);

-- Cumulative Analysis

SELECT *,SUM(total_sales) OVER(ORDER BY order_date) AS total_cum
FROM 
(SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS order_date, 
SUM(sales_amount) AS total_sales
FROM gold_fact_sales
WHERE order_date != ''
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
) AS t;

SELECT *,SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS total_cum
FROM 
(SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS order_date, 
SUM(sales_amount) AS total_sales
FROM gold_fact_sales
WHERE order_date != ''
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
) AS t;

SELECT *,SUM(total_sales) OVER(ORDER BY order_date) AS total_cum
FROM 
(SELECT YEAR(order_date) AS order_date, 
SUM(sales_amount) AS total_sales
FROM gold_fact_sales
WHERE order_date != ''
GROUP BY YEAR(order_date)
) AS t;

SELECT *,SUM(total_sales) OVER(ORDER BY order_date) AS total_cum,
AVG(average_price) OVER(ORDER BY order_date) AS moving_average_price
FROM 
(SELECT YEAR(order_date) AS order_date, 
SUM(sales_amount) AS total_sales, 
AVG(price) AS average_price
FROM gold_fact_sales
WHERE order_date != ''
GROUP BY YEAR(order_date)
) AS t;

-- Performance Analysis
SELECT *
FROM gold_fact_sales;

SELECT *
FROM gold_dim_products;

WITH yearly_pruduct_sales AS
(SELECT YEAR(s.order_date) AS order_year,
p.product_name, 
SUM(s.sales_amount) AS current_sales
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
ON s.product_key = p.product_key
WHERE s.order_date != ''
GROUP BY YEAR(s.order_date),p.product_name)
SELECT *, AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE
WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN "Below Average"
WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN "Above Average"
WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) = 0 THEN "Average"
END AS indicator
FROM yearly_pruduct_sales
ORDER BY 2,1;

WITH yearly_product_sales AS
(SELECT YEAR(s.order_date) AS order_year,
p.product_name, 
SUM(s.sales_amount) AS current_sales
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
ON s.product_key = p.product_key
WHERE s.order_date != ''
GROUP BY YEAR(s.order_date),p.product_name)
SELECT *, LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS prev_sales,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_ps,
CASE
WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN "Decrease"
WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN "Increase"
ELSE "No Change"
END AS indicator
FROM yearly_product_sales
ORDER BY 2,1;

-- Proportional Analysis
SELECT p.category,
SUM(sales_amount) AS total_sales
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.category;

WITH proportional AS 
(SELECT p.category,
SUM(sales_amount) AS total_sales
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
)
SELECT *,SUM(total_sales) OVER() AS total, 
CONCAT(ROUND((total_sales/SUM(total_sales) OVER())*100,2),'%') AS percentage_of_total
FROM proportional
ORDER BY total_sales DESC;

-- Data Segmentation
WITH product_segments AS
(SELECT 
product_key,
product_name, 
cost,
CASE
WHEN cost < 100 THEN 'Below 100'
WHEN cost BETWEEN 100 AND 500 THEN '100-500'
WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
ELSE 'Above 1000'
END AS cost_range
FROM gold_dim_products)
SELECT 
cost_range, 
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

UPDATE gold_fact_sales
SET order_date = NULL
WHERE order_date = '';

WITH customer_segments AS
(SELECT 
s.customer_key,
SUM(sales_amount) AS total_spending,
MIN(order_date) AS first_purcase,
MAX(order_date) AS last_purcase,
TIMESTAMPDIFF(MONTH, MIN(order_date), 
MAX(order_date)) AS lifespan
FROM gold_fact_sales s
LEFT JOIN gold_dim_customers c
ON s.customer_key = c.customer_key
GROUP BY s.customer_key)
SELECT 
customer_key,
total_spending,
lifespan,
CASE
WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
ELSE 'New'
END AS customer_category
FROM customer_segments;



WITH customer_segments AS
(SELECT 
s.customer_key,
SUM(sales_amount) AS total_spending,
MIN(order_date) AS first_purcase,
MAX(order_date) AS last_purcase,
TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold_fact_sales s
LEFT JOIN gold_dim_customers c
ON s.customer_key = c.customer_key
GROUP BY s.customer_key)
SELECT 
customer_category,
COUNT(customer_key) AS total_customers
FROM
(SELECT customer_key,
CASE
WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
ELSE 'New'
END AS customer_category
FROM customer_segments) AS t
GROUP BY customer_category
ORDER BY total_customers DESC;

-- Build Customer Report
SELECT birthdate
FROM gold_dim_customers
WHERE birthdate ='';

UPDATE gold_dim_customers
SET birthdate = NULL
WHERE birthdate = '';

SELECT birthdate
FROM gold_dim_customers
WHERE birthdate IS NULL;

CREATE VIEW gold_report_customers AS
WITH base_query AS
(SELECT s.order_number, 
s.product_key, 
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(first_name,' ',last_name) AS customer_name, 
TIMESTAMPDIFF(YEAR,birthdate,NOW()) AS age
FROM gold_fact_sales s
LEFT JOIN gold_dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
AND birthdate IS NOT NULL), 
customer_aggregation AS
(SELECT customer_key,
customer_number,
customer_name, 
age,
COUNT(order_number) AS total_orders,
COUNT(DISTINCT product_key) AS total_products,
 SUM(quantity) AS total_quantity,
 SUM(sales_amount) AS total_sales,
MAX(order_date) AS last_order,
TIMESTAMPDIFF(MONTH,MIN(order_date),
MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
customer_key,
customer_number,
customer_name, 
age)
SELECT 
customer_key,
customer_number,
customer_name, 
age,CASE
WHEN age < 20 THEN 'Under 20'
WHEN age BETWEEN 20 AND 29 THEN '20-29'
WHEN age BETWEEN 30 AND 39 THEN '30-39'
WHEN age BETWEEN 40 AND 49 THEN '40-49'
ELSE '50 and Above'
END AS age_group,
CASE
WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
ELSE 'New'
END AS customer_category,
last_order,
TIMESTAMPDIFF(MONTH,last_order,NOW()) AS recency,
total_orders,
total_products,
total_quantity,
total_sales,
lifespan,
CASE
WHEN total_orders = 0 THEN 0
ELSE ROUND(total_sales/total_orders,0) 
END AS aov,
CASE
WHEN lifespan = 0 THEN 0
ELSE ROUND(total_sales/lifespan,0) 
END AS avg_monthly_spend
FROM customer_aggregation;

CREATE VIEW gold_report_products AS
WITH base_query AS
(SELECT 
s.order_number, 
s.order_date,
s.customer_key,
s.sales_amount,
s.quantity,
p.product_key,
p.product_name, 
p.category, 
p.subcategory,
p.cost
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL), 
product_aggregation AS
(SELECT 
product_key,
product_name,
category,
subcategory,
cost,
TIMESTAMPDIFF(MONTH,MIN(order_date), MAX(order_date)) AS lifespan,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT customer_key) AS total_customers,
 SUM(quantity) AS total_quantity,
 SUM(sales_amount) AS total_sales,
MAX(order_date) AS last_sale,
ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query
GROUP BY 
product_key,
product_name,
category,
subcategory,
cost)
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
last_sale,
TIMESTAMPDIFF(MONTH,last_sale,NOW()) AS recency_in_months,
CASE
WHEN total_sales > 50000 THEN 'High Perfomer'
WHEN total_sales > 10000 THEN 'Mid Range'
ELSE 'Low Performer'
END AS product_range,
lifespan,
total_orders,
total_quantity,
total_sales,
total_customers,
avg_selling_price,
CASE
WHEN total_orders = 0 THEN 0
ELSE ROUND(total_sales/total_orders,0) 
END AS avg_order_revenue,
CASE
WHEN lifespan = 0 THEN 0
ELSE ROUND(total_sales/lifespan,0) 
END AS avg_monthly_revenue
FROM product_aggregation;