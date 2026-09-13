-- ============================================
-- Retail_Store: Staging Schema (cleaned data)
-- ============================================

CREATE SCHEMA IF NOT EXISTS staging;

-- Cleaned customers
CREATE TABLE staging.customers AS
SELECT
    customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name)  AS last_name,
    LOWER(TRIM(email)) AS email,
    TRIM(phone) AS phone,
    TRIM(city) AS city,
    TRIM(country) AS country,
    signup_date
FROM retail_store.customers
WHERE customer_id IS NOT NULL;

-- Cleaned products
CREATE TABLE staging.products AS
SELECT
    product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    unit_price,
    stock_quantity
FROM retail_store.products
WHERE product_id IS NOT NULL;

-- Cleaned orders
CREATE TABLE staging.orders AS
SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity,
    TRIM(order_status) AS order_status
FROM retail_store.orders
WHERE order_id IS NOT NULL AND quantity > 0;

-- Cleaned payments
CREATE TABLE staging.payments AS
SELECT
    payment_id,
    order_id,
    payment_date,
    TRIM(payment_method) AS payment_method,
    amount_paid,
    TRIM(payment_status) AS payment_status
FROM retail_store.payments
WHERE payment_id IS NOT NULL;
