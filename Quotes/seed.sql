-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO quotes.records (code, customer_code, product_code, quoted_premium) VALUES
    ('QU001', 'CU001', 'PR001', 1200000),
    ('QU002', 'CU002', 'PR002', 2500000),
    ('QU003', 'CU003', 'PR003', 1800000),
    ('QU004', 'CU004', 'PR004', 300000),
    ('QU005', 'CU005', 'PR005', 650000)
ON CONFLICT (code) DO NOTHING;
