\set ON_ERROR_STOP on
-- Run as a PostgreSQL administrator with psql, not the pgAdmin Query Tool.
-- This script creates missing databases and restores the four sibling SQL dumps.
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
\connect lab_netmicro_payments
\ir lab_netmicro_payments.sql
\connect lab_netmicro_jobs
\ir lab_netmicro_jobs.sql
\connect lab_netmicro_policy
\ir lab_netmicro_policy.sql
\connect lab_netmicro_pricing
\ir lab_netmicro_pricing.sql
