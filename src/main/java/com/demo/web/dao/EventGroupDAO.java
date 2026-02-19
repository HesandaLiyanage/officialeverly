package com.demo.web.dao;

import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the event_group junction table.
 * Manages the many-to-many relationship between events and groups.
 */
public class EventGroupDAO {

    /**
     * Associate multiple groups with an event.
     */
    public void addGroupsToEvent(int eventId, List<Integer> groupIds) {
        String sql = "INSERT INTO event_group (event_id, group_id) VALUES (?, ?) ON CONFLICT DO NOTHING";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int groupId : groupIds) {
                stmt.setInt(1, eventId);
                stmt.setInt(2, groupId);
                stmt.addBatch();
            }
            int[] results = stmt.executeBatch();
            System.out.println("[DEBUG EventGroupDAO] addGroupsToEvent: inserted " + results.length + " rows for event " + eventId);
        } catch (SQLException e) {
            System.err.println("[ERROR EventGroupDAO] addGroupsToEvent: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error adding groups to event", e);
        }
    }

    /**
     * Get all group IDs associated with an event.
     */
    public List<Integer> findGroupIdsByEventId(int eventId) {
        String sql = "SELECT group_id FROM event_group WHERE event_id = ?";
        List<Integer> groupIds = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                groupIds.add(rs.getInt("group_id"));
            }
            System.out.println("[DEBUG EventGroupDAO] findGroupIdsByEventId(" + eventId + ") returned " + groupIds.size() + " groups");
        } catch (SQLException e) {
            System.err.println("[ERROR EventGroupDAO] findGroupIdsByEventId: " + e.getMessage());
            e.printStackTrace();
        }
        return groupIds;
    }

    /**
     * Remove all group associations for an event (used during update).
     */
    public void deleteGroupsByEventId(int eventId) {
        String sql = "DELETE FROM event_group WHERE event_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            int rows = stmt.executeUpdate();
            System.out.println("[DEBUG EventGroupDAO] deleteGroupsByEventId(" + eventId + ") deleted " + rows + " rows");
        } catch (SQLException e) {
            System.err.println("[ERROR EventGroupDAO] deleteGroupsByEventId: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error deleting groups for event", e);
        }
    }
}
