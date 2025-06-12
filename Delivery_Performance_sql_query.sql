create database DeliveryPerformance;
use DeliveryPerformance;

select * from `delivery analysis`;

-- Q1.What is the on-time delivery rate across different shipment modes?
select `shipment mode`,
	count(*) as total_orders,
	sum(case when `delivery status` = 'on time' then 1 else 0 end) as on_time_deliveries,
    round(sum(case when `delivery status` = 'on time' then 1 else 0 end) * 100.0 / count(*), 2) as on_time_delivery_rate
from `delivery analysis`
group by `shipment mode`
order by on_time_delivery_rate desc;

-- Q2.Which warehouse blocks experience the highest number of delayed deliveries?
select `warehouse block`, count(*) as delay_deliveries
from `delivery analysis`
where `delivery status` = 'delayed'
group by `warehouse block`
order by  delay_deliveries DESC;

-- Q3.Which 2 shipment modes experience the most frequent delivery delay?
select `shipment mode`, 
count(*) as delay_deliveries
from `delivery analysis` 
where `delivery status` = 'delayed'
group by `shipment mode` 
order by delay_deliveries desc
limit 2;

-- Q.4 Does product priority (low, medium, high) influence delivery performance?
select `product priority`,
    count(*) as total_orders,
    sum(case when `delivery status` = 'delayed' then 1 else 0 end ) as delayed_deliveries
from `delivery analysis`
group by`product priority`
order by delayed_deliveries DESC;


-- Q5. Is there a relationship between higher discounts offered and delivery delays ?
select round(`discount offered`, -1) as discount_range,
   count(*) as total_orders,
   sum(case when `delivery status` ='delayed' then 1 else 0 end) as delayed_orders,
   concat(round(sum(case when `delivery status` ='delayed' then 1 else 0 end) * 100.0/ count(*), 2), '%')  as delay_rate_percent
from `delivery analysis`
group by discount_range
order by discount_range;

-- Q6.Analyze If High Priority Products Trigger More Customer Calls?
select `product priority`,
   count(*) as total_orders,
   sum(`customer care calls`) as total_calls,
   round(avg(`customer care calls`), 2) as avg_calls_per_order
from `delivery analysis`
group by `product priority`
order by avg_calls_per_order DESC;

-- Q7. Which customer gender places more orders and experiences more delays?
select gender ,
   count(*) as total_orders,
   sum(`delivery status` = 'delayed') as total_delays,
   concat(round( sum(`delivery status` = 'delayed') * 100.0 / COUNT(*), 2), '%' ) as delay_rate_percent 
from `delivery analysis`
group by gender 
order by total_orders desc;


-- Q8. Do customers with more previous order experience fewer delivery delays?

SELECT 
  purchase_range_start,
  CONCAT(purchase_range_start, '-', purchase_range_start + 4) AS purchase_range,
  COUNT(*) AS total_orders,
  SUM(`delivery status` = 'delayed') AS delayed_orders,
  concat(ROUND(SUM(`delivery status` = 'delayed') * 100.0 / COUNT(*), 2), '%') AS delay_rate_percent
FROM (
  SELECT 
    FLOOR(`previous orders` / 5) * 5 AS purchase_range_start,
    `delivery status`
  FROM `delivery analysis`
) AS sub
GROUP BY purchase_range_start
ORDER BY purchase_range_start;

-- Q9.Which shipment mode is used most frequently across all deliveries?
select `shipment mode`,
count(*) as total_shipments
from `delivery analysis`
group by `shipment mode`
order by total_shipments desc
limit 1;

-- Q10.Does customer satisfaction (rating) differ between delayed and on-time deliveries?
select `delivery status`, 
  count(*) as total_orders,
round(avg(`customer rating`), 2) as avg_rating
from `delivery analysis`
group by `delivery status`;










