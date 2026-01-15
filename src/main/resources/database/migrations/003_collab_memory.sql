-- ============================================================
-- Collaborative Memory Feature Migration
-- Run this migration to enable collaborative memory sharing
-- ============================================================

-- Add collaboration fields to memory table
ALTER TABLE memory ADD COLUMN IF NOT EXISTS is_collaborative BOOLEAN DEFAULT FALSE;
ALTER TABLE memory ADD COLUMN IF NOT EXISTS group_key_id VARCHAR(255);

-- Table for storing invite links
CREATE TABLE IF NOT EXISTS memory_invite_link (
    invite_id SERIAL PRIMARY KEY,
    memory_id INTEGER NOT NULL REFERENCES memory(memory_id) ON DELETE CASCADE,
    invite_token VARCHAR(64) UNIQUE NOT NULL,
    created_by INTEGER NOT NULL REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    max_uses INTEGER,
    use_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table for memory members (collaborators)
CREATE TABLE IF NOT EXISTS memory_member (
    member_id SERIAL PRIMARY KEY,
    memory_id INTEGER NOT NULL REFERENCES memory(memory_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    role VARCHAR(20) DEFAULT 'contributor', -- 'owner', 'contributor'
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    encrypted_group_key BYTEA, -- Group key encrypted with user's master key
    group_key_iv BYTEA,
    UNIQUE(memory_id, user_id)
);

-- Index for fast invite token lookup
CREATE INDEX IF NOT EXISTS idx_invite_token ON memory_invite_link(invite_token);
CREATE INDEX IF NOT EXISTS idx_memory_members ON memory_member(memory_id, user_id);

-- Track which media item was uploaded by which user in collab memories
-- (The user_id column already exists and tracks the uploader)
-- Adding a separate column for clarity in collaborative contexts
ALTER TABLE media_items ADD COLUMN IF NOT EXISTS uploaded_by_user_id INTEGER REFERENCES users(user_id);

-- Backfill existing media items: set uploaded_by_user_id = user_id for existing records
UPDATE media_items SET uploaded_by_user_id = user_id WHERE uploaded_by_user_id IS NULL;
