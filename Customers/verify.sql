DO $$ BEGIN
    IF (SELECT COUNT(*) FROM customers.records WHERE code IN ('CU001', 'CU002', 'CU003', 'CU004', 'CU005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in customers';
    END IF;
END $$;
