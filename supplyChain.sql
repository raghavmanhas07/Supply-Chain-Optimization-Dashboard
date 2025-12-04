use supply;
select count(*) from supply_chain;

SELECT `Order Region`, Delivery_Performance, Late_Penalty_Cost
FROM supply_chain
WHERE `Delivery_Performance` = 'Late'
LIMIT 10;

-- Total scale of operations
select
count(*) as Total_Orders,
round(sum(Sales),2) as total_revenue,
round(avg(Sales), 2) as avg_order_value
from supply_chain;

-- raw count of performance
select Delivery_Performance,
count(*) as order_count
from supply_chain
group by Delivery_Performance;

-- Where is most of the business coming from?
select `Order Region`,
count(*) total_orders
from supply_chain
group by `Order region`
order by total_orders DESC
LIMIT 5;

-- "Do the logistics collapse during specific months (like the holiday season)?
SELECT 
    MONTHNAME(STR_TO_DATE(`order date (DateOrders)`, '%m/%d/%Y %H:%i')) as Month_Name,
    COUNT(*) as Total_Volume,
    SUM(CASE WHEN Delivery_Performance = 'Late' THEN 1 ELSE 0 END) as Late_Volume
FROM supply_chain
GROUP BY Month_Name
ORDER BY Total_Volume DESC;


-- Region which is costing most in late fees
SELECT `Order Region`,
count(*) as Total_Orders,
SUM(CASE WHEN Delivery_Performance = 'Late' THEN 1 ELSE 0 END) as Late_Count,
ROUND(SUM(CASE WHEN Delivery_Performance = 'Late' THEN 1 ELSE 0 END) / count(*) * 100, 2) as Late_Percentage,
SUM(Late_Penalty_Cost) as Total_Financial_Loss
from supply_chain GROUP BY `Order Region`
ORDER BY Total_Financial_Loss DESC;

-- Which product categories are most frequently late in each Region?
WITH ranked_delays AS(
SELECT
`Order Region`, `Category Name`,
count(*) as delay_count,
RANK() OVER (PARTITION BY `Order Region` ORDER BY count(*) DESC) as Rank_Num
from supply_chain 
where Delivery_Performance = 'Late' 
group by `Order Region`, `Category Name`
)
select * from ranked_delays where Rank_Num <= 3;










