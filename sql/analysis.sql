-- Storewise Revenue
Select s.store_id, 
s.store_name,
Sum(s2.amount) as total_sales
From stores s
Join sales s2
On s.store_id = s2.store_id
Group by s.store_id, s.store_name
Order by total_sales desc;

-- Product total sales per store
With total_product_sales as (
Select store_id,
product_id,
Sum(amount) as total_sales
From sales
Group by store_id,
product_id
)

Select store_id,
product_id,
total_sales
From (
Select store_id,
product_id,
total_sales,
Row_number() Over (partition by store_id order by total_sales desc) as rnk
From total_product_sales
) t
Where rnk = 1;

-- Top 3 customers per store 
With customer_sales as (
Select customer_id,
store_id,
Sum(amount) as total_sales
From sales
Group by customer_id,
store_id
)

Select store_id,
customer_id,
total_sales
From (
Select store_id,
customer_id,
total_sales,
Dense_Rank() Over (partition by store_id order by total_sales Desc) as rnk
From customer_sales
) t
Where rnk <= 3;

Select store_id,
Avg(amount) as avg_tran_value
From sales
Group by store_id;
