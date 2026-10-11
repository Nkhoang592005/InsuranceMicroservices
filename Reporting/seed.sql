-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO reporting.records (code, report_month, product_code, premium_total) VALUES
    ('RE001', '2026-01-01', 'PR001', 1200000),
    ('RE002', '2026-01-01', 'PR002', 2500000),
    ('RE003', '2026-01-01', 'PR003', 1800000),
    ('RE004', '2026-01-01', 'PR004', 300000),
    ('RE005', '2026-01-01', 'PR005', 650000)
ON CONFLICT (code) DO NOTHING;
