-- Autograph Sharing Feature Migration
-- Run this SQL against your PostgreSQL database
-- Database: everly

-- ============================================
-- 1. Add share_token column to autograph table
--    (needed for generating shareable links)
-- ============================================
ALTER TABLE autograph ADD COLUMN IF NOT EXISTS share_token VARCHAR(50);

-- Unique index on share_token (only for non-null values)
CREATE UNIQUE INDEX IF NOT EXISTS idx_autograph_share_token 
    ON autograph(share_token) WHERE share_token IS NOT NULL;

-- ============================================
-- 2. Add content_plain column to autograph_entry table
--    (stores plain text version of the rich HTML content)
-- ============================================
ALTER TABLE autograph_entry ADD COLUMN IF NOT EXISTS content_plain TEXT;

-- ============================================
-- 3. Drop the UNIQUE constraint on link column
--    (multiple entries can share the same token/link)
-- ============================================
ALTER TABLE autograph_entry DROP CONSTRAINT IF EXISTS autograph_entry_link_key;
