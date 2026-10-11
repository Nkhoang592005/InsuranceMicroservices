-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO renewals.records (code, contract_code, renewal_on, renewal_premium) VALUES
    ('RE001', 'CO001', '2027-01-01', 1200000),
    ('RE002', 'CO002', '2027-01-01', 2500000),
    ('RE003', 'CO003', '2027-01-01', 1800000),
    ('RE004', 'CO004', '2027-01-01', 300000),
    ('RE005', 'CO005', '2027-01-01', 650000)
ON CONFLICT (code) DO NOTHING;
