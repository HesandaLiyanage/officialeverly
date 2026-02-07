-- ============================================
-- COMPLETE SQL FOR FEED COMMENTS FEATURE
-- ============================================
-- Run these queries in order in your PostgreSQL database
-- Tables required: feed_posts, feed_profiles
-- ============================================

-- 1. Create feed_post_comments table
-- Stores comments on feed posts
CREATE TABLE IF NOT EXISTS feed_post_comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES feed_posts(post_id) ON DELETE CASCADE,
    feed_profile_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    parent_comment_id INTEGER REFERENCES feed_post_comments(comment_id) ON DELETE CASCADE,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_comments_post_id ON feed_post_comments(post_id);
CREATE INDEX IF NOT EXISTS idx_comments_profile_id ON feed_post_comments(feed_profile_id);
CREATE INDEX IF NOT EXISTS idx_comments_parent_id ON feed_post_comments(parent_comment_id);
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON feed_post_comments(created_at DESC);

-- Comments for documentation
COMMENT ON TABLE feed_post_comments IS 'Stores comments on feed posts';
COMMENT ON COLUMN feed_post_comments.post_id IS 'Reference to the post being commented on';
COMMENT ON COLUMN feed_post_comments.feed_profile_id IS 'Reference to the profile of the commenter';
COMMENT ON COLUMN feed_post_comments.parent_comment_id IS 'Reference to parent comment for replies (NULL if top-level)';
COMMENT ON COLUMN feed_post_comments.comment_text IS 'The comment content';

-- 2. Create feed_comment_likes table
-- Stores likes on comments
CREATE TABLE IF NOT EXISTS feed_comment_likes (
    like_id SERIAL PRIMARY KEY,
    comment_id INTEGER NOT NULL REFERENCES feed_post_comments(comment_id) ON DELETE CASCADE,
    feed_profile_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(comment_id, feed_profile_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_comment_likes_comment_id ON feed_comment_likes(comment_id);
CREATE INDEX IF NOT EXISTS idx_comment_likes_profile_id ON feed_comment_likes(feed_profile_id);

-- Comments for documentation
COMMENT ON TABLE feed_comment_likes IS 'Stores likes on comments';
COMMENT ON COLUMN feed_comment_likes.comment_id IS 'Reference to the comment being liked';
COMMENT ON COLUMN feed_comment_likes.feed_profile_id IS 'Reference to the profile that liked the comment';

-- 3. Create feed_post_likes table (if it doesn't exist)
-- Stores likes on posts
CREATE TABLE IF NOT EXISTS feed_post_likes (
    like_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES feed_posts(post_id) ON DELETE CASCADE,
    feed_profile_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(post_id, feed_profile_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_post_likes_post_id ON feed_post_likes(post_id);
CREATE INDEX IF NOT EXISTS idx_post_likes_profile_id ON feed_post_likes(feed_profile_id);

-- Comments for documentation
COMMENT ON TABLE feed_post_likes IS 'Stores likes on posts';
COMMENT ON COLUMN feed_post_likes.post_id IS 'Reference to the post being liked';
COMMENT ON COLUMN feed_post_likes.feed_profile_id IS 'Reference to the profile that liked the post';

-- ============================================
-- USEFUL QUERIES FOR TESTING
-- ============================================

-- Get all comments for a post with commenter info and like count
-- SELECT 
--     c.comment_id, 
--     c.comment_text, 
--     c.created_at,
--     c.parent_comment_id,
--     fp.feed_username,
--     fp.feed_profile_picture_url,
--     (SELECT COUNT(*) FROM feed_comment_likes WHERE comment_id = c.comment_id) as like_count
-- FROM feed_post_comments c
-- JOIN feed_profiles fp ON c.feed_profile_id = fp.feed_profile_id
-- WHERE c.post_id = 1
-- ORDER BY c.created_at ASC;

-- Check if a user has liked a comment
-- SELECT COUNT(*) > 0 as is_liked
-- FROM feed_comment_likes 
-- WHERE comment_id = 1 AND feed_profile_id = 1;

-- Get comment count for a post
-- SELECT COUNT(*) FROM feed_post_comments WHERE post_id = 1;

-- Get like count for a post
-- SELECT COUNT(*) FROM feed_post_likes WHERE post_id = 1;
