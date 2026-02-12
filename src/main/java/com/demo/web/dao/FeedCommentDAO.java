package com.demo.web.dao;

import com.demo.web.model.FeedComment;
import com.demo.web.model.FeedProfile;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Data Access Object for FeedComment operations.
 */
public class FeedCommentDAO {

    private static final Logger logger = Logger.getLogger(FeedCommentDAO.class.getName());

    /**
     * Create a new comment
     */
    public FeedComment createComment(FeedComment comment) {
        String sql = "INSERT INTO feed_post_comments (post_id, feed_profile_id, parent_comment_id, comment_text) " +
                "VALUES (?, ?, ?, ?) RETURNING comment_id, created_at";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, comment.getPostId());
            stmt.setInt(2, comment.getFeedProfileId());
            if (comment.getParentCommentId() != null) {
                stmt.setInt(3, comment.getParentCommentId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setString(4, comment.getCommentText());

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                comment.setCommentId(rs.getInt("comment_id"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
            }

            logger.info("[FeedCommentDAO] Created comment ID: " + comment.getCommentId() +
                    " for post: " + comment.getPostId() +
                    " by profile: " + comment.getFeedProfileId() +
                    " (Parent: " + comment.getParentCommentId() + ")");
            return comment;

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error creating comment: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get all comments for a post with commenter info and like counts
     */
    public List<FeedComment> getCommentsForPost(int postId, int currentProfileId) {
        List<FeedComment> comments = new ArrayList<>();

        String sql = "SELECT c.comment_id, c.post_id, c.feed_profile_id, c.parent_comment_id, " +
                "c.comment_text, c.created_at, c.updated_at, " +
                "fp.feed_username, fp.feed_profile_picture_url, fp.feed_bio, " +
                "(SELECT COUNT(*) FROM feed_comment_likes WHERE comment_id = c.comment_id) as like_count, " +
                "(SELECT COUNT(*) > 0 FROM feed_comment_likes WHERE comment_id = c.comment_id AND feed_profile_id = ?) as liked_by_user "
                +
                "FROM feed_post_comments c " +
                "LEFT JOIN feed_profiles fp ON c.feed_profile_id = fp.feed_profile_id " +
                "WHERE c.post_id = ? " +
                "ORDER BY c.created_at ASC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, currentProfileId);
            stmt.setInt(2, postId);

            logger.info("[FeedCommentDAO] Executing getCommentsForPost for postId: " + postId + ", currentProfileId: "
                    + currentProfileId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                FeedComment c = mapResultSetToComment(rs);
                comments.add(c);
                logger.info("[FeedCommentDAO] Found comment: " + c.getCommentId() + ", Profile: " + c.getFeedProfileId()
                        + ", Post: " + c.getPostId());
            }

            logger.info("[FeedCommentDAO] Retrieved " + comments.size() + " comments for post " + postId);

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error getting comments: " + e.getMessage());
            e.printStackTrace();
        }

        return comments;
    }

    /**
     * Get comment by ID
     */
    public FeedComment getCommentById(int commentId) {
        String sql = "SELECT c.comment_id, c.post_id, c.feed_profile_id, c.parent_comment_id, " +
                "c.comment_text, c.created_at, c.updated_at, " +
                "fp.feed_username, fp.feed_profile_picture_url, fp.feed_bio " +
                "FROM feed_post_comments c " +
                "LEFT JOIN feed_profiles fp ON c.feed_profile_id = fp.feed_profile_id " +
                "WHERE c.comment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToComment(rs);
            }

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error getting comment: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Delete a comment
     */
    public boolean deleteComment(int commentId) {
        String sql = "DELETE FROM feed_post_comments WHERE comment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            int rowsAffected = stmt.executeUpdate();

            logger.info("[FeedCommentDAO] Deleted comment " + commentId + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error deleting comment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get comment count for a post
     */
    public int getCommentCount(int postId) {
        String sql = "SELECT COUNT(*) FROM feed_post_comments WHERE post_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error getting comment count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Like a comment
     */
    public boolean likeComment(int commentId, int feedProfileId) {
        String sql = "INSERT INTO feed_comment_likes (comment_id, feed_profile_id) VALUES (?, ?) " +
                "ON CONFLICT (comment_id, feed_profile_id) DO NOTHING";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            stmt.setInt(2, feedProfileId);
            stmt.executeUpdate();

            logger.info("[FeedCommentDAO] Profile " + feedProfileId + " liked comment " + commentId);
            return true;

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error liking comment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Unlike a comment
     */
    public boolean unlikeComment(int commentId, int feedProfileId) {
        String sql = "DELETE FROM feed_comment_likes WHERE comment_id = ? AND feed_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            stmt.setInt(2, feedProfileId);
            int rowsAffected = stmt.executeUpdate();

            logger.info("[FeedCommentDAO] Profile " + feedProfileId + " unliked comment " + commentId);
            return rowsAffected > 0;

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error unliking comment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if user has liked a comment
     */
    public boolean hasLikedComment(int commentId, int feedProfileId) {
        String sql = "SELECT COUNT(*) > 0 FROM feed_comment_likes WHERE comment_id = ? AND feed_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            stmt.setInt(2, feedProfileId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getBoolean(1);
            }

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error checking comment like: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get like count for a comment
     */
    public int getCommentLikeCount(int commentId) {
        String sql = "SELECT COUNT(*) FROM feed_comment_likes WHERE comment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error getting comment like count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Get replies for a specific comment
     */
    public List<FeedComment> getRepliesForComment(int parentCommentId, int currentProfileId) {
        List<FeedComment> replies = new ArrayList<>();

        String sql = "SELECT c.comment_id, c.post_id, c.feed_profile_id, c.parent_comment_id, " +
                "c.comment_text, c.created_at, c.updated_at, " +
                "fp.feed_username, fp.feed_profile_picture_url, fp.feed_bio, " +
                "(SELECT COUNT(*) FROM feed_comment_likes WHERE comment_id = c.comment_id) as like_count, " +
                "(SELECT COUNT(*) > 0 FROM feed_comment_likes WHERE comment_id = c.comment_id AND feed_profile_id = ?) as liked_by_user "
                +
                "FROM feed_post_comments c " +
                "LEFT JOIN feed_profiles fp ON c.feed_profile_id = fp.feed_profile_id " +
                "WHERE c.parent_comment_id = ? " +
                "ORDER BY c.created_at ASC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, currentProfileId);
            stmt.setInt(2, parentCommentId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                replies.add(mapResultSetToComment(rs));
            }

            logger.info("[FeedCommentDAO] Retrieved " + replies.size() + " replies for comment " + parentCommentId);

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error getting replies: " + e.getMessage());
            e.printStackTrace();
        }

        return replies;
    }

    /**
     * Get reply count for a comment
     */
    public int getReplyCount(int parentCommentId) {
        String sql = "SELECT COUNT(*) FROM feed_post_comments WHERE parent_comment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, parentCommentId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            logger.severe("[FeedCommentDAO] Error getting reply count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Map ResultSet to FeedComment with FeedProfile
     */
    private FeedComment mapResultSetToComment(ResultSet rs) throws SQLException {
        FeedComment comment = new FeedComment();
        comment.setCommentId(rs.getInt("comment_id"));
        comment.setPostId(rs.getInt("post_id"));
        comment.setFeedProfileId(rs.getInt("feed_profile_id"));

        int parentId = rs.getInt("parent_comment_id");
        comment.setParentCommentId(rs.wasNull() ? null : parentId);

        comment.setCommentText(rs.getString("comment_text"));
        comment.setCreatedAt(rs.getTimestamp("created_at"));
        comment.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Create FeedProfile from join
        FeedProfile profile = new FeedProfile();
        profile.setFeedProfileId(rs.getInt("feed_profile_id"));
        profile.setFeedUsername(rs.getString("feed_username"));
        profile.setFeedProfilePictureUrl(rs.getString("feed_profile_picture_url"));

        try {
            profile.setFeedBio(rs.getString("feed_bio"));
        } catch (SQLException e) {
            // Column might not exist in all queries
        }

        comment.setFeedProfile(profile);

        // Set like count and liked status if available
        try {
            comment.setLikeCount(rs.getInt("like_count"));
            comment.setLikedByCurrentUser(rs.getBoolean("liked_by_user"));
        } catch (SQLException e) {
            // Columns might not exist in all queries
        }

        return comment;
    }
}
