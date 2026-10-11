-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO audit.records (code, actor_code, action_name, entity_code) VALUES
    ('AU001', 'AG001', 'create_contract', 'CO001'),
    ('AU002', 'AG002', 'create_contract', 'CO002'),
    ('AU003', 'AG003', 'create_contract', 'CO003'),
    ('AU004', 'AG004', 'create_contract', 'CO004'),
    ('AU005', 'AG005', 'create_contract', 'CO005')
ON CONFLICT (code) DO NOTHING;
