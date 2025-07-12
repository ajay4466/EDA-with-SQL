/* performance analysis
 Analyzing the yearly performance of products by comparing each product's sales to both its
 avg sale and previous year sales*/

WITH yearly_products_sales as (
select
	year(f.order_date) Order_year,
    p.product_name,
    sum(f.sales_amount) as current_sales
from fact_sales f
left join dim_products p
on f.product_key = p.product_key
where year(f.order_date) is not null
group by year(f.order_date),p.product_name
)
select 
	order_year,
    product_name,
    current_sales,
    avg(current_sales) over(partition by product_name) AvgSales,
    current_sales - avg(current_sales) over(partition by product_name) as diff_avg,
case 
	when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'Above Average'
	when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'Below Average'
    else 'Avg'
end AS Avg_Change,
	lag(current_sales) over(partition by product_name order by order_year) AS py_sales,
    current_sales - lag(current_sales) over(partition by product_name order by order_year) AS diff_py,
case 
	when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
	when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
    else 'No Change'
end AS py_change
from yearly_products_sales
order by product_name,order_year
