-- Vault Feature Migration
-- Run this SQL against your PostgreSQL database

-- ============================================
-- 1. Add vault password fields to users table
-- ============================================
ALTER TABLE users ADD COLUMN IF NOT EXISTS vault_password_hash VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS vault_password_salt VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS vault_setup_completed BOOLEAN DEFAULT FALSE;

-- ============================================
-- 2. Add is_in_vault flag to memory table
-- ============================================
ALTER TABLE memory ADD COLUMN IF NOT EXISTS is_in_vault BOOLEAN DEFAULT FALSE;

-- ============================================
-- 3. Add is_in_vault flag to journal table
-- ============================================
ALTER TABLE journal ADD COLUMN IF NOT EXISTS is_in_vault BOOLEAN DEFAULT FALSE;

-- ============================================
-- 4. Create indexes for efficient vault queries
-- ============================================
CREATE INDEX IF NOT EXISTS idx_memory_user_vault ON memory(user_id, is_in_vault);
CREATE INDEX IF NOT EXISTS idx_journal_user_vault ON journal(user_id, is_in_vault);

-- ============================================
-- 5. Update existing records (set default value)
-- ============================================
UPDATE memory SET is_in_vault = FALSE WHERE is_in_vault IS NULL;
UPDATE journal SET is_in_vault = FALSE WHERE is_in_vault IS NULL;
UPDATE users SET vault_setup_completed = FALSE WHERE vault_setup_completed IS NULL;
