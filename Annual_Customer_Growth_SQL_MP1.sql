WITH mua AS(
-- Monthly Activity Users per Year
	SELECT YEAR, FLOOR(AVG(total_customer)) AS avg_mcag, 
	((AVG(total_customer)-LAG(AVG(total_customer)) OVER(ORDER BY YEAR)))/LAG(AVG(total_customer)) OVER(ORDER BY YEAR)*100 AS percentage
	FROM (SELECT date_part('year', ord.order_purchase_timestamp) AS YEAR,
				 date_part('month', ord.order_purchase_timestamp) AS MONTH,
				 COUNT(DISTINCT cust.customer_unique_id) AS total_customer
		  FROM orders_dataset ord
		  JOIN customers_dataset cust
		  ON cust.customer_id = ord.customer_id
		  GROUP BY 1, 2) AS cust_ord_date
	GROUP BY 1
	ORDER BY 1),
new_cust AS(
-- Number of New Customers (first time ordering) per Year
	SELECT YEAR, SUM(total_order) AS new_customer
	FROM (SELECT date_part('year', ord.order_purchase_timestamp) AS YEAR,
				 cust.customer_unique_id,
				 COUNT(cust.customer_unique_id) AS total_order
		  FROM orders_dataset ord
		  JOIN customers_dataset cust
		  ON cust.customer_id = ord.customer_id
		  GROUP BY 1,2
		  HAVING COUNT(cust.customer_unique_id) = 1
		  ORDER BY 1) AS cust_orders1
	GROUP BY 1
	ORDER BY 1),
rep_order AS(
-- Number of Customers That's Been Repeat Order per Year
	SELECT YEAR, COUNT(total_order) AS cust_repeat_order
	FROM (SELECT date_part('year', ord.order_purchase_timestamp) AS YEAR,
				 cust.customer_unique_id,
				 COUNT(cust.customer_unique_id) AS total_order
		  FROM orders_dataset ord
		  JOIN customers_dataset cust
		  ON cust.customer_id = ord.customer_id
		  GROUP BY 1,2
		  HAVING COUNT(cust.customer_unique_id) > 1
		  ORDER BY 1) AS cust_orders2
	GROUP BY 1
	ORDER BY 1),
freq_order AS(
-- Order Frequency per Year
	SELECT YEAR, ROUND(AVG(total_order),3) AS avg_order
	FROM (SELECT date_part('year', ord.order_purchase_timestamp) AS YEAR,
				 cust.customer_unique_id,
				 COUNT(cust.customer_unique_id) AS total_order
		  FROM orders_dataset ord
		  JOIN customers_dataset cust
		  ON cust.customer_id = ord.customer_id
		  GROUP BY 1,2
		  ORDER BY 1) AS cust_orders3
	GROUP BY 1
	ORDER BY 1)
	
SELECT mua.YEAR, mua.avg_mcag, nc.new_customer, ro.cust_repeat_order, fo.avg_order
FROM mua
INNER JOIN new_cust nc
ON mua.YEAR = nc.YEAR
INNER JOIN rep_order ro
ON mua.YEAR = ro.YEAR
INNER JOIN freq_order fo
ON mua.YEAR = fo.YEAR;