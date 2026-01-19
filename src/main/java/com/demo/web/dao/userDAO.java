package com.demo.web.dao;

import com.demo.web.model.user;
import com.demo.web.util.DatabaseUtil;
import com.demo.web.util.PasswordUtil;
import com.demo.web.util.EncryptionService;
import com.demo.web.util.EncryptionService.UserMasterKeyData;

import javax.crypto.SecretKey;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class userDAO {

    /**
     * Authenticate user by username and password
     * THIS METHOD UNCHANGED - Your existing authentication works as-is
     */
    public user authenticateUser(String username, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at, is_active, last_login, profile_picture_url "
                    +
                    "FROM users WHERE username = ? AND is_active = true";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);

            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                String salt = rs.getString("salt");

                // Verify password using your existing PasswordUtil
                if (PasswordUtil.verifyPassword(password, salt, storedHash)) {
                    return mapResultSetToUser(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error during authentication", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    /**
     * NEW METHOD: Unlock user's master encryption key after authentication
     * Call this AFTER authenticateUser succeeds
     *
     * @param userId   The authenticated user's ID
     * @param password The user's password (plain text)
     * @return The unlocked master key (store in session, NOT database)
     */
    public SecretKey unlockUserMasterKey(int userId, String password) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT u.master_key_encrypted, u.key_derivation_salt, em.iv " +
                    "FROM users u " +
                    "JOIN encryption_metadata em ON em.entity_id = CAST(u.user_id AS VARCHAR) " +
                    "WHERE u.user_id = ? AND em.entity_type = 'user_master_key'";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                byte[] encryptedMasterKey = rs.getBytes("master_key_encrypted");
                byte[] salt = rs.getBytes("key_derivation_salt");
                byte[] iv = rs.getBytes("iv");

                // Check if user has encryption keys set up
                if (encryptedMasterKey == null || salt == null || iv == null) {
                    throw new Exception("User encryption keys not initialized. This might be an old account.");
                }

                // Unlock the master key
                return EncryptionService.unlockUserMasterKey(password, salt, encryptedMasterKey, iv);
            }

            throw new Exception("Encryption keys not found for user");

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while unlocking master key", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * NEW METHOD: Complete login with encryption key unlocking
     * This combines authentication + key unlocking
     *
     * @return Array: [0] = user object, [1] = master key (cast to SecretKey)
     */
    public Object[] loginUserWithEncryption(String username, String password) {
        // Step 1: Authenticate user (existing method)
        user authenticatedUser = authenticateUser(username, password);

        if (authenticatedUser == null) {
            return null; // Authentication failed
        }

        // Step 2: Unlock encryption keys
        try {
            SecretKey masterKey = unlockUserMasterKey(authenticatedUser.getId(), password);
            return new Object[] { authenticatedUser, masterKey };
        } catch (Exception e) {
            // Authentication succeeded but encryption keys failed
            // This might happen for old accounts created before encryption was added
            System.err.println("Warning: User authenticated but encryption keys unavailable: " + e.getMessage());
            // Return user without master key - handle this in your servlet
            return new Object[] { authenticatedUser, null };
        }
    }

    /**
     * Find user by ID - UNCHANGED
     */
    public user findById(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at, is_active, last_login, profile_picture_url "
                    +
                    "FROM users WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while finding user", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Find user by email - UNCHANGED
     */
    public user findByemail(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at, is_active, last_login, profile_picture_url "
                    +
                    "FROM users WHERE email = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while finding user", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Find user by username - UNCHANGED
     */
    public user findByUsername(String username) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at, is_active, last_login, profile_picture_url "
                    +
                    "FROM users WHERE username = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while finding user", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Update user's last login timestamp - UNCHANGED
     */
    public boolean updateLastLogin(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE users SET last_login = ? WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(2, userId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while updating last login", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * UPDATED: Create a new user WITH encryption setup
     */
    public boolean createUser(user user) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet generatedKeys = null;

        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // STEP 1: Generate authentication credentials (EXISTING)
            String authSalt = PasswordUtil.generateSalt();
            String passwordHash = PasswordUtil.hashPassword(user.getPassword(), authSalt);

            // STEP 2: Generate encryption keys (NEW)
            UserMasterKeyData keyData = EncryptionService.setupUserMasterKey(user.getPassword());

            // STEP 3: Insert user with both auth and encryption data
            String sql = "INSERT INTO users (username, email, password, salt, bio, profile_picture_url, " +
                    "is_active, joined_at, master_key_encrypted, key_derivation_salt) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING user_id";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, passwordHash); // Auth password hash
            stmt.setString(4, authSalt); // Auth salt
            stmt.setString(5, user.getBio());
            stmt.setString(6, user.getProfilePictureUrl());
            stmt.setBoolean(7, true);
            stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            stmt.setBytes(9, keyData.getEncryptedMasterKey()); // NEW: Encryption master key
            stmt.setBytes(10, keyData.getSalt()); // NEW: Encryption salt

            generatedKeys = stmt.executeQuery();

            if (generatedKeys.next()) {
                int newUserId = generatedKeys.getInt("user_id");
                user.setId(newUserId);

                // STEP 4: Store IV for master key in encryption_metadata
                storeUserMasterKeyIV(conn, newUserId, keyData.getIv());

                conn.commit(); // Commit transaction
                return true;
            }

            conn.rollback();
            return false;

        } catch (Exception e) {
            try {
                if (conn != null)
                    conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            throw new RuntimeException("Database error while creating user", e);
        } finally {
            try {
                if (conn != null)
                    conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(generatedKeys, stmt, conn);
        }
    }

    /**
     * NEW HELPER METHOD: Store IV for user's master key
     */
    private void storeUserMasterKeyIV(Connection conn, int userId, byte[] iv) throws SQLException {
        String sql = "INSERT INTO encryption_metadata (entity_type, entity_id, iv) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "user_master_key");
            pstmt.setString(2, String.valueOf(userId));
            pstmt.setBytes(3, iv);
            pstmt.executeUpdate();
        }
    }

    /**
     * NEW METHOD: Check if user has encryption keys set up
     * Useful for migrating old accounts
     */
    public boolean hasEncryptionKeys(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT 1 FROM users WHERE user_id = ? AND master_key_encrypted IS NOT NULL";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

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
     * NEW METHOD: Setup encryption for existing user (migration)
     * Use this to add encryption to accounts created before encryption was
     * implemented
     */
    public boolean setupEncryptionForExistingUser(int userId, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            // Generate encryption keys
            UserMasterKeyData keyData = EncryptionService.setupUserMasterKey(password);

            // Update user record
            String sql = "UPDATE users SET master_key_encrypted = ?, key_derivation_salt = ? WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setBytes(1, keyData.getEncryptedMasterKey());
            stmt.setBytes(2, keyData.getSalt());
            stmt.setInt(3, userId);

            int updated = stmt.executeUpdate();

            if (updated > 0) {
                // Store IV
                storeUserMasterKeyIV(conn, userId, keyData.getIv());
                conn.commit();
                return true;
            }

            conn.rollback();
            return false;

        } catch (Exception e) {
            try {
                if (conn != null)
                    conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null)
                    conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Check if username exists - UNCHANGED
     */
    public boolean usernameExists(String username) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT 1 FROM users WHERE username = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);

            rs = stmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while checking username", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Update profile pic - UNCHANGED
     */
    public boolean updateProfilePicture(int userId, String profilePictureUrl) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE users SET profile_picture_url = ? WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, profilePictureUrl);
            stmt.setInt(2, userId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Check if email exists - UNCHANGED
     */
    public boolean emailExists(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT 1 FROM users WHERE email = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            rs = stmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while checking email", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Map ResultSet to User object - UNCHANGED
     */
    private user mapResultSetToUser(ResultSet rs) throws SQLException {
        user user = new user();
        user.setId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setSalt(rs.getString("salt"));
        user.setBio(rs.getString("bio"));
        user.setProfilePictureUrl(rs.getString("profile_picture_url"));
        user.set_active(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("joined_at"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        return user;
    }

    /**
     * Close database resources - UNCHANGED
     */
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

    // ======================= ADMIN METHODS =======================

    /**
     * Get all users except admin user
     */
    public List<user> getAllUsersExceptAdmin() {
        List<user> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at, is_active, last_login, profile_picture_url "
                    +
                    "FROM users WHERE username != 'admin' ORDER BY joined_at DESC";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while getting all users", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return users;
    }

    /**
     * Delete a user by ID and cascade delete related data
     */
    public boolean deleteUser(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            // Delete from group_members first
            try {
                stmt = conn.prepareStatement("DELETE FROM group_members WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete groups created by user (and their members first)
            try {
                stmt = conn.prepareStatement(
                        "DELETE FROM group_members WHERE group_id IN (SELECT group_id FROM \"group\" WHERE user_id = ?)");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();

                stmt = conn.prepareStatement("DELETE FROM \"group\" WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete from memory_members (collaborative memory memberships)
            try {
                stmt = conn.prepareStatement("DELETE FROM memory_members WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete from memory_media (media in user's memories)
            try {
                stmt = conn.prepareStatement(
                        "DELETE FROM memory_media WHERE memory_id IN (SELECT memory_id FROM memory WHERE user_id = ?)");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete encryption_keys for user's media
            try {
                stmt = conn.prepareStatement("DELETE FROM encryption_keys WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete media items
            try {
                stmt = conn.prepareStatement("DELETE FROM media_items WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete memories
            try {
                stmt = conn.prepareStatement("DELETE FROM memory WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete journal streaks
            try {
                stmt = conn.prepareStatement("DELETE FROM journal_streaks WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete user sessions
            try {
                stmt = conn.prepareStatement("DELETE FROM user_sessions WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete remember me tokens
            try {
                stmt = conn.prepareStatement("DELETE FROM remember_me_tokens WHERE user_id = ?");
                stmt.setInt(1, userId);
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Delete encryption metadata
            try {
                stmt = conn.prepareStatement("DELETE FROM encryption_metadata WHERE entity_id = ?");
                stmt.setString(1, String.valueOf(userId));
                stmt.executeUpdate();
                stmt.close();
            } catch (SQLException e) {
                // Table might not exist, continue
            }

            // Finally delete the user
            stmt = conn.prepareStatement("DELETE FROM users WHERE user_id = ?");
            stmt.setInt(1, userId);
            int deleted = stmt.executeUpdate();

            conn.commit();
            return deleted > 0;

        } catch (SQLException e) {
            try {
                if (conn != null)
                    conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            throw new RuntimeException("Database error while deleting user", e);
        } finally {
            try {
                if (conn != null)
                    conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get users with activity stats (memory count)
     * Returns a list of maps with user info and memory_count
     */
    public List<Map<String, Object>> getUsersWithActivityStats() {
        List<Map<String, Object>> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT u.user_id, u.username, u.email, u.joined_at, u.last_login, u.is_active, " +
                    "COALESCE(COUNT(m.memory_id), 0) as memory_count " +
                    "FROM users u " +
                    "LEFT JOIN memory m ON u.user_id = m.user_id " +
                    "WHERE u.username != 'admin' " +
                    "GROUP BY u.user_id, u.username, u.email, u.joined_at, u.last_login, u.is_active " +
                    "ORDER BY memory_count DESC";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> userStats = new HashMap<>();
                userStats.put("userId", rs.getInt("user_id"));
                userStats.put("username", rs.getString("username"));
                userStats.put("email", rs.getString("email"));
                userStats.put("joinedAt", rs.getTimestamp("joined_at"));
                userStats.put("lastLogin", rs.getTimestamp("last_login"));
                userStats.put("isActive", rs.getBoolean("is_active"));
                userStats.put("memoryCount", rs.getInt("memory_count"));
                result.add(userStats);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while getting user activity stats", e);
        } finally {
            closeResources(rs, stmt, conn);
        }

        return result;
    }

    /**
     * Get total user count (excluding admin)
     */
    public int getTotalUserCount() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT COUNT(*) as count FROM users WHERE username != 'admin'";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count");
            }
            return 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
}