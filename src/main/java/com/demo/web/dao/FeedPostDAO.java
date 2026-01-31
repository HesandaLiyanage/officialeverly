package com.demo.web.dao;

import com.demo.web.model.FeedPost;
import com.demo.web.model.FeedProfile;
import com.demo.web.model.Memory;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Data Access Object for FeedPost operations.
 */
public class FeedPostDAO {

    private static final Logger logger = Logger.getLogger(FeedPostDAO.class.getName());

    /**
     * Create a new post
     */
    public int createPost(FeedPost post) {
        String sql = "INSERT INTO feed_posts (memory_id, feed_profile_id, caption) VALUES (?, ?, ?) RETURNING post_id";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, post.getMemoryId());
            stmt.setInt(2, post.getFeedProfileId());
            stmt.setString(3, post.getCaption());

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int postId = rs.getInt("post_id");
                logger.info("[FeedPostDAO] Created post with ID: " + postId);
                return postId;
            }
        } catch (SQLException e) {
            logger.severe("[FeedPostDAO] Error creating post: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Get post by ID with full details
     */
    public FeedPost findById(int postId) {
        String sql = "SELECT p.*, m.title, m.description, m.cover_media_id, m.created_timestamp as memory_created, " +
                "f.feed_username, f.feed_profile_picture_url, f.feed_bio, " +
                "med.file_path as cover_url " +
                "FROM feed_posts p " +
                "JOIN memory m ON p.memory_id = m.memory_id " +
                "JOIN feed_profiles f ON p.feed_profile_id = f.feed_profile_id " +
                "LEFT JOIN media_items med ON m.cover_media_id = med.media_id " +
                "WHERE p.post_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToPost(rs);
            }
        } catch (SQLException e) {
            logger.severe("[FeedPostDAO] Error finding post by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all posts for FYP (random order, no algorithm)
     */
    public List<FeedPost> findAllPosts() {
        List<FeedPost> posts = new ArrayList<>();

        String sql = "SELECT p.*, m.title, m.description, m.cover_media_id, m.created_timestamp as memory_created, " +
                "f.feed_username, f.feed_profile_picture_url, f.feed_bio, " +
                "med.file_path as cover_url " +
                "FROM feed_posts p " +
                "JOIN memory m ON p.memory_id = m.memory_id " +
                "JOIN feed_profiles f ON p.feed_profile_id = f.feed_profile_id " +
                "LEFT JOIN media_items med ON m.cover_media_id = med.media_id " +
                "ORDER BY RANDOM()";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                posts.add(mapResultSetToPost(rs));
            }
            logger.info("[FeedPostDAO] Found " + posts.size() + " posts for FYP");
        } catch (SQLException e) {
            logger.severe("[FeedPostDAO] Error fetching all posts: " + e.getMessage());
            e.printStackTrace();
        }
        return posts;
    }

    /**
     * Get posts by feed profile ID (user's posts)
     */
    public List<FeedPost> findByFeedProfileId(int feedProfileId) {
        List<FeedPost> posts = new ArrayList<>();

        String sql = "SELECT p.*, m.title, m.description, m.cover_media_id, m.created_timestamp as memory_created, " +
                "f.feed_username, f.feed_profile_picture_url, f.feed_bio, " +
                "med.file_path as cover_url " +
                "FROM feed_posts p " +
                "JOIN memory m ON p.memory_id = m.memory_id " +
                "JOIN feed_profiles f ON p.feed_profile_id = f.feed_profile_id " +
                "LEFT JOIN media_items med ON m.cover_media_id = med.media_id " +
                "WHERE p.feed_profile_id = ? " +
                "ORDER BY p.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                posts.add(mapResultSetToPost(rs));
            }
            logger.info("[FeedPostDAO] Found " + posts.size() + " posts for profile: " + feedProfileId);
        } catch (SQLException e) {
            logger.severe("[FeedPostDAO] Error fetching posts by profile: " + e.getMessage());
            e.printStackTrace();
        }
        return posts;
    }

    /**
     * Check if a memory is already posted by a user
     */
    public boolean isMemoryPosted(int memoryId, int feedProfileId) {
        String sql = "SELECT COUNT(*) FROM feed_posts WHERE memory_id = ? AND feed_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, memoryId);
            stmt.setInt(2, feedProfileId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.severe("[FeedPostDAO] Error checking if memory posted: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete a post
     */
    public boolean deletePost(int postId) {
        String sql = "DELETE FROM feed_posts WHERE post_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            int affected = stmt.executeUpdate();
            logger.info("[FeedPostDAO] Deleted post: " + postId + " (affected: " + affected + ")");
            return affected > 0;
        } catch (SQLException e) {
            logger.severe("[FeedPostDAO] Error deleting post: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get first media URL for a memory (for post display)
     */
    public String getFirstMediaUrl(int memoryId) {
        String sql = "SELECT med.file_path FROM memory_media mm " +
                "JOIN media_items med ON mm.media_id = med.media_id " +
                "WHERE mm.memory_id = ? " +
                "ORDER BY mm.added_timestamp " +
                "LIMIT 1";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, memoryId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getString("file_path");
            }
        } catch (SQLException e) {
            logger.severe("[FeedPostDAO] Error getting first media: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Map ResultSet to FeedPost with related objects
     */
    private FeedPost mapResultSetToPost(ResultSet rs) throws SQLException {
        FeedPost post = new FeedPost();
        post.setPostId(rs.getInt("post_id"));
        post.setMemoryId(rs.getInt("memory_id"));
        post.setFeedProfileId(rs.getInt("feed_profile_id"));
        post.setCaption(rs.getString("caption"));
        post.setCreatedAt(rs.getTimestamp("created_at"));
        post.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Map memory
        Memory memory = new Memory();
        memory.setMemoryId(rs.getInt("memory_id"));
        memory.setTitle(rs.getString("title"));
        memory.setDescription(rs.getString("description"));

        Integer coverMediaId = rs.getInt("cover_media_id");
        if (!rs.wasNull()) {
            memory.setCoverMediaId(coverMediaId);
        }

        post.setMemory(memory);

        // Map feed profile
        FeedProfile profile = new FeedProfile();
        profile.setFeedProfileId(rs.getInt("feed_profile_id"));
        profile.setFeedUsername(rs.getString("feed_username"));
        profile.setFeedProfilePictureUrl(rs.getString("feed_profile_picture_url"));
        profile.setFeedBio(rs.getString("feed_bio"));
        post.setFeedProfile(profile);

        // Cover URL
        String coverUrl = rs.getString("cover_url");
        if (coverUrl != null) {
            post.setCoverMediaUrl(coverUrl);
        }

        return post;
    }
}
