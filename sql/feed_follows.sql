-- ============================================
-- FEED FOLLOWS TABLE
-- ============================================
-- Table for storing follower/following relationships
-- between feed profiles
-- ============================================

-- Create the feed_follows table
CREATE TABLE IF NOT EXISTS feed_follows (
    follow_id SERIAL PRIMARY KEY,
    follower_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    following_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_follow UNIQUE (follower_id, following_id),
    CONSTRAINT no_self_follow CHECK (follower_id != following_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_feed_follows_follower ON feed_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_feed_follows_following ON feed_follows(following_id);

-- Comments for documentation
COMMENT ON TABLE feed_follows IS 'Stores follower/following relationships between feed profiles';
COMMENT ON COLUMN feed_follows.follower_id IS 'The feed profile that is following';
COMMENT ON COLUMN feed_follows.following_id IS 'The feed profile being followed';

-- ============================================
-- USEFUL QUERIES
-- ============================================

-- Get follower count for a user
-- SELECT COUNT(*) FROM feed_follows WHERE following_id = ?;

-- Get following count for a user
-- SELECT COUNT(*) FROM feed_follows WHERE follower_id = ?;

-- Get all followers of a user
-- SELECT fp.* FROM feed_profiles fp
-- JOIN feed_follows ff ON fp.feed_profile_id = ff.follower_id
-- WHERE ff.following_id = ?;

-- Get all users a user is following
-- SELECT fp.* FROM feed_profiles fp
-- JOIN feed_follows ff ON fp.feed_profile_id = ff.following_id
-- WHERE ff.follower_id = ?;

-- Check if user A follows user B
-- SELECT 1 FROM feed_follows WHERE follower_id = ? AND following_id = ?;

-- Get random recommended users (not followed by current user)
-- SELECT fp.* FROM feed_profiles fp
-- WHERE fp.feed_profile_id != ?
-- AND fp.feed_profile_id NOT IN (
--     SELECT following_id FROM feed_follows WHERE follower_id = ?
-- )
-- ORDER BY RANDOM()
-- LIMIT 5;
