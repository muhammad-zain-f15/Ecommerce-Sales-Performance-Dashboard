-- which categories contribute the most to overall sales?
with total_sales_by_category as
(
select
p.category,
sum(sales_amount) category_sales
from gold.fact_sales f
join gold.dim_products p
on f.product_key = p.product_key
group by p.category
),
category_and_total_sales as (
select
category,
category_sales,
sum(category_sales) over() as total_sales
from total_sales_by_category
)
select
category,
category_sales,
total_sales,
concat(round((cast(category_sales as float)/total_sales) * 100,2),'%') as sales_contribution_percentage
from category_and_total_sales
order by category_sales desc;


