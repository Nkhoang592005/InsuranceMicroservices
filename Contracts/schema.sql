-- Optional demo module: Hợp đồng bảo hiểm
CREATE SCHEMA IF NOT EXISTS contracts;
CREATE TABLE IF NOT EXISTS contracts.records (
    code TEXT PRIMARY KEY,
    quote_code TEXT NOT NULL,
    agent_code TEXT NOT NULL,
    starts_on DATE NOT NULL,
    ends_on DATE NOT NULL CHECK (ends_on > starts_on)
);
