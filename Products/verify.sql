DO $$ BEGIN
    IF (SELECT COUNT(*) FROM products.records WHERE code IN ('PR001', 'PR002', 'PR003', 'PR004', 'PR005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in products';
    END IF;
END $$;
