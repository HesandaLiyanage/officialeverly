-- Post Reports table for tracking reported feed posts
CREATE TABLE IF NOT EXISTS post_reports (
    report_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES feed_posts(post_id) ON DELETE CASCADE,
    reporter_profile_id INTEGER NOT NULL REFERENCES feed_profiles(feed_profile_id) ON DELETE CASCADE,
    reason VARCHAR(50) NOT NULL DEFAULT 'other',
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',  -- pending, reviewed, dismissed, action_taken
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP,
    reviewed_by INTEGER REFERENCES users(user_id),
    UNIQUE(post_id, reporter_profile_id)  -- One report per user per post
);

-- Index for quick lookups
CREATE INDEX IF NOT EXISTS idx_post_reports_status ON post_reports(status);
CREATE INDEX IF NOT EXISTS idx_post_reports_post_id ON post_reports(post_id);
CREATE INDEX IF NOT EXISTS idx_post_reports_created_at ON post_reports(created_at DESC);
