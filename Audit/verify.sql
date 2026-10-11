DO $$ BEGIN
    IF (SELECT COUNT(*) FROM audit.records WHERE code IN ('AU001', 'AU002', 'AU003', 'AU004', 'AU005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in audit';
    END IF;
END $$;
