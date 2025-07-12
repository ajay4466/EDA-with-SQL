-- Data Segmentation
/* Segment products into cost ranges and count how many products fall into each segment*/
with products_segments as(
select
	product_key,
	product_name,
	cost,
    case 
		when cost < 100 then 'Below 100'
		when cost between 100 and 500 then '100-500'
        when cost between 500 and 1000 then '500-1000'
        else 'Above 1000'
	end AS CostRange
from dim_products 
)
select 
costrange,
count(product_key) AS TotalProducts
from products_segments
group by costrange
order by TotalProducts desc