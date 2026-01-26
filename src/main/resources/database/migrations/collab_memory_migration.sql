-- Collaborative Memory Feature Migration
-- Run this SQL against your PostgreSQL database

-- ============================================
-- 1. Create memory_members table for collaboration
-- ============================================
CREATE TABLE IF NOT EXISTS memory_members (
    id SERIAL PRIMARY KEY,
    memory_id INTEGER NOT NULL REFERENCES memory(memory_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL DEFAULT 'member', -- 'owner' or 'member'
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(memory_id, user_id)
);

-- Create indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_memory_members_memory ON memory_members(memory_id);
CREATE INDEX IF NOT EXISTS idx_memory_members_user ON memory_members(user_id);

-- ============================================
-- 2. Add collaborative fields to memory table
-- ============================================
ALTER TABLE memory ADD COLUMN IF NOT EXISTS is_collaborative BOOLEAN DEFAULT FALSE;
ALTER TABLE memory ADD COLUMN IF NOT EXISTS collab_share_key VARCHAR(20);

-- Unique index on share key (only for non-null values)
CREATE UNIQUE INDEX IF NOT EXISTS idx_memory_collab_key ON memory(collab_share_key) WHERE collab_share_key IS NOT NULL;

-- ============================================
-- 3. Update existing records
-- ============================================
UPDATE memory SET is_collaborative = FALSE WHERE is_collaborative IS NULL;
