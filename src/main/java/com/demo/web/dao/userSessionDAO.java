package com.demo.web.dao;

import com.demo.web.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;

public class userSessionDAO {

    /**
     * Create a remember me token for user
     */
    public String createRememberMeToken(int userId) {
        String sessionToken = UUID.randomUUID().toString();
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // First, clean up any existing tokens for this user
            cleanupExpiredTokens(userId, conn);

            String sql = "INSERT INTO user_sessions (user_id, session_id, expires_at, created_at) " +
                    "VALUES (?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, sessionToken);
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis() + (30L * 24 * 60 * 60 * 1000))); // 30 days
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                return sessionToken;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while creating remember me token", e);
        } finally {
            closeResources(null, stmt, conn);
        }

        return null;
    }

    /**
     * Validate and get user ID from remember me token
     */
    public Integer getUserIdByToken(String sessionToken) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id FROM user_sessions " +
                    "WHERE session_id = ? AND expires_at > ? AND is_active = true";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionToken);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("user_id");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while validating token", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Invalidate a remember me token
     */
    public boolean invalidateToken(String sessionToken) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE user_sessions SET is_active = false WHERE session_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionToken);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while invalidating token", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Clean up expired tokens for a user
     */
    private void cleanupExpiredTokens(int userId, Connection conn) throws SQLException {
        PreparedStatement stmt = null;

        try {
            String sql = "DELETE FROM user_sessions WHERE user_id = ? AND " +
                    "(expires_at < ? OR is_active = false)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));

            stmt.executeUpdate();

        } finally {
            if (stmt != null) stmt.close();
        }
    }

    /**
     * Clean up all expired tokens (call this periodically)
     */
    public void cleanupAllExpiredTokens() {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM user_sessions WHERE expires_at < ?";

            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while cleaning up tokens", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Close database resources
     */
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}