package com.demo.web.dao;

import com.demo.web.model.GroupMember;
import com.demo.web.model.user;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class GroupMemberDAO {
    private static final Logger logger = Logger.getLogger(GroupMemberDAO.class.getName());

    // Default constructor using DatabaseUtil
    public GroupMemberDAO() {
    }

    // Legacy constructor for backward compatibility
    private Connection legacyConnection;
    public GroupMemberDAO(Connection connection) {
        this.legacyConnection = connection;
    }

    private Connection getConnection() throws SQLException {
        if (legacyConnection != null) {
            return legacyConnection;
        }
        return DatabaseUtil.getConnection();
    }

    // Create (Add a member to a group)
    public boolean addGroupMember(GroupMember gm) {
        String sql = "INSERT INTO group_member (group_id, user_id, role, joined_at, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, gm.getGroupId());
            stmt.setInt(2, gm.getUser().getId());
            stmt.setString(3, gm.getRole());
            stmt.setTimestamp(4, gm.getJoinedAt() != null ? gm.getJoinedAt() : new Timestamp(System.currentTimeMillis()));
            stmt.setString(5, gm.getStatus() != null ? gm.getStatus() : "active");
            int rows = stmt.executeUpdate();
            System.out.println("[DEBUG GroupMemberDAO] addGroupMember: Added " + rows + " member(s) to group " + gm.getGroupId());
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupMemberDAO] Error adding group member: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Check if user is already a member of the group
    public boolean isUserMember(int groupId, int userId) {
        String sql = "SELECT COUNT(*) as cnt FROM group_member WHERE group_id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                boolean isMember = rs.getInt("cnt") > 0;
                System.out.println("[DEBUG GroupMemberDAO] isUserMember: User " + userId + " in group " + groupId + " = " + isMember);
                return isMember;
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupMemberDAO] Error checking membership: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Read (Get all members of a group)
    public List<GroupMember> getMembersByGroupId(int groupId) {
        List<GroupMember> members = new ArrayList<>();
        String sql = "SELECT gm.group_id, gm.role, gm.joined_at, gm.status, u.user_id, u.username, u.email, u.profile_picture_url " +
                "FROM group_member gm " +
                "JOIN users u ON gm.user_id = u.user_id " +
                "WHERE gm.group_id = ? " +
                "ORDER BY CASE WHEN gm.role = 'admin' THEN 0 ELSE 1 END, gm.joined_at";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                user u = new user();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setProfilePictureUrl(rs.getString("profile_picture_url"));

                GroupMember gm = new GroupMember();
                gm.setGroupId(rs.getInt("group_id"));
                gm.setUser(u);
                gm.setRole(rs.getString("role"));
                gm.setJoinedAt(rs.getTimestamp("joined_at"));
                gm.setStatus(rs.getString("status"));

                members.add(gm);
            }
            System.out.println("[DEBUG GroupMemberDAO] getMembersByGroupId: Found " + members.size() + " members for group " + groupId);
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupMemberDAO] Error getting members: " + e.getMessage());
            e.printStackTrace();
        }
        return members;
    }

    // Update membership details (role, status)
    public boolean updateGroupMember(GroupMember gm) {
        String sql = "UPDATE group_member SET role = ?, joined_at = ?, status = ? WHERE group_id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, gm.getRole());
            stmt.setTimestamp(2, gm.getJoinedAt());
            stmt.setString(3, gm.getStatus());
            stmt.setInt(4, gm.getGroupId());
            stmt.setInt(5, gm.getUser().getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupMemberDAO] Error updating member: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Delete (remove member from group)
    public boolean deleteGroupMember(int groupId, int userId) {
        String sql = "DELETE FROM group_member WHERE group_id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupMemberDAO] Error deleting member: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
