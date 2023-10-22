WITH annual_revenue AS(
-- Annual Revenue
	SELECT date_part('year', ord.order_purchase_timestamp) AS YEAR,
		   ROUND(SUM(oid.price + oid.freight_value)::numeric,2) AS revenue
	FROM orders_dataset ord
	JOIN order_items_dataset oid
	on ord.order_id = oid.order_id
	WHERE ord.order_status = 'delivered'
	GROUP BY 1
	ORDER BY 1),
annual_canceled AS(
-- The Numbers of canceled orders per Year
	SELECT date_part('year', order_purchase_timestamp) AS YEAR,
		   COUNT(order_id) AS annual_cancel_totals
	FROM orders_dataset
	WHERE order_status = 'canceled'
	GROUP BY 1
	ORDER BY 1),
annual_top_product AS(
-- The Highest Revenue Product Categories Per Year
	SELECT YEAR, product_category, cat_revenue
	FROM (SELECT date_part('year', ord.order_purchase_timestamp) AS YEAR,
				 pd.product_category_name AS product_category,
				 ROUND(SUM(oid.price + oid.freight_value)) AS cat_revenue,
				 RANK() OVER (PARTITION BY date_part('year', ord.order_purchase_timestamp)
							  ORDER BY SUM(oid.price + oid.freight_value) DESC) AS ranks
		  FROM order_items_dataset oid
		  JOIN orders_dataset ord
		  ON oid.order_id = ord.order_id
		  JOIN product_dataset pd
		  ON oid.product_id = pd.product_id
		  WHERE ord.order_status = 'delivered'
		  GROUP BY 1,2
		  ORDER BY 1) as cat_rank
	WHERE ranks = 1),
annual_top_canceled AS(
-- The Most Canceled Product Categories per Year
	SELECT YEAR, product_category, annual_cancel_total
	FROM (SELECT date_part('year', ord.order_purchase_timestamp) AS YEAR,
				 pd.product_category_name AS product_category,
				 COUNT(ord.order_id) AS annual_cancel_total,
				 RANK() OVER (PARTITION BY date_part('year', ord.order_purchase_timestamp)
							  ORDER BY COUNT(ord.order_id) DESC) AS ranks
		  FROM order_items_dataset oid
		  JOIN orders_dataset ord
		  ON oid.order_id = ord.order_id
		  JOIN product_dataset pd
		  ON oid.product_id = pd.product_id
		  WHERE ord.order_status = 'canceled'
		  GROUP BY 1,2
		  ORDER BY 1) as cat_rank
	WHERE ranks = 1)
	
SELECT ar.YEAR, ar.revenue, ac.annual_cancel_totals, atp.product_category, atp.cat_revenue, atc.product_category, atc.annual_cancel_total
FROM annual_revenue ar
JOIN annual_canceled ac
ON ar.YEAR = ac.YEAR
JOIN annual_top_product atp
ON ar.YEAR = atp.YEAR
JOIN annual_top_canceled atc
ON ar.YEAR = atc.YEAR;