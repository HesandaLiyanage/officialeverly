package com.demo.web.dao;

import com.demo.web.model.GroupMember;
import com.demo.web.model.user;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GroupMemberDAO {
    private Connection connection;

    public GroupMemberDAO(Connection connection) {
        this.connection = connection;
    }

    // Create (Add a member to a group)
    public boolean addGroupMember(GroupMember gm) throws SQLException {
        String sql = "INSERT INTO group_member (group_id, member_id, role, joined_at, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, gm.getGroupId());
            stmt.setInt(2, gm.getUser().getId());
            stmt.setString(3, gm.getRole());
            stmt.setTimestamp(4, gm.getJoinedAt());
            stmt.setString(5, gm.getStatus());
            return stmt.executeUpdate() > 0;
        }
    }

    // Read (Get all members of a group)
    public List<GroupMember> getMembersByGroupId(int groupId) throws SQLException {
        List<GroupMember> members = new ArrayList<>();
        String sql = "SELECT gm.group_id, gm.role, gm.joined_at, gm.status, u.user_id, u.username, u.email " +
                "FROM group_member gm " +
                "JOIN user u ON gm.member_id = u.user_id " +
                "WHERE gm.group_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                user u = new user();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));

                GroupMember gm = new GroupMember();
                gm.setGroupId(rs.getInt("group_id"));
                gm.setUser(u);
                gm.setRole(rs.getString("role"));
                gm.setJoinedAt(rs.getTimestamp("joined_at"));
                gm.setStatus(rs.getString("status"));

                members.add(gm);
            }
        }
        return members;
    }

    // Update membership details (role, status)
    public boolean updateGroupMember(GroupMember gm) throws SQLException {
        String sql = "UPDATE group_member SET role = ?, joined_at = ?, status = ? WHERE group_id = ? AND member_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, gm.getRole());
            stmt.setTimestamp(2, gm.getJoinedAt());
            stmt.setString(3, gm.getStatus());
            stmt.setInt(4, gm.getGroupId());
            stmt.setInt(5, gm.getUser().getId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Delete (remove member from group)
    public boolean deleteGroupMember(int groupId, int memberId) throws SQLException {
        String sql = "DELETE FROM group_member WHERE group_id = ? AND member_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            stmt.setInt(2, memberId);
            return stmt.executeUpdate() > 0;
        }
    }
}
