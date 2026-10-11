-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO commissions.records (code, agent_code, contract_code, commission_amount) VALUES
    ('CO001', 'AG001', 'CO001', 72000.0),
    ('CO002', 'AG002', 'CO002', 175000.0),
    ('CO003', 'AG003', 'CO003', 144000.0),
    ('CO004', 'AG004', 'CO004', 27000.0),
    ('CO005', 'AG005', 'CO005', 65000.0)
ON CONFLICT (code) DO NOTHING;
