-- Optional demo module: Thông báo khách hàng
CREATE SCHEMA IF NOT EXISTS notifications;
CREATE TABLE IF NOT EXISTS notifications.records (
    code TEXT PRIMARY KEY,
    customer_code TEXT NOT NULL,
    channel TEXT NOT NULL CHECK (channel IN ('email','sms','portal')),
    message_body TEXT NOT NULL
);
