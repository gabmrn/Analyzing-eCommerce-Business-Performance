CREATE EXTENSION IF NOT EXISTS tablefunc;

CREATE TABLE payment_d AS(
SELECT date_part('year', ord.order_purchase_timestamp) AS YEAR, opd.payment_type, COUNT(opd.payment_type) AS total_payments
FROM order_payments_dataset opd
JOIN orders_dataset ord 
ON ord.order_id = opd.order_id
GROUP BY 1,2
ORDER BY 2 DESC)

SELECT payment_type, y2016, y2017, y2018, y2016+y2017+y2018 AS total_payment
FROM (SELECT payment_type,
      CASE WHEN "y2016" IS NULL THEN 0 ELSE "y2016" END AS y2016,
      CASE WHEN "y2017" IS NULL THEN 0 ELSE "y2017" END AS y2017,
      CASE WHEN "y2018" IS NULL THEN 0 ELSE "y2018" END AS y2018
	  FROM crosstab('SELECT payment_type, year, total_payments FROM payment_d ORDER BY 1,2',
   		  		    $$VALUES (2016::numeric), (2017::numeric), (2018::numeric)$$)
	  AS payment_new(payment_type text, "y2016" numeric, "y2017" numeric, "y2018" numeric)) AS payment1
ORDER BY 5 DESC;


