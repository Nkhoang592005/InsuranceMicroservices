DO $$ BEGIN
    IF (SELECT COUNT(*) FROM notifications.records WHERE code IN ('NO001', 'NO002', 'NO003', 'NO004', 'NO005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in notifications';
    END IF;
END $$;
