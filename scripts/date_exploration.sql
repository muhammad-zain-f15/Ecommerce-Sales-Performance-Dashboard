-- Date Exploration 
-- Identify the earliest and latest dates
-- find the date of first and last orders
SELECT
min(order_date) as first_order_date,
max(order_date) as last_order_date
FROM gold.fact_sales;

-- How many months of sales data are available?
SELECT
DATEDIFF(month,min(order_date),max(order_date)) as order_range_months
FROM gold.fact_sales;

-- find the youngest and the oldest customer
SELECT
min(birthdate) as oldest_customer_bdate,
DATEDIFF(year,min(birthdate),getdate()) as oldest_age,
max(birthdate) as youngest_customer_bdate,
datediff(year,max(birthdate),getdate()) as youngest_age
from gold.dim_customers;
