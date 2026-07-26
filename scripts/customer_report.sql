/*
Customer Report
	- This report consolidates key customer metrics and behaviors

	Highlights:
	1.Gather essential fields such as name, age, and transaction detials
	2. segment customers into categories and age groups
	3. Aggregate customer level metrics
		-total orders
		-total quantity purchased
		-total sales
		-total products
		-lifespan (in months)
		-total profit
	4. calculate valuable KPIs:
		-recency (months since last order)
		-average order value
		-average monthly spend

*/


CREATE VIEW gold.customers_report AS
with base_query as
(
/*
1. Base query: Retrieve core columns from the tables
*/
	SELECT
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	p.cost,
	(f.sales_amount*f.quantity)-(p.cost*f.quantity) as profit,
	c.customer_key,
	CONCAT(c.first_name,' ',c.last_name) as customer_name,
	DATEDIFF(year,birthdate,GETDATE()) as age
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	where order_date is not null
),
customer_aggregation as
(
/*
1. Aggregated query: Perform required aggregations
*/
select
	customer_key,
	customer_name,
	age,
	count(distinct order_number) as total_orders,
	sum(quantity) as total_quantity,
	sum(sales_amount) as total_sales,
	sum(profit) as total_profit,
	count(distinct product_key) as total_products,
	datediff(month,min(order_date),max(order_date)) as lifespan,
	min(order_date) first_order_date,
	max(order_date) last_order_date
FROM base_query
GROUP BY customer_key,customer_name,age
),
final_report as (

SELECT
	*,
	CASE
			when lifespan >= 12 and total_sales >5000 then 'VIP'
			when lifespan >= 12 and total_sales <=5000 then 'Regular'
			ELSE 'New'
	END AS customer_segment,
	CASE 
		when age < 20 then 'under 20'
		when age < 30 then '20-29'
		when age < 40 then '30-39'
		when age <= 50 then '40-50'
		ELSE 'Above 50'
	END AS age_group,
	DATEDIFF(month,last_order_date,getdate()) recency,
	case 
		when total_orders = 0 then 0
		else round((total_sales/total_orders),2)
	END average_order_value,
	case 
		when lifespan = 0 then 0
		else round((total_sales/lifespan),2)
	END average_monthly_spend

	from customer_aggregation
)
SELECT
customer_key,
customer_name,
age,
age_group,
customer_segment,
last_order_date,
recency,
total_orders,
total_sales,
total_profit,
total_quantity,
lifespan,
average_order_value,
average_monthly_spend
from final_report

