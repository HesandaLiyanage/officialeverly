package com.demo.web.dao;

import com.demo.web.model.Group;
import com.demo.web.model.GroupMember; // Assuming GroupMember model exists
import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class GroupDAO {
    private static final Logger logger = Logger.getLogger(GroupDAO.class.getName());
    // private GroupMemberDAO groupMemberDAO; // COMMENTED OUT TEMPORARILY

    public GroupDAO() {
        // this.groupMemberDAO = new GroupMemberDAO(); // COMMENTED OUT TEMPORARILY
    }

    /**
     * Create a new group
     */
    public boolean createGroup(Group group) {
        String sql = "INSERT INTO \"group\" (g_name, g_description, created_at, user_id, group_pic) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, group.getName());
            stmt.setString(2, group.getDescription());
            stmt.setTimestamp(3, group.getCreatedAt() != null ? group.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            stmt.setInt(4, group.getUserId());
            stmt.setString(5, group.getGroupPicUrl());
            int rowsInserted = stmt.executeUpdate();
            System.out.println("[DEBUG GroupDAO] createGroup affected " + rowsInserted + " rows.");
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupDAO] Error while creating group: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while creating group", e);
        }
    }

    /**
     * Get group by ID
     */
    public Group findById(int groupId) {
        String sql = "SELECT group_id, g_name, g_description, created_at, user_id, group_pic FROM \"group\" WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Group result = mapResultSetToGroup(rs);
                System.out.println("[DEBUG GroupDAO] findById(" + groupId + ") returned: " + result);
                return result;
            } else {
                System.out.println("[DEBUG GroupDAO] findById(" + groupId + ") returned null (record not found).");
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupDAO] Error while fetching group by ID " + groupId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching group by ID", e);
        }
        return null;
    }

    /**
     * Get all groups by a specific user
     */
    public List<Group> findByUserId(int userId) {
        String sql = "SELECT group_id, g_name, g_description, created_at, user_id, group_pic FROM \"group\" WHERE user_id = ?";
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
            System.out.println("[DEBUG GroupDAO] Error while fetching groups by user ID " + userId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching groups by user ID", e);
        }
        return groups;
    }

    /**
     * Get member count for a specific group
     * Note: Assumes 'group_member' table name is correct and not a reserved word needing quotes.
     * If 'group_member' is also a reserved word or needs quoting, change it to "\"group_member\"".
     */
    public int getMemberCount(int groupId) {
        String sql = "SELECT COUNT(*) as member_count FROM group_member WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("member_count");
                System.out.println("[DEBUG GroupDAO] getMemberCount(" + groupId + ") returned: " + count);
                return count;
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupDAO] Error while getting member count for group ID " + groupId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Update an existing group
     */
    public boolean updateGroup(Group group) {
        String sql = "UPDATE \"group\" SET g_name = ?, g_description = ?, group_pic = ? WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, group.getName());
            stmt.setString(2, group.getDescription());
            stmt.setString(3, group.getGroupPicUrl());
            stmt.setInt(4, group.getGroupId());
            System.out.println("[DEBUG GroupDAO] updateGroup preparing statement with values - Name: '" + group.getName() + "', Description: '" + group.getDescription() + "', Pic URL: '" + group.getGroupPicUrl() + "', ID: " + group.getGroupId());
            int rowsUpdated = stmt.executeUpdate();
            System.out.println("[DEBUG GroupDAO] updateGroup executed. Rows affected: " + rowsUpdated + " for ID: " + group.getGroupId());
            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupDAO] Error while updating group ID " + group.getGroupId() + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while updating group", e);
        }
    }

    /**
     * Delete group by ID
     */
    public boolean deleteGroup(int groupId) {
        // First delete all members directly without using GroupMemberDAO
        String deleteMembersSql = "DELETE FROM group_member WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteMembersSql)) {
            stmt.setInt(1, groupId);
            int membersDeleted = stmt.executeUpdate();
            System.out.println("[DEBUG GroupDAO] Deleted " + membersDeleted + " members for group ID: " + groupId);
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupDAO] Error deleting members for group ID " + groupId + ": " + e.getMessage());
        }

        // Then delete the group
        String sql = "DELETE FROM \"group\" WHERE group_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            int rowsDeleted = stmt.executeUpdate();
            System.out.println("[DEBUG GroupDAO] deleteGroup affected " + rowsDeleted + " rows for ID: " + groupId);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupDAO] Error while deleting group ID " + groupId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while deleting group", e);
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
        return group;
    }
}