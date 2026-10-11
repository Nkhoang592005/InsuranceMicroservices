DO $$ BEGIN
    IF (SELECT COUNT(*) FROM workflow.records WHERE code IN ('WO001', 'WO002', 'WO003', 'WO004', 'WO005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in workflow';
    END IF;
END $$;
