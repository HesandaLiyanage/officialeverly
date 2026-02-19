package com.demo.web.dao;

import com.demo.web.model.AutographActivity;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AutographActivityDAO {

    /**
     * Log a new activity when someone writes in an autograph book.
     * Saves the full canvas state as JSONB in entry_data.
     */
    public boolean logActivity(int autographId, int writerUserId, String writerUsername,
            String signerName, String entryDataJson) {
        String sql = "INSERT INTO autograph_activity (autograph_id, user_id, action, created_at, signer_name, entry_data) "
                + "VALUES (?, ?, ?, CURRENT_DATE, ?, CAST(? AS jsonb))";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            stmt.setInt(2, writerUserId);
            stmt.setString(3, "wrote in");
            stmt.setString(4, signerName);
            stmt.setString(5, entryDataJson);
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
     * Joins with autograph table (for book title) and users table (for writer
     * username).
     */
    public List<AutographActivity> getRecentActivitiesByOwner(int ownerUserId, int limit) {
        String sql = "SELECT aa.activity_id, aa.autograph_id, a.a_title, aa.user_id, u.username, aa.action, aa.created_at "
                + "FROM autograph_activity aa "
                + "JOIN autograph a ON aa.autograph_id = a.autograph_id "
                + "JOIN users u ON aa.user_id = u.user_id "
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
                activity.setWriterUserId(rs.getInt("user_id"));
                activity.setWriterUsername(rs.getString("username"));
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

    /**
     * Get all entries with entry_data for a specific autograph book (for the
     * viewer).
     * Returns entry_data JSON, signer_name, date, and username.
     */
    public List<String[]> getEntriesByAutographId(int autographId) {
        String sql = "SELECT aa.entry_data, aa.signer_name, aa.created_at, u.username "
                + "FROM autograph_activity aa "
                + "LEFT JOIN users u ON aa.user_id = u.user_id "
                + "WHERE aa.autograph_id = ? AND aa.entry_data IS NOT NULL "
                + "ORDER BY aa.created_at ASC";
        List<String[]> entries = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String entryData = rs.getString("entry_data");
                String signerName = rs.getString("signer_name");
                String createdAt = rs.getString("created_at");
                String username = rs.getString("username");
                if (signerName == null)
                    signerName = username != null ? username : "Anonymous";
                if (createdAt == null)
                    createdAt = "";
                entries.add(new String[] { entryData, signerName, createdAt });
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG AutographActivityDAO] Error fetching entries: " + e.getMessage());
            e.printStackTrace();
        }
        return entries;
    }
}
