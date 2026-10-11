-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO risk.records (code, customer_code, risk_score, risk_level) VALUES
    ('RI001', 'CU001', 10, 'low'),
    ('RI002', 'CU002', 20, 'low'),
    ('RI003', 'CU003', 30, 'low'),
    ('RI004', 'CU004', 40, 'medium'),
    ('RI005', 'CU005', 50, 'medium')
ON CONFLICT (code) DO NOTHING;
