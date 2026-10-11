-- Optional demo module: Báo cáo doanh thu mẫu
CREATE SCHEMA IF NOT EXISTS reporting;
CREATE TABLE IF NOT EXISTS reporting.records (
    code TEXT PRIMARY KEY,
    report_month DATE NOT NULL,
    product_code TEXT NOT NULL,
    premium_total NUMERIC(14,2) NOT NULL CHECK (premium_total >= 0)
);
