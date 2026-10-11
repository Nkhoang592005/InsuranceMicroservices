-- Fictional fixtures. Reruns preserve existing records with the same code.
INSERT INTO workflow.records (code, contract_code, step_name, step_status) VALUES
    ('WO001', 'CO001', 'issue_contract', 'completed'),
    ('WO002', 'CO002', 'issue_contract', 'completed'),
    ('WO003', 'CO003', 'issue_contract', 'completed'),
    ('WO004', 'CO004', 'issue_contract', 'completed'),
    ('WO005', 'CO005', 'issue_contract', 'completed')
ON CONFLICT (code) DO NOTHING;
