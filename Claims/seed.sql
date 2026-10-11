-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO claims.records (code, contract_code, incident_on, claimed_amount) VALUES
    ('CL001', 'CO001', '2026-03-15', 100000),
    ('CL002', 'CO002', '2026-03-15', 200000),
    ('CL003', 'CO003', '2026-03-15', 300000),
    ('CL004', 'CO004', '2026-03-15', 400000),
    ('CL005', 'CO005', '2026-03-15', 500000)
ON CONFLICT (code) DO NOTHING;
