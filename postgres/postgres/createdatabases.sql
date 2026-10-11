\set ON_ERROR_STOP on
-- Run with psql as a PostgreSQL administrator. Safe to run again.
SELECT 'CREATE ROLE lab_user LOGIN PASSWORD ''lab_pass'''
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'lab_user') \gexec

SELECT format('CREATE DATABASE %I OWNER lab_user', name)
FROM (VALUES ('lab_netmicro_payments'), ('lab_netmicro_jobs'),
             ('lab_netmicro_policy'), ('lab_netmicro_pricing')) AS databases(name)
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = name) \gexec

GRANT ALL PRIVILEGES ON DATABASE lab_netmicro_payments TO lab_user;
GRANT ALL PRIVILEGES ON DATABASE lab_netmicro_jobs TO lab_user;
GRANT ALL PRIVILEGES ON DATABASE lab_netmicro_policy TO lab_user;
GRANT ALL PRIVILEGES ON DATABASE lab_netmicro_pricing TO lab_user;
-- These four databases are required by the supplied assignment script.
-- Additional create_*_database.sql files are optional extensions.
