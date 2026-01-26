package com.demo.web.dao;

import com.demo.web.model.GroupAnnouncement;
import com.demo.web.model.user;
import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GroupAnnouncementDAO {

    public boolean createAnnouncement(GroupAnnouncement announcement) {
        String sql = "INSERT INTO group_announcement (group_id, user_id, title, content, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, announcement.getGroupId());
            stmt.setInt(2, announcement.getUserId());
            stmt.setString(3, announcement.getTitle());
            stmt.setString(4, announcement.getContent());
            stmt.setTimestamp(5, announcement.getCreatedAt() != null ? announcement.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR GroupAnnouncementDAO] createAnnouncement: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<GroupAnnouncement> findByGroupId(int groupId) {
        String sql = "SELECT ga.*, u.username, u.profile_picture_url " +
                     "FROM group_announcement ga " +
                     "JOIN users u ON ga.user_id = u.user_id " +
                     "WHERE ga.group_id = ? " +
                     "ORDER BY ga.created_at DESC";
        List<GroupAnnouncement> announcements = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                announcements.add(mapResultSetToAnnouncement(rs));
            }
        } catch (SQLException e) {
            System.err.println("[ERROR GroupAnnouncementDAO] findByGroupId: " + e.getMessage());
            e.printStackTrace();
        }
        return announcements;
    }

    public GroupAnnouncement findById(int announcementId) {
        String sql = "SELECT ga.*, u.username, u.profile_picture_url " +
                     "FROM group_announcement ga " +
                     "JOIN users u ON ga.user_id = u.user_id " +
                     "WHERE ga.announcement_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, announcementId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAnnouncement(rs);
            }
        } catch (SQLException e) {
            System.err.println("[ERROR GroupAnnouncementDAO] findById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private GroupAnnouncement mapResultSetToAnnouncement(ResultSet rs) throws SQLException {
        GroupAnnouncement ga = new GroupAnnouncement();
        ga.setAnnouncementId(rs.getInt("announcement_id"));
        ga.setGroupId(rs.getInt("group_id"));
        ga.setUserId(rs.getInt("user_id"));
        ga.setTitle(rs.getString("title"));
        ga.setContent(rs.getString("content"));
        ga.setCreatedAt(rs.getTimestamp("created_at"));

        // Map user data
        user u = new user();
        u.setId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setProfilePictureUrl(rs.getString("profile_picture_url"));
        ga.setPostedBy(u);

        return ga;
    }
}
