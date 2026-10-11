-- Optional demo module: Đại lý bảo hiểm
CREATE SCHEMA IF NOT EXISTS agents;
CREATE TABLE IF NOT EXISTS agents.records (
    code TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    commission_rate NUMERIC(5,2) NOT NULL CHECK (commission_rate BETWEEN 0 AND 100)
);
