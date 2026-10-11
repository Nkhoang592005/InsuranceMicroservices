--
-- PostgreSQL database dump
--

\restrict QrhR33mQAIiEvkmbFzsCvMUqRTmfj5szTVTAfvamMRuJJ6RemqY8dDIQnPybA3o

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: agents; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA agents;


--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA audit;


--
-- Name: billing; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA billing;


--
-- Name: claims; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA claims;


--
-- Name: commissions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA commissions;


--
-- Name: contracts; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA contracts;


--
-- Name: customers; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA customers;


--
-- Name: identity; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA identity;


--
-- Name: notifications; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA notifications;


--
-- Name: payments; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA payments;


--
-- Name: products; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA products;


--
-- Name: quotes; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA quotes;


--
-- Name: renewals; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA renewals;


--
-- Name: reporting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA reporting;


--
-- Name: risk; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA risk;


--
-- Name: support; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA support;


--
-- Name: underwriting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA underwriting;


--
-- Name: workflow; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA workflow;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: records; Type: TABLE; Schema: agents; Owner: -
--

CREATE TABLE agents.records (
    code text NOT NULL,
    full_name text NOT NULL,
    email text NOT NULL,
    commission_rate numeric(5,2) NOT NULL,
    CONSTRAINT records_commission_rate_check CHECK (((commission_rate >= (0)::numeric) AND (commission_rate <= (100)::numeric)))
);


--
-- Name: records; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.records (
    code text NOT NULL,
    actor_code text NOT NULL,
    action_name text NOT NULL,
    entity_code text NOT NULL
);


--
-- Name: records; Type: TABLE; Schema: billing; Owner: -
--

CREATE TABLE billing.records (
    code text NOT NULL,
    contract_code text NOT NULL,
    amount_due numeric(14,2) NOT NULL,
    due_on date NOT NULL,
    CONSTRAINT records_amount_due_check CHECK ((amount_due > (0)::numeric))
);


--
-- Name: records; Type: TABLE; Schema: claims; Owner: -
--

CREATE TABLE claims.records (
    code text NOT NULL,
    contract_code text NOT NULL,
    incident_on date NOT NULL,
    claimed_amount numeric(14,2) NOT NULL,
    CONSTRAINT records_claimed_amount_check CHECK ((claimed_amount > (0)::numeric))
);


--
-- Name: records; Type: TABLE; Schema: commissions; Owner: -
--

CREATE TABLE commissions.records (
    code text NOT NULL,
    agent_code text NOT NULL,
    contract_code text NOT NULL,
    commission_amount numeric(14,2) NOT NULL,
    CONSTRAINT records_commission_amount_check CHECK ((commission_amount >= (0)::numeric))
);


--
-- Name: records; Type: TABLE; Schema: contracts; Owner: -
--

CREATE TABLE contracts.records (
    code text NOT NULL,
    quote_code text NOT NULL,
    agent_code text NOT NULL,
    starts_on date NOT NULL,
    ends_on date NOT NULL,
    CONSTRAINT records_check CHECK ((ends_on > starts_on))
);


--
-- Name: records; Type: TABLE; Schema: customers; Owner: -
--

CREATE TABLE customers.records (
    code text NOT NULL,
    full_name text NOT NULL,
    email text NOT NULL,
    city text NOT NULL
);


--
-- Name: records; Type: TABLE; Schema: identity; Owner: -
--

CREATE TABLE identity.records (
    code text NOT NULL,
    username text NOT NULL,
    agent_code text NOT NULL,
    role_name text NOT NULL,
    CONSTRAINT records_role_name_check CHECK ((role_name = ANY (ARRAY['agent'::text, 'admin'::text, 'reviewer'::text])))
);


--
-- Name: records; Type: TABLE; Schema: notifications; Owner: -
--

CREATE TABLE notifications.records (
    code text NOT NULL,
    customer_code text NOT NULL,
    channel text NOT NULL,
    message_body text NOT NULL,
    CONSTRAINT records_channel_check CHECK ((channel = ANY (ARRAY['email'::text, 'sms'::text, 'portal'::text])))
);


--
-- Name: records; Type: TABLE; Schema: payments; Owner: -
--

