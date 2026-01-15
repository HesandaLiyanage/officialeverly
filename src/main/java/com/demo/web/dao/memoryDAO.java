package com.demo.web.dao;

import com.demo.web.model.Memory;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class memoryDAO {

    /**
     * Create a new memory
     */
    public int createMemory(Memory memory) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory (title, description, user_id, updated_at, is_public) " +
                    "VALUES (?, ?, ?, ?, ?) RETURNING memory_id";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memory.getTitle());
            stmt.setString(2, memory.getDescription());
            stmt.setInt(3, memory.getUserId());
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            stmt.setBoolean(5, memory.isPublic());

            rs = stmt.executeQuery();

            if (rs.next()) {
                int memoryId = rs.getInt("memory_id");
                memory.setMemoryId(memoryId);
                return memoryId;
            }

            throw new SQLException("Failed to create memory, no ID obtained");

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Link media to memory
     */
    public boolean linkMediaToMemory(int memoryId, int mediaId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory_media (memory_id, media_id) VALUES (?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, mediaId);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get memory by ID
     */
    public Memory getMemoryById(int memoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id, title, description, updated_at, user_id, " +
                    "cover_media_id, created_timestamp, is_public, share_key, expires_at, is_link_shared, " +
                    "is_collaborative, group_key_id " +
                    "FROM memory WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToMemory(rs);
            }

            return null;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get all memories for a user (excluding vault items)
     */
    public List<Memory> getMemoriesByUserId(int userId) throws SQLException {
        List<Memory> memories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id, title, description, updated_at, user_id, " +
                    "cover_media_id, created_timestamp, is_public, share_key, expires_at, is_link_shared, " +
                    "is_collaborative, group_key_id " +
                    "FROM memory WHERE user_id = ? AND (is_in_vault = FALSE OR is_in_vault IS NULL) " +
                    "ORDER BY created_timestamp DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                memories.add(mapResultSetToMemory(rs));
            }

            return memories;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Update memory
     */
    public boolean updateMemory(Memory memory) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE memory SET title = ?, description = ?, updated_at = ?, " +
                    "cover_media_id = ?, is_public = ? WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memory.getTitle());
            stmt.setString(2, memory.getDescription());
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

            if (memory.getCoverMediaId() != null) {
                stmt.setInt(4, memory.getCoverMediaId());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }

            stmt.setBoolean(5, memory.isPublic());
            stmt.setInt(6, memory.getMemoryId());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Delete memory
     */
    public boolean deleteMemory(int memoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // Note: This will also delete related entries in memory_media due to CASCADE
            String sql = "DELETE FROM memory WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Set cover media for memory
     */
    public boolean setCoverMedia(int memoryId, int mediaId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE memory SET cover_media_id = ? WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, mediaId);
            stmt.setInt(2, memoryId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get media count for a memory
     */
    public int getMediaCount(int memoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT COUNT(*) as count FROM memory_media WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count");
            }

            return 0;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Map ResultSet to Memory object
     */
    private Memory mapResultSetToMemory(ResultSet rs) throws SQLException {
        Memory memory = new Memory();
        memory.setMemoryId(rs.getInt("memory_id"));
        memory.setTitle(rs.getString("title"));
        memory.setDescription(rs.getString("description"));
        memory.setUpdatedAt(rs.getTimestamp("updated_at"));
        memory.setUserId(rs.getInt("user_id"));

        int coverMediaId = rs.getInt("cover_media_id");
        if (!rs.wasNull()) {
            memory.setCoverMediaId(coverMediaId);
        }

        memory.setCreatedTimestamp(rs.getTimestamp("created_timestamp"));
        memory.setPublic(rs.getBoolean("is_public"));
        memory.setShareKey(rs.getString("share_key"));
        memory.setExpiresAt(rs.getTimestamp("expires_at"));
        memory.setLinkShared(rs.getBoolean("is_link_shared"));
        memory.setCollaborative(rs.getBoolean("is_collaborative"));
        memory.setGroupKeyId(rs.getString("group_key_id"));

        return memory;
    }

    /**
     * Close database resources
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

    // ============================================
    // COLLABORATIVE MEMORY METHODS
    // ============================================

    /**
     * Set a memory as collaborative and assign a group key
     */
    public boolean setCollaborative(int memoryId, String groupKeyId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE memory SET is_collaborative = TRUE, group_key_id = ? WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, groupKeyId);
            stmt.setInt(2, memoryId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    // ============================================
    // VAULT METHODS
    // ============================================

    /**
     * Get all vault memories for a user
     */
    public List<Memory> getVaultMemoriesByUserId(int userId) throws SQLException {
        List<Memory> memories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id, title, description, updated_at, user_id, " +
                    "cover_media_id, created_timestamp, is_public, share_key, expires_at, is_link_shared, " +
                    "is_collaborative, group_key_id " +
                    "FROM memory WHERE user_id = ? AND is_in_vault = TRUE " +
                    "ORDER BY created_timestamp DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                memories.add(mapResultSetToMemory(rs));
            }

            return memories;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Move a memory to the vault
     */
    public boolean moveToVault(int memoryId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE memory SET is_in_vault = TRUE WHERE memory_id = ? AND user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, userId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Remove a memory from the vault (restore to regular view)
     */
    public boolean removeFromVault(int memoryId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE memory SET is_in_vault = FALSE WHERE memory_id = ? AND user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, userId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Check if a memory is in the vault
     */
    public boolean isMemoryInVault(int memoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT is_in_vault FROM memory WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getBoolean("is_in_vault");
            }

            return false;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }
}