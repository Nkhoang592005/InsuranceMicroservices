-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO identity.records (code, username, agent_code, role_name) VALUES
    ('ID001', 'demo_agent_1', 'AG001', 'agent'),
    ('ID002', 'demo_agent_2', 'AG002', 'agent'),
    ('ID003', 'demo_agent_3', 'AG003', 'agent'),
    ('ID004', 'demo_agent_4', 'AG004', 'agent'),
    ('ID005', 'demo_agent_5', 'AG005', 'agent')
ON CONFLICT (code) DO NOTHING;
