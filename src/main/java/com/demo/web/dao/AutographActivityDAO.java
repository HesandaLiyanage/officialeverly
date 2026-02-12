package com.demo.web.dao;

import com.demo.web.model.AutographActivity;
import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for autograph activity tracking.
 * Handles CRUD operations for the autograph_activity table.
 */
public class AutographActivityDAO {

    /**
     * Create a new activity record when someone writes in an autograph book.
     * 
     * @param activity The activity to create
     * @return true if successfully created
     * @throws SQLException if database error occurs
     */
    public boolean createActivity(AutographActivity activity) throws SQLException {
        String sql = "INSERT INTO autograph_activity (activity_type, autograph_id, entry_id, invitee_user_id, book_title, created_at) "
                +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, activity.getActivityType() != null ? activity.getActivityType() : "autograph_written");
            stmt.setInt(2, activity.getAutographId());

            if (activity.getEntryId() != null) {
                stmt.setInt(3, activity.getEntryId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }

            stmt.setInt(4, activity.getInviteeUserId());
            stmt.setString(5, activity.getBookTitle());
            stmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    activity.setActivityId(rs.getInt(1));
                }
                System.out
                        .println("[DEBUG AutographActivityDAO] Created activity for book: " + activity.getBookTitle());
                return true;
            }
        }
        return false;
    }

    /**
     * Find all activities for autographs owned by a specific user.
     * This joins with the autograph table to filter by owner, and users table to
     * get invitee username.
     * 
     * @param ownerUserId The user ID of the autograph book owner
     * @param limit       Maximum number of activities to return
     * @return List of activities sorted by most recent first
     * @throws SQLException if database error occurs
     */
    public List<AutographActivity> findByAutographOwner(int ownerUserId, int limit) throws SQLException {
        String sql = "SELECT aa.activity_id, aa.activity_type, aa.autograph_id, aa.entry_id, " +
                "aa.invitee_user_id, aa.book_title, aa.created_at, u.username as invitee_username " +
                "FROM autograph_activity aa " +
                "JOIN autograph a ON aa.autograph_id = a.autograph_id " +
                "JOIN users u ON aa.invitee_user_id = u.user_id " +
                "WHERE a.user_id = ? " +
                "ORDER BY aa.created_at DESC " +
                "LIMIT ?";

        List<AutographActivity> activities = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerUserId);
            stmt.setInt(2, limit);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                AutographActivity activity = new AutographActivity();
                activity.setActivityId(rs.getInt("activity_id"));
                activity.setActivityType(rs.getString("activity_type"));
                activity.setAutographId(rs.getInt("autograph_id"));

                int entryId = rs.getInt("entry_id");
                activity.setEntryId(rs.wasNull() ? null : entryId);

                activity.setInviteeUserId(rs.getInt("invitee_user_id"));
                activity.setBookTitle(rs.getString("book_title"));
                activity.setCreatedAt(rs.getTimestamp("created_at"));
                activity.setInviteeUsername(rs.getString("invitee_username"));

                activities.add(activity);
            }

            System.out.println("[DEBUG AutographActivityDAO] Found " + activities.size() + " activities for owner: "
                    + ownerUserId);
        }

        return activities;
    }

    /**
     * Find recent activities for a specific autograph book.
     * 
     * @param autographId The autograph book ID
     * @param limit       Maximum number of activities to return
     * @return List of activities sorted by most recent first
     * @throws SQLException if database error occurs
     */
    public List<AutographActivity> findByAutographId(int autographId, int limit) throws SQLException {
        String sql = "SELECT aa.activity_id, aa.activity_type, aa.autograph_id, aa.entry_id, " +
                "aa.invitee_user_id, aa.book_title, aa.created_at, u.username as invitee_username " +
                "FROM autograph_activity aa " +
                "JOIN users u ON aa.invitee_user_id = u.user_id " +
                "WHERE aa.autograph_id = ? " +
                "ORDER BY aa.created_at DESC " +
                "LIMIT ?";

        List<AutographActivity> activities = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, autographId);
            stmt.setInt(2, limit);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                AutographActivity activity = new AutographActivity();
                activity.setActivityId(rs.getInt("activity_id"));
                activity.setActivityType(rs.getString("activity_type"));
                activity.setAutographId(rs.getInt("autograph_id"));

                int entryId = rs.getInt("entry_id");
                activity.setEntryId(rs.wasNull() ? null : entryId);

                activity.setInviteeUserId(rs.getInt("invitee_user_id"));
                activity.setBookTitle(rs.getString("book_title"));
                activity.setCreatedAt(rs.getTimestamp("created_at"));
                activity.setInviteeUsername(rs.getString("invitee_username"));

                activities.add(activity);
            }
        }

        return activities;
    }
}
