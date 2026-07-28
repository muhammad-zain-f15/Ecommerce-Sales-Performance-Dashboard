-- find the total sales
SELECT
sum(sales_amount) total_sales
FROM gold.fact_sales;
-- find how many items are sold
SELECT
	SUM(quantity) as total_quantity
FROM gold.fact_sales;
-- find the average selling price
SELECT
avg(sales_amount) avg_selling_price
FROM gold.fact_sales;
-- find the total no of orders
SELECT
count(distinct order_number) as total_orders
FROM gold.fact_sales;
-- find the total no of products
SELECT
count(distinct product_name) as total_products
FROM gold.dim_products;
-- find the total no of customers
SELECT
count(distinct customer_key) as total_customers
FROM gold.dim_customers;
-- find the total no of customers that has placed order
SELECT
count(distinct customer_key) as total_customers
FROM gold.fact_sales;

-- report to show all business key metrics 
SELECT 'Total Sales' as measure_name, sum(sales_amount) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' as measure_name, sum(quantity) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Avg Selling Price' as measure_name, avg(sales_amount) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders' as measure_name, count(distinct order_number) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Products' as measure_name, count(distinct product_name) as measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Customers' as measure_name, count(distinct customer_key) as measure_value FROM gold.fact_sales
