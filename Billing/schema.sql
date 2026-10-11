-- Optional demo module: Hóa đơn và số tiền cần thanh toán
CREATE SCHEMA IF NOT EXISTS billing;
CREATE TABLE IF NOT EXISTS billing.records (
    code TEXT PRIMARY KEY,
    contract_code TEXT NOT NULL,
    amount_due NUMERIC(14,2) NOT NULL CHECK (amount_due > 0),
    due_on DATE NOT NULL
);
