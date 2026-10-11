-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO underwriting.records (code, quote_code, decision, review_note) VALUES
    ('UN001', 'QU001', 'approved', 'Ho so gia lap du dieu kien'),
    ('UN002', 'QU002', 'approved', 'Ho so gia lap du dieu kien'),
    ('UN003', 'QU003', 'approved', 'Ho so gia lap du dieu kien'),
    ('UN004', 'QU004', 'approved', 'Ho so gia lap du dieu kien'),
    ('UN005', 'QU005', 'approved', 'Ho so gia lap du dieu kien')
ON CONFLICT (code) DO NOTHING;
