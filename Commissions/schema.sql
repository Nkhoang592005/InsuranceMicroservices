-- Optional demo module: Hoa hồng đại lý
CREATE SCHEMA IF NOT EXISTS commissions;
CREATE TABLE IF NOT EXISTS commissions.records (
    code TEXT PRIMARY KEY,
    agent_code TEXT NOT NULL,
    contract_code TEXT NOT NULL,
    commission_amount NUMERIC(14,2) NOT NULL CHECK (commission_amount >= 0)
);
