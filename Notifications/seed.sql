-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO notifications.records (code, customer_code, channel, message_body) VALUES
    ('NO001', 'CU001', 'portal', 'Hop dong CO001 da duoc tao (du lieu demo)'),
    ('NO002', 'CU002', 'portal', 'Hop dong CO002 da duoc tao (du lieu demo)'),
    ('NO003', 'CU003', 'portal', 'Hop dong CO003 da duoc tao (du lieu demo)'),
    ('NO004', 'CU004', 'portal', 'Hop dong CO004 da duoc tao (du lieu demo)'),
    ('NO005', 'CU005', 'portal', 'Hop dong CO005 da duoc tao (du lieu demo)')
ON CONFLICT (code) DO NOTHING;
