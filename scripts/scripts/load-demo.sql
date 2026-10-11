\set ON_ERROR_STOP on
-- Optional synthetic data in a dedicated database. All modules load atomically.
BEGIN;
\ir ../../Customers/schema.sql
\ir ../../Customers/seed.sql
\ir ../../Customers/verify.sql
\ir ../../Agents/schema.sql
\ir ../../Agents/seed.sql
\ir ../../Agents/verify.sql
\ir ../../Products/schema.sql
\ir ../../Products/seed.sql
\ir ../../Products/verify.sql
\ir ../../Quotes/schema.sql
\ir ../../Quotes/seed.sql
\ir ../../Quotes/verify.sql
\ir ../../Contracts/schema.sql
\ir ../../Contracts/seed.sql
\ir ../../Contracts/verify.sql
\ir ../../Billing/schema.sql
\ir ../../Billing/seed.sql
\ir ../../Billing/verify.sql
\ir ../../Payments/schema.sql
\ir ../../Payments/seed.sql
\ir ../../Payments/verify.sql
\ir ../../Claims/schema.sql
\ir ../../Claims/seed.sql
\ir ../../Claims/verify.sql
\ir ../../Commissions/schema.sql
\ir ../../Commissions/seed.sql
\ir ../../Commissions/verify.sql
\ir ../../Renewals/schema.sql
\ir ../../Renewals/seed.sql
\ir ../../Renewals/verify.sql
\ir ../../Underwriting/schema.sql
\ir ../../Underwriting/seed.sql
\ir ../../Underwriting/verify.sql
\ir ../../Risk/schema.sql
\ir ../../Risk/seed.sql
\ir ../../Risk/verify.sql
\ir ../../Notifications/schema.sql
\ir ../../Notifications/seed.sql
\ir ../../Notifications/verify.sql
\ir ../../Reporting/schema.sql
\ir ../../Reporting/seed.sql
\ir ../../Reporting/verify.sql
\ir ../../Audit/schema.sql
\ir ../../Audit/seed.sql
\ir ../../Audit/verify.sql
\ir ../../Identity/schema.sql
\ir ../../Identity/seed.sql
\ir ../../Identity/verify.sql
\ir ../../Support/schema.sql
\ir ../../Support/seed.sql
\ir ../../Support/verify.sql
\ir ../../Workflow/schema.sql
\ir ../../Workflow/seed.sql
\ir ../../Workflow/verify.sql
\ir verify-demo-links.sql
COMMIT;
SELECT 'Customers' AS module, COUNT(*) AS rows FROM customers.records
UNION ALL
SELECT 'Agents' AS module, COUNT(*) AS rows FROM agents.records
UNION ALL
SELECT 'Products' AS module, COUNT(*) AS rows FROM products.records
UNION ALL
SELECT 'Quotes' AS module, COUNT(*) AS rows FROM quotes.records
UNION ALL
SELECT 'Contracts' AS module, COUNT(*) AS rows FROM contracts.records
UNION ALL
SELECT 'Billing' AS module, COUNT(*) AS rows FROM billing.records
UNION ALL
SELECT 'Payments' AS module, COUNT(*) AS rows FROM payments.records
UNION ALL
SELECT 'Claims' AS module, COUNT(*) AS rows FROM claims.records
UNION ALL
SELECT 'Commissions' AS module, COUNT(*) AS rows FROM commissions.records
UNION ALL
SELECT 'Renewals' AS module, COUNT(*) AS rows FROM renewals.records
UNION ALL
SELECT 'Underwriting' AS module, COUNT(*) AS rows FROM underwriting.records
UNION ALL
SELECT 'Risk' AS module, COUNT(*) AS rows FROM risk.records
UNION ALL
SELECT 'Notifications' AS module, COUNT(*) AS rows FROM notifications.records
UNION ALL
SELECT 'Reporting' AS module, COUNT(*) AS rows FROM reporting.records
UNION ALL
SELECT 'Audit' AS module, COUNT(*) AS rows FROM audit.records
UNION ALL
SELECT 'Identity' AS module, COUNT(*) AS rows FROM identity.records
UNION ALL
SELECT 'Support' AS module, COUNT(*) AS rows FROM support.records
UNION ALL
SELECT 'Workflow' AS module, COUNT(*) AS rows FROM workflow.records;