CREATE TABLE payments.records (
    code text NOT NULL,
    invoice_code text NOT NULL,
    amount_paid numeric(14,2) NOT NULL,
    payment_method text NOT NULL,
    CONSTRAINT records_amount_paid_check CHECK ((amount_paid > (0)::numeric)),
    CONSTRAINT records_payment_method_check CHECK ((payment_method = ANY (ARRAY['bank_transfer'::text, 'card'::text, 'cash'::text])))
);


--
-- Name: records; Type: TABLE; Schema: products; Owner: -
--

CREATE TABLE products.records (
    code text NOT NULL,
    product_name text NOT NULL,
    category text NOT NULL,
    base_premium numeric(14,2) NOT NULL,
    CONSTRAINT records_base_premium_check CHECK ((base_premium > (0)::numeric))
);


--
-- Name: records; Type: TABLE; Schema: quotes; Owner: -
--

CREATE TABLE quotes.records (
    code text NOT NULL,
    customer_code text NOT NULL,
    product_code text NOT NULL,
    quoted_premium numeric(14,2) NOT NULL,
    CONSTRAINT records_quoted_premium_check CHECK ((quoted_premium > (0)::numeric))
);


--
-- Name: records; Type: TABLE; Schema: renewals; Owner: -
--

CREATE TABLE renewals.records (
    code text NOT NULL,
    contract_code text NOT NULL,
    renewal_on date NOT NULL,
    renewal_premium numeric(14,2) NOT NULL,
    CONSTRAINT records_renewal_premium_check CHECK ((renewal_premium > (0)::numeric))
);


--
-- Name: records; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE reporting.records (
    code text NOT NULL,
    report_month date NOT NULL,
    product_code text NOT NULL,
    premium_total numeric(14,2) NOT NULL,
    CONSTRAINT records_premium_total_check CHECK ((premium_total >= (0)::numeric))
);


--
-- Name: records; Type: TABLE; Schema: risk; Owner: -
--

CREATE TABLE risk.records (
    code text NOT NULL,
    customer_code text NOT NULL,
    risk_score integer NOT NULL,
    risk_level text NOT NULL,
    CONSTRAINT records_risk_level_check CHECK ((risk_level = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text]))),
    CONSTRAINT records_risk_score_check CHECK (((risk_score >= 0) AND (risk_score <= 100)))
);


--
-- Name: records; Type: TABLE; Schema: support; Owner: -
--

CREATE TABLE support.records (
    code text NOT NULL,
    customer_code text NOT NULL,
    subject text NOT NULL,
    ticket_status text NOT NULL,
    CONSTRAINT records_ticket_status_check CHECK ((ticket_status = ANY (ARRAY['open'::text, 'resolved'::text, 'closed'::text])))
);


--
-- Name: records; Type: TABLE; Schema: underwriting; Owner: -
--

CREATE TABLE underwriting.records (
    code text NOT NULL,
    quote_code text NOT NULL,
    decision text NOT NULL,
    review_note text NOT NULL,
    CONSTRAINT records_decision_check CHECK ((decision = ANY (ARRAY['approved'::text, 'review'::text, 'declined'::text])))
);


--
-- Name: records; Type: TABLE; Schema: workflow; Owner: -
--

CREATE TABLE workflow.records (
    code text NOT NULL,
    contract_code text NOT NULL,
    step_name text NOT NULL,
    step_status text NOT NULL,
    CONSTRAINT records_step_status_check CHECK ((step_status = ANY (ARRAY['pending'::text, 'completed'::text, 'failed'::text])))
);


--
-- Data for Name: records; Type: TABLE DATA; Schema: agents; Owner: -
--

COPY agents.records (code, full_name, email, commission_rate) FROM stdin;
AG001	Dai ly demo 1	agent1@example.test	6.00
AG002	Dai ly demo 2	agent2@example.test	7.00
AG003	Dai ly demo 3	agent3@example.test	8.00
AG004	Dai ly demo 4	agent4@example.test	9.00
AG005	Dai ly demo 5	agent5@example.test	10.00
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: audit; Owner: -
--

