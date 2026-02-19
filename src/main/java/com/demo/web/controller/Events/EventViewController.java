package com.demo.web.controller.Events;

import com.demo.web.model.Event;
import com.demo.web.model.Group;
import com.demo.web.service.AuthService;
import com.demo.web.service.EventService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * View controller for event pages.
 * Handles GET requests for listing, creating, and editing events.
 */
public class EventViewController extends HttpServlet {

    private AuthService authService;
    private EventService eventService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        eventService = new EventService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validate session
        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        String action = request.getParameter("action");
        String eventIdParam = request.getParameter("event_id");

        // Determine the action
        if ("create".equals(action)) {
            handleCreateEvent(request, response, userId);
        } else if ("edit".equals(action) && eventIdParam != null) {
            handleEditEvent(request, response, userId, eventIdParam);
        } else {
            handleListEvents(request, response, userId);
        }
    }

    /**
     * Handles listing all events for the user.
     */
    private void handleListEvents(HttpServletRequest request, HttpServletResponse response,
            int userId) throws ServletException, IOException {
        System.out.println("[DEBUG EventViewController] Starting to handle /events request");

        try {
            // Check if user is a group admin
            boolean isGroupAdmin = eventService.isUserGroupAdmin(userId);
            System.out.println("[DEBUG EventViewController] User is group admin: " + isGroupAdmin);

            request.setAttribute("isGroupAdmin", isGroupAdmin);

            // Get all events
            List<Event> allEvents = eventService.getAllEvents(userId);
            List<Event> upcomingEvents = eventService.getUpcomingEvents(userId);
            List<Event> pastEvents = eventService.getPastEvents(userId);

            System.out.println("[DEBUG EventViewController] Total: " + allEvents.size() +
                    ", Upcoming: " + upcomingEvents.size() +
                    ", Past: " + pastEvents.size());

            // Set attributes for JSP
            request.setAttribute("allEvents", allEvents);
            request.setAttribute("upcomingEvents", upcomingEvents);
            request.setAttribute("pastEvents", pastEvents);
            request.setAttribute("upcomingCount", upcomingEvents.size());
            request.setAttribute("pastCount", pastEvents.size());
            request.setAttribute("totalCount", allEvents.size());

            request.getRequestDispatcher("/views/app/eventdashboard.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("[DEBUG EventViewController] Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching events: " + e.getMessage());
            request.getRequestDispatcher("/views/app/eventdashboard.jsp").forward(request, response);
        }
    }

    /**
     * Handles create event page (display the form).
     */
    private void handleCreateEvent(HttpServletRequest request, HttpServletResponse response,
            int userId) throws ServletException, IOException {
        System.out.println("[DEBUG EventViewController] Handling /createevent request");

        try {
            // Get all groups created by this user
            List<Group> userGroups = eventService.getUserGroups(userId);
            System.out.println("[DEBUG EventViewController] Found " + userGroups.size() + " groups for user");

            if (userGroups.isEmpty()) {
                request.setAttribute("error", "You need to create a group first before creating events.");
                request.setAttribute("noGroups", true);
            }

            request.setAttribute("userGroups", userGroups);
            request.getRequestDispatcher("/views/app/createevent.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("[DEBUG EventViewController] Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading groups: " + e.getMessage());
            request.getRequestDispatcher("/views/app/createevent.jsp").forward(request, response);
        }
    }

    /**
     * Handles edit event page (display the form).
     */
    private void handleEditEvent(HttpServletRequest request, HttpServletResponse response,
            int userId, String eventIdParam) throws ServletException, IOException {
        System.out.println("[DEBUG EventViewController] Handling /editevent request");

        HttpSession session = authService.getSession(request);

        try {
            if (eventIdParam == null || eventIdParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Event ID is required");
                response.sendRedirect(request.getContextPath() + "/events");
                return;
            }

            int eventId = Integer.parseInt(eventIdParam);

            // Get event with permission check
            Event event = eventService.getEventByIdWithPermission(eventId, userId);

            if (event == null) {
                session.setAttribute("errorMessage", "Event not found or you don't have permission");
                response.sendRedirect(request.getContextPath() + "/events");
                return;
            }

            System.out.println("[DEBUG EventViewController] Found event: " + event.getTitle());

            // Get all user's groups for the dropdown
            List<Group> userGroups = eventService.getUserGroups(userId);

            // Get group IDs currently associated with this event
            List<Integer> eventGroupIds = eventService.getGroupIdsForEvent(eventId);
            if (eventGroupIds == null || eventGroupIds.isEmpty()) {
                // Fallback: use legacy groupId column
                eventGroupIds = new ArrayList<>();
                eventGroupIds.add(event.getGroupId());
            }

            // Set attributes for JSP
            request.setAttribute("event", event);
            request.setAttribute("userGroups", userGroups);
            request.setAttribute("eventGroupIds", eventGroupIds);

            request.getRequestDispatcher("/views/app/editevent.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid event ID");
            response.sendRedirect(request.getContextPath() + "/events");
        } catch (Exception e) {
            System.out.println("[DEBUG EventViewController] Error: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while loading the event");
            response.sendRedirect(request.getContextPath() + "/events");
        }
    }
}
