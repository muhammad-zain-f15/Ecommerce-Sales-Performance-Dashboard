-- Dimensions Exploration (Identify unique values in each dimension)

-- Explore all counries our customer come from
select
distinct country
from gold.dim_customers;

-- Explore all categories "The major division"
select
distinct category
from gold.dim_products

-- explore category and subcategory
select
distinct category,subcategory
from gold.dim_products
