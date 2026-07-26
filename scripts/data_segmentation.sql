-- segment products into cost ranges and count how many products
-- fall into each segment

select
*
from gold.dim_products;

SELECT
max(cost) as max_price,
min(cost) as min_price
from gold.dim_products;

with product_cost_ranges as
(
	SELECT
	product_key,
	product_name,
	cost,
	case 
		when cost <= 500 then '0-500'
		when cost <= 1500 then '501-1500'
		else 'Above 1500'
	end as cost_ranges
	from gold.dim_products
)
select
cost_ranges,
count(product_key) as 'no of products'
from product_cost_ranges
group by cost_ranges;

/*
Group customers into three segments based on their spending behavior:
	VIP: at least 12 months of history and spending more than $5000
	Regular: at least 12 months of history but spending less than or equal to$5000
	New: lifespan less than 12 months
And find the total no of customers by each gorup
*/

SELECT
*
from gold.fact_sales;

with customer_life_span_spending as
(
	SELECT
	customer_key,
	sum(sales_amount) as total_sales,
	DATEDIFF(month,min(order_date),max(order_date)) as life_span
	from gold.fact_sales
	GROUP BY customer_key
)
select
customer_segment,
count(customer_key) as no_of_customers
FROM 
(
	SELECT
	*,
	CASE
		when life_span >= 12 and total_sales >5000 then 'VIP'
		when life_span >= 12 and total_sales <=5000 then 'Regular'
		ELSE 'New'
	END AS customer_segment
	FROM customer_life_span_spending
) t
GROUP BY customer_segment;
