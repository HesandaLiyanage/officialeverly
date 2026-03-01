package com.demo.web.dao;

import com.demo.web.model.Plan;
import com.demo.web.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class SubscriptionDAO {

    public Plan getPlanByUserId(int userId) {
        String sql = "SELECT p.* FROM plans p JOIN users u ON u.plan_id = p.plan_id WHERE u.user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToPlan(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Plan getPlanById(int planId) {
        String sql = "SELECT * FROM plans WHERE plan_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, planId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToPlan(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Plan getPlanByName(String name) {
        String sql = "SELECT * FROM plans WHERE name = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToPlan(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Plan> getAllPlans() {
        List<Plan> plans = new ArrayList<>();
        String sql = "SELECT * FROM plans ORDER BY price_monthly ASC";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                plans.add(mapRowToPlan(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return plans;
    }

    public boolean updateUserPlan(int userId, int newPlanId) {
        String sql = "UPDATE users SET plan_id = ? WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newPlanId);
            stmt.setInt(2, userId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public long getUsedStorage(int userId) {
        String sql = "SELECT SUM(file_size) FROM media_items WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // default to 0 if no media or error
    }

    public int getMemoryCount(int userId) {
        String sql = "SELECT COUNT(*) FROM memory WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get storage used per memory (top N largest memories)
     */
    public List<Map<String, Object>> getStorageByMemory(int userId, int limit) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = """
                SELECT m.memory_id, m.title, COALESCE(SUM(mi.file_size), 0) AS total_size,
                       COUNT(mi.media_id) AS file_count
                FROM memory m
                LEFT JOIN memory_media mm ON mm.memory_id = m.memory_id
                LEFT JOIN media_items mi ON mi.media_id = mm.media_id
                WHERE m.user_id = ?
                GROUP BY m.memory_id, m.title
                ORDER BY total_size DESC
                LIMIT ?
                """;
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new java.util.LinkedHashMap<>();
                    row.put("id", rs.getInt("memory_id"));
                    row.put("title", rs.getString("title"));
                    row.put("totalSize", rs.getLong("total_size"));
                    row.put("fileCount", rs.getInt("file_count"));
                    result.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Get storage used per group (aggregated from group memories)
     */
    public List<Map<String, Object>> getStorageByGroup(int userId, int limit) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = """
                SELECT g.group_id, g.name, COALESCE(SUM(mi.file_size), 0) AS total_size,
                       COUNT(DISTINCT m.memory_id) AS memory_count
                FROM "group" g
                JOIN group_member gm ON gm.group_id = g.group_id
                LEFT JOIN memory m ON m.group_id = g.group_id
                LEFT JOIN memory_media mm ON mm.memory_id = m.memory_id
                LEFT JOIN media_items mi ON mi.media_id = mm.media_id
                WHERE gm.user_id = ?
                GROUP BY g.group_id, g.name
                ORDER BY total_size DESC
                LIMIT ?
                """;
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new java.util.LinkedHashMap<>();
                    row.put("id", rs.getInt("group_id"));
                    row.put("name", rs.getString("name"));
                    row.put("totalSize", rs.getLong("total_size"));
                    row.put("memoryCount", rs.getInt("memory_count"));
                    result.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Get potential duplicate files (same file_size + mime_type, multiple uploads)
     */
    public List<Map<String, Object>> getDuplicateFiles(int userId) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = """
                SELECT mi.file_size, mi.mime_type, mi.title, mi.media_id,
                       mi.upload_timestamp, m.title AS memory_title, m.memory_id
                FROM media_items mi
                LEFT JOIN memory_media mm ON mm.media_id = mi.media_id
                LEFT JOIN memory m ON m.memory_id = mm.memory_id
                WHERE mi.user_id = ?
                  AND mi.file_size IN (
                    SELECT file_size FROM media_items
                    WHERE user_id = ? AND file_size > 0
                    GROUP BY file_size, mime_type
                    HAVING COUNT(*) > 1
                  )
                ORDER BY mi.file_size DESC, mi.upload_timestamp ASC
                """;
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new java.util.LinkedHashMap<>();
                    row.put("mediaId", rs.getInt("media_id"));
                    row.put("fileSize", rs.getLong("file_size"));
                    row.put("mimeType", rs.getString("mime_type"));
                    row.put("title", rs.getString("title"));
                    row.put("memoryTitle", rs.getString("memory_title"));
                    row.put("memoryId", rs.getInt("memory_id"));
                    row.put("uploadDate", rs.getTimestamp("upload_timestamp"));
                    result.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Get storage breakdown by content type (image, video, audio, etc.)
     */
    public Map<String, Long> getStorageByContentType(int userId) {
        Map<String, Long> result = new java.util.LinkedHashMap<>();
        result.put("image", 0L);
        result.put("video", 0L);
        result.put("audio", 0L);
        result.put("other", 0L);
        String sql = """
                SELECT media_type, COALESCE(SUM(file_size), 0) AS total_size
                FROM media_items
                WHERE user_id = ?
                GROUP BY media_type
                """;
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String type = rs.getString("media_type");
                    long size = rs.getLong("total_size");
                    if (type == null)
                        type = "other";
                    type = type.toLowerCase();
                    if (type.contains("image") || type.contains("photo")) {
                        result.put("image", result.get("image") + size);
                    } else if (type.contains("video")) {
                        result.put("video", result.get("video") + size);
                    } else if (type.contains("audio") || type.contains("voice")) {
                        result.put("audio", result.get("audio") + size);
                    } else {
                        result.put("other", result.get("other") + size);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Get count of items in trash for this user
     */
    public int getTrashItemCount(int userId) {
        String sql = "SELECT COUNT(*) FROM recycle_bin WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Plan mapRowToPlan(ResultSet rs) throws SQLException {
        int memoryLimit = -1;
        try {
            memoryLimit = rs.getInt("memory_limit");
        } catch (SQLException e) {
            // column might not exist if migration failed or driver issue
        }

        return new Plan(
                rs.getInt("plan_id"),
                rs.getString("name"),
                rs.getLong("storage_limit_bytes"),
                rs.getDouble("price_monthly"),
                rs.getDouble("price_annual"),
                rs.getInt("max_members"),
                rs.getString("description"),
                memoryLimit);
    }
}
