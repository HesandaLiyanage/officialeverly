// File: src/main/java/com/demo/web/dao/RecycleBinDAO.java
package com.demo.web.dao;

import com.demo.web.model.RecycleBinItem;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecycleBinDAO {

    // Save a journal to recycle bin
    public int saveJournalToRecycleBin(RecycleBinItem item) {
        String sql = """
            INSERT INTO recycle_bin (original_id, item_type, user_id, title, content, metadata)
            VALUES (?, 'journal', ?, ?, ?, ?::JSONB) RETURNING id
            """;

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, item.getOriginalId());
            stmt.setInt(2, item.getUserId());
            stmt.setString(3, item.getTitle());
            stmt.setString(4, item.getContent());
            stmt.setString(5, item.getMetadata());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Get all deleted journals for a user
    public List<RecycleBinItem> findJournalsByUserId(int userId) {
        String sql = "SELECT * FROM recycle_bin WHERE user_id = ? AND item_type = 'journal' ORDER BY deleted_at DESC";
        List<RecycleBinItem> items = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                RecycleBinItem item = new RecycleBinItem();
                item.setId(rs.getInt("id"));
                item.setOriginalId(rs.getInt("original_id"));
                item.setItemType(rs.getString("item_type"));
                item.setUserId(rs.getInt("user_id"));
                item.setTitle(rs.getString("title"));
                item.setContent(rs.getString("content"));
                item.setMetadata(rs.getString("metadata"));
                item.setDeletedAt(rs.getTimestamp("deleted_at"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // Get one item by ID (for restore)
    public RecycleBinItem findById(int id) {
        String sql = "SELECT * FROM recycle_bin WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                RecycleBinItem item = new RecycleBinItem();
                item.setId(rs.getInt("id"));
                item.setOriginalId(rs.getInt("original_id"));
                item.setItemType(rs.getString("item_type"));
                item.setUserId(rs.getInt("user_id"));
                item.setTitle(rs.getString("title"));
                item.setContent(rs.getString("content"));
                item.setMetadata(rs.getString("metadata"));
                item.setDeletedAt(rs.getTimestamp("deleted_at"));
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Remove from recycle bin (after restore or permanent delete)
    public boolean deleteFromRecycleBin(int id) {
        String sql = "DELETE FROM recycle_bin WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}