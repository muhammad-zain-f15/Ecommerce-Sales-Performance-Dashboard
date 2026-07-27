/*
Product Report
	- This report consolidates key product metrics and behaviors

	Highlights:
	1.Gather essential fields such as product name, category,sub-category and cost
	2. segment products by revenue to identify high Performers, mid-range and low performers
	3. Aggregate product level metrics
		-total orders
		-total quantity sold
		-total sales
		-total customers(unique)
		-lifespan (in months)
		-total profit
	4. calculate valuable KPIs:
		-recency (months since last order)
		-average order revenue
		-average monthly revenue

*/


/*
1. Base query: select the relevant columns for our product report
*/

create view gold.products_report as
with base_query as
(
	SELECT
		f.order_number,
		f.customer_key,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		f.price,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost,

		(f.price-p.cost)*quantity as profit
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	on f.product_key = p.product_key
	WHERE order_date is not null
),
aggregated_cols as (
select
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	count(distinct order_number) as total_orders,
	sum(quantity) as total_quantity,
	sum(sales_amount) as total_sales,
	sum(profit) as total_profit,
	sum(distinct customer_key) as total_customers,
	min(order_date) as first_order_date,
	max(order_date) as last_order_date,
	datediff(month,min(order_date),max(order_date)) as lifespan
from base_query
GROUP BY
product_key,
product_name,
category,
subcategory,
cost)
select
product_key,
product_name,
category,
subcategory,
cost,
CASE 
	WHEN total_sales > 50000 then 'High-Performers'
	WHEN total_sales >= 10000 then 'Mid-Range'
	ELSE 'Low-Performers'
end as product_segment,
total_orders,
total_sales,
total_quantity,
total_profit,
total_customers,
lifespan,
DATEDIFF(month,last_order_date,getdate()) recency,
case 
	when total_orders = 0 then 0
	else total_sales/total_orders
end as average_order_revenue,
case
	when lifespan = 0 then total_sales
	else total_sales/lifespan
end as average_monthly_revenue
from aggregated_cols;

