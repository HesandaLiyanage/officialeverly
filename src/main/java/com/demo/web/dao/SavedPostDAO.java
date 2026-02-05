package com.demo.web.dao;

import com.demo.web.model.FeedPost;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * SavedPostDAO - Handles saved/bookmarked posts operations.
 */
public class SavedPostDAO {

    private static final Logger logger = Logger.getLogger(SavedPostDAO.class.getName());

    /**
     * Save a post (bookmark)
     */
    public boolean savePost(int feedProfileId, int postId) {
        String sql = "INSERT INTO saved_posts (feed_profile_id, post_id) VALUES (?, ?) ON CONFLICT DO NOTHING";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            stmt.setInt(2, postId);

            int rows = stmt.executeUpdate();
            logger.info("[SavedPostDAO] Post " + postId + " saved by profile " + feedProfileId);
            return rows > 0;

        } catch (SQLException e) {
            logger.severe("[SavedPostDAO] Error saving post: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Unsave a post (remove bookmark)
     */
    public boolean unsavePost(int feedProfileId, int postId) {
        String sql = "DELETE FROM saved_posts WHERE feed_profile_id = ? AND post_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            stmt.setInt(2, postId);

            int rows = stmt.executeUpdate();
            logger.info("[SavedPostDAO] Post " + postId + " unsaved by profile " + feedProfileId);
            return rows > 0;

        } catch (SQLException e) {
            logger.severe("[SavedPostDAO] Error unsaving post: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if a post is saved by user
     */
    public boolean isPostSaved(int feedProfileId, int postId) {
        String sql = "SELECT 1 FROM saved_posts WHERE feed_profile_id = ? AND post_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            stmt.setInt(2, postId);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            logger.severe("[SavedPostDAO] Error checking saved status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all saved posts for a user
     */
    public List<FeedPost> getSavedPosts(int feedProfileId) {
        List<FeedPost> posts = new ArrayList<>();

        String sql = "SELECT fp.* FROM feed_posts fp " +
                "INNER JOIN saved_posts sp ON fp.post_id = sp.post_id " +
                "WHERE sp.feed_profile_id = ? " +
                "ORDER BY sp.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FeedPost post = mapResultSetToFeedPost(rs);
                    posts.add(post);
                }
            }

            logger.info("[SavedPostDAO] Retrieved " + posts.size() + " saved posts for profile " + feedProfileId);

        } catch (SQLException e) {
            logger.severe("[SavedPostDAO] Error getting saved posts: " + e.getMessage());
            e.printStackTrace();
        }

        return posts;
    }

    /**
     * Get count of saved posts for a user
     */
    public int getSavedPostCount(int feedProfileId) {
        String sql = "SELECT COUNT(*) FROM saved_posts WHERE feed_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            logger.severe("[SavedPostDAO] Error getting saved post count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Map ResultSet to FeedPost object
     */
    private FeedPost mapResultSetToFeedPost(ResultSet rs) throws SQLException {
        FeedPost post = new FeedPost();
        post.setPostId(rs.getInt("post_id"));
        post.setFeedProfileId(rs.getInt("feed_profile_id"));
        post.setCaption(rs.getString("caption"));
        post.setCoverMediaUrl(rs.getString("cover_media_url"));

        // Handle memory_id which might be null
        int memoryId = rs.getInt("memory_id");
        if (!rs.wasNull()) {
            post.setMemoryId(memoryId);
        }

        post.setCreatedAt(rs.getTimestamp("created_at"));
        post.setUpdatedAt(rs.getTimestamp("updated_at"));

        return post;
    }
}
