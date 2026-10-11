-- Optional demo module: Giao dịch thanh toán
CREATE SCHEMA IF NOT EXISTS payments;
CREATE TABLE IF NOT EXISTS payments.records (
    code TEXT PRIMARY KEY,
    invoice_code TEXT NOT NULL,
    amount_paid NUMERIC(14,2) NOT NULL CHECK (amount_paid > 0),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('bank_transfer','card','cash'))
);
