package com.demo.web.dao;

import com.demo.web.model.Group;
import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GroupDAO {

    public GroupDAO() {
    }

    /**
     * Create a new group
     */
    public boolean createGroup(Group group) {
        // ✅ Use unquoted table name (unless you explicitly created it with quotes)
        String sql = "INSERT INTO \"group\" (g_name, g_description, created_at, user_id, group_pic, group_url) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, group.getName());
            stmt.setString(2, group.getDescription());
            stmt.setTimestamp(3, group.getCreatedAt() != null ? group.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            stmt.setInt(4, group.getUserId());
            stmt.setString(5, group.getGroupPicUrl());
            stmt.setString(6, group.getGroupUrl());
            int rowsInserted = stmt.executeUpdate();
            System.out.println("[DEBUG GroupDAO] createGroup affected " + rowsInserted + " rows.");
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error while creating group: " + e.getMessage());
            e.printStackTrace();
            return false; // Avoid throwing exception in DAO; let controller handle
        }
    }

    /**
     * Get group by ID
     */
    public Group findById(int groupId) {
        String sql = "SELECT group_id, g_name, g_description, created_at, user_id, group_pic, group_url FROM \"group\" WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Group result = mapResultSetToGroup(rs);
                System.out.println("[DEBUG GroupDAO] findById(" + groupId + ") returned: " + result);
                return result;
            }
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error fetching group by ID " + groupId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all groups created by a user (owned only)
     */
    public List<Group> findByUserId(int userId) {
        String sql = "SELECT group_id, g_name, g_description, created_at, user_id, group_pic, group_url FROM \"group\" WHERE user_id = ?";
        List<Group> groups = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                groups.add(mapResultSetToGroup(rs));
            }
            System.out.println("[DEBUG GroupDAO] findByUserId(" + userId + ") returned " + groups.size() + " records.");
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error fetching groups by user ID " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return groups;
    }

    // ✅ NEW METHOD: Get ALL groups user is part of (owned OR joined)
    public List<Group> findGroupsByMemberId(int userId) {
        String sql = """
            SELECT DISTINCT g.group_id, g.g_name, g.g_description, g.created_at, 
                   g.user_id, g.group_pic, g.group_url
            FROM "group" g
            LEFT JOIN group_member gm ON g.group_id = gm.group_id
            WHERE g.user_id = ? OR gm.member_id = ?
            ORDER BY g.created_at DESC
            """;

        List<Group> groups = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                groups.add(mapResultSetToGroup(rs));
            }
            System.out.println("[DEBUG GroupDAO] findGroupsByMemberId(" + userId + ") returned " + groups.size() + " groups.");
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error fetching groups for member ID " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return groups;
    }

    /**
     * Get group by URL
     */
    public Group findByUrl(String groupUrl) {
        String sql = "SELECT group_id, g_name, g_description, created_at, user_id, group_pic, group_url FROM \"group\" WHERE group_url = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, groupUrl);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToGroup(rs);
            }
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error fetching group by URL '" + groupUrl + "': " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Check if group URL already exists
     */
    public boolean isUrlTaken(String groupUrl) {
        String sql = "SELECT COUNT(*) as url_count FROM \"group\" WHERE group_url = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, groupUrl);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("url_count") > 0;
            }
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error checking URL '" + groupUrl + "': " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get member count for a specific group
     */
    public int getMemberCount(int groupId) {
        String sql = "SELECT COUNT(*) as member_count FROM group_member WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("member_count");
            }
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error getting member count for group " + groupId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Update an existing group
     */
    public boolean updateGroup(Group group) {
        String sql = "UPDATE \"group\" SET g_name = ?, g_description = ?, group_pic = ?, group_url = ? WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, group.getName());
            stmt.setString(2, group.getDescription());
            stmt.setString(3, group.getGroupPicUrl());
            stmt.setString(4, group.getGroupUrl());
            stmt.setInt(5, group.getGroupId());
            int rowsUpdated = stmt.executeUpdate();
            System.out.println("[DEBUG GroupDAO] updateGroup affected " + rowsUpdated + " rows.");
            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error updating group " + group.getGroupId() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete group by ID
     */
    public boolean deleteGroup(int groupId) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);

            // Delete members first
            try (PreparedStatement stmt1 = conn.prepareStatement("DELETE FROM group_member WHERE group_id = ?")) {
                stmt1.setInt(1, groupId);
                stmt1.executeUpdate();
            }

            // Delete group
            try (PreparedStatement stmt2 = conn.prepareStatement("DELETE FROM \"group\" WHERE group_id = ?")) {
                stmt2.setInt(1, groupId);
                int rows = stmt2.executeUpdate();
                conn.commit();
                return rows > 0;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            System.err.println("[ERROR GroupDAO] Error deleting group " + groupId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Map ResultSet to Group object
     */
    private Group mapResultSetToGroup(ResultSet rs) throws SQLException {
        Group group = new Group();
        group.setGroupId(rs.getInt("group_id"));
        group.setName(rs.getString("g_name"));
        group.setDescription(rs.getString("g_description"));
        group.setCreatedAt(rs.getTimestamp("created_at"));
        group.setUserId(rs.getInt("user_id"));
        group.setGroupPicUrl(rs.getString("group_pic"));
        group.setGroupUrl(rs.getString("group_url"));
        return group;
    }
}