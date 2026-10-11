DO $$ BEGIN
    IF (SELECT COUNT(*) FROM payments.records WHERE code IN ('PA001', 'PA002', 'PA003', 'PA004', 'PA005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in payments';
    END IF;
END $$;
