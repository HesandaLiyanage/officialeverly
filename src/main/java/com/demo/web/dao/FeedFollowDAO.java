package com.demo.web.dao;

import com.demo.web.model.FeedProfile;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Data Access Object for Feed Follow operations.
 * Handles all database operations related to follower/following relationships.
 */
public class FeedFollowDAO {

    private static final Logger logger = Logger.getLogger(FeedFollowDAO.class.getName());

    /**
     * Follow a user
     * 
     * @param followerId  The feed profile ID of the follower
     * @param followingId The feed profile ID of the user to follow
     * @return true if followed successfully, false otherwise
     */
    public boolean follow(int followerId, int followingId) {
        if (followerId == followingId) {
            logger.warning("[FeedFollowDAO] Cannot follow yourself");
            return false;
        }

        String sql = "INSERT INTO feed_follows (follower_id, following_id) VALUES (?, ?) ON CONFLICT DO NOTHING";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, followerId);
            stmt.setInt(2, followingId);

            int affected = stmt.executeUpdate();
            logger.info("[FeedFollowDAO] User " + followerId + " followed " + followingId + " (affected: " + affected
                    + ")");
            return affected > 0;
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error following user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Unfollow a user
     * 
     * @param followerId  The feed profile ID of the follower
     * @param followingId The feed profile ID of the user to unfollow
     * @return true if unfollowed successfully, false otherwise
     */
    public boolean unfollow(int followerId, int followingId) {
        String sql = "DELETE FROM feed_follows WHERE follower_id = ? AND following_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, followerId);
            stmt.setInt(2, followingId);

            int affected = stmt.executeUpdate();
            logger.info("[FeedFollowDAO] User " + followerId + " unfollowed " + followingId + " (affected: " + affected
                    + ")");
            return affected > 0;
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error unfollowing user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if a user is following another user
     * 
     * @param followerId  The feed profile ID of the potential follower
     * @param followingId The feed profile ID of the potential followed user
     * @return true if following, false otherwise
     */
    public boolean isFollowing(int followerId, int followingId) {
        String sql = "SELECT 1 FROM feed_follows WHERE follower_id = ? AND following_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, followerId);
            stmt.setInt(2, followingId);

            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error checking follow status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get follower count for a feed profile
     * 
     * @param feedProfileId The feed profile ID
     * @return Number of followers
     */
    public int getFollowerCount(int feedProfileId) {
        String sql = "SELECT COUNT(*) FROM feed_follows WHERE following_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error getting follower count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get following count for a feed profile
     * 
     * @param feedProfileId The feed profile ID
     * @return Number of users followed
     */
    public int getFollowingCount(int feedProfileId) {
        String sql = "SELECT COUNT(*) FROM feed_follows WHERE follower_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error getting following count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get all followers of a feed profile
     * 
     * @param feedProfileId The feed profile ID
     * @return List of FeedProfile objects representing followers
     */
    public List<FeedProfile> getFollowers(int feedProfileId) {
        List<FeedProfile> followers = new ArrayList<>();

        String sql = "SELECT fp.feed_profile_id, fp.user_id, fp.feed_username, " +
                "fp.feed_profile_picture_url, fp.feed_bio, fp.created_at, fp.updated_at " +
                "FROM feed_profiles fp " +
                "JOIN feed_follows ff ON fp.feed_profile_id = ff.follower_id " +
                "WHERE ff.following_id = ? " +
                "ORDER BY ff.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                followers.add(mapResultSetToProfile(rs));
            }
            logger.info("[FeedFollowDAO] Found " + followers.size() + " followers for profile " + feedProfileId);
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error getting followers: " + e.getMessage());
            e.printStackTrace();
        }
        return followers;
    }

    /**
     * Get all users a feed profile is following
     * 
     * @param feedProfileId The feed profile ID
     * @return List of FeedProfile objects representing followed users
     */
    public List<FeedProfile> getFollowing(int feedProfileId) {
        List<FeedProfile> following = new ArrayList<>();

        String sql = "SELECT fp.feed_profile_id, fp.user_id, fp.feed_username, " +
                "fp.feed_profile_picture_url, fp.feed_bio, fp.created_at, fp.updated_at " +
                "FROM feed_profiles fp " +
                "JOIN feed_follows ff ON fp.feed_profile_id = ff.following_id " +
                "WHERE ff.follower_id = ? " +
                "ORDER BY ff.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                following.add(mapResultSetToProfile(rs));
            }
            logger.info("[FeedFollowDAO] Found " + following.size() + " following for profile " + feedProfileId);
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error getting following: " + e.getMessage());
            e.printStackTrace();
        }
        return following;
    }

    /**
     * Get recommended users for a feed profile (random users not already followed)
     * 
     * @param feedProfileId The current user's feed profile ID
     * @param limit         Maximum number of recommendations to return
     * @return List of recommended FeedProfile objects
     */
    public List<FeedProfile> getRecommendedUsers(int feedProfileId, int limit) {
        List<FeedProfile> recommended = new ArrayList<>();

        String sql = "SELECT fp.feed_profile_id, fp.user_id, fp.feed_username, " +
                "fp.feed_profile_picture_url, fp.feed_bio, fp.created_at, fp.updated_at, " +
                "(SELECT COUNT(*) FROM feed_follows WHERE following_id = fp.feed_profile_id) as follower_count " +
                "FROM feed_profiles fp " +
                "WHERE fp.feed_profile_id != ? " +
                "AND fp.feed_profile_id NOT IN (" +
                "    SELECT following_id FROM feed_follows WHERE follower_id = ?" +
                ") " +
                "ORDER BY RANDOM() " +
                "LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedProfileId);
            stmt.setInt(2, feedProfileId);
            stmt.setInt(3, limit);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                FeedProfile profile = mapResultSetToProfile(rs);
                recommended.add(profile);
            }
            logger.info(
                    "[FeedFollowDAO] Found " + recommended.size() + " recommended users for profile " + feedProfileId);
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error getting recommended users: " + e.getMessage());
            e.printStackTrace();
        }
        return recommended;
    }

    /**
     * Get mutual followers count (users who follow both profiles)
     * 
     * @param profileId1 First feed profile ID
     * @param profileId2 Second feed profile ID
     * @return Number of mutual followers
     */
    public int getMutualFollowersCount(int profileId1, int profileId2) {
        String sql = "SELECT COUNT(*) FROM feed_follows f1 " +
                "JOIN feed_follows f2 ON f1.follower_id = f2.follower_id " +
                "WHERE f1.following_id = ? AND f2.following_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, profileId1);
            stmt.setInt(2, profileId2);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("[FeedFollowDAO] Error getting mutual followers count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if two users follow each other (mutual follow)
     * 
     * @param profileId1 First feed profile ID
     * @param profileId2 Second feed profile ID
     * @return true if they follow each other
     */
    public boolean areMutualFollowers(int profileId1, int profileId2) {
        return isFollowing(profileId1, profileId2) && isFollowing(profileId2, profileId1);
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
