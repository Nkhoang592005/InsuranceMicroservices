-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO customers.records (code, full_name, email, city) VALUES
    ('CU001', 'Khach hang demo 1', 'customer1@example.test', 'Ha Noi'),
    ('CU002', 'Khach hang demo 2', 'customer2@example.test', 'Ha Noi'),
    ('CU003', 'Khach hang demo 3', 'customer3@example.test', 'Ha Noi'),
    ('CU004', 'Khach hang demo 4', 'customer4@example.test', 'Ha Noi'),
    ('CU005', 'Khach hang demo 5', 'customer5@example.test', 'Ha Noi')
ON CONFLICT (code) DO NOTHING;
