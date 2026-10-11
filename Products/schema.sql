-- Optional demo module: Sản phẩm bảo hiểm
CREATE SCHEMA IF NOT EXISTS products;
CREATE TABLE IF NOT EXISTS products.records (
    code TEXT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    base_premium NUMERIC(14,2) NOT NULL CHECK (base_premium > 0)
);
