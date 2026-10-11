-- Optional demo module: Tài khoản và vai trò mẫu
CREATE SCHEMA IF NOT EXISTS identity;
CREATE TABLE IF NOT EXISTS identity.records (
    code TEXT PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    agent_code TEXT NOT NULL,
    role_name TEXT NOT NULL CHECK (role_name IN ('agent','admin','reviewer'))
);
