// File: com/demo/web/dao/autographDAO.java (With Debugging Output)
package com.demo.web.dao;

import com.demo.web.model.autograph;
import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class autographDAO {

    private static final Logger logger = Logger.getLogger(autographDAO.class.getName());

    /**
     * Create a new autograph
     */
    public boolean createAutograph(autograph autograph) {
        String sql = "INSERT INTO autograph (a_title, a_description, created_at, user_id, autograph_pic_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, autograph.getTitle());
            stmt.setString(2, autograph.getDescription());
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(4, autograph.getUserId());
            stmt.setString(5, autograph.getAutographPicUrl());
            int rowsInserted = stmt.executeUpdate();
            System.out.println("[DEBUG autographDAO] createAutograph affected " + rowsInserted + " rows.");
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while creating autograph: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while creating autograph", e);
        }
    }

    public String getOrCreateShareToken(int autographId) throws SQLException {
        String selectSql = "SELECT share_token FROM autograph WHERE autograph_id = ?";
        String updateSql = "UPDATE autograph SET share_token = ? WHERE autograph_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {

            selectStmt.setInt(1, autographId);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                String existingToken = rs.getString("share_token");
                if (existingToken != null && !existingToken.isEmpty()) {
                    return existingToken;
                }
            }

            // Generate a random 12-character alphanumeric token
            String newToken = generateAlphanumericToken(12);

            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, newToken);
                updateStmt.setInt(2, autographId);
                updateStmt.executeUpdate();
            }

            return newToken;
        }
    }

    /**
     * Revoke the share token for an autograph, so a new one will be generated next
     * time.
     */
    public boolean revokeShareToken(int autographId) throws SQLException {
        String sql = "UPDATE autograph SET share_token = NULL WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            int rows = stmt.executeUpdate();
            System.out
                    .println("[DEBUG autographDAO] revokeShareToken affected " + rows + " rows for ID: " + autographId);
            return rows > 0;
        }
    }

    /**
     * Generate a random alphanumeric token of the specified length.
     */
    private String generateAlphanumericToken(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        java.security.SecureRandom random = new java.security.SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    /**
     * Get autograph by ID
     */
    public autograph findById(int autographId) {
        String sql = "SELECT autograph_id, a_title, a_description, created_at, user_id, autograph_pic_url FROM autograph WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                autograph result = mapResultSetToAutograph(rs);
                System.out.println("[DEBUG autographDAO] findById(" + autographId + ") returned: " + result);
                return result;
            } else {
                System.out.println(
                        "[DEBUG autographDAO] findById(" + autographId + ") returned null (record not found).");
            }
        } catch (SQLException e) {
            System.out.println(
                    "[DEBUG autographDAO] Error while fetching autograph by ID " + autographId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching autograph by ID", e);
        }
        return null;
    }

    /**
     * Get autograph by share token
     */
    public autograph getAutographByShareToken(String shareToken) throws SQLException {

        String sql = "SELECT autograph_id, a_title, a_description, created_at, user_id, autograph_pic_url, share_token "
                +
                "FROM autograph WHERE share_token = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, shareToken);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                autograph ag = new autograph();
                ag.setAutographId(rs.getInt("autograph_id"));
                ag.setTitle(rs.getString("a_title"));
                ag.setDescription(rs.getString("a_description"));
                ag.setCreatedAt(rs.getTimestamp("created_at"));
                ag.setUserId(rs.getInt("user_id"));
                ag.setAutographPicUrl(rs.getString("autograph_pic_url"));
                ag.setShareToken(rs.getString("share_token"));
                return ag;
            }
        }

        return null;
    }

    /**
     * Get all autographs by a specific user
     */
    public List<autograph> findByUserId(int userId) {
        String sql = "SELECT autograph_id, a_title, a_description, created_at, user_id, autograph_pic_url FROM autograph WHERE user_id = ?";
        List<autograph> autographs = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                autographs.add(mapResultSetToAutograph(rs));
            }
            System.out.println(
                    "[DEBUG autographDAO] findByUserId(" + userId + ") returned " + autographs.size() + " records.");
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while fetching autographs by user ID " + userId + ": "
                    + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching autographs by user ID", e);
        }
        return autographs;
    }

    /**
     * Update an existing autograph
     */
    public boolean updateAutograph(autograph autograph) {
        // Include autograph_pic_url in the UPDATE statement
        // Ensure the WHERE clause uses autograph_id
        String sql = "UPDATE autograph SET a_title = ?, a_description = ?, autograph_pic_url = ? WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, autograph.getTitle()); // Parameter 1: new title
            stmt.setString(2, autograph.getDescription()); // Parameter 2: new description
            stmt.setString(3, autograph.getAutographPicUrl()); // Parameter 3: new pic URL
            stmt.setInt(4, autograph.getAutographId()); // Parameter 4: WHERE autograph_id

            System.out.println("[DEBUG autographDAO] updateAutograph preparing statement with values - Title: '"
                    + autograph.getTitle() + "', Description: '" + autograph.getDescription() + "', Pic URL: '"
                    + autograph.getAutographPicUrl() + "', ID: " + autograph.getAutographId());

            int rowsUpdated = stmt.executeUpdate();

            System.out.println("[DEBUG autographDAO] updateAutograph executed. Rows affected: " + rowsUpdated
                    + " for ID: " + autograph.getAutographId());

            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while updating autograph ID " + autograph.getAutographId()
                    + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while updating autograph", e);
        }
    }

    /**
     * Delete autograph by ID
     */
    public boolean deleteAutograph(int autographId) {
        String sql = "DELETE FROM autograph WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            int rowsDeleted = stmt.executeUpdate();
            System.out.println(
                    "[DEBUG autographDAO] deleteAutograph affected " + rowsDeleted + " rows for ID: " + autographId);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            System.out.println(
                    "[DEBUG autographDAO] Error while deleting autograph ID " + autographId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while deleting autograph", e);
        }
    }

    /**
     * Map ResultSet to autograph object
     */
    private autograph mapResultSetToAutograph(ResultSet rs) throws SQLException {
        autograph autograph = new autograph();
        autograph.setAutographId(rs.getInt("autograph_id"));
        autograph.setTitle(rs.getString("a_title"));
        autograph.setDescription(rs.getString("a_description"));
        autograph.setCreatedAt(rs.getTimestamp("created_at"));
        autograph.setUserId(rs.getInt("user_id"));
        autograph.setAutographPicUrl(rs.getString("autograph_pic_url"));
        return autograph;
    }
}
