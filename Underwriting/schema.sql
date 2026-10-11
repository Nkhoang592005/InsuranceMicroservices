-- Optional demo module: Thẩm định hồ sơ
CREATE SCHEMA IF NOT EXISTS underwriting;
CREATE TABLE IF NOT EXISTS underwriting.records (
    code TEXT PRIMARY KEY,
    quote_code TEXT NOT NULL,
    decision TEXT NOT NULL CHECK (decision IN ('approved','review','declined')),
    review_note TEXT NOT NULL
);
