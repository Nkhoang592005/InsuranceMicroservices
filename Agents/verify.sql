DO $$ BEGIN
    IF (SELECT COUNT(*) FROM agents.records WHERE code IN ('AG001', 'AG002', 'AG003', 'AG004', 'AG005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in agents';
    END IF;
END $$;