COPY audit.records (code, actor_code, action_name, entity_code) FROM stdin;
AU001	AG001	create_contract	CO001
AU002	AG002	create_contract	CO002
AU003	AG003	create_contract	CO003
AU004	AG004	create_contract	CO004
AU005	AG005	create_contract	CO005
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: billing; Owner: -
--

COPY billing.records (code, contract_code, amount_due, due_on) FROM stdin;
BI001	CO001	1200000.00	2026-01-10
BI002	CO002	2500000.00	2026-01-10
BI003	CO003	1800000.00	2026-01-10
BI004	CO004	300000.00	2026-01-10
BI005	CO005	650000.00	2026-01-10
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: claims; Owner: -
--

COPY claims.records (code, contract_code, incident_on, claimed_amount) FROM stdin;
CL001	CO001	2026-03-15	100000.00
CL002	CO002	2026-03-15	200000.00
CL003	CO003	2026-03-15	300000.00
CL004	CO004	2026-03-15	400000.00
CL005	CO005	2026-03-15	500000.00
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: commissions; Owner: -
--

COPY commissions.records (code, agent_code, contract_code, commission_amount) FROM stdin;
CO001	AG001	CO001	72000.00
CO002	AG002	CO002	175000.00
CO003	AG003	CO003	144000.00
CO004	AG004	CO004	27000.00
CO005	AG005	CO005	65000.00
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: contracts; Owner: -
--

COPY contracts.records (code, quote_code, agent_code, starts_on, ends_on) FROM stdin;
CO001	QU001	AG001	2026-01-01	2026-12-31
CO002	QU002	AG002	2026-01-01	2026-12-31
CO003	QU003	AG003	2026-01-01	2026-12-31
CO004	QU004	AG004	2026-01-01	2026-12-31
CO005	QU005	AG005	2026-01-01	2026-12-31
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: customers; Owner: -
--

COPY customers.records (code, full_name, email, city) FROM stdin;
CU001	Khach hang demo 1	customer1@example.test	Ha Noi
CU002	Khach hang demo 2	customer2@example.test	Ha Noi
CU003	Khach hang demo 3	customer3@example.test	Ha Noi
CU004	Khach hang demo 4	customer4@example.test	Ha Noi
CU005	Khach hang demo 5	customer5@example.test	Ha Noi
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: identity; Owner: -
--

COPY identity.records (code, username, agent_code, role_name) FROM stdin;
ID001	demo_agent_1	AG001	agent
ID002	demo_agent_2	AG002	agent
ID003	demo_agent_3	AG003	agent
ID004	demo_agent_4	AG004	agent
ID005	demo_agent_5	AG005	agent
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: notifications; Owner: -
--

COPY notifications.records (code, customer_code, channel, message_body) FROM stdin;
NO001	CU001	portal	Hop dong CO001 da duoc tao (du lieu demo)
NO002	CU002	portal	Hop dong CO002 da duoc tao (du lieu demo)
NO003	CU003	portal	Hop dong CO003 da duoc tao (du lieu demo)
NO004	CU004	portal	Hop dong CO004 da duoc tao (du lieu demo)
NO005	CU005	portal	Hop dong CO005 da duoc tao (du lieu demo)
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: payments; Owner: -
--

COPY payments.records (code, invoice_code, amount_paid, payment_method) FROM stdin;
PA001	BI001	1200000.00	bank_transfer
PA002	BI002	2500000.00	bank_transfer
PA003	BI003	1800000.00	bank_transfer
PA004	BI004	300000.00	bank_transfer
PA005	BI005	650000.00	bank_transfer
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: products; Owner: -
--

COPY products.records (code, product_name, category, base_premium) FROM stdin;
PR001	Bao hiem xe	motor	1200000.00
PR002	Bao hiem suc khoe	health	2500000.00
PR003	Bao hiem nha	property	1800000.00
PR004	Bao hiem du lich	travel	300000.00
PR005	Bao hiem tai nan	accident	650000.00
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: quotes; Owner: -
--

COPY quotes.records (code, customer_code, product_code, quoted_premium) FROM stdin;
QU001	CU001	PR001	1200000.00
QU002	CU002	PR002	2500000.00
QU003	CU003	PR003	1800000.00
QU004	CU004	PR004	300000.00
QU005	CU005	PR005	650000.00
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: renewals; Owner: -
--

