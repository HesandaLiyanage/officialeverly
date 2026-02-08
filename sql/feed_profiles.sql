-- Feed Profiles Table
-- Run this SQL to create the feed_profiles table in your PostgreSQL database

CREATE TABLE IF NOT EXISTS feed_profiles (
    feed_profile_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE REFERENCES users(user_id) ON DELETE CASCADE,
    feed_username VARCHAR(30) NOT NULL UNIQUE,
    feed_profile_picture_url VARCHAR(500),
    feed_bio VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_feed_profiles_user_id ON feed_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_feed_profiles_feed_username ON feed_profiles(feed_username);

-- Comments
COMMENT ON TABLE feed_profiles IS 'Stores feed profile information separate from main user accounts';
COMMENT ON COLUMN feed_profiles.user_id IS 'Reference to the main users table';
COMMENT ON COLUMN feed_profiles.feed_username IS 'Unique username for the feed (lowercase, alphanumeric + underscores)';
COMMENT ON COLUMN feed_profiles.feed_profile_picture_url IS 'URL to profile picture for feed';
COMMENT ON COLUMN feed_profiles.feed_bio IS 'User bio for the feed (max 500 chars)';
