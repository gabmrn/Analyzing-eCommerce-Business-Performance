-- Preparing the data

-- 1. Create the database for this dataset by secondary click on Databases menu then you will find Create > Database... then enter the name of new database.
-- 2. Create tables and choosethe most suitable datatypes for each of datasets, there are 8 datasets.
CREATE TABLE customers_dataset(
	customer_id VARCHAR,
	customer_unique_id VARCHAR,
	customer_zip_code_prefix VARCHAR,
	customer_city VARCHAR,
	customer_state VARCHAR);
	
CREATE TABLE geolocation_dataset(
	geolocation_zip_code_prefix VARCHAR,
	geolocation_lat DECIMAL,
	geolocation_lng DECIMAL,
	geolocation_city VARCHAR,
	geolocation_state VARCHAR);
	
CREATE TABLE order_items_dataset(
	order_id VARCHAR,
	order_item_id INTEGER,
	product_id VARCHAR,
	seller_id VARCHAR,
	shipping_limit_date TIMESTAMP,
	price FLOAT,
	freight_value FLOAT);
	
CREATE TABLE order_payments_dataset(
	order_id VARCHAR,
	payment_sequential INTEGER,
	payment_type VARCHAR,
	payment_installments INTEGER,
	payment_value FLOAT);

CREATE TABLE order_reviews_dataset(
	review_id VARCHAR,
	order_id VARCHAR,
	review_score INTEGER,
	review_comment_title VARCHAR,
	review_comment_message VARCHAR,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP);

CREATE TABLE orders_dataset(
	order_id VARCHAR,
	customer_id VARCHAR,
	order_status VARCHAR,
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP);

CREATE TABLE product_dataset(
	product_id VARCHAR,
	product_category_name VARCHAR,
	product_name_lenght FLOAT,
	product_description_lenght FLOAT,
	product_photos_qty FLOAT,
	product_weight_g FLOAT,
	product_length_cm FLOAT,
	product_height_cm FLOAT,
	product_width_cm FLOAT);


CREATE TABLE sellers_dataset(
	seller_id VARCHAR,
	seller_zip_code_prefix VARCHAR,
	seller_city VARCHAR,
	seller_state VARCHAR);

-- 3. Import every datasets to the tables that have been prepared.

-- You can either add the primary key and foreign key when you create table or use alter table.
-- 4. In this case, I use alter table to set the primary key and foreign key.

ALTER TABLE customers_dataset ADD CONSTRAINT customers_dataset_pkey PRIMARY KEY(customer_id);
ALTER TABLE product_dataset ADD CONSTRAINT product_dataset_pkey PRIMARY KEY(product_id);
ALTER TABLE orders_dataset ADD CONSTRAINT orders_dataset_pkey PRIMARY KEY(order_id);
ALTER TABLE sellers_dataset ADD CONSTRAINT sellers_dataset_pkey PRIMARY KEY(seller_id);

ALTER TABLE order_items_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE order_items_dataset ADD FOREIGN KEY (product_id) REFERENCES product_dataset;
ALTER TABLE order_items_dataset ADD FOREIGN KEY (seller_id) REFERENCES sellers_dataset;
ALTER TABLE order_payments_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE order_reviews_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE orders_dataset ADD FOREIGN KEY (customer_id) REFERENCES customers_dataset;

-- 5. Make ERD by secondary click on the database and click Generate ERD.