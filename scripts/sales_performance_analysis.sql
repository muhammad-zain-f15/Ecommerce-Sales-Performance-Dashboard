/*
Analyze the yearly performance of products by comparing 
their current year sales to both the average sales of the product and the previous year sales
*/

-- year over year analysis

with cy_sales_by_product as(
select
	year(order_date) as year,
	p.product_name,
	-- 1. current year sales calculation
	sum(sales_amount) as cy_sale
from gold.fact_sales f
join gold.dim_products p
on f.product_key = p.product_key
where order_date is not null
group by year(order_date),product_name
),
avg_and_py_sale as (
select
year,
product_name,
cy_sale,
-- 2. avg sales per year calculation
avg(cy_sale) over (partition by product_name) as avg_sale,
-- 3. py_sale calculation
lag(cy_sale) over (partition by product_name order by year) as py_sale
from cy_sales_by_product
)
select
year,
product_name,
cy_sale,
avg_sale,
py_sale,
case 
	when cy_sale > avg_sale then 'Above Avg'
	when cy_sale < avg_sale then 'Below Avg'
	else 'Average'
end as cy_vs_avg,
case 
	when cy_sale > py_sale then 'Increase'
	when cy_sale < py_sale then 'Decrease'
	else 'No change'
end as cy_vs_py
from avg_and_py_sale
order by product_name,year;