COPY renewals.records (code, contract_code, renewal_on, renewal_premium) FROM stdin;
RE001	CO001	2027-01-01	1200000.00
RE002	CO002	2027-01-01	2500000.00
RE003	CO003	2027-01-01	1800000.00
RE004	CO004	2027-01-01	300000.00
RE005	CO005	2027-01-01	650000.00
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: reporting; Owner: -
--

COPY reporting.records (code, report_month, product_code, premium_total) FROM stdin;
RE001	2026-01-01	PR001	1200000.00
RE002	2026-01-01	PR002	2500000.00
RE003	2026-01-01	PR003	1800000.00
RE004	2026-01-01	PR004	300000.00
RE005	2026-01-01	PR005	650000.00
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: risk; Owner: -
--

COPY risk.records (code, customer_code, risk_score, risk_level) FROM stdin;
RI001	CU001	10	low
RI002	CU002	20	low
RI003	CU003	30	low
RI004	CU004	40	medium
RI005	CU005	50	medium
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: support; Owner: -
--

COPY support.records (code, customer_code, subject, ticket_status) FROM stdin;
SU001	CU001	Huong dan thanh toan hop dong demo	open
SU002	CU002	Huong dan thanh toan hop dong demo	open
SU003	CU003	Huong dan thanh toan hop dong demo	open
SU004	CU004	Huong dan thanh toan hop dong demo	open
SU005	CU005	Huong dan thanh toan hop dong demo	open
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: underwriting; Owner: -
--

COPY underwriting.records (code, quote_code, decision, review_note) FROM stdin;
UN001	QU001	approved	Ho so gia lap du dieu kien
UN002	QU002	approved	Ho so gia lap du dieu kien
UN003	QU003	approved	Ho so gia lap du dieu kien
UN004	QU004	approved	Ho so gia lap du dieu kien
UN005	QU005	approved	Ho so gia lap du dieu kien
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: workflow; Owner: -
--

COPY workflow.records (code, contract_code, step_name, step_status) FROM stdin;
WO001	CO001	issue_contract	completed
WO002	CO002	issue_contract	completed
WO003	CO003	issue_contract	completed
WO004	CO004	issue_contract	completed
WO005	CO005	issue_contract	completed
\.


--
-- Name: records records_email_key; Type: CONSTRAINT; Schema: agents; Owner: -
--

ALTER TABLE ONLY agents.records
    ADD CONSTRAINT records_email_key UNIQUE (email);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: agents; Owner: -
--

ALTER TABLE ONLY agents.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: billing; Owner: -
--

ALTER TABLE ONLY billing.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: claims; Owner: -
--

ALTER TABLE ONLY claims.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: commissions; Owner: -
--

ALTER TABLE ONLY commissions.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: contracts; Owner: -
--

ALTER TABLE ONLY contracts.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_email_key; Type: CONSTRAINT; Schema: customers; Owner: -
--

ALTER TABLE ONLY customers.records
    ADD CONSTRAINT records_email_key UNIQUE (email);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: customers; Owner: -
--

ALTER TABLE ONLY customers.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: identity; Owner: -
--

ALTER TABLE ONLY identity.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_username_key; Type: CONSTRAINT; Schema: identity; Owner: -
--

ALTER TABLE ONLY identity.records
    ADD CONSTRAINT records_username_key UNIQUE (username);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: notifications; Owner: -
--

ALTER TABLE ONLY notifications.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: payments; Owner: -
--

ALTER TABLE ONLY payments.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: products; Owner: -
--

ALTER TABLE ONLY products.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: quotes; Owner: -
--

ALTER TABLE ONLY quotes.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: renewals; Owner: -
--

ALTER TABLE ONLY renewals.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY reporting.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: risk; Owner: -
--

ALTER TABLE ONLY risk.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: support; Owner: -
--

ALTER TABLE ONLY support.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: underwriting; Owner: -
--

ALTER TABLE ONLY underwriting.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: workflow; Owner: -
--

ALTER TABLE ONLY workflow.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (code);


--
-- PostgreSQL database dump complete
--

\unrestrict QrhR33mQAIiEvkmbFzsCvMUqRTmfj5szTVTAfvamMRuJJ6RemqY8dDIQnPybA3o

