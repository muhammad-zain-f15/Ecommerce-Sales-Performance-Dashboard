-- ranking analysis
-- which 5 products generate the highest revenue
SELECT top 5
	p.product_name,
	sum(sales_amount) as total_revenue
FROM gold.fact_sales f
left join gold.dim_products p
on p.product_key = f.product_key
group by product_name
order by sum(sales_amount) desc;

-- what are the 5 worst performing product in term of sales
SELECT top 5
	p.product_name,
	sum(sales_amount) as total_revenue
FROM gold.fact_sales f
left join gold.dim_products p
on p.product_key = f.product_key
group by product_name
order by sum(sales_amount) asc;


