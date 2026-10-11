-- Optional demo module: Công việc xử lý hồ sơ
CREATE SCHEMA IF NOT EXISTS workflow;
CREATE TABLE IF NOT EXISTS workflow.records (
    code TEXT PRIMARY KEY,
    contract_code TEXT NOT NULL,
    step_name TEXT NOT NULL,
    step_status TEXT NOT NULL CHECK (step_status IN ('pending','completed','failed'))
);
