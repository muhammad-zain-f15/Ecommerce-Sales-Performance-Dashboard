-- Analyse sales performance over time

-- 1. sales performance over years
SELECT 
	YEAR(order_date) as year,
	sum(sales_amount) as total_sales,
	count(DISTINCT customer_key) as total_customers,
	sum(quantity) as total_quantity
from gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
order by YEAR(order_date);

-- 2. sales performance over years and months
SELECT 
	DATETRUNC(month,order_date) as order_date,
	sum(sales_amount) as total_sales,
	count(DISTINCT customer_key) as total_customers,
	sum(quantity) as total_quantity
from gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
order by DATETRUNC(month,order_date);
