package com.demo.web.dao;

import com.demo.web.model.Event;
import com.demo.web.model.Group;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {
    private Connection connection;
    private GroupDAO groupDAO;

    public EventDAO(Connection connection) {
        this.connection = connection;
        this.groupDAO = new GroupDAO(connection);
    }

    // Create a new event
    public boolean addEvent(Event event, int groupId) throws SQLException {
        String sql = "INSERT INTO event (event_id, name, event_date, group_id) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, event.getEventId());
            stmt.setString(2, event.getName());
            stmt.setTimestamp(3, event.getEventDate());
            stmt.setInt(4, groupId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Get an event by ID (including associated group)
    public Event getEventById(int eventId) throws SQLException {
        String sql = "SELECT * FROM event WHERE event_id = ?";
        Event event = null;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                event = new Event();
                event.setEventId(rs.getInt("event_id"));
                event.setName(rs.getString("name"));
                event.setEventDate(rs.getTimestamp("event_date"));

                // fetch the associated group
                int groupId = rs.getInt("group_id");
                Group group = groupDAO.getGroupById(groupId);
                event.setGroup(group);
            }
        }
        return event;
    }

    // Update an event
    public boolean updateEvent(Event event) throws SQLException {
        String sql = "UPDATE event SET name = ?, event_date = ?, group_id = ? WHERE event_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, event.getName());
            stmt.setTimestamp(2, event.getEventDate());
            stmt.setInt(3, event.getGroup().getGroupId());
            stmt.setInt(4, event.getEventId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Delete an event
    public boolean deleteEvent(int eventId) throws SQLException {
        String sql = "DELETE FROM event WHERE event_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Get all events (with associated groups)
    public List<Event> getAllEvents() throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM event";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Event event = new Event();
                int eventId = rs.getInt("event_id");
                event.setEventId(eventId);
                event.setName(rs.getString("name"));
                event.setEventDate(rs.getTimestamp("event_date"));

                // fetch the associated group
                int groupId = rs.getInt("group_id");
                Group group = groupDAO.getGroupById(groupId);
                event.setGroup(group);

                events.add(event);
            }
        }
        return events;
    }
}
