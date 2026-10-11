-- Optional demo module: Báo giá
CREATE SCHEMA IF NOT EXISTS quotes;
CREATE TABLE IF NOT EXISTS quotes.records (
    code TEXT PRIMARY KEY,
    customer_code TEXT NOT NULL,
    product_code TEXT NOT NULL,
    quoted_premium NUMERIC(14,2) NOT NULL CHECK (quoted_premium > 0)
);
