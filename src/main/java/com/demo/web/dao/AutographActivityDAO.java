package com.demo.web.dao;

import com.demo.web.model.AutographActivity;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AutographActivityDAO {

    /**
     * Log a new activity when someone writes in an autograph book.
     */
    public boolean logActivity(int autographId, int writerUserId, String writerUsername) {
        String sql = "INSERT INTO autograph_activity (autograph_id, writer_user_id, writer_username, created_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            stmt.setInt(2, writerUserId);
            stmt.setString(3, writerUsername);
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            int rows = stmt.executeUpdate();
            System.out.println("[DEBUG AutographActivityDAO] logActivity affected " + rows + " rows.");
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG AutographActivityDAO] Error logging activity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get recent activities for autograph books owned by the given user.
     * Joins with the autograph table to get the book title and filter by owner.
     */
    public List<AutographActivity> getRecentActivitiesByOwner(int ownerUserId, int limit) {
        String sql = "SELECT aa.activity_id, aa.autograph_id, a.a_title, aa.writer_user_id, aa.writer_username, aa.created_at "
                + "FROM autograph_activity aa "
                + "JOIN autograph a ON aa.autograph_id = a.autograph_id "
                + "WHERE a.user_id = ? "
                + "ORDER BY aa.created_at DESC "
                + "LIMIT ?";
        List<AutographActivity> activities = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerUserId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                AutographActivity activity = new AutographActivity();
                activity.setActivityId(rs.getInt("activity_id"));
                activity.setAutographId(rs.getInt("autograph_id"));
                activity.setAutographTitle(rs.getString("a_title"));
                activity.setWriterUserId(rs.getInt("writer_user_id"));
                activity.setWriterUsername(rs.getString("writer_username"));
                activity.setCreatedAt(rs.getTimestamp("created_at"));
                activities.add(activity);
            }
            System.out.println("[DEBUG AutographActivityDAO] getRecentActivitiesByOwner(" + ownerUserId + ") returned "
                    + activities.size() + " records.");
        } catch (SQLException e) {
            System.out.println("[DEBUG AutographActivityDAO] Error fetching recent activities: " + e.getMessage());
            e.printStackTrace();
        }
        return activities;
    }
}
