package com.demo.web.dao;

import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.logging.Logger;

/**
 * Data Access Object for Feed Post Like operations.
 */
public class FeedPostLikeDAO {

    private static final Logger logger = Logger.getLogger(FeedPostLikeDAO.class.getName());

    /**
     * Like a post
     */
    public boolean likePost(int postId, int feedProfileId) {
        String sql = "INSERT INTO feed_post_likes (post_id, feed_profile_id) VALUES (?, ?) " +
                "ON CONFLICT (post_id, feed_profile_id) DO NOTHING";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            stmt.setInt(2, feedProfileId);
            stmt.executeUpdate();

            logger.info("[FeedPostLikeDAO] Profile " + feedProfileId + " liked post " + postId);
            return true;

        } catch (SQLException e) {
            logger.severe("[FeedPostLikeDAO] Error liking post: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Unlike a post
     */
    public boolean unlikePost(int postId, int feedProfileId) {
        String sql = "DELETE FROM feed_post_likes WHERE post_id = ? AND feed_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            stmt.setInt(2, feedProfileId);
            int rowsAffected = stmt.executeUpdate();

            logger.info("[FeedPostLikeDAO] Profile " + feedProfileId + " unliked post " + postId);
            return rowsAffected > 0;

        } catch (SQLException e) {
            logger.severe("[FeedPostLikeDAO] Error unliking post: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if user has liked a post
     */
    public boolean hasLikedPost(int postId, int feedProfileId) {
        String sql = "SELECT COUNT(*) > 0 FROM feed_post_likes WHERE post_id = ? AND feed_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            stmt.setInt(2, feedProfileId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getBoolean(1);
            }

        } catch (SQLException e) {
            logger.severe("[FeedPostLikeDAO] Error checking post like: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get like count for a post
     */
    public int getLikeCount(int postId) {
        String sql = "SELECT COUNT(*) FROM feed_post_likes WHERE post_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            logger.severe("[FeedPostLikeDAO] Error getting post like count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Toggle like on a post (like if not liked, unlike if already liked)
     * 
     * @return true if post is now liked, false if now unliked
     */
    public boolean toggleLike(int postId, int feedProfileId) {
        if (hasLikedPost(postId, feedProfileId)) {
            unlikePost(postId, feedProfileId);
            return false;
        } else {
            likePost(postId, feedProfileId);
            return true;
        }
    }
}
