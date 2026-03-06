package com.demo.web.dao.Memory;

import com.demo.web.model.Memory;
import com.demo.web.model.Event;
import com.demo.web.model.Group;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for Memory Recap feature.
 * Provides random memories grouped by time, event, and group.
 */
public class MemoryRecapDAO {

    // ============================================
    // BY TIME - Random memories from different time periods
    // ============================================

    /**
     * Get random memories from the past week for a user
     */
    public List<Memory> getLastWeekMemories(int userId, int limit) {
        return getMemoriesByTimeRange(userId, "NOW() - INTERVAL '7 days'", "NOW()", limit);
    }

    /**
     * Get random memories from the past month for a user
     */
    public List<Memory> getLastMonthMemories(int userId, int limit) {
        return getMemoriesByTimeRange(userId, "NOW() - INTERVAL '1 month'", "NOW()", limit);
    }

    /**
     * Get random memories from exactly 1 year ago (within a 2-week window)
     */
    public List<Memory> getOneYearAgoMemories(int userId, int limit) {
        return getMemoriesByTimeRange(userId,
                "NOW() - INTERVAL '1 year' - INTERVAL '7 days'",
                "NOW() - INTERVAL '1 year' + INTERVAL '7 days'",
                limit);
    }

    /**
     * Get random memories from a specific month (any year)
     */
    public List<Memory> getMemoriesFromMonth(int userId, int month, int limit) {
        List<Memory> memories = new ArrayList<>();
        String sql = "SELECT m.memory_id, m.title, m.description, m.updated_at, m.user_id, " +
                "m.cover_media_id, m.created_timestamp, m.is_public, m.share_key, m.expires_at, " +
                "m.is_link_shared, m.is_collaborative, m.collab_share_key, m.group_id " +
                "FROM memory m " +
                "WHERE m.user_id = ? " +
                "AND EXTRACT(MONTH FROM m.created_timestamp) = ? " +
                "AND (m.is_in_vault = FALSE OR m.is_in_vault IS NULL) " +
                "ORDER BY RANDOM() LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, month);
            stmt.setInt(3, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                memories.add(mapResultSetToMemory(rs));
            }
        } catch (SQLException e) {
            System.err.println("[MemoryRecapDAO] Error getMemoriesFromMonth: " + e.getMessage());
            e.printStackTrace();
        }
        return memories;
    }

    /**
     * Generic time range query with random ordering
     */
    private List<Memory> getMemoriesByTimeRange(int userId, String fromExpr, String toExpr, int limit) {
        List<Memory> memories = new ArrayList<>();
        String sql = "SELECT m.memory_id, m.title, m.description, m.updated_at, m.user_id, " +
                "m.cover_media_id, m.created_timestamp, m.is_public, m.share_key, m.expires_at, " +
                "m.is_link_shared, m.is_collaborative, m.collab_share_key, m.group_id " +
                "FROM memory m " +
                "WHERE m.user_id = ? " +
                "AND m.created_timestamp >= " + fromExpr + " " +
                "AND m.created_timestamp <= " + toExpr + " " +
                "AND (m.is_in_vault = FALSE OR m.is_in_vault IS NULL) " +
                "ORDER BY RANDOM() LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                memories.add(mapResultSetToMemory(rs));
            }
        } catch (SQLException e) {
            System.err.println("[MemoryRecapDAO] Error getMemoriesByTimeRange: " + e.getMessage());
            e.printStackTrace();
        }
        return memories;
    }

    /**
     * Get all time-based recap bundles as a list of maps.
     * Each map has: label, subtitle, emoji, memories list, media count
     */
    public List<Map<String, Object>> getTimeRecaps(int userId, int memoriesPerBundle) {
        List<Map<String, Object>> recaps = new ArrayList<>();

        // Last Week
        List<Memory> lastWeek = getLastWeekMemories(userId, memoriesPerBundle);
        if (!lastWeek.isEmpty()) {
            Map<String, Object> recap = new HashMap<>();
            recap.put("label", "Last Week");
            recap.put("subtitle", "Remember what happened last week?");
            recap.put("emoji", "📅");
            recap.put("memories", lastWeek);
            recap.put("memoryCount", lastWeek.size());
            recaps.add(recap);
        }

        // Last Month
        List<Memory> lastMonth = getLastMonthMemories(userId, memoriesPerBundle);
        if (!lastMonth.isEmpty()) {
            Map<String, Object> recap = new HashMap<>();
            recap.put("label", "This Month");
            recap.put("subtitle", "Your month so far has been amazing!");
            recap.put("emoji", "🗓️");
            recap.put("memories", lastMonth);
            recap.put("memoryCount", lastMonth.size());
            recaps.add(recap);
        }

        // 1 Year Ago
        List<Memory> yearAgo = getOneYearAgoMemories(userId, memoriesPerBundle);
        if (!yearAgo.isEmpty()) {
            Map<String, Object> recap = new HashMap<>();
            recap.put("label", "1 Year Ago");
            recap.put("subtitle", "Look back at this time last year!");
            recap.put("emoji", "⏳");
            recap.put("memories", yearAgo);
            recap.put("memoryCount", yearAgo.size());
            recaps.add(recap);
        }

        return recaps;
    }

    // ============================================
    // BY EVENT - Random memories linked to events
    // ============================================

    /**
     * Get events the user has been part of (through groups they own or are members
     * of),
     * along with random memories from those event's groups.
     */
    public List<Map<String, Object>> getEventRecaps(int userId, int maxEvents, int memoriesPerEvent) {
        List<Map<String, Object>> recaps = new ArrayList<>();

        // Get random events from groups the user is part of
        String sql = "SELECT DISTINCT e.event_id, e.e_title, e.e_description, e.e_date, " +
                "e.created_at, e.group_id, e.event_pic " +
                "FROM event e " +
                "INNER JOIN \"group\" g ON e.group_id = g.group_id " +
                "LEFT JOIN group_member gm ON g.group_id = gm.group_id " +
                "WHERE (g.user_id = ? OR gm.member_id = ?) " +
                "ORDER BY RANDOM() LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, maxEvents);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getInt("event_id"));
                event.setTitle(rs.getString("e_title"));
                event.setDescription(rs.getString("e_description"));
                event.setEventDate(rs.getTimestamp("e_date"));
                event.setCreatedAt(rs.getTimestamp("created_at"));
                event.setGroupId(rs.getInt("group_id"));
                event.setEventPicUrl(rs.getString("event_pic"));

                // Get random memories from this event's group
                List<Memory> eventMemories = getMemoriesByGroupId(event.getGroupId(), userId, memoriesPerEvent);

                Map<String, Object> recap = new HashMap<>();
                recap.put("label", "Remember " + event.getTitle());
                recap.put("subtitle", event.getDescription() != null ? event.getDescription() : "A special event!");
                recap.put("emoji", "🎉");
                recap.put("event", event);
                recap.put("memories", eventMemories);
                recap.put("memoryCount", eventMemories.size());
                recaps.add(recap);
            }
        } catch (SQLException e) {
            System.err.println("[MemoryRecapDAO] Error getEventRecaps: " + e.getMessage());
            e.printStackTrace();
        }

        return recaps;
    }

    // ============================================
    // BY GROUP - Random memories from groups user is in
    // ============================================

    /**
     * Get group-based recaps: random groups + random memories from each group
     */
    public List<Map<String, Object>> getGroupRecaps(int userId, int maxGroups, int memoriesPerGroup) {
        List<Map<String, Object>> recaps = new ArrayList<>();

        // Get random groups the user is part of (owned or joined)
        String sql = "SELECT g.group_id, g.g_name, g.g_description, g.created_at, " +
                "g.user_id, g.group_pic, g.group_url " +
                "FROM \"group\" g " +
                "LEFT JOIN group_member gm ON g.group_id = gm.group_id " +
                "WHERE g.user_id = ? OR gm.member_id = ? " +
                "GROUP BY g.group_id, g.g_name, g.g_description, g.created_at, g.user_id, g.group_pic, g.group_url " +
                "ORDER BY RANDOM() LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, maxGroups);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Group group = new Group();
                group.setGroupId(rs.getInt("group_id"));
                group.setName(rs.getString("g_name"));
                group.setDescription(rs.getString("g_description"));
                group.setCreatedAt(rs.getTimestamp("created_at"));
                group.setUserId(rs.getInt("user_id"));
                group.setGroupPicUrl(rs.getString("group_pic"));
                group.setGroupUrl(rs.getString("group_url"));

                // Get random memories from this group
                List<Memory> groupMemories = getMemoriesByGroupId(group.getGroupId(), userId, memoriesPerGroup);

                // Also include user's own memories that aren't in any group
                // (for the owner's personal memories perspective)
                if (groupMemories.isEmpty()) {
                    // If no memories exist in the group yet, skip this group recap
                    continue;
                }

                Map<String, Object> recap = new HashMap<>();
                recap.put("label", "Remember " + group.getName());
                recap.put("subtitle",
                        group.getDescription() != null ? group.getDescription() : "Memories with your group");
                recap.put("emoji", "👥");
                recap.put("group", group);
                recap.put("memories", groupMemories);
                recap.put("memoryCount", groupMemories.size());
                recaps.add(recap);
            }
        } catch (SQLException e) {
            System.err.println("[MemoryRecapDAO] Error getGroupRecaps: " + e.getMessage());
            e.printStackTrace();
        }

        return recaps;
    }

    // ============================================
    // HELPER: Get memories by group ID (random)
    // ============================================

    private List<Memory> getMemoriesByGroupId(int groupId, int userId, int limit) {
        List<Memory> memories = new ArrayList<>();
        String sql = "SELECT m.memory_id, m.title, m.description, m.updated_at, m.user_id, " +
                "m.cover_media_id, m.created_timestamp, m.is_public, m.share_key, m.expires_at, " +
                "m.is_link_shared, m.is_collaborative, m.collab_share_key, m.group_id " +
                "FROM memory m " +
                "WHERE m.group_id = ? " +
                "AND (m.is_in_vault = FALSE OR m.is_in_vault IS NULL) " +
                "ORDER BY RANDOM() LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                memories.add(mapResultSetToMemory(rs));
            }
        } catch (SQLException e) {
            System.err.println("[MemoryRecapDAO] Error getMemoriesByGroupId: " + e.getMessage());
            e.printStackTrace();
        }
        return memories;
    }

    // ============================================
    // STATS - Quick stats for the sidebar
    // ============================================

    /**
     * Get total memory count for a user
     */
    public int getTotalMemoryCount(int userId) {
        String sql = "SELECT COUNT(*) as cnt FROM memory WHERE user_id = ? " +
                "AND (is_in_vault = FALSE OR is_in_vault IS NULL)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getInt("cnt");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get total event count for user's groups
     */
    public int getTotalEventCount(int userId) {
        String sql = "SELECT COUNT(DISTINCT e.event_id) as cnt FROM event e " +
                "INNER JOIN \"group\" g ON e.group_id = g.group_id " +
                "LEFT JOIN group_member gm ON g.group_id = gm.group_id " +
                "WHERE g.user_id = ? OR gm.member_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getInt("cnt");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get total group count for a user
     */
    public int getTotalGroupCount(int userId) {
        String sql = "SELECT COUNT(DISTINCT g.group_id) as cnt FROM \"group\" g " +
                "LEFT JOIN group_member gm ON g.group_id = gm.group_id " +
                "WHERE g.user_id = ? OR gm.member_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getInt("cnt");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get the cover media URL for a memory (first media item)
     */
    public Integer getFirstMediaIdForMemory(int memoryId) {
        String sql = "SELECT media_id FROM memory_media WHERE memory_id = ? LIMIT 1";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, memoryId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getInt("media_id");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ============================================
    // Memory ResultSet Mapper (matches memoryDAO pattern)
    // ============================================

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
            // Columns may not exist
        }

        try {
            int gid = rs.getInt("group_id");
            if (!rs.wasNull()) {
                memory.setGroupId(gid);
            }
        } catch (SQLException e) {
            // Column may not exist
        }

        return memory;
    }
}
