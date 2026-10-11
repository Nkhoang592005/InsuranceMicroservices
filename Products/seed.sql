-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO products.records (code, product_name, category, base_premium) VALUES
    ('PR001', 'Bao hiem xe', 'motor', 1200000),
    ('PR002', 'Bao hiem suc khoe', 'health', 2500000),
    ('PR003', 'Bao hiem nha', 'property', 1800000),
    ('PR004', 'Bao hiem du lich', 'travel', 300000),
    ('PR005', 'Bao hiem tai nan', 'accident', 650000)
ON CONFLICT (code) DO NOTHING;
