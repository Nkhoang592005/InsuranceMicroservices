DO $$ BEGIN
    IF (SELECT COUNT(*) FROM renewals.records WHERE code IN ('RE001', 'RE002', 'RE003', 'RE004', 'RE005')) <> 5 THEN
        RAISE EXCEPTION 'Missing fixtures in renewals';
    END IF;
END $$;
