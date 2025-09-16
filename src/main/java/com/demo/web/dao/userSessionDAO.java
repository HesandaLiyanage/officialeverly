package com.demo.web.dao;

import com.demo.web.model.UserSession;
import com.demo.web.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class userSessionDAO {

    /**
     * Create a new user session with device information
     */
    public boolean createSession(int userId, String sessionId,
                                 String deviceName, String deviceType,
                                 String ipAddress, String userAgent) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO user_sessions (session_id, user_id, created_at, expires_at, " +
                    "device_name, device_type, ip_address, user_agent, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionId);
            stmt.setInt(2, userId);
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

            // Set expiration time (e.g., 24 hours from now)
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (24L * 60 * 60 * 1000));
            stmt.setTimestamp(4, expiresAt);

            // Device information
            stmt.setString(5, deviceName);
            stmt.setString(6, deviceType);
            stmt.setString(7, ipAddress);
            stmt.setString(8, userAgent);
            stmt.setBoolean(9, true); // is_active

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Create a new user session (backward compatibility)
     */
    public boolean createSession(int userId, String sessionId) {
        return createSession(userId, sessionId, "Unknown Device", "Unknown", "Unknown IP", "Unknown Browser");
    }

    /**
     * Find session by session ID
     */
    public UserSession findBySessionId(String sessionId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT session_id, user_id, created_at, expires_at, " +
                    "device_name, device_type, ip_address, user_agent, is_active " +
                    "FROM user_sessions WHERE session_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                UserSession session = new UserSession();
                session.setSessionId(rs.getString("session_id"));
                session.setUserId(rs.getInt("user_id"));
                session.setCreatedAt(rs.getTimestamp("created_at"));
                session.setExpiresAt(rs.getTimestamp("expires_at"));
                session.setDeviceName(rs.getString("device_name"));
                session.setDeviceType(rs.getString("device_type"));
                session.setIpAddress(rs.getString("ip_address"));
                session.setUserAgent(rs.getString("user_agent"));
                session.setActive(rs.getBoolean("is_active"));
                return session;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Get all active sessions for a user
     */
    public List<UserSession> getUserSessions(int userId) {
        List<UserSession> sessions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT session_id, user_id, created_at, expires_at, " +
                    "device_name, device_type, ip_address, user_agent, is_active " +
                    "FROM user_sessions WHERE user_id = ? AND is_active = TRUE AND expires_at > ? " +
                    "ORDER BY created_at DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));

            rs = stmt.executeQuery();

            while (rs.next()) {
                UserSession session = new UserSession();
                session.setSessionId(rs.getString("session_id"));
                session.setUserId(rs.getInt("user_id"));
                session.setCreatedAt(rs.getTimestamp("created_at"));
                session.setExpiresAt(rs.getTimestamp("expires_at"));
                session.setDeviceName(rs.getString("device_name"));
                session.setDeviceType(rs.getString("device_type"));
                session.setIpAddress(rs.getString("ip_address"));
                session.setUserAgent(rs.getString("user_agent"));
                session.setActive(rs.getBoolean("is_active"));
                sessions.add(session);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return sessions;
    }

    /**
     * Revoke a specific session (logout device)
     */
    public boolean revokeSession(String sessionId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE user_sessions SET is_active = FALSE WHERE session_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Revoke all sessions except current one
     */
    public int revokeAllSessionsExcept(int userId, String currentSessionId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE user_sessions SET is_active = FALSE " +
                    "WHERE user_id = ? AND session_id != ? AND is_active = TRUE";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, currentSessionId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Delete user session (permanent deletion)
     */
    public boolean deleteSession(String sessionId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM user_sessions WHERE session_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionId);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Delete expired sessions
     */
    public int deleteExpiredSessions() {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM user_sessions WHERE expires_at < ?";

            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Check if session exists and is valid
     */
    public boolean isValidSession(String sessionId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT 1 FROM user_sessions WHERE session_id = ? " +
                    "AND expires_at > ? AND is_active = TRUE";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionId);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));

            rs = stmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Update session expiration time
     */
    public boolean updateSessionExpiration(String sessionId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE user_sessions SET expires_at = ? WHERE session_id = ?";

            stmt = conn.prepareStatement(sql);
            Timestamp newExpiresAt = new Timestamp(System.currentTimeMillis() + (24L * 60 * 60 * 1000));
            stmt.setTimestamp(1, newExpiresAt);
            stmt.setString(2, sessionId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Create remember me token
     */
    public String createRememberMeToken(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String token = UUID.randomUUID().toString();
            String sql = "INSERT INTO remember_me_tokens (user_id, token, created_at, expires_at) VALUES (?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, token);
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

            // Set expiration time (e.g., 30 days from now)
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (30L * 24 * 60 * 60 * 1000));
            stmt.setTimestamp(4, expiresAt);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                return token;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, conn);
        }

        return null;
    }

    /**
     * Get user ID by remember me token
     */
    public Integer getUserIdByToken(String token) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id FROM remember_me_tokens WHERE token = ? AND expires_at > ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("user_id");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
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