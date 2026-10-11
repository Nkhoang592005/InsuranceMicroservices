DO $$ BEGIN
    IF (SELECT COUNT(*) FROM quotes.records WHERE code IN ('QU001', 'QU002', 'QU003', 'QU004', 'QU005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in quotes';
    END IF;
END $$;
