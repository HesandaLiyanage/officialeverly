package com.demo.web.dao;

import com.demo.web.model.Event;
import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class EventDAO {
    private static final Logger logger = Logger.getLogger(EventDAO.class.getName());

    public EventDAO() {
    }

    /**
     * Create a new event
     */
    public boolean createEvent(Event event) {
        String sql = "INSERT INTO event (e_title, e_description, e_date, created_at, group_id, event_pic) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, event.getTitle());
            stmt.setString(2, event.getDescription());
            stmt.setTimestamp(3, event.getEventDate());
            stmt.setTimestamp(4, event.getCreatedAt() != null ? event.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            stmt.setInt(5, event.getGroupId());
            stmt.setString(6, event.getEventPicUrl());
            int rowsInserted = stmt.executeUpdate();
            System.out.println("[DEBUG EventDAO] createEvent affected " + rowsInserted + " rows.");
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while creating event: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while creating event", e);
        }
    }

    /**
     * Get event by ID
     */
    public Event findById(int eventId) {
        String sql = "SELECT event_id, e_title, e_description, e_date, created_at, group_id, event_pic FROM event WHERE event_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Event result = mapResultSetToEvent(rs);
                System.out.println("[DEBUG EventDAO] findById(" + eventId + ") returned: " + result);
                return result;
            } else {
                System.out.println("[DEBUG EventDAO] findById(" + eventId + ") returned null (record not found).");
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while fetching event by ID " + eventId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching event by ID", e);
        }
        return null;
    }

    /**
     * Get all events by group ID
     */
    public List<Event> findByGroupId(int groupId) {
        String sql = "SELECT event_id, e_title, e_description, e_date, created_at, group_id, event_pic FROM event WHERE group_id = ? ORDER BY e_date DESC";
        List<Event> events = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            System.out.println("[DEBUG EventDAO] findByGroupId(" + groupId + ") returned " + events.size() + " records.");
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while fetching events by group ID " + groupId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching events by group ID", e);
        }
        return events;
    }

    /**
     * Get all events for a specific user (based on groups they created/own)
     * Only group creators (admins) can see and create events
     */
    public List<Event> findByUserId(int userId) {
        String sql = "SELECT e.event_id, e.e_title, e.e_description, e.e_date, e.created_at, e.group_id, e.event_pic " +
                "FROM event e " +
                "INNER JOIN \"group\" g ON e.group_id = g.group_id " +
                "WHERE g.user_id = ? " +
                "ORDER BY e.e_date DESC";
        List<Event> events = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            System.out.println("[DEBUG EventDAO] findByUserId(" + userId + ") returned " + events.size() + " records.");
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while fetching events by user ID " + userId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching events by user ID", e);
        }
        return events;
    }

    /**
     * Get upcoming events for a user (only from groups they created)
     */
    public List<Event> findUpcomingEventsByUserId(int userId) {
        String sql = "SELECT e.event_id, e.e_title, e.e_description, e.e_date, e.created_at, e.group_id, e.event_pic " +
                "FROM event e " +
                "INNER JOIN \"group\" g ON e.group_id = g.group_id " +
                "WHERE g.user_id = ? AND e.e_date >= CURRENT_TIMESTAMP " +
                "ORDER BY e.e_date ASC";
        List<Event> events = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            System.out.println("[DEBUG EventDAO] findUpcomingEventsByUserId(" + userId + ") returned " + events.size() + " records.");
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while fetching upcoming events by user ID " + userId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching upcoming events by user ID", e);
        }
        return events;
    }

    /**
     * Get past events for a user (only from groups they created)
     */
    public List<Event> findPastEventsByUserId(int userId) {
        String sql = "SELECT e.event_id, e.e_title, e.e_description, e.e_date, e.created_at, e.group_id, e.event_pic " +
                "FROM event e " +
                "INNER JOIN \"group\" g ON e.group_id = g.group_id " +
                "WHERE g.user_id = ? AND e.e_date < CURRENT_TIMESTAMP " +
                "ORDER BY e.e_date DESC";
        List<Event> events = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            System.out.println("[DEBUG EventDAO] findPastEventsByUserId(" + userId + ") returned " + events.size() + " records.");
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while fetching past events by user ID " + userId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching past events by user ID", e);
        }
        return events;
    }

    /**
     * Check if user is a group admin (has at least one group they created)
     */
    public boolean isUserGroupAdmin(int userId) {
        String sql = "SELECT COUNT(*) as group_count FROM \"group\" WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("group_count");
                boolean isAdmin = count > 0;
                System.out.println("[DEBUG EventDAO] isUserGroupAdmin(" + userId + ") returned: " + isAdmin + " (has " + count + " groups)");
                return isAdmin;
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while checking if user is group admin " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update an existing event
     */
    public boolean updateEvent(Event event) {
        String sql = "UPDATE event SET e_title = ?, e_description = ?, e_date = ?, event_pic = ? WHERE event_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, event.getTitle());
            stmt.setString(2, event.getDescription());
            stmt.setTimestamp(3, event.getEventDate());
            stmt.setString(4, event.getEventPicUrl());
            stmt.setInt(5, event.getEventId());
            System.out.println("[DEBUG EventDAO] updateEvent preparing statement with values - Title: '" + event.getTitle() + "', Description: '" + event.getDescription() + "', Date: " + event.getEventDate() + ", Pic URL: '" + event.getEventPicUrl() + "', ID: " + event.getEventId());
            int rowsUpdated = stmt.executeUpdate();
            System.out.println("[DEBUG EventDAO] updateEvent executed. Rows affected: " + rowsUpdated + " for ID: " + event.getEventId());
            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while updating event ID " + event.getEventId() + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while updating event", e);
        }
    }

    /**
     * Delete event by ID
     */
    public boolean deleteEvent(int eventId) {
        String sql = "DELETE FROM event WHERE event_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            int rowsDeleted = stmt.executeUpdate();
            System.out.println("[DEBUG EventDAO] deleteEvent affected " + rowsDeleted + " rows for ID: " + eventId);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG EventDAO] Error while deleting event ID " + eventId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while deleting event", e);
        }
    }

    /**
     * Map ResultSet to Event object
     */
    private Event mapResultSetToEvent(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setEventId(rs.getInt("event_id"));
        event.setTitle(rs.getString("e_title"));
        event.setDescription(rs.getString("e_description"));
        event.setEventDate(rs.getTimestamp("e_date"));
        event.setCreatedAt(rs.getTimestamp("created_at"));
        event.setGroupId(rs.getInt("group_id"));
        event.setEventPicUrl(rs.getString("event_pic"));
        return event;
    }
}