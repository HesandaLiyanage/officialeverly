package com.demo.web.dao;

import com.demo.web.model.Group;
import com.demo.web.model.GroupMember;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GroupDAO {
    private Connection connection;
    private GroupMemberDAO groupMemberDAO;

    public GroupDAO(Connection connection) {
        this.connection = connection;
        this.groupMemberDAO = new GroupMemberDAO(connection);
    }

    // Create a new group
    public boolean addGroup(Group group) throws SQLException {
        String sql = "INSERT INTO group (group_id, name, creator_id) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, group.getGroupId());
            stmt.setString(2, group.getName());
            stmt.setInt(3, group.getCreatorId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Read (get a group by id, including members)
    public Group getGroupById(int groupId) throws SQLException {
        String sql = "SELECT * FROM group WHERE group_id = ?";
        Group group = null;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                group = new Group();
                group.setGroupId(rs.getInt("group_id"));
                group.setName(rs.getString("name"));
                group.setCreatorId(rs.getInt("creator_id"));

                // fetch members
                List<GroupMember> members = groupMemberDAO.getMembersByGroupId(groupId);
                group.setMembers(members);
            }
        }
        return group;
    }

    // Update group details
    public boolean updateGroup(Group group) throws SQLException {
        String sql = "UPDATE group SET name = ?, creator_id = ? WHERE group_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, group.getName());
            stmt.setInt(2, group.getCreatorId());
            stmt.setInt(3, group.getGroupId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Delete group (also optionally delete members)
    public boolean deleteGroup(int groupId) throws SQLException {
        // first delete members
        List<GroupMember> members = groupMemberDAO.getMembersByGroupId(groupId);
        for (GroupMember gm : members) {
            groupMemberDAO.deleteGroupMember(groupId, gm.getUser().getId());
        }

        // then delete the group
        String sql = "DELETE FROM group WHERE group_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Get all groups (optional)
    public List<Group> getAllGroups() throws SQLException {
        List<Group> groups = new ArrayList<>();
        String sql = "SELECT * FROM group";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Group group = new Group();
                int groupId = rs.getInt("group_id");
                group.setGroupId(groupId);
                group.setName(rs.getString("name"));
                group.setCreatorId(rs.getInt("creator_id"));

                List<GroupMember> members = groupMemberDAO.getMembersByGroupId(groupId);
                group.setMembers(members);

                groups.add(group);
            }
        }
        return groups;
    }
}
