\set ON_ERROR_STOP on
BEGIN;
\ir ../../Customers/verify.sql
\ir ../../Agents/verify.sql
\ir ../../Products/verify.sql
\ir ../../Quotes/verify.sql
\ir ../../Contracts/verify.sql
\ir ../../Billing/verify.sql
\ir ../../Payments/verify.sql
\ir ../../Claims/verify.sql
\ir ../../Commissions/verify.sql
\ir ../../Renewals/verify.sql
\ir ../../Underwriting/verify.sql
\ir ../../Risk/verify.sql
\ir ../../Notifications/verify.sql
\ir ../../Reporting/verify.sql
\ir ../../Audit/verify.sql
\ir ../../Identity/verify.sql
\ir ../../Support/verify.sql
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
