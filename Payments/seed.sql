-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO payments.records (code, invoice_code, amount_paid, payment_method) VALUES
    ('PA001', 'BI001', 1200000, 'bank_transfer'),
    ('PA002', 'BI002', 2500000, 'bank_transfer'),
    ('PA003', 'BI003', 1800000, 'bank_transfer'),
    ('PA004', 'BI004', 300000, 'bank_transfer'),
    ('PA005', 'BI005', 650000, 'bank_transfer')
ON CONFLICT (code) DO NOTHING;
