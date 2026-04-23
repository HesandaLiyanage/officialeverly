package com.demo.web.dao.Auth;

import com.demo.web.model.Auth.UserSession;
import com.demo.web.util.AppLogger;
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
import java.util.logging.Logger;

public class userSessionDAO {

    private static final Map<String, SecretKey> masterKeyCache = new ConcurrentHashMap<>();
    private static final Logger logger = AppLogger.getLogger(userSessionDAO.class);

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
            AppLogger.error(logger, "Failed to create session for user " + userId, e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean createSession(int userId, String sessionId) {
        return createSession(userId, sessionId, "Unknown Device", "Unknown", "Unknown IP", "Unknown Browser");
    }

    public boolean createSessionWithMasterKey(int userId, String sessionId, SecretKey masterKey,
                                              String deviceName, String deviceType,
                                              String ipAddress, String userAgent) {
        boolean sessionCreated = createSession(userId, sessionId, deviceName, deviceType, ipAddress, userAgent);

        if (sessionCreated && masterKey != null) {
            storeMasterKeyInCache(sessionId, masterKey);
        }

        return sessionCreated;
    }

    public void storeMasterKeyInCache(String sessionId, SecretKey masterKey) {
        if (sessionId != null && masterKey != null) {
            masterKeyCache.put(sessionId, masterKey);
        }
    }

    public SecretKey getMasterKeyFromCache(String sessionId) {
        return masterKeyCache.get(sessionId);
    }

    public void removeMasterKeyFromCache(String sessionId) {
        masterKeyCache.remove(sessionId);
    }

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
            AppLogger.error(logger, "Failed to look up session " + sessionId, e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

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
            AppLogger.error(logger, "Failed to load sessions for user " + userId, e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return sessions;
    }

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
                removeMasterKeyFromCache(sessionId);
                return true;
            }

            return false;

        } catch (SQLException e) {
            AppLogger.error(logger, "Failed to revoke session " + sessionId, e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public int revokeAllSessionsExcept(int userId, String currentSessionId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
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

            rs.close();
            stmt.close();

            String updateSql = "UPDATE user_sessions SET is_active = FALSE " +
                    "WHERE user_id = ? AND session_id != ? AND is_active = TRUE";

            stmt = conn.prepareStatement(updateSql);
            stmt.setInt(1, userId);
            stmt.setString(2, currentSessionId);

            int rowsUpdated = stmt.executeUpdate();

            for (String sessionId : sessionIdsToRevoke) {
                removeMasterKeyFromCache(sessionId);
            }

            return rowsUpdated;

        } catch (SQLException e) {
            AppLogger.error(logger, "Failed to revoke sibling sessions for user " + userId, e);
            return 0;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

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
                removeMasterKeyFromCache(sessionId);
                return true;
            }

            return false;

        } catch (SQLException e) {
            AppLogger.error(logger, "Failed to delete session " + sessionId, e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public int deleteExpiredSessions() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();

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

            String deleteSql = "DELETE FROM user_sessions WHERE expires_at < ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));

            int rowsDeleted = stmt.executeUpdate();

            for (String sessionId : expiredSessionIds) {
                removeMasterKeyFromCache(sessionId);
            }

            return rowsDeleted;

        } catch (SQLException e) {
            AppLogger.error(logger, "Failed to delete expired sessions", e);
            return 0;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

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
            AppLogger.warn(logger, "Session validation query failed for " + sessionId, e);
            return false;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean hasMasterKey(String sessionId) {
        return masterKeyCache.containsKey(sessionId);
    }

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
            AppLogger.error(logger, "Failed to extend session " + sessionId, e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

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

            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (30L * 24 * 60 * 60 * 1000));
            stmt.setTimestamp(4, expiresAt);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                return token;
            }

        } catch (SQLException e) {
            AppLogger.error(logger, "Failed to create remember-me token for user " + userId, e);
        } finally {
            closeResources(null, stmt, conn);
        }

        return null;
    }

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
            AppLogger.warn(logger, "Failed to resolve remember-me token", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    public boolean deleteRememberMeToken(String token) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM remember_me_tokens WHERE token = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            AppLogger.warn(logger, "Failed to delete remember-me token", e);
            return false;
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public int getMasterKeyCacheSize() {
        return masterKeyCache.size();
    }

    public void clearAllMasterKeys() {
        masterKeyCache.clear();
    }

    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            AppLogger.warn(logger, "Failed to close JDBC resources", e);
        }
    }
}
