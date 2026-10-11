-- Optional demo module: Đề nghị gia hạn
CREATE SCHEMA IF NOT EXISTS renewals;
CREATE TABLE IF NOT EXISTS renewals.records (
    code TEXT PRIMARY KEY,
    contract_code TEXT NOT NULL,
    renewal_on DATE NOT NULL,
    renewal_premium NUMERIC(14,2) NOT NULL CHECK (renewal_premium > 0)
);
