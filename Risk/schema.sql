-- Optional demo module: Đánh giá rủi ro
CREATE SCHEMA IF NOT EXISTS risk;
CREATE TABLE IF NOT EXISTS risk.records (
    code TEXT PRIMARY KEY,
    customer_code TEXT NOT NULL,
    risk_score INTEGER NOT NULL CHECK (risk_score BETWEEN 0 AND 100),
    risk_level TEXT NOT NULL CHECK (risk_level IN ('low','medium','high'))
);
