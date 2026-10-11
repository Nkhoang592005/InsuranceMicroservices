-- Validate logical links and calculated values between the optional demo modules.
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM quotes.records q LEFT JOIN customers.records c ON c.code=q.customer_code LEFT JOIN products.records p ON p.code=q.product_code WHERE c.code IS NULL OR p.code IS NULL)
    OR EXISTS (SELECT 1 FROM contracts.records c LEFT JOIN quotes.records q ON q.code=c.quote_code LEFT JOIN agents.records a ON a.code=c.agent_code WHERE q.code IS NULL OR a.code IS NULL)
    OR EXISTS (SELECT 1 FROM billing.records b LEFT JOIN contracts.records c ON c.code=b.contract_code WHERE c.code IS NULL)
    OR EXISTS (SELECT 1 FROM payments.records p LEFT JOIN billing.records b ON b.code=p.invoice_code WHERE b.code IS NULL)
    OR EXISTS (SELECT 1 FROM claims.records cl LEFT JOIN contracts.records c ON c.code=cl.contract_code WHERE c.code IS NULL OR cl.incident_on NOT BETWEEN c.starts_on AND c.ends_on)
    OR EXISTS (SELECT 1 FROM commissions.records co LEFT JOIN contracts.records c ON c.code=co.contract_code LEFT JOIN agents.records a ON a.code=co.agent_code WHERE c.code IS NULL OR a.code IS NULL OR co.agent_code<>c.agent_code)
    OR EXISTS (SELECT 1 FROM renewals.records r LEFT JOIN contracts.records c ON c.code=r.contract_code WHERE c.code IS NULL OR r.renewal_on<=c.ends_on)
    OR EXISTS (SELECT 1 FROM underwriting.records u LEFT JOIN quotes.records q ON q.code=u.quote_code WHERE q.code IS NULL)
    OR EXISTS (SELECT 1 FROM risk.records r LEFT JOIN customers.records c ON c.code=r.customer_code WHERE c.code IS NULL)
    OR EXISTS (SELECT 1 FROM notifications.records n LEFT JOIN customers.records c ON c.code=n.customer_code WHERE c.code IS NULL)
    OR EXISTS (SELECT 1 FROM reporting.records r LEFT JOIN products.records p ON p.code=r.product_code WHERE p.code IS NULL)
    OR EXISTS (SELECT 1 FROM audit.records au LEFT JOIN agents.records a ON a.code=au.actor_code LEFT JOIN contracts.records c ON c.code=au.entity_code WHERE a.code IS NULL OR c.code IS NULL)
    OR EXISTS (SELECT 1 FROM identity.records i LEFT JOIN agents.records a ON a.code=i.agent_code WHERE a.code IS NULL)
    OR EXISTS (SELECT 1 FROM support.records s LEFT JOIN customers.records c ON c.code=s.customer_code WHERE c.code IS NULL)
    OR EXISTS (SELECT 1 FROM workflow.records w LEFT JOIN contracts.records c ON c.code=w.contract_code WHERE c.code IS NULL)
    THEN RAISE EXCEPTION 'Invalid demo relationship or date'; END IF;

    IF EXISTS (SELECT 1 FROM payments.records p JOIN billing.records b ON b.code=p.invoice_code WHERE p.amount_paid<>b.amount_due)
    OR EXISTS (SELECT 1 FROM billing.records b JOIN contracts.records c ON c.code=b.contract_code JOIN quotes.records q ON q.code=c.quote_code WHERE b.amount_due<>q.quoted_premium)
    OR EXISTS (SELECT 1 FROM commissions.records co JOIN agents.records a ON a.code=co.agent_code JOIN billing.records b ON b.contract_code=co.contract_code WHERE co.commission_amount<>ROUND(b.amount_due*a.commission_rate/100,2))
    THEN RAISE EXCEPTION 'Incorrect demo payment or commission'; END IF;
END $$;

-- Ensure invalid business values really are rejected, without persisting test rows.
DO $$
BEGIN
    BEGIN
        INSERT INTO products.records VALUES ('__INVALID__','Invalid product','motor',-1);
        RAISE EXCEPTION 'Negative premium was accepted';
    EXCEPTION WHEN check_violation THEN NULL;
    END;
    BEGIN
        INSERT INTO contracts.records VALUES ('__INVALID__','QU001','AG001','2026-12-31','2026-01-01');
        RAISE EXCEPTION 'Reversed contract dates were accepted';
    EXCEPTION WHEN check_violation THEN NULL;
    END;
END $$;
