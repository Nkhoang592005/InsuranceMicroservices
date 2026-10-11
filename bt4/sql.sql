CREATE TABLE IF NOT EXISTS public.policies (
    id SERIAL PRIMARY KEY,
    policy_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO public.policies (policy_name, description) VALUES
('Default Policy', 'Chính sách mặc định cho hệ thống'),
('Security Policy', 'Chính sách bảo mật Microservices');