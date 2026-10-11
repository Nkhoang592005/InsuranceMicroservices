-- Optional demo module: Khách hàng
CREATE SCHEMA IF NOT EXISTS customers;
CREATE TABLE IF NOT EXISTS customers.records (
    code TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    city TEXT NOT NULL
);
