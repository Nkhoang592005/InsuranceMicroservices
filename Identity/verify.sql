DO $$ BEGIN
    IF (SELECT COUNT(*) FROM identity.records WHERE code IN ('ID001', 'ID002', 'ID003', 'ID004', 'ID005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in identity';
    END IF;
END $$;
