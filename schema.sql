-- ============================================
-- Retail_Store: Source Schema
-- ============================================

CREATE SCHEMA IF NOT EXISTS retail_store;

-- Customers table
CREATE TABLE retail_store.customers (
    customer_id     INT PRIMARY KEY,
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    email           VARCHAR(100),
    phone           VARCHAR(20),
    city            VARCHAR(50),
    country         VARCHAR(50),
    signup_date     DATE
);

-- Products table
CREATE TABLE retail_store.products (
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(100),
    category        VARCHAR(50),
    unit_price      NUMERIC(10,2),
    stock_quantity  INT
);

-- Orders table
CREATE TABLE retail_store.orders (
    order_id        INT PRIMARY KEY,
    customer_id     INT REFERENCES retail_store.customers(customer_id),
    product_id      INT REFERENCES retail_store.products(product_id),
    order_date      DATE,
    quantity        INT,
    order_status    VARCHAR(20)
);

-- Payments table
CREATE TABLE retail_store.payments (
    payment_id      INT PRIMARY KEY,
    order_id        INT REFERENCES retail_store.orders(order_id),
    payment_date    DATE,
    payment_method  VARCHAR(20),
    amount_paid     NUMERIC(10,2),
    payment_status  VARCHAR(20)
);
