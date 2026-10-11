DO $$ BEGIN
    IF (SELECT COUNT(*) FROM support.records WHERE code IN ('SU001', 'SU002', 'SU003', 'SU004', 'SU005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in support';
    END IF;
END $$;
