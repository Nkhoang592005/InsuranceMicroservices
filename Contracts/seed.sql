-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO contracts.records (code, quote_code, agent_code, starts_on, ends_on) VALUES
    ('CO001', 'QU001', 'AG001', '2026-01-01', '2026-12-31'),
    ('CO002', 'QU002', 'AG002', '2026-01-01', '2026-12-31'),
    ('CO003', 'QU003', 'AG003', '2026-01-01', '2026-12-31'),
    ('CO004', 'QU004', 'AG004', '2026-01-01', '2026-12-31'),
    ('CO005', 'QU005', 'AG005', '2026-01-01', '2026-12-31')
ON CONFLICT (code) DO NOTHING;
