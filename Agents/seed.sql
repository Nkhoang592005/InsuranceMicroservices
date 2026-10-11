-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO agents.records (code, full_name, email, commission_rate) VALUES
    ('AG001', 'Dai ly demo 1', 'agent1@example.test', 6),
    ('AG002', 'Dai ly demo 2', 'agent2@example.test', 7),
    ('AG003', 'Dai ly demo 3', 'agent3@example.test', 8),
    ('AG004', 'Dai ly demo 4', 'agent4@example.test', 9),
    ('AG005', 'Dai ly demo 5', 'agent5@example.test', 10)
ON CONFLICT (code) DO NOTHING;
