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
import java.sql.Statement;
import java.sql.Timestamp;

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
     * Deactivate a user account (set is_active = false).
     * Does NOT delete any data — the account can be reactivated later.
     *
     * @param userId The user ID to deactivate
     * @return true if deactivation was successful
     */
    public boolean deactivateAccount(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE users SET is_active = false WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            int rowsUpdated = stmt.executeUpdate();
            System.out.println("Deactivated account for user ID: " + userId + ", rows affected: " + rowsUpdated);
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while deactivating account", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Reactivate a user account (set is_active = true).
     * Used when a deactivated user logs back in.
     *
     * @param userId The user ID to reactivate
     * @return true if reactivation was successful
     */
    public boolean reactivateAccount(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE users SET is_active = true WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            int rowsUpdated = stmt.executeUpdate();
            System.out.println("Reactivated account for user ID: " + userId + ", rows affected: " + rowsUpdated);
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while reactivating account", e);
        } finally {
            closeResources(null, stmt, conn);
        }
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
}