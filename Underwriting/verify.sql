DO $$ BEGIN
    IF (SELECT COUNT(*) FROM underwriting.records WHERE code IN ('UN001', 'UN002', 'UN003', 'UN004', 'UN005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in underwriting';
    END IF;
END $$;
