DO $$ BEGIN
    IF (SELECT COUNT(*) FROM billing.records WHERE code IN ('BI001', 'BI002', 'BI003', 'BI004', 'BI005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in billing';
    END IF;
END $$;
