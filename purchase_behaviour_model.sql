--Base customer sales data model
WITH all_sales AS 
(SELECT 
u.id AS user_id,
u.email,
u.age,
u.gender,
u.country,
u.traffic_source,
CAST(u.created_at AS DATE) AS account_creation_date,
oi.order_id,
oi.product_id,
CAST(oi.created_at AS DATE) AS order_date,
oi.sale_price,
p.category,
p.name AS product_name,
p.brand,
p.retail_price,
p.department
FROM bigquery-public-data.thelook_ecommerce.users u 
LEFT JOIN bigquery-public-data.thelook_ecommerce.order_items oi 
ON u.id = oi.user_id
LEFT JOIN bigquery-public-data.thelook_ecommerce.products p 
ON oi.product_id = p.id
WHERE u.id = 53565
)

--purchase behavior modeling
SELECT 
user_id,
email,
age,
gender,
country,
traffic_source,
MIN(order_date) AS cohort_date,
MAX(order_date) AS latest_shopping_date,
DATE_DIFF(MAX(order_date),MIN(order_date),MONTH) AS lifespan_months,
ROUND(SUM(sale_price),2) AS ltv,
COUNT(DISTINCT order_id) AS purchase_frequency,
ROUND(SUM(sale_price)/COUNT(DISTINCT order_id),2) AS average_order_value
FROM all_sales
GROUP BY 
user_id,
email,
age,
gender,
country,
traffic_source

