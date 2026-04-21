package com.demo.web.dao.Feed;

import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class FeedProfileDAO {

    public FeedProfile findByUserId(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT feed_profile_id, user_id, feed_username, feed_profile_picture_url, " +
                    "feed_bio, created_at, updated_at FROM feed_profiles WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToFeedProfile(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while finding feed profile by user ID", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    public FeedProfile findByUsername(String feedUsername) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT feed_profile_id, user_id, feed_username, feed_profile_picture_url, " +
                    "feed_bio, created_at, updated_at FROM feed_profiles WHERE feed_username = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, feedUsername);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToFeedProfile(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while finding feed profile by username", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    public FeedProfile findByFeedProfileId(int feedProfileId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT feed_profile_id, user_id, feed_username, feed_profile_picture_url, " +
                    "feed_bio, created_at, updated_at FROM feed_profiles WHERE feed_profile_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, feedProfileId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToFeedProfile(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while finding feed profile by ID", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    public boolean usernameExists(String feedUsername) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT 1 FROM feed_profiles WHERE LOWER(feed_username) = LOWER(?)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, feedUsername);

            rs = stmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while checking username existence", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean createProfile(FeedProfile profile) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO feed_profiles (user_id, feed_username, feed_profile_picture_url, " +
                    "feed_bio, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?) RETURNING feed_profile_id";

            stmt = conn.prepareStatement(sql);
            Timestamp now = new Timestamp(System.currentTimeMillis());

            stmt.setInt(1, profile.getUserId());
            stmt.setString(2, profile.getFeedUsername());
            stmt.setString(3, profile.getFeedProfilePictureUrl());
            stmt.setString(4, profile.getFeedBio());
            stmt.setTimestamp(5, now);
            stmt.setTimestamp(6, now);

            rs = stmt.executeQuery();

            if (rs.next()) {
                profile.setFeedProfileId(rs.getInt("feed_profile_id"));
                profile.setCreatedAt(now);
                profile.setUpdatedAt(now);
                return true;
            }

            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while creating feed profile", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean updateProfile(FeedProfile profile) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE feed_profiles SET feed_username = ?, feed_profile_picture_url = ?, " +
                    "feed_bio = ?, updated_at = ? WHERE feed_profile_id = ?";

            stmt = conn.prepareStatement(sql);
            Timestamp now = new Timestamp(System.currentTimeMillis());

            stmt.setString(1, profile.getFeedUsername());
            stmt.setString(2, profile.getFeedProfilePictureUrl());
            stmt.setString(3, profile.getFeedBio());
            stmt.setTimestamp(4, now);
            stmt.setInt(5, profile.getFeedProfileId());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while updating feed profile", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean updateProfilePicture(int profileId, String pictureUrl) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE feed_profiles SET feed_profile_picture_url = ?, updated_at = ? " +
                    "WHERE feed_profile_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, pictureUrl);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(3, profileId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while updating profile picture", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean deleteByUserId(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM feed_profiles WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while deleting feed profile", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    private FeedProfile mapResultSetToFeedProfile(ResultSet rs) throws SQLException {
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

    public java.util.List<FeedProfile> findRandomProfiles(int excludeProfileId, int limit) {
        java.util.List<FeedProfile> profiles = new java.util.ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT feed_profile_id, user_id, feed_username, feed_profile_picture_url, " +
                    "feed_bio, created_at, updated_at FROM feed_profiles " +
                    "WHERE feed_profile_id != ? " +
                    "ORDER BY RANDOM() LIMIT ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, excludeProfileId);
            stmt.setInt(2, limit);

            rs = stmt.executeQuery();

            while (rs.next()) {
                profiles.add(mapResultSetToFeedProfile(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return profiles;
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
