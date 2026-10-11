-- Optional demo module: Nhật ký thao tác mẫu
CREATE SCHEMA IF NOT EXISTS audit;
CREATE TABLE IF NOT EXISTS audit.records (
    code TEXT PRIMARY KEY,
    actor_code TEXT NOT NULL,
    action_name TEXT NOT NULL,
    entity_code TEXT NOT NULL
);
