-- Create plans table
CREATE TABLE IF NOT EXISTS plans (
    plan_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    storage_limit_bytes BIGINT NOT NULL,
    price_monthly DECIMAL(10, 2) NOT NULL,
    price_annual DECIMAL(10, 2) NOT NULL,
    max_members INT DEFAULT 1,
    description TEXT
);

-- Insert default plans
-- 20 GB = 21474836480 bytes
-- 250 GB = 268435456000 bytes
-- 1 TB = 1099511627776 bytes
-- 2 TB = 2199023255552 bytes

INSERT INTO plans (name, storage_limit_bytes, price_monthly, price_annual, max_members, description)
VALUES 
    ('Basic', 21474836480, 0.00, 0.00, 1, 'Free tier with 20GB storage'),
    ('Premium', 268435456000, 2.99, 2.39, 1, 'Premium tier with 250GB storage'),
    ('Pro', 1099511627776, 5.99, 4.79, 1, 'Pro tier with 1TB storage'),
    ('Family', 2199023255552, 9.99, 7.99, 6, 'Family tier with 2TB storage')
ON CONFLICT (name) DO NOTHING;

-- Add plan_id to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS plan_id INT DEFAULT 1 REFERENCES plans(plan_id);

-- Update existing users
UPDATE users SET plan_id = (SELECT plan_id FROM plans WHERE name = 'Basic') WHERE plan_id IS NULL;
