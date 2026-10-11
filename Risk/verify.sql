DO $$ BEGIN
    IF (SELECT COUNT(*) FROM risk.records WHERE code IN ('RI001', 'RI002', 'RI003', 'RI004', 'RI005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in risk';
    END IF;
END $$;
