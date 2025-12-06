package com.demo.web.dao;

import com.demo.web.model.UserSession;
import com.demo.web.util.DatabaseUtil;

import javax.crypto.SecretKey;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * IMPORTANT: Master keys are stored in memory (HTTP session or this cache)
 * NEVER store master keys in the database!
 */
public class userSessionDAO {

    // In-memory cache for master keys (as fallback if not using HTTP session)
    // Key: sessionId, Value: SecretKey (master key)
    // NOTE: In production, use Redis or similar for distributed systems
    private static final Map<String, SecretKey> masterKeyCache = new ConcurrentHashMap<>();

    /**
     * Create a new user session with device information
     * UNCHANGED - your existing session creation
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

            // Set expiration time (24 hours from now)
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (24L * 60 * 60 * 1000));
            stmt.setTimestamp(4, expiresAt);

            stmt.setString(5, deviceName);
            stmt.setString(6, deviceType);
            stmt.setString(7, ipAddress);
            stmt.setString(8, userAgent);
            stmt.setBoolean(9, true);

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
     * Create a new user session (backward compatibility) - UNCHANGED
     */
    public boolean createSession(int userId, String sessionId) {
        return createSession(userId, sessionId, "Unknown Device", "Unknown", "Unknown IP", "Unknown Browser");
    }

    /**
     * NEW METHOD: Create session WITH master key storage
     * Use this after successful login with encryption unlocking
     */
    public boolean createSessionWithMasterKey(int userId, String sessionId, SecretKey masterKey,
                                              String deviceName, String deviceType,
                                              String ipAddress, String userAgent) {
        // Create normal session in database
        boolean sessionCreated = createSession(userId, sessionId, deviceName, deviceType, ipAddress, userAgent);

        if (sessionCreated && masterKey != null) {
            // Store master key in memory cache
            storeMasterKeyInCache(sessionId, masterKey);
        }

        return sessionCreated;
    }

    /**
     * NEW METHOD: Store master key in memory cache
     * Call this after successful login
     */
    public void storeMasterKeyInCache(String sessionId, SecretKey masterKey) {
        if (sessionId != null && masterKey != null) {
            masterKeyCache.put(sessionId, masterKey);
        }
    }

    /**
     * NEW METHOD: Retrieve master key from cache
     * Use this when user makes requests (already logged in)
     */
    public SecretKey getMasterKeyFromCache(String sessionId) {
        return masterKeyCache.get(sessionId);
    }

    /**
     * NEW METHOD: Remove master key from cache
     * Call this on logout or session expiration
     */
    public void removeMasterKeyFromCache(String sessionId) {
        masterKeyCache.remove(sessionId);
    }

    /**
     * Find session by session ID - UNCHANGED
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
     * Get all active sessions for a user - UNCHANGED
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
     * UPDATED: Revoke a specific session (logout device)
     * Now also removes master key from cache
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

            if (rowsUpdated > 0) {
                // Remove master key from cache
                removeMasterKeyFromCache(sessionId);
                return true;
            }

            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * UPDATED: Revoke all sessions except current one
     * Now also removes master keys from cache
     */
    public int revokeAllSessionsExcept(int userId, String currentSessionId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // First, get all session IDs to revoke
            conn = DatabaseUtil.getConnection();
            String selectSql = "SELECT session_id FROM user_sessions " +
                    "WHERE user_id = ? AND session_id != ? AND is_active = TRUE";

            stmt = conn.prepareStatement(selectSql);
            stmt.setInt(1, userId);
            stmt.setString(2, currentSessionId);

            rs = stmt.executeQuery();

            List<String> sessionIdsToRevoke = new ArrayList<>();
            while (rs.next()) {
                sessionIdsToRevoke.add(rs.getString("session_id"));
            }

            // Close result set before next query
            rs.close();
            stmt.close();

            // Now revoke the sessions
            String updateSql = "UPDATE user_sessions SET is_active = FALSE " +
                    "WHERE user_id = ? AND session_id != ? AND is_active = TRUE";

            stmt = conn.prepareStatement(updateSql);
            stmt.setInt(1, userId);
            stmt.setString(2, currentSessionId);

            int rowsUpdated = stmt.executeUpdate();

            // Remove master keys from cache for all revoked sessions
            for (String sessionId : sessionIdsToRevoke) {
                removeMasterKeyFromCache(sessionId);
            }

            return rowsUpdated;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * UPDATED: Delete user session (permanent deletion)
     * Now also removes master key from cache
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

            if (rowsDeleted > 0) {
                // Remove master key from cache
                removeMasterKeyFromCache(sessionId);
                return true;
            }

            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * UPDATED: Delete expired sessions
     * Now also cleans up master keys from cache
     */
    public int deleteExpiredSessions() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();

            // First, get expired session IDs
            String selectSql = "SELECT session_id FROM user_sessions WHERE expires_at < ?";
            stmt = conn.prepareStatement(selectSql);
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));

            rs = stmt.executeQuery();

            List<String> expiredSessionIds = new ArrayList<>();
            while (rs.next()) {
                expiredSessionIds.add(rs.getString("session_id"));
            }

            rs.close();
            stmt.close();

            // Delete expired sessions
            String deleteSql = "DELETE FROM user_sessions WHERE expires_at < ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));

            int rowsDeleted = stmt.executeUpdate();

            // Clean up master keys from cache
            for (String sessionId : expiredSessionIds) {
                removeMasterKeyFromCache(sessionId);
            }

            return rowsDeleted;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Check if session exists and is valid - UNCHANGED
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
     * NEW METHOD: Check if session has master key in cache
     * Use this to verify user can decrypt files
     */
    public boolean hasMasterKey(String sessionId) {
        return masterKeyCache.containsKey(sessionId);
    }

    /**
     * Update session expiration time - UNCHANGED
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
     * Create remember me token - UNCHANGED
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

            // Set expiration time (30 days from now)
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
     * Get user ID by remember me token - UNCHANGED
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
     * NEW METHOD: Get cache statistics (for debugging)
     */
    public int getMasterKeyCacheSize() {
        return masterKeyCache.size();
    }

    /**
     * NEW METHOD: Clear entire master key cache (use with caution!)
     * Useful for server restart or maintenance
     */
    public void clearAllMasterKeys() {
        masterKeyCache.clear();
    }

    /**
     * Close database resources - UNCHANGED
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