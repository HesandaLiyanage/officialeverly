-- ============================================
-- COMPLETE SQL FOR FEED POSTS FEATURE
-- ============================================
-- Tables required: users, memory, memory_media, feed_profiles
-- Run these queries in order in your PostgreSQL database
-- ============================================

-- 1. Create feed_profiles table (if not exists)
-- This stores separate feed profile info for each user
CREATE TABLE IF NOT EXISTS feed_profiles (
    feed_profile_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    feed_username VARCHAR(50) NOT NULL UNIQUE,
    feed_profile_picture_url TEXT,
    feed_bio VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_feed_profiles_user_id ON feed_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_feed_profiles_feed_username ON feed_profiles(feed_username);

-- 2. Create feed_posts table
-- This links posts to memories and feed profiles
CREATE TABLE IF NOT EXISTS feed_posts (
    post_id SERIAL PRIMARY KEY,
    memory_id INTEGER NOT NULL REFERENCES memory(memory_id) ON DELETE CASCADE,
    feed_profile_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    caption TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_feed_posts_feed_profile ON feed_posts(feed_profile_id);
CREATE INDEX IF NOT EXISTS idx_feed_posts_created ON feed_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_feed_posts_memory ON feed_posts(memory_id);

-- Comments for documentation
COMMENT ON TABLE feed_posts IS 'Stores posts shared to the public feed, each backed by a memory';
COMMENT ON COLUMN feed_posts.memory_id IS 'Reference to the memory being shared as a post';
COMMENT ON COLUMN feed_posts.feed_profile_id IS 'Reference to the feed profile of the poster';
COMMENT ON COLUMN feed_posts.caption IS 'Optional caption/description for the post';
