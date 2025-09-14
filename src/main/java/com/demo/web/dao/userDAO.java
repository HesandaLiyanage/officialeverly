package com.demo.web.dao;

import com.demo.web.model.user;
import com.demo.web.util.DatabaseUtil;
import com.demo.web.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class userDAO {

    /**
     * Authenticate user by username and password
     */
    public user authenticateUser(String username, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at,is_active, last_login, profile_picture_url" +
                    "FROM users WHERE username = ? AND is_active = true";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);

            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                String salt = rs.getString("salt");

                // Verify password
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
     * Find user by ID
     */
    public user findById(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at,is_active, last_login, profile_picture_url" +
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
     * Find user by email
     */
    /**
     * Find user by email
     */
    public user findByemail(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at,is_active, last_login, profile_picture_url " +
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

        // Fixed: was returning 1
    }

    /**
     * Find user by username
     */
    public user findByUsername(String username) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT user_id, username, email, password, salt, bio, joined_at,is_active, last_login, profile_picture_url " +
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
     * Update user's last login timestamp
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
     * Create a new user
     */
    public boolean createUser(user user) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // Generate salt and hash password
            String salt = PasswordUtil.generateSalt();
            String passwordHash = PasswordUtil.hashPassword(user.getPassword(), salt);

            String sql = "INSERT INTO users (username, email, password, salt, bio, profile_picture_url, is_active, joined_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, passwordHash);
            stmt.setString(4, salt);
            stmt.setString(5, user.getBio());
            stmt.setString(6, user.getProfilePictureUrl());
            stmt.setBoolean(7, true);
            stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while creating user", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Check if username exists
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

    //update profile pic
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
     * Check if email exists
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
     * Map ResultSet to User object
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
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("joined_at"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        return user;
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