-- part to whole analysis
-- which category contributes the most to overall sales

WITH category_sales as (
select
	category,
    sum(sales_amount) TotalSales
from fact_sales f 
left join dim_products p
on p.product_key = f.product_key
group by category
)
select 
	category,
    totalsales,
    sum(totalsales) over() AS OverallSales,
	CONCAT(ROUND((TotalSales / SUM(TotalSales) OVER()) * 100, 2), '%') AS percOfSales
from category_sales