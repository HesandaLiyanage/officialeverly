package com.demo.web.service;

import com.demo.web.dao.EventDAO;
import com.demo.web.dao.EventGroupDAO;
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
    private EventGroupDAO eventGroupDAO;
    private GroupDAO groupDAO;

    public EventService() {
        this.eventDAO = new EventDAO();
        this.eventGroupDAO = new EventGroupDAO();
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

        // Get all group IDs for this event from the junction table
        List<Integer> groupIds = eventGroupDAO.findGroupIdsByEventId(eventId);
        event.setGroupIds(groupIds);

        // Verify ownership: user must own at least one of the event's groups
        boolean hasPermission = false;
        for (int groupId : groupIds) {
            Group eventGroup = groupDAO.findById(groupId);
            if (eventGroup != null && eventGroup.getUserId() == userId) {
                hasPermission = true;
                break;
            }
        }

        // Fallback: check the legacy group_id column
        if (!hasPermission) {
            Group eventGroup = groupDAO.findById(event.getGroupId());
            if (eventGroup != null && eventGroup.getUserId() == userId) {
                hasPermission = true;
            }
        }

        return hasPermission ? event : null;
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

    /**
     * Gets all group IDs associated with an event.
     */
    public List<Integer> getGroupIdsForEvent(int eventId) {
        return eventGroupDAO.findGroupIdsByEventId(eventId);
    }
}
