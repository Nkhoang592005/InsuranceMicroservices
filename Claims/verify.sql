DO $$ BEGIN
    IF (SELECT COUNT(*) FROM claims.records WHERE code IN ('CL001', 'CL002', 'CL003', 'CL004', 'CL005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in claims';
    END IF;
END $$;
