<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web.model.Event" %>
<%@ page import="com.demo.web.model.Group" %>
<%@ page import="com.demo.web.dao.EventDAO" %>
<%@ page import="com.demo.web.dao.GroupDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Check session
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // Get event ID from URL parameter
    String eventIdParam = request.getParameter("id");

    if (eventIdParam == null || eventIdParam.trim().isEmpty()) {
        session.setAttribute("errorMessage", "Event ID is required");
        response.sendRedirect(request.getContextPath() + "/events");
        return;
    }

    // Fetch event data
    Event event = null;
    Group group = null;

    try {
        int eventId = Integer.parseInt(eventIdParam);

        EventDAO eventDAO = new EventDAO();
        event = eventDAO.findById(eventId);

        if (event == null) {
            session.setAttribute("errorMessage", "Event not found");
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        // Get group information
        GroupDAO groupDAO = new GroupDAO();
        group = groupDAO.findById(event.getGroupId());

        if (group == null) {
            session.setAttribute("errorMessage", "Group not found for this event");
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        // Security check: Verify the group belongs to this user
        if (group.getUserId() != userId) {
            session.setAttribute("errorMessage", "You don't have permission to view this event");
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

    } catch (NumberFormatException e) {
        session.setAttribute("errorMessage", "Invalid event ID");
        response.sendRedirect(request.getContextPath() + "/events");
        return;
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("errorMessage", "An error occurred while loading the event");
        response.sendRedirect(request.getContextPath() + "/events");
        return;
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    String formattedDate = dateFormat.format(event.getEventDate());

    String eventPicUrl = event.getEventPicUrl();
    if (eventPicUrl == null || eventPicUrl.isEmpty()) {
        eventPicUrl = "https://images.unsplash.com/photo-1511895426328-dc8714191300?w=1200";
    } else {
        eventPicUrl = request.getContextPath() + "/" + eventPicUrl;
    }
%>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/eventinfo.css">
</head>
<body>

<div class="event-viewer-wrapper">
    <div class="event-viewer-container">
        <!-- Navigation Header -->
        <div class="viewer-header">
            <button class="nav-btn prev-event" id="prevEvent" onclick="window.history.back();" style="cursor: pointer;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Back
            </button>
            <h1 class="event-title" id="eventTitle"><%= event.getTitle() %></h1>
            <button class="nav-btn next-event" id="nextEvent" style="visibility: hidden;">
                Next
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
        </div>

        <!-- Event Banner -->
        <div class="event-banner-container">
            <img src="<%= eventPicUrl %>" alt="<%= event.getTitle() %>" id="eventBanner" class="event-banner-img">
        </div>

        <!-- Event Info -->
        <div class="event-info-section">
            <div class="info-row">
                <div class="info-item">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span id="eventDate"><%= formattedDate %></span>
                </div>
                <div class="info-item">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span id="eventGroup"><%= group != null ? group.getName() : "Unknown Group" %></span>
                </div>
            </div>
        </div>

        <!-- Event Description -->
        <div class="event-description-section">
            <h3 class="section-title">About This Event</h3>
            <p class="event-description" id="eventDescription">
                <%= event.getDescription() != null && !event.getDescription().isEmpty()
                        ? event.getDescription()
                        : "No description available for this event." %>
            </p>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons-section">
            <button class="primary-action-btn" id="goToMemoryBtn">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                    <polyline points="21 15 16 10 5 21"></polyline>
                </svg>
                Go to the Memory
            </button>
            <div class="secondary-actions">
                <button class="secondary-action-btn edit-btn" id="editEventBtn">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                    Edit Event
                </button>
                <button class="secondary-action-btn delete-btn" id="deleteEventBtn">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="3 6 5 6 21 6"></polyline>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    </svg>
                    Delete Event
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Hidden form for delete functionality -->
<form id="deleteEventForm" method="POST" action="${pageContext.request.contextPath}/deleteEvent" style="display: none;">
    <input type="hidden" name="event_id" value="<%= eventIdParam %>">
</form>

<jsp:include page="../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const eventId = '<%= eventIdParam %>';
        const contextPath = '${pageContext.request.contextPath}';

        console.log('[DEBUG] Event ID from URL:', eventId);

        // Go to Memory button
        document.getElementById('goToMemoryBtn').addEventListener('click', () => {
            window.location.href = contextPath + '/memoryview?event_id=' + eventId;
        });

        // Edit Event button
        document.getElementById('editEventBtn').addEventListener('click', () => {
            window.location.href = contextPath + '/editevent?event_id=' + eventId;
        });

        // Delete Event button
        document.getElementById('deleteEventBtn').addEventListener('click', () => {
            const eventTitle = '<%= event.getTitle().replace("'", "\\'") %>';

            if (confirm('Are you sure you want to delete "' + eventTitle + '"?\n\nThis action cannot be undone and will also delete all associated memories.')) {
                console.log('[DEBUG] Deleting event with ID:', eventId);
                // Submit the hidden form
                document.getElementById('deleteEventForm').submit();
            }
        });
    });
</script>

</body>
</html>