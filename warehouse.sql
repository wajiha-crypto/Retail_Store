-- ============================================
-- Retail_Store: Warehouse Schema (star schema)
-- ============================================

CREATE SCHEMA IF NOT EXISTS warehouse;

-- Dimension: Customers
CREATE TABLE warehouse.dim_customers AS
SELECT
    customer_id,
    first_name || ' ' || last_name AS full_name,
    email,
    phone,
    city,
    country,
    signup_date
FROM staging.customers;
ALTER TABLE warehouse.dim_customers ADD PRIMARY KEY (customer_id);

-- Dimension: Products
CREATE TABLE warehouse.dim_products AS
SELECT
    product_id,
    product_name,
    category,
    unit_price,
    stock_quantity
FROM staging.products;
ALTER TABLE warehouse.dim_products ADD PRIMARY KEY (product_id);

-- Dimension: Date (auto-generated from order date range)
CREATE TABLE warehouse.dim_date AS
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_id,
    d::DATE AS full_date,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(MONTH FROM d) AS month,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(DAY FROM d) AS day,
    TO_CHAR(d, 'Day') AS day_name,
    EXTRACT(QUARTER FROM d) AS quarter
FROM generate_series(
    (SELECT MIN(order_date) FROM staging.orders),
    (SELECT MAX(order_date) FROM staging.orders),
    interval '1 day'
) AS d;
ALTER TABLE warehouse.dim_date ADD PRIMARY KEY (date_id);

-- Fact table: Sales (orders + payments + revenue)
CREATE TABLE warehouse.fact_sales AS
SELECT
    o.order_id,
    o.customer_id,
    o.product_id,
    TO_CHAR(o.order_date, 'YYYYMMDD')::INT AS date_id,
    o.quantity,
    o.order_status,
    p.unit_price,
    (o.quantity * p.unit_price) AS revenue,
    pay.payment_method,
    pay.amount_paid,
    pay.payment_status
FROM staging.orders o
JOIN staging.products p ON o.product_id = p.product_id
LEFT JOIN staging.payments pay ON o.order_id = pay.order_id;
ALTER TABLE warehouse.fact_sales ADD PRIMARY KEY (order_id);
