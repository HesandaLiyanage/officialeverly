package com.demo.web.dao.Vault;

import com.demo.web.util.DatabaseUtil;
import com.demo.web.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VaultDAO {

    public boolean hasVaultSetup(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT vault_setup_completed FROM users WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getBoolean("vault_setup_completed");
            }

            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while checking vault setup", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean setupVaultPassword(int userId, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            String salt = PasswordUtil.generateSalt();
            String passwordHash = PasswordUtil.hashPassword(password, salt);

            String sql = "UPDATE users SET vault_password_hash = ?, vault_password_salt = ?, " +
                    "vault_setup_completed = TRUE WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, passwordHash);
            stmt.setString(2, salt);
            stmt.setInt(3, userId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while setting up vault password", e);
        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean verifyVaultPassword(int userId, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT vault_password_hash, vault_password_salt FROM users WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("vault_password_hash");
                String salt = rs.getString("vault_password_salt");

                if (storedHash == null || salt == null) {
                    return false; // Vault not set up
                }

                return PasswordUtil.verifyPassword(password, salt, storedHash);
            }

            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while verifying vault password", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean changeVaultPassword(int userId, String currentPassword, String newPassword) {
        if (!verifyVaultPassword(userId, currentPassword)) {
            return false;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            String newSalt = PasswordUtil.generateSalt();
            String newPasswordHash = PasswordUtil.hashPassword(newPassword, newSalt);

            String sql = "UPDATE users SET vault_password_hash = ?, vault_password_salt = ? WHERE user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPasswordHash);
            stmt.setString(2, newSalt);
            stmt.setInt(3, userId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error while changing vault password", e);
        } finally {
            closeResources(null, stmt, conn);
        }
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
