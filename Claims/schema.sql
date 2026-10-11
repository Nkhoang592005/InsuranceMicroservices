-- Optional demo module: Yêu cầu bồi thường
CREATE SCHEMA IF NOT EXISTS claims;
CREATE TABLE IF NOT EXISTS claims.records (
    code TEXT PRIMARY KEY,
    contract_code TEXT NOT NULL,
    incident_on DATE NOT NULL,
    claimed_amount NUMERIC(14,2) NOT NULL CHECK (claimed_amount > 0)
);
