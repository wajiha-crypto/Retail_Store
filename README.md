# Retail_Store — PostgreSQL ETL with DBeaver

Raw CSVs → PostgreSQL source schema → staging → warehouse → analytics queries.

## Files

- `customers.csv`, `products.csv`, `orders.csv`, `payments.csv` — raw source data
- `schema.sql` — creates the `retail_store` schema and source tables
- `staging.sql` — creates the `staging` schema with cleaned data
- `warehouse.sql` — creates the `warehouse` schema (dimension + fact tables)
- `queries.sql` — analytical queries (CTEs, window functions)

## How to run (DBeaver)

1. Run `schema.sql`.
2. Import the CSVs into their matching tables, in this order:
   customers → products → orders → payments.
3. Run `staging.sql`.
4. Run `warehouse.sql`.
5. Run the queries in `queries.sql` to see the business insights.

## Verify

```sql
SELECT COUNT(*) FROM retail_store.customers; -- 10
SELECT COUNT(*) FROM retail_store.orders;    -- 15
```
