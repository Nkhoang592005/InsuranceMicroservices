-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO support.records (code, customer_code, subject, ticket_status) VALUES
    ('SU001', 'CU001', 'Huong dan thanh toan hop dong demo', 'open'),
    ('SU002', 'CU002', 'Huong dan thanh toan hop dong demo', 'open'),
    ('SU003', 'CU003', 'Huong dan thanh toan hop dong demo', 'open'),
    ('SU004', 'CU004', 'Huong dan thanh toan hop dong demo', 'open'),
    ('SU005', 'CU005', 'Huong dan thanh toan hop dong demo', 'open')
ON CONFLICT (code) DO NOTHING;
