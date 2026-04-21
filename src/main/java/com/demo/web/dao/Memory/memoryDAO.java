package com.demo.web.dao.Memory;

import com.demo.web.dao.Journals.RecycleBinDAO;
import com.demo.web.model.Journals.RecycleBinItem;
import com.demo.web.model.Memory.Memory;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class memoryDAO {

    public int createMemory(Memory memory) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory (title, description, user_id, updated_at, is_public, group_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?) RETURNING memory_id";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memory.getTitle());
            stmt.setString(2, memory.getDescription());
            stmt.setInt(3, memory.getUserId());
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            stmt.setBoolean(5, memory.isPublic());
            if (memory.getGroupId() != null) {
                stmt.setInt(6, memory.getGroupId());
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }

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

    public boolean unlinkMediaFromMemory(int memoryId, int mediaId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM memory_media WHERE memory_id = ? AND media_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, mediaId);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public Memory getMemoryById(int memoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id, title, description, updated_at, user_id, " +
                    "cover_media_id, created_timestamp, is_public, share_key, expires_at, is_link_shared, nic " +
                    "is_collaborative, collab_share_key, group_id, is_in_vault " +
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

    public List<Memory> getMemoriesByUserId(int userId) throws SQLException {
        List<Memory> memories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id, title, description, updated_at, user_id, " +
                    "cover_media_id, created_timestamp, is_public, share_key, expires_at, is_link_shared, " +
                    "is_collaborative, collab_share_key, group_id " +
                    "FROM memory WHERE user_id = ? AND (is_in_vault = FALSE OR is_in_vault IS NULL) " +
                    "AND (is_collaborative = FALSE OR is_collaborative IS NULL) " +
                    "AND (group_id IS NULL) " +
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

    public List<Memory> getMemoriesByGroupId(int groupId) throws SQLException {
        List<Memory> memories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id, title, description, updated_at, user_id, " +
                    "cover_media_id, created_timestamp, is_public, share_key, expires_at, is_link_shared, " +
                    "is_collaborative, collab_share_key, group_id " +
                    "FROM memory WHERE group_id = ? " +
                    "ORDER BY created_timestamp DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, groupId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                memories.add(mapResultSetToMemory(rs));
            }

            return memories;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

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

    public boolean deleteMemory(int memoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            String sql = "DELETE FROM memory WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public boolean deleteMemoryToRecycleBin(int memoryId, int userId) throws SQLException {
        Memory memory = getMemoryById(memoryId);
        if (memory == null) {
            return false;
        }

        RecycleBinItem item = new RecycleBinItem();
        item.setOriginalId(memory.getMemoryId());
        item.setUserId(userId);
        item.setTitle(memory.getTitle());
        item.setContent(memory.getDescription());
        item.setMetadata(buildRecycleMetadata(memory));

        RecycleBinDAO recycleBinDAO = new RecycleBinDAO();
        int recycleId = recycleBinDAO.saveMemoryToRecycleBin(item);
        if (recycleId <= 0) {
            return false;
        }

        return deleteMemory(memoryId);
    }

    public boolean restoreMemoryFromRecycleBin(int recycleBinId, int userId) throws SQLException {
        RecycleBinDAO recycleBinDAO = new RecycleBinDAO();
        RecycleBinItem item = recycleBinDAO.findById(recycleBinId);
        if (item == null || !"memory".equals(item.getItemType()) || item.getUserId() != userId) {
            return false;
        }

        Memory memory = new Memory();
        memory.setTitle(item.getTitle());
        memory.setDescription(item.getContent());
        memory.setUserId(userId);
        memory.setPublic(parseBooleanMetadata(item.getMetadata(), "isPublic"));
        memory.setGroupId(parseIntegerMetadata(item.getMetadata(), "groupId"));

        boolean restored = createMemory(memory) > 0;
        if (restored) {
            recycleBinDAO.deleteFromRecycleBin(recycleBinId);
            return true;
        }

        return false;
    }

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

        try {
            memory.setCollaborative(rs.getBoolean("is_collaborative"));
            memory.setCollabShareKey(rs.getString("collab_share_key"));
        } catch (SQLException e) {
        }

        try {
            int gid = rs.getInt("group_id");
            if (!rs.wasNull()) {
                memory.setGroupId(gid);
            }
        } catch (SQLException e) {
        }

        try {
            memory.setInVault(rs.getBoolean("is_in_vault"));
        } catch (SQLException e) {
        }

        return memory;
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

    private String buildRecycleMetadata(Memory memory) {
        StringBuilder metadata = new StringBuilder("{");
        metadata.append("\"groupId\":");
        if (memory.getGroupId() != null) {
            metadata.append(memory.getGroupId());
        } else {
            metadata.append("null");
        }
        metadata.append(",\"isPublic\":").append(memory.isPublic()).append("}");
        return metadata.toString();
    }

    private Integer parseIntegerMetadata(String metadata, String key) {
        String rawValue = extractMetadataValue(metadata, key);
        if (rawValue == null || "null".equals(rawValue)) {
            return null;
        }

        try {
            return Integer.parseInt(rawValue);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private boolean parseBooleanMetadata(String metadata, String key) {
        return Boolean.parseBoolean(extractMetadataValue(metadata, key));
    }

    private String extractMetadataValue(String metadata, String key) {
        if (metadata == null) {
            return null;
        }

        String marker = "\"" + key + "\":";
        int start = metadata.indexOf(marker);
        if (start == -1) {
            return null;
        }

        start += marker.length();
        int end = metadata.indexOf(",", start);
        if (end == -1) {
            end = metadata.indexOf("}", start);
        }
        if (end == -1) {
            return null;
        }

        return metadata.substring(start, end).trim().replace("\"", "");
    }


    public List<Memory> getVaultMemoriesByUserId(int userId) throws SQLException {
        List<Memory> memories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id, title, description, updated_at, user_id, " +
                    "cover_media_id, created_timestamp, is_public, share_key, expires_at, is_link_shared " +
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


    public List<Memory> getCollabMemoriesByUserId(int userId) throws SQLException {
        List<Memory> memories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT DISTINCT m.memory_id, m.title, m.description, m.updated_at, m.user_id, " +
                    "m.cover_media_id, m.created_timestamp, m.is_public, m.share_key, m.expires_at, " +
                    "m.is_link_shared, m.is_collaborative, m.collab_share_key " +
                    "FROM memory m " +
                    "JOIN memory_members mm ON m.memory_id = mm.memory_id " +
                    "WHERE mm.user_id = ? AND m.is_collaborative = TRUE " +
                    "AND (m.is_in_vault = FALSE OR m.is_in_vault IS NULL) " +
                    "ORDER BY m.created_timestamp DESC";

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

    public Memory getMemoryByShareKey(String shareKey) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id, title, description, updated_at, user_id, " +
                    "cover_media_id, created_timestamp, is_public, share_key, expires_at, " +
                    "is_link_shared, is_collaborative, collab_share_key " +
                    "FROM memory WHERE collab_share_key = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, shareKey);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToMemory(rs);
            }

            return null;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public boolean setCollabShareKey(int memoryId, String shareKey) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE memory SET collab_share_key = ? WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, shareKey);
            stmt.setInt(2, memoryId);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    public int createCollabMemory(Memory memory) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory (title, description, user_id, updated_at, is_public, is_collaborative) " +
                    "VALUES (?, ?, ?, ?, ?, TRUE) RETURNING memory_id";

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

            throw new SQLException("Failed to create collab memory, no ID obtained");

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    public List<Memory> getSharedMemoriesByOwner(int userId) {
        List<Memory> memories = new ArrayList<>();
        String sql = "SELECT * FROM memory WHERE user_id = ? AND collab_share_key IS NOT NULL AND (is_in_vault = FALSE OR is_in_vault IS NULL)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    memories.add(mapResultSetToMemory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return memories;
    }
}
