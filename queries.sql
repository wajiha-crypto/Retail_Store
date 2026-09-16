-- Retail_Store: Analytical Queries
-- (Window functions, CTEs, business insights)
-- 1. CTE: Total revenue and order count per customer
WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.full_name,
        COUNT(f.order_id) AS total_orders,
        SUM(f.revenue) AS total_revenue
    FROM warehouse.dim_customers c
    JOIN warehouse.fact_sales f ON c.customer_id = f.customer_id
    GROUP BY c.customer_id, c.full_name
)
SELECT *
FROM customer_summary
ORDER BY total_revenue DESC;

-- 2. LAG/LEAD: Compare each order's revenue to the customer's previous and next order
SELECT
    customer_id,
    order_id,
    revenue,
    LAG(revenue) OVER (PARTITION BY customer_id ORDER BY order_id) AS previous_order_revenue,
    LEAD(revenue) OVER (PARTITION BY customer_id ORDER BY order_id) AS next_order_revenue
FROM warehouse.fact_sales
ORDER BY customer_id, order_id;

-- 3. CTE + Window function: Top-selling product per category by revenue
WITH product_revenue AS (
    SELECT
        p.category,
        p.product_name,
        SUM(f.revenue) AS total_revenue,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(f.revenue) DESC) AS category_rank
    FROM warehouse.dim_products p
    JOIN warehouse.fact_sales f ON p.product_id = f.product_id
    GROUP BY p.category, p.product_name
)
SELECT category, product_name, total_revenue
FROM product_revenue
WHERE category_rank = 1;

-- 4. Running total of revenue over time
SELECT
    d.full_date,
    SUM(f.revenue) AS daily_revenue,
    SUM(SUM(f.revenue)) OVER (ORDER BY d.full_date) AS running_total_revenue
FROM warehouse.fact_sales f
JOIN warehouse.dim_date d ON f.date_id = d.date_id
GROUP BY d.full_date
ORDER BY d.full_date;
