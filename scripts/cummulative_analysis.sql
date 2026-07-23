-- calculate total sales per month
-- and the running total of sales overtime

select
year,
month,
total_sales_per_month,
sum(total_sales_per_month) over(partition by year order by month rows between unbounded preceding and current row) as running_total
from 
(
	select 
	year(order_date) as year,
	month(order_date) as month,
	sum(sales_amount) total_sales_per_month
	from gold.fact_sales
	where order_date is not null
	group by year(order_date),month(order_date)
) t;


-- running total_sales and moving average sales over the year
select
year,
total_sales_per_year,
sum(total_sales_per_year) over(order by year) as running_total,
avg(avg_sales) over(order by year) as moving_avg_sales
from 
(
	select 
	year(order_date) as year,
	sum(sales_amount) total_sales_per_year,
	avg(sales_amount) avg_sales
	from gold.fact_sales
	where order_date is not null
	group by year(order_date)
) t;
