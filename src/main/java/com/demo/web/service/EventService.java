package com.demo.web.service;

import com.demo.web.dao.EventDAO;
import com.demo.web.dao.GroupDAO;
import com.demo.web.model.Event;
import com.demo.web.model.Group;

import java.util.List;

/**
 * Service for event operations.
 * Extracted from FrontControllerServlet.EventListLogicHandler,
 * CreateEventLogicHandler, and EditEventLogicHandler
 */
public class EventService {

    private EventDAO eventDAO;
    private GroupDAO groupDAO;

    public EventService() {
        this.eventDAO = new EventDAO();
        this.groupDAO = new GroupDAO();
    }

    /**
     * Gets all events for a user.
     * 
     * @param userId The user ID
     * @return List of events
     */
    public List<Event> getAllEvents(int userId) {
        return eventDAO.findByUserId(userId);
    }

    /**
     * Gets upcoming events for a user.
     * 
     * @param userId The user ID
     * @return List of upcoming events
     */
    public List<Event> getUpcomingEvents(int userId) {
        return eventDAO.findUpcomingEventsByUserId(userId);
    }

    /**
     * Gets past events for a user.
     * 
     * @param userId The user ID
     * @return List of past events
     */
    public List<Event> getPastEvents(int userId) {
        return eventDAO.findPastEventsByUserId(userId);
    }

    /**
     * Checks if a user is a group admin (has created at least one group).
     * 
     * @param userId The user ID
     * @return true if user has created groups
     */
    public boolean isUserGroupAdmin(int userId) {
        return eventDAO.isUserGroupAdmin(userId);
    }

    /**
     * Gets an event by ID.
     * 
     * @param eventId The event ID
     * @return The event if found, null otherwise
     */
    public Event getEventById(int eventId) {
        return eventDAO.findById(eventId);
    }

    /**
     * Gets an event by ID with permission check.
     * Validates that the user owns the group the event belongs to.
     * 
     * @param eventId The event ID
     * @param userId  The user ID for permission check
     * @return The event if found and user has permission, null otherwise
     */
    public Event getEventByIdWithPermission(int eventId, int userId) {
        Event event = eventDAO.findById(eventId);
        if (event == null) {
            return null;
        }

        // Get the group and verify ownership
        Group eventGroup = groupDAO.findById(event.getGroupId());
        if (eventGroup == null || eventGroup.getUserId() != userId) {
            return null;
        }

        return event;
    }

    /**
     * Gets all groups owned by a user (for event creation dropdown).
     * 
     * @param userId The user ID
     * @return List of groups owned by user
     */
    public List<Group> getUserGroups(int userId) {
        return groupDAO.findByUserId(userId);
    }

    /**
     * Gets a group by ID.
     * 
     * @param groupId The group ID
     * @return The group if found, null otherwise
     */
    public Group getGroupById(int groupId) {
        return groupDAO.findById(groupId);
    }
}
