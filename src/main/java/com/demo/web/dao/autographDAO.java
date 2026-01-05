// File: com/demo/web/dao/autographDAO.java (With Debugging Output)
package com.demo.web.dao;

import com.demo.web.model.autograph;
import com.demo.web.model.RecycleBinItem;
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
                System.out.println("[DEBUG autographDAO] findById(" + autographId + ") returned null (record not found).");
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while fetching autograph by ID " + autographId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching autograph by ID", e);
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
            System.out.println("[DEBUG autographDAO] findByUserId(" + userId + ") returned " + autographs.size() + " records.");
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while fetching autographs by user ID " + userId + ": " + e.getMessage());
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
            stmt.setString(1, autograph.getTitle());      // Parameter 1: new title
            stmt.setString(2, autograph.getDescription()); // Parameter 2: new description
            stmt.setString(3, autograph.getAutographPicUrl()); // Parameter 3: new pic URL
            stmt.setInt(4, autograph.getAutographId());   // Parameter 4: WHERE autograph_id

            System.out.println("[DEBUG autographDAO] updateAutograph preparing statement with values - Title: '" + autograph.getTitle() + "', Description: '" + autograph.getDescription() + "', Pic URL: '" + autograph.getAutographPicUrl() + "', ID: " + autograph.getAutographId());

            int rowsUpdated = stmt.executeUpdate();

            System.out.println("[DEBUG autographDAO] updateAutograph executed. Rows affected: " + rowsUpdated + " for ID: " + autograph.getAutographId());

            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while updating autograph ID " + autograph.getAutographId() + ": " + e.getMessage());
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
            System.out.println("[DEBUG autographDAO] deleteAutograph affected " + rowsDeleted + " rows for ID: " + autographId);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while deleting autograph ID " + autographId + ": " + e.getMessage());
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

    /**
     * Move autograph to recycle bin (soft delete)
     */
    public boolean deleteAutographToRecycleBin(int autographId, int userId) {
        autograph autograph = findById(autographId);
        if (autograph == null || autograph.getUserId() != userId) {
            return false;
        }

        RecycleBinItem item = new RecycleBinItem();
        item.setOriginalId(autograph.getAutographId());
        item.setUserId(userId);
        item.setTitle(autograph.getTitle());
        item.setContent(autograph.getDescription());
        String metadata = "{\"autographPicUrl\": \"" +
                (autograph.getAutographPicUrl() != null ? autograph.getAutographPicUrl() : "") +
                "\"}";
        item.setMetadata(metadata);

        RecycleBinDAO rbDao = new RecycleBinDAO();
        int recycleId = rbDao.saveAutographToRecycleBin(item);
        if (recycleId <= 0) return false;

        String deleteSql = "DELETE FROM autograph WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
            stmt.setInt(1, autographId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Restore autograph from recycle bin
     */
    public boolean restoreAutographFromRecycleBin(int recycleBinId, int userId) {
        RecycleBinDAO rbDao = new RecycleBinDAO();
        RecycleBinItem item = rbDao.findById(recycleBinId);
        if (item == null || !"autograph".equals(item.getItemType()) || item.getUserId() != userId) {
            return false;
        }

        autograph autograph = new autograph();
        autograph.setTitle(item.getTitle());
        autograph.setDescription(item.getContent());
        autograph.setUserId(userId);

        String autographPicUrl = "";
        if (item.getMetadata() != null) {
            String meta = item.getMetadata();
            int start = meta.indexOf("\"autographPicUrl\": \"");
            if (start != -1) {
                start += 20;
                int end = meta.indexOf("\"", start);
                if (end != -1) {
                    autographPicUrl = meta.substring(start, end);
                }
            }
        }
        autograph.setAutographPicUrl(autographPicUrl);

        boolean restored = createAutograph(autograph);
        if (restored) {
            rbDao.deleteFromRecycleBin(recycleBinId);
            return true;
        }
        return false;
    }
}