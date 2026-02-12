-- Saved/Bookmarked Posts Table
-- Allows users to save posts to view later

CREATE TABLE IF NOT EXISTS saved_posts (
    saved_id SERIAL PRIMARY KEY,
    feed_profile_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    post_id INTEGER NOT NULL REFERENCES feed_posts(post_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_saved_post UNIQUE (feed_profile_id, post_id)
);

-- Index for faster lookups by user
CREATE INDEX IF NOT EXISTS idx_saved_posts_profile ON saved_posts(feed_profile_id);

-- Index for finding who saved a post
CREATE INDEX IF NOT EXISTS idx_saved_posts_post ON saved_posts(post_id);
