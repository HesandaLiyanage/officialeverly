-- Feed Posts Table
-- Run this SQL to create the feed_posts table in your PostgreSQL database

CREATE TABLE IF NOT EXISTS feed_posts (
    post_id SERIAL PRIMARY KEY,
    memory_id INTEGER NOT NULL REFERENCES memories(memory_id) ON DELETE CASCADE,
    feed_profile_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    caption TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_feed_posts_feed_profile ON feed_posts(feed_profile_id);
CREATE INDEX IF NOT EXISTS idx_feed_posts_created ON feed_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_feed_posts_memory ON feed_posts(memory_id);

-- Comments
COMMENT ON TABLE feed_posts IS 'Stores posts shared to the public feed, each backed by a memory';
COMMENT ON COLUMN feed_posts.memory_id IS 'Reference to the memory being shared as a post';
COMMENT ON COLUMN feed_posts.feed_profile_id IS 'Reference to the feed profile of the poster';
COMMENT ON COLUMN feed_posts.caption IS 'Optional caption/description for the post';
