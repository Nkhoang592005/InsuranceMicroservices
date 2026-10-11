-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO billing.records (code, contract_code, amount_due, due_on) VALUES
    ('BI001', 'CO001', 1200000, '2026-01-10'),
    ('BI002', 'CO002', 2500000, '2026-01-10'),
    ('BI003', 'CO003', 1800000, '2026-01-10'),
    ('BI004', 'CO004', 300000, '2026-01-10'),
    ('BI005', 'CO005', 650000, '2026-01-10')
ON CONFLICT (code) DO NOTHING;
