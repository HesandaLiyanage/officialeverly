package com.demo.web.dao;

import com.demo.web.model.FeedProfile;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Data Access Object for Blocked User operations.
 * Handles all database operations related to blocking/unblocking users in the
 * feed.
 */
public class BlockedUserDAO {

    private static final Logger logger = Logger.getLogger(BlockedUserDAO.class.getName());

    /**
     * Ensure the blocked_users table exists
     */
    public void ensureTableExists() {
        String sql = "CREATE TABLE IF NOT EXISTS blocked_users (" +
                "id SERIAL PRIMARY KEY, " +
                "blocker_profile_id INTEGER NOT NULL, " +
                "blocked_profile_id INTEGER NOT NULL, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "UNIQUE(blocker_profile_id, blocked_profile_id)" +
                ")";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
            logger.info("[BlockedUserDAO] blocked_users table ensured");
        } catch (SQLException e) {
            logger.severe("[BlockedUserDAO] Error creating blocked_users table: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Block a user
     *
     * @param blockerProfileId The feed profile ID of the user performing the block
     * @param blockedProfileId The feed profile ID of the user being blocked
     * @return true if blocked successfully, false otherwise
     */
    public boolean blockUser(int blockerProfileId, int blockedProfileId) {
        if (blockerProfileId == blockedProfileId) {
            logger.warning("[BlockedUserDAO] Cannot block yourself");
            return false;
        }

        String sql = "INSERT INTO blocked_users (blocker_profile_id, blocked_profile_id) VALUES (?, ?) ON CONFLICT DO NOTHING";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, blockerProfileId);
            stmt.setInt(2, blockedProfileId);

            int affected = stmt.executeUpdate();
            logger.info("[BlockedUserDAO] User " + blockerProfileId + " blocked " + blockedProfileId
                    + " (affected: " + affected + ")");
            return affected > 0;
        } catch (SQLException e) {
            logger.severe("[BlockedUserDAO] Error blocking user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Unblock a user
     *
     * @param blockerProfileId The feed profile ID of the user who blocked
     * @param blockedProfileId The feed profile ID of the user to unblock
     * @return true if unblocked successfully, false otherwise
     */
    public boolean unblockUser(int blockerProfileId, int blockedProfileId) {
        String sql = "DELETE FROM blocked_users WHERE blocker_profile_id = ? AND blocked_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, blockerProfileId);
            stmt.setInt(2, blockedProfileId);

            int affected = stmt.executeUpdate();
            logger.info("[BlockedUserDAO] User " + blockerProfileId + " unblocked " + blockedProfileId
                    + " (affected: " + affected + ")");
            return affected > 0;
        } catch (SQLException e) {
            logger.severe("[BlockedUserDAO] Error unblocking user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if a user is blocked by another user
     *
     * @param blockerProfileId The feed profile ID of the potential blocker
     * @param blockedProfileId The feed profile ID of the potentially blocked user
     * @return true if blocked, false otherwise
     */
    public boolean isBlocked(int blockerProfileId, int blockedProfileId) {
        String sql = "SELECT 1 FROM blocked_users WHERE blocker_profile_id = ? AND blocked_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, blockerProfileId);
            stmt.setInt(2, blockedProfileId);

            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            logger.severe("[BlockedUserDAO] Error checking block status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all users blocked by a specific user
     *
     * @param blockerProfileId The feed profile ID of the blocker
     * @return List of FeedProfile objects representing blocked users
     */
    public List<FeedProfile> getBlockedUsers(int blockerProfileId) {
        List<FeedProfile> blockedUsers = new ArrayList<>();

        String sql = "SELECT fp.feed_profile_id, fp.user_id, fp.feed_username, " +
                "fp.feed_profile_picture_url, fp.feed_bio, fp.created_at, fp.updated_at " +
                "FROM feed_profiles fp " +
                "JOIN blocked_users bu ON fp.feed_profile_id = bu.blocked_profile_id " +
                "WHERE bu.blocker_profile_id = ? " +
                "ORDER BY bu.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, blockerProfileId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                blockedUsers.add(mapResultSetToProfile(rs));
            }
            logger.info("[BlockedUserDAO] Found " + blockedUsers.size()
                    + " blocked users for profile " + blockerProfileId);
        } catch (SQLException e) {
            logger.severe("[BlockedUserDAO] Error getting blocked users: " + e.getMessage());
            e.printStackTrace();
        }
        return blockedUsers;
    }

    /**
     * Get all blocked profile IDs for a given user (used for filtering feed)
     *
     * @param blockerProfileId The feed profile ID of the blocker
     * @return List of blocked feed profile IDs
     */
    public List<Integer> getBlockedProfileIds(int blockerProfileId) {
        List<Integer> blockedIds = new ArrayList<>();

        String sql = "SELECT blocked_profile_id FROM blocked_users WHERE blocker_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, blockerProfileId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                blockedIds.add(rs.getInt("blocked_profile_id"));
            }
        } catch (SQLException e) {
            logger.severe("[BlockedUserDAO] Error getting blocked profile IDs: " + e.getMessage());
            e.printStackTrace();
        }
        return blockedIds;
    }

    /**
     * Map ResultSet to FeedProfile object
     */
    private FeedProfile mapResultSetToProfile(ResultSet rs) throws SQLException {
        FeedProfile profile = new FeedProfile();
        profile.setFeedProfileId(rs.getInt("feed_profile_id"));
        profile.setUserId(rs.getInt("user_id"));
        profile.setFeedUsername(rs.getString("feed_username"));
        profile.setFeedProfilePictureUrl(rs.getString("feed_profile_picture_url"));
        profile.setFeedBio(rs.getString("feed_bio"));
        profile.setCreatedAt(rs.getTimestamp("created_at"));
        profile.setUpdatedAt(rs.getTimestamp("updated_at"));
        return profile;
    }
}
