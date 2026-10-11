DO $$ BEGIN
    IF (SELECT COUNT(*) FROM commissions.records WHERE code IN ('CO001', 'CO002', 'CO003', 'CO004', 'CO005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in commissions';
    END IF;
END $$;
