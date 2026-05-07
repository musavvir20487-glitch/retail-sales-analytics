-- ================================================
-- Retail Sales Analytics Project
-- Author: Syed Musavvir Rehan
-- Database: MySQL
-- Dataset: Sample Superstore (9994 rows)
-- Description: 15 business analytics queries covering
--              sales performance, customer analysis,
--              product insights, and regional trends
-- ================================================

USE retail_analytics;

------
SELECT 
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(sales), 2)            AS total_revenue,
    ROUND(SUM(profit), 2)           AS total_profit,
    ROUND(SUM(profit)/SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore;
----- SELECT * FROM superstore LIMIT 5;
-----------
select year(order_date) as year ,sum(sales) as revenue_over_years,
sum(profit) as profit_over_years from superstore
group by year(order_date) 
order by year(order_date) asc;
 --------------
 WITH cte AS (
    SELECT 
        YEAR(order_date)  AS yr,
        MONTH(order_date) AS mn,
        ROUND(SUM(sales), 2) AS sum_sales
    FROM superstore
    GROUP BY YEAR(order_date), MONTH(order_date)
    ORDER BY yr ASC, mn ASC
),
cte2 AS (
    SELECT 
        yr,
        mn,
        sum_sales,
        LAG(sum_sales) OVER (ORDER BY yr ASC, mn ASC) AS prev_sales
    FROM cte
)
SELECT 
    yr,
    mn,
    sum_sales,
    prev_sales,
    ROUND((sum_sales - prev_sales) / prev_sales * 100, 2) AS growth_pct
FROM cte2;
-----------
select region, round(sum(sales),2) as revenue_over_region,
round(sum(profit),2) as profit_over_region ,
round(sum(profit)/sum(sales)*100,2) as profit_margin_pct from superstore
group by region order by revenue_over_region desc, profit_over_region desc;
-----------
select customer_name, round(sum(sales),2) as revenue_by_customer,
round(sum(profit),2) as profit_by_customer, count(distinct(order_id)) as no_of_orders
from superstore group by customer_name 
order by revenue_by_customer desc, profit_by_customer desc
limit 10;
------------
select product_name, category, sub_category, round(SUM(sales),2) as sum_sales,
round(SUM(profit),2) as sum_profit, SUM(quantity) as sum_quantity from superstore 
group by product_name, category, sub_category
order by sum_profit desc 
limit 10;
------------
select product_name, category, sub_category,COUNT(DISTINCT order_id), round(SUM(sales),2) as sum_sales,
round(SUM(profit),2) as sum_profit, SUM(quantity) as sum_quantity from superstore 
group by product_name, category, sub_category
order by sum_profit asc
limit 10;
------------
select category, sub_category, round(sum(sales),2) as sales_over_categories,
round(sum(profit),2) as profit_over_categories,
round(sum(profit)/sum(sales)*100,2) as profit_margin_pct from superstore 
group by category, sub_category order by profit_over_categories desc;
----------
select segment, count(order_id), round(sum(sales),2) as revenue_over_segment,
round(sum(profit),2) as profit_over_segment,
round(sum(profit)/sum(sales)*100,2) as profit_margin_pct,
SUM(sales)/COUNT(DISTINCT order_id) as average_order_value
from superstore group by segment 
order by  revenue_over_segment desc;
------------/*Who are the top 5 customers in each region by revenue?*/
with cte as (
select customer_name, region, sum(sales) as revenue_over_region from superstore
group by customer_name, region),
cte2 as(
select customer_name, region, revenue_over_region ,
dense_rank() over (partition by region order by revenue_over_region desc) as drk 
from cte)
select customer_name,region, revenue_over_region,drk from cte2 where drk <=5;
---------/* Which shipping mode is used most and which is most profitable?*/
select ship_mode, count(order_id), round(sum(sales),2) as revenue_over_ship_mode,
round(sum(profit),2) as profit_over_ship_mode,  
round(sum(profit)/sum(sales)*100,2) as profit_margin_pct ,
round(avg(datediff(ship_date,order_date)),1) as avg_shipping_days from superstore
group by ship_mode ;
----------/* What is the exact revenue growth % from one year to the next?*/
with cte1 as (
select year(order_date) as yr, round(sum(sales),2) as curr_sum_sales from superstore 
group by year(order_date) order by year(order_date) asc),
cte2 as (
select yr, curr_sum_sales, lag(curr_sum_sales) over (order by yr asc) as prev_yr_sum_sales 
from cte1)
select yr , curr_sum_sales, prev_yr_sum_sales,
round((curr_sum_sales - prev_yr_sum_sales)/ prev_yr_sum_sales*100,2) as growth_pct
from cte2;
-----------
select order_date, region, sales , 
round(sum(sales) over (partition by region order by order_date asc),1) as cumulative_revenue 
from superstore 
---------
SELECT
    CASE
        WHEN discount = 0    THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low (0-20%)'
        WHEN discount <= 0.4 THEN 'Medium (20-40%)'
        ELSE                      'High (40%+)'
    END                              AS discount_category,
    COUNT(order_id)                  AS order_count,
    ROUND(AVG(sales), 2)             AS avg_sales,
    ROUND(AVG(profit), 2)            AS avg_profit,
    ROUND(SUM(profit), 2)            AS total_profit
FROM superstore
GROUP BY discount_category
ORDER BY total_profit DESC;

---------
WITH customer_summary AS (
    SELECT
        customer_name,
        COUNT(DISTINCT order_id)     AS order_count,
        ROUND(SUM(sales), 2)         AS total_revenue,
        ROUND(SUM(profit), 2)        AS total_profit
    FROM superstore
    GROUP BY customer_name
),
ranked AS (
    SELECT
        customer_name,
        order_count,
        total_revenue,
        total_profit,
        ROW_NUMBER() OVER (ORDER BY order_count DESC) AS rn
    FROM customer_summary
)
SELECT * FROM ranked WHERE rn <= 10;

