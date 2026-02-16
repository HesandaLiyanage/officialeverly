-- Add memory_limit column to plans table
ALTER TABLE plans ADD COLUMN IF NOT EXISTS memory_limit INT DEFAULT -1;

-- Update plans with memory limits
-- Basic: 50 memories
-- Others: Unlimited (-1)

UPDATE plans SET memory_limit = 50 WHERE name = 'Basic';
UPDATE plans SET memory_limit = -1 WHERE name IN ('Premium', 'Pro', 'Family');
