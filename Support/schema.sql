-- Optional demo module: Phiếu hỗ trợ
CREATE SCHEMA IF NOT EXISTS support;
CREATE TABLE IF NOT EXISTS support.records (
    code TEXT PRIMARY KEY,
    customer_code TEXT NOT NULL,
    subject TEXT NOT NULL,
    ticket_status TEXT NOT NULL CHECK (ticket_status IN ('open','resolved','closed'))
);
