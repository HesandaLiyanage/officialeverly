<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.Event" %>
        <%@ page import="com.demo.web.model.Group" %>
            <%@ page import="com.demo.web.dao.EventDAO" %>
                <%@ page import="com.demo.web.dao.GroupDAO" %>
                    <%@ page import="com.demo.web.dao.EventVoteDAO" %>
                        <%@ page import="java.text.SimpleDateFormat" %>
                            <%@ page import="java.util.List" %>
                                <%@ page import="java.util.Map" %>
                                    <%@ page import="java.util.ArrayList" %>
                                        <% Integer userId=(Integer) session.getAttribute("user_id"); if (userId==null) {
                                            response.sendRedirect(request.getContextPath() + "/login" ); return; }
                                            String eventIdParam=request.getParameter("id"); if (eventIdParam==null ||
                                            eventIdParam.trim().isEmpty()) {
                                            session.setAttribute("errorMessage", "Event ID is required" );
                                            response.sendRedirect(request.getContextPath() + "/events" ); return; }
                                            String groupIdParam=request.getParameter("groupId"); Integer
                                            filterGroupId=null; if (groupIdParam !=null &&
                                            !groupIdParam.trim().isEmpty()) { try {
                                            filterGroupId=Integer.parseInt(groupIdParam); } catch (NumberFormatException
                                            ignore) {} } Event event=null; List<Group> eventGroups = new ArrayList<>();
                                                try {
                                                int eventId = Integer.parseInt(eventIdParam);
                                                EventDAO eventDAO = new EventDAO();
                                                event = eventDAO.findById(eventId);
                                                if (event == null) {
                                                session.setAttribute("errorMessage", "Event not found");
                                                response.sendRedirect(request.getContextPath() + "/events"); return;
                                                }

                                                GroupDAO groupDAO = new GroupDAO();
                                                List<Integer> groupIds = eventDAO.getGroupIdsForEvent(eventId);
                                                    if (groupIds.isEmpty()) { groupIds.add(event.getGroupId()); }
                                                    for (int gid : groupIds) {
                                                    Group g = groupDAO.findById(gid);
                                                    if (g != null) eventGroups.add(g);
                                                    }

                                                    boolean hasAccess = false;
                                                    for (Group g : eventGroups) {
                                                    if (g.getUserId() == userId) { hasAccess = true; break; }
                                                    }
                                                    if (!hasAccess) {
                                                    session.setAttribute("errorMessage", "You don't have permission to
                                                    view this event");
                                                    response.sendRedirect(request.getContextPath() + "/events"); return;
                                                    }
                                                    } catch (NumberFormatException e) {
                                                    session.setAttribute("errorMessage", "Invalid event ID");
                                                    response.sendRedirect(request.getContextPath() + "/events"); return;
                                                    } catch (Exception e) {
                                                    e.printStackTrace();
                                                    session.setAttribute("errorMessage", "An error occurred while
                                                    loading the event");
                                                    response.sendRedirect(request.getContextPath() + "/events"); return;
                                                    }

                                                    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
                                                    String formattedDate = dateFormat.format(event.getEventDate());
                                                    String eventPicUrl = event.getEventPicUrl();
                                                    boolean hasImage = (eventPicUrl != null && !eventPicUrl.isEmpty());
                                                    String displayPicUrl = hasImage ? request.getContextPath() + "/" +
                                                    eventPicUrl : null;
                                                    boolean isPastEvent = event.getEventDate().before(new
                                                    java.util.Date());

                                                    StringBuilder groupNamesStr = new StringBuilder();
                                                    for (int i = 0; i < eventGroups.size(); i++) {
                                                        groupNamesStr.append(eventGroups.get(i).getName()); if (i <
                                                        eventGroups.size() - 1) groupNamesStr.append(", ");
    }

    List<Group> pollGroups;
    if (filterGroupId != null) {
        pollGroups = new ArrayList<>();
        for (Group g : eventGroups) {
            if (g.getGroupId() == filterGroupId) { pollGroups.add(g); break; }
        }
    } else {
        pollGroups = eventGroups;
    }
%>
<!DOCTYPE html>
<html lang=" en">

                                                        <head>
                                                            <meta charset="UTF-8">
                                                            <meta name="viewport"
                                                                content="width=device-width, initial-scale=1.0">
                                                            <title>
                                                                <%= event.getTitle() %> - Everly
                                                            </title>
                                                            <link
                                                                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                                                                rel="stylesheet">
                                                            <link rel="stylesheet"
                                                                href="${pageContext.request.contextPath}/resources/css/base.css">
                                                            <link rel="stylesheet"
                                                                href="${pageContext.request.contextPath}/resources/css/memoryviewer.css">
                                                            <style>
                                                                /* Event-specific overrides on top of memoryviewer.css */
                                                                .mv-media-section {
                                                                    background: #000;
                                                                    position: relative;
                                                                }

                                                                /* Event banner in left pane */
                                                                .ev-banner-area {
                                                                    width: 100%;
                                                                    height: 500px;
                                                                    display: flex;
                                                                    align-items: center;
                                                                    justify-content: center;
                                                                    position: relative;
                                                                    overflow: hidden;
                                                                }

                                                                .ev-banner-area img {
                                                                    width: 100%;
                                                                    height: 100%;
                                                                    object-fit: cover;
                                                                }

                                                                /* No image state */
                                                                .ev-no-image {
                                                                    display: flex;
                                                                    flex-direction: column;
                                                                    align-items: center;
                                                                    justify-content: center;
                                                                    width: 100%;
                                                                    height: 500px;
                                                                    color: rgba(255, 255, 255, 0.5);
                                                                    gap: 12px;
                                                                    text-align: center;
                                                                    padding: 40px;
                                                                    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
                                                                }

                                                                .ev-no-image svg {
                                                                    width: 56px;
                                                                    height: 56px;
                                                                    opacity: 0.4;
                                                                }

                                                                .ev-no-image h3 {
                                                                    font-size: 16px;
                                                                    font-weight: 600;
                                                                    color: rgba(255, 255, 255, 0.6);
                                                                }

                                                                /* Past event badge overlay */
                                                                .ev-past-badge {
                                                                    position: absolute;
                                                                    top: 16px;
                                                                    left: 16px;
                                                                    background: rgba(0, 0, 0, 0.6);
                                                                    color: #fbbf24;
                                                                    padding: 6px 14px;
                                                                    border-radius: 20px;
                                                                    font-size: 12px;
                                                                    font-weight: 700;
                                                                    z-index: 5;
                                                                    display: flex;
                                                                    align-items: center;
                                                                    gap: 6px;
                                                                }

                                                                /* ========== Voting Poll Styles ========== */
                                                                .ev-polls-title {
                                                                    font-size: 11px;
                                                                    font-weight: 700;
                                                                    text-transform: uppercase;
                                                                    letter-spacing: 0.6px;
                                                                    color: #9ca3af;
                                                                    margin-bottom: 12px;
                                                                    display: flex;
                                                                    align-items: center;
                                                                    gap: 6px;
                                                                }

                                                                .ev-poll-card {
                                                                    background: #f9fafb;
                                                                    border: 1px solid #f3f4f6;
                                                                    border-radius: 12px;
                                                                    padding: 16px;
                                                                    margin-bottom: 12px;
                                                                }

                                                                .ev-poll-group-name {
                                                                    font-size: 12px;
                                                                    font-weight: 700;
                                                                    color: #9A74D8;
                                                                    margin-bottom: 10px;
                                                                    display: flex;
                                                                    align-items: center;
                                                                    gap: 5px;
                                                                }

                                                                .ev-poll-question {
                                                                    font-size: 14px;
                                                                    font-weight: 700;
                                                                    color: #262626;
                                                                    margin-bottom: 4px;
                                                                }

                                                                .ev-poll-hint {
                                                                    font-size: 11px;
                                                                    color: #9ca3af;
                                                                    margin-bottom: 10px;
                                                                }

                                                                .ev-poll-options {
                                                                    display: flex;
                                                                    flex-direction: column;
                                                                    gap: 6px;
                                                                }

                                                                .ev-poll-btn {
                                                                    display: flex;
                                                                    align-items: center;
                                                                    justify-content: space-between;
                                                                    padding: 10px 14px;
                                                                    border: 1.5px solid #e5e7eb;
                                                                    border-radius: 10px;
                                                                    background: white;
                                                                    cursor: pointer;
                                                                    transition: all 0.2s ease;
                                                                    font-size: 13px;
                                                                    font-weight: 600;
                                                                    color: #374151;
                                                                    font-family: 'Plus Jakarta Sans', sans-serif;
                                                                }

                                                                .ev-poll-btn:hover {
                                                                    border-color: #9A74D8;
                                                                    background: #faf5ff;
                                                                }

                                                                .ev-poll-btn.selected.going {
                                                                    border-color: #22c55e;
                                                                    background: #f0fdf4;
                                                                    color: #16a34a;
                                                                }

                                                                .ev-poll-btn.selected.not_going {
                                                                    border-color: #ef4444;
                                                                    background: #fef2f2;
                                                                    color: #dc2626;
                                                                }

                                                                .ev-poll-btn.selected.maybe {
                                                                    border-color: #f59e0b;
                                                                    background: #fffbeb;
                                                                    color: #d97706;
                                                                }

                                                                .ev-poll-btn-left {
                                                                    display: flex;
                                                                    align-items: center;
                                                                    gap: 8px;
                                                                }

                                                                .ev-poll-btn-icon {
                                                                    font-size: 14px;
                                                                }

                                                                .ev-poll-count {
                                                                    font-size: 12px;
                                                                    color: #9ca3af;
                                                                    font-weight: 500;
                                                                }

                                                                .ev-poll-bar-wrap {
                                                                    height: 3px;
                                                                    background: #f3f4f6;
                                                                    border-radius: 2px;
                                                                    margin-top: 4px;
                                                                    overflow: hidden;
                                                                }

                                                                .ev-poll-bar {
                                                                    height: 100%;
                                                                    border-radius: 2px;
                                                                    transition: width 0.5s ease;
                                                                }

                                                                .ev-poll-bar.going {
                                                                    background: #22c55e;
                                                                }

                                                                .ev-poll-bar.not_going {
                                                                    background: #ef4444;
                                                                }

                                                                .ev-poll-bar.maybe {
                                                                    background: #f59e0b;
                                                                }

                                                                .ev-poll-total {
                                                                    font-size: 11px;
                                                                    color: #9ca3af;
                                                                    text-align: center;
                                                                    padding-top: 6px;
                                                                }

                                                                .ev-poll-voters-toggle {
                                                                    font-size: 12px;
                                                                    color: #9A74D8;
                                                                    cursor: pointer;
                                                                    font-weight: 600;
                                                                    background: none;
                                                                    border: none;
                                                                    padding: 0;
                                                                    margin-top: 8px;
                                                                    font-family: 'Plus Jakarta Sans', sans-serif;
                                                                }

                                                                .ev-poll-voters-toggle:hover {
                                                                    text-decoration: underline;
                                                                }

                                                                .ev-poll-voters-list {
                                                                    margin-top: 8px;
                                                                    display: none;
                                                                }

                                                                .ev-poll-voters-list.show {
                                                                    display: block;
                                                                }

                                                                .ev-poll-voter {
                                                                    display: flex;
                                                                    align-items: center;
                                                                    gap: 8px;
                                                                    padding: 6px 0;
                                                                    border-bottom: 1px solid #f3f4f6;
                                                                }

                                                                .ev-poll-voter:last-child {
                                                                    border-bottom: none;
                                                                }

                                                                .ev-poll-voter-avatar {
                                                                    width: 24px;
                                                                    height: 24px;
                                                                    border-radius: 50%;
                                                                    background: #e5e7eb;
                                                                    display: flex;
                                                                    align-items: center;
                                                                    justify-content: center;
                                                                    font-size: 10px;
                                                                    font-weight: 700;
                                                                    color: #6b7280;
                                                                    flex-shrink: 0;
                                                                }

                                                                .ev-poll-voter-name {
                                                                    font-size: 12px;
                                                                    font-weight: 500;
                                                                    color: #374151;
                                                                    flex: 1;
                                                                }

                                                                .ev-poll-voter-badge {
                                                                    font-size: 10px;
                                                                    padding: 2px 8px;
                                                                    border-radius: 12px;
                                                                    font-weight: 600;
                                                                }

                                                                .ev-poll-voter-badge.going {
                                                                    background: #dcfce7;
                                                                    color: #16a34a;
                                                                }

                                                                .ev-poll-voter-badge.not_going {
                                                                    background: #fee2e2;
                                                                    color: #dc2626;
                                                                }

                                                                .ev-poll-voter-badge.maybe {
                                                                    background: #fef3c7;
                                                                    color: #d97706;
                                                                }

                                                                /* Groups chips */
                                                                .ev-groups-chips {
                                                                    display: flex;
                                                                    flex-wrap: wrap;
                                                                    gap: 6px;
                                                                    margin-top: 4px;
                                                                }

                                                                .ev-group-chip {
                                                                    display: inline-flex;
                                                                    align-items: center;
                                                                    gap: 4px;
                                                                    font-size: 12px;
                                                                    font-weight: 600;
                                                                    color: #9A74D8;
                                                                    background: #f3f0ff;
                                                                    padding: 4px 10px;
                                                                    border-radius: 12px;
                                                                }
                                                            </style>
                                                        </head>

                                                        <body>
                                                            <div class="mv-page">
                                                                <!-- Close button -->
                                                                <a href="${pageContext.request.contextPath}/events"
                                                                    class="mv-close-btn">
                                                                    <svg width="20" height="20" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                                                    </svg>
                                                                </a>

                                                                <div class="mv-wrapper">
                                                                    <!-- LEFT: Event Banner -->
                                                                    <div class="mv-media-section">
                                                                        <% if (hasImage) { %>
                                                                            <div class="ev-banner-area">
                                                                                <% if (isPastEvent) { %>
                                                                                    <div class="ev-past-badge">
                                                                                        <svg width="12" height="12"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2.5">
                                                                                            <circle cx="12" cy="12"
                                                                                                r="10"></circle>
                                                                                            <polyline
                                                                                                points="12 6 12 12 16 14">
                                                                                            </polyline>
                                                                                        </svg>
                                                                                        Past Event
                                                                                    </div>
                                                                                    <% } %>
                                                                                        <img src="<%= displayPicUrl %>"
                                                                                            alt="<%= event.getTitle() %>">
                                                                            </div>
                                                                            <% } else { %>
                                                                                <div class="ev-no-image">
                                                                                    <% if (isPastEvent) { %>
                                                                                        <div class="ev-past-badge"
                                                                                            style="position: static; margin-bottom: 8px;">
                                                                                            <svg width="12" height="12"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2.5">
                                                                                                <circle cx="12" cy="12"
                                                                                                    r="10"></circle>
                                                                                                <polyline
                                                                                                    points="12 6 12 12 16 14">
                                                                                                </polyline>
                                                                                            </svg>
                                                                                            Past Event
                                                                                        </div>
                                                                                        <% } %>
                                                                                            <svg viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="1.5">
                                                                                                <rect x="3" y="4"
                                                                                                    width="18"
                                                                                                    height="18" rx="2"
                                                                                                    ry="2"></rect>
                                                                                                <line x1="16" y1="2"
                                                                                                    x2="16" y2="6">
                                                                                                </line>
                                                                                                <line x1="8" y1="2"
                                                                                                    x2="8" y2="6">
                                                                                                </line>
                                                                                                <line x1="3" y1="10"
                                                                                                    x2="21" y2="10">
                                                                                                </line>
                                                                                            </svg>
                                                                                            <h3>
                                                                                                <%= event.getTitle() %>
                                                                                            </h3>
                                                                                </div>
                                                                                <% } %>
                                                                    </div>

                                                                    <!-- RIGHT: Details Section -->
                                                                    <div class="mv-details-section">
                                                                        <!-- Header -->
                                                                        <div class="mv-header">
                                                                            <div class="mv-header-left">
                                                                                <div class="mv-avatar">
                                                                                    <svg width="16" height="16"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2.5">
                                                                                        <rect x="3" y="4" width="18"
                                                                                            height="18" rx="2" ry="2">
                                                                                        </rect>
                                                                                        <line x1="16" y1="2" x2="16"
                                                                                            y2="6"></line>
                                                                                        <line x1="8" y1="2" x2="8"
                                                                                            y2="6"></line>
                                                                                        <line x1="3" y1="10" x2="21"
                                                                                            y2="10"></line>
                                                                                    </svg>
                                                                                </div>
                                                                                <div class="mv-header-text">
                                                                                    <h3>Event</h3>
                                                                                    <div class="mv-type-badge">
                                                                                        <svg width="10" height="10"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2.5">
                                                                                            <path
                                                                                                d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2">
                                                                                            </path>
                                                                                            <circle cx="9" cy="7" r="4">
                                                                                            </circle>
                                                                                        </svg>
                                                                                        <%= groupNamesStr.toString() %>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Scrollable Content -->
                                                                        <div class="mv-content">
                                                                            <!-- Title -->
                                                                            <div class="mv-info-group">
                                                                                <div class="mv-info-value title">
                                                                                    <%= event.getTitle() %>
                                                                                </div>
                                                                            </div>

                                                                            <div class="mv-divider"></div>

                                                                            <!-- Date -->
                                                                            <div class="mv-info-group">
                                                                                <div class="mv-info-label">Date</div>
                                                                                <div class="mv-info-value date">
                                                                                    <svg viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <rect x="3" y="4" width="18"
                                                                                            height="18" rx="2" ry="2">
                                                                                        </rect>
                                                                                        <line x1="16" y1="2" x2="16"
                                                                                            y2="6"></line>
                                                                                        <line x1="8" y1="2" x2="8"
                                                                                            y2="6"></line>
                                                                                        <line x1="3" y1="10" x2="21"
                                                                                            y2="10"></line>
                                                                                    </svg>
                                                                                    <%= formattedDate %>
                                                                                </div>
                                                                            </div>

                                                                            <!-- Groups -->
                                                                            <div class="mv-info-group">
                                                                                <div class="mv-info-label">Shared With
                                                                                </div>
                                                                                <div class="ev-groups-chips">
                                                                                    <% for (Group g : eventGroups) { %>
                                                                                        <span class="ev-group-chip">
                                                                                            <svg width="10" height="10"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2.5">
                                                                                                <path
                                                                                                    d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2">
                                                                                                </path>
                                                                                                <circle cx="9" cy="7"
                                                                                                    r="4"></circle>
                                                                                            </svg>
                                                                                            <%= g.getName() %>
                                                                                        </span>
                                                                                        <% } %>
                                                                                </div>
                                                                            </div>

                                                                            <% if (event.getDescription() !=null &&
                                                                                !event.getDescription().isEmpty()) { %>
                                                                                <div class="mv-divider"></div>
                                                                                <div class="mv-info-group">
                                                                                    <div class="mv-info-label">About
                                                                                    </div>
                                                                                    <div class="mv-info-value"
                                                                                        style="white-space: pre-wrap;">
                                                                                        <%= event.getDescription() %>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>

                                                                                    <!-- Voting Polls -->
                                                                                    <% if (!pollGroups.isEmpty()) {
                                                                                        EventVoteDAO voteDAO=new
                                                                                        EventVoteDAO(); %>
                                                                                        <div class="mv-divider"></div>
                                                                                        <div class="mv-info-group">
                                                                                            <div class="ev-polls-title">
                                                                                                <svg width="12"
                                                                                                    height="12"
                                                                                                    viewBox="0 0 24 24"
                                                                                                    fill="none"
                                                                                                    stroke="currentColor"
                                                                                                    stroke-width="2.5">
                                                                                                    <path
                                                                                                        d="M22 11.08V12a10 10 0 1 1-5.93-9.14">
                                                                                                    </path>
                                                                                                    <polyline
                                                                                                        points="22 4 12 14.01 9 11.01">
                                                                                                    </polyline>
                                                                                                </svg>
                                                                                                Polls
                                                                                            </div>

                                                                                            <% for (Group pollGroup :
                                                                                                pollGroups) { int
                                                                                                pgId=pollGroup.getGroupId();
                                                                                                int
                                                                                                eId=event.getEventId();
                                                                                                Map<String, Integer> vc
                                                                                                =
                                                                                                voteDAO.getVoteCounts(eId,
                                                                                                pgId);
                                                                                                String uv =
                                                                                                voteDAO.getUserVote(eId,
                                                                                                pgId, userId);
                                                                                                List<Map<String, Object>
                                                                                                    > voters =
                                                                                                    voteDAO.getVoters(eId,
                                                                                                    pgId);
                                                                                                    int total =
                                                                                                    vc.get("total");
                                                                                                    int gc =
                                                                                                    vc.get("going");
                                                                                                    int ngc =
                                                                                                    vc.get("not_going");
                                                                                                    int mc =
                                                                                                    vc.get("maybe");
                                                                                                    %>
                                                                                                    <div class="ev-poll-card"
                                                                                                        data-event-id="<%= eId %>"
                                                                                                        data-group-id="<%= pgId %>">
                                                                                                        <% if
                                                                                                            (pollGroups.size()>
                                                                                                            1) { %>
                                                                                                            <div
                                                                                                                class="ev-poll-group-name">
                                                                                                                <svg width="12"
                                                                                                                    height="12"
                                                                                                                    viewBox="0 0 24 24"
                                                                                                                    fill="none"
                                                                                                                    stroke="currentColor"
                                                                                                                    stroke-width="2">
                                                                                                                    <path
                                                                                                                        d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2">
                                                                                                                    </path>
                                                                                                                    <circle
                                                                                                                        cx="9"
                                                                                                                        cy="7"
                                                                                                                        r="4">
                                                                                                                    </circle>
                                                                                                                </svg>
                                                                                                                <%= pollGroup.getName()
                                                                                                                    %>
                                                                                                            </div>
                                                                                                            <% } %>
                                                                                                                <div
                                                                                                                    class="ev-poll-question">
                                                                                                                    Are
                                                                                                                    you
                                                                                                                    going?
                                                                                                                </div>
                                                                                                                <p
                                                                                                                    class="ev-poll-hint">
                                                                                                                    Tap
                                                                                                                    to
                                                                                                                    vote.
                                                                                                                    Tap
                                                                                                                    again
                                                                                                                    to
                                                                                                                    un-vote.
                                                                                                                </p>

                                                                                                                <div
                                                                                                                    class="ev-poll-options">
                                                                                                                    <button
                                                                                                                        type="button"
                                                                                                                        class="ev-poll-btn <%= "
                                                                                                                        going".equals(uv)
                                                                                                                        ? "selected going"
                                                                                                                        : ""
                                                                                                                        %>"
                                                                                                                        onclick="castVote(
                                                                                                                        <%= eId
                                                                                                                            %>
                                                                                                                            ,
                                                                                                                            <%= pgId
                                                                                                                                %>
                                                                                                                                ,
                                                                                                                                'going',
                                                                                                                                this)">
                                                                                                                                <span
                                                                                                                                    class="ev-poll-btn-left"><span
                                                                                                                                        class="ev-poll-btn-icon">✅</span>Going</span>
                                                                                                                                <span
                                                                                                                                    class="ev-poll-count"
                                                                                                                                    id="count-going-<%= pgId %>">
                                                                                                                                    <%= gc
                                                                                                                                        %>
                                                                                                                                </span>
                                                                                                                    </button>
                                                                                                                    <div
                                                                                                                        class="ev-poll-bar-wrap">
                                                                                                                        <div class="ev-poll-bar going"
                                                                                                                            id="bar-going-<%= pgId %>"
                                                                                                                            style="width:<%= total > 0 ? (gc * 100 / total) : 0 %>%">
                                                                                                                        </div>
                                                                                                                    </div>

                                                                                                                    <button
                                                                                                                        type="button"
                                                                                                                        class="ev-poll-btn <%= "
                                                                                                                        not_going".equals(uv)
                                                                                                                        ? "selected not_going"
                                                                                                                        : ""
                                                                                                                        %>"
                                                                                                                        onclick="castVote(
                                                                                                                        <%= eId
                                                                                                                            %>
                                                                                                                            ,
                                                                                                                            <%= pgId
                                                                                                                                %>
                                                                                                                                ,
                                                                                                                                'not_going',
                                                                                                                                this)">
                                                                                                                                <span
                                                                                                                                    class="ev-poll-btn-left"><span
                                                                                                                                        class="ev-poll-btn-icon">❌</span>Not
                                                                                                                                    Going</span>
                                                                                                                                <span
                                                                                                                                    class="ev-poll-count"
                                                                                                                                    id="count-not_going-<%= pgId %>">
                                                                                                                                    <%= ngc
                                                                                                                                        %>
                                                                                                                                </span>
                                                                                                                    </button>
                                                                                                                    <div
                                                                                                                        class="ev-poll-bar-wrap">
                                                                                                                        <div class="ev-poll-bar not_going"
                                                                                                                            id="bar-not_going-<%= pgId %>"
                                                                                                                            style="width:<%= total > 0 ? (ngc * 100 / total) : 0 %>%">
                                                                                                                        </div>
                                                                                                                    </div>

                                                                                                                    <button
                                                                                                                        type="button"
                                                                                                                        class="ev-poll-btn <%= "
                                                                                                                        maybe".equals(uv)
                                                                                                                        ? "selected maybe"
                                                                                                                        : ""
                                                                                                                        %>"
                                                                                                                        onclick="castVote(
                                                                                                                        <%= eId
                                                                                                                            %>
                                                                                                                            ,
                                                                                                                            <%= pgId
                                                                                                                                %>
                                                                                                                                ,
                                                                                                                                'maybe',
                                                                                                                                this)">
                                                                                                                                <span
                                                                                                                                    class="ev-poll-btn-left"><span
                                                                                                                                        class="ev-poll-btn-icon">🤔</span>Maybe</span>
                                                                                                                                <span
                                                                                                                                    class="ev-poll-count"
                                                                                                                                    id="count-maybe-<%= pgId %>">
                                                                                                                                    <%= mc
                                                                                                                                        %>
                                                                                                                                </span>
                                                                                                                    </button>
                                                                                                                    <div
                                                                                                                        class="ev-poll-bar-wrap">
                                                                                                                        <div class="ev-poll-bar maybe"
                                                                                                                            id="bar-maybe-<%= pgId %>"
                                                                                                                            style="width:<%= total > 0 ? (mc * 100 / total) : 0 %>%">
                                                                                                                        </div>
                                                                                                                    </div>
                                                                                                                </div>

                                                                                                                <p class="ev-poll-total"
                                                                                                                    id="poll-total-<%= pgId %>">
                                                                                                                    <%= total
                                                                                                                        %>
                                                                                                                        vote
                                                                                                                        <%= total
                                                                                                                            !=1
                                                                                                                            ? "s"
                                                                                                                            : ""
                                                                                                                            %>
                                                                                                                </p>

                                                                                                                <button
                                                                                                                    type="button"
                                                                                                                    class="ev-poll-voters-toggle"
                                                                                                                    onclick="toggleVoters(<%= pgId %>)">Show
                                                                                                                    who
                                                                                                                    voted</button>
                                                                                                                <div class="ev-poll-voters-list"
                                                                                                                    id="voters-list-<%= pgId %>">
                                                                                                                    <% if
                                                                                                                        (voters
                                                                                                                        !=null
                                                                                                                        &&
                                                                                                                        !voters.isEmpty())
                                                                                                                        {
                                                                                                                        for
                                                                                                                        (Map<String,
                                                                                                                        Object>
                                                                                                                        voter
                                                                                                                        :
                                                                                                                        voters)
                                                                                                                        {
                                                                                                                        String
                                                                                                                        vn
                                                                                                                        =
                                                                                                                        (String)
                                                                                                                        voter.get("username");
                                                                                                                        String
                                                                                                                        vv
                                                                                                                        =
                                                                                                                        (String)
                                                                                                                        voter.get("vote");
                                                                                                                        String
                                                                                                                        vl
                                                                                                                        =
                                                                                                                        "going".equals(vv)
                                                                                                                        ?
                                                                                                                        "Going"
                                                                                                                        :
                                                                                                                        "not_going".equals(vv)
                                                                                                                        ?
                                                                                                                        "Not
                                                                                                                        Going"
                                                                                                                        :
                                                                                                                        "Maybe";
                                                                                                                        %>
                                                                                                                        <div
                                                                                                                            class="ev-poll-voter">
                                                                                                                            <div
                                                                                                                                class="ev-poll-voter-avatar">
                                                                                                                                <%= vn.substring(0,
                                                                                                                                    1).toUpperCase()
                                                                                                                                    %>
                                                                                                                            </div>
                                                                                                                            <span
                                                                                                                                class="ev-poll-voter-name">
                                                                                                                                <%= vn
                                                                                                                                    %>
                                                                                                                            </span>
                                                                                                                            <span
                                                                                                                                class="ev-poll-voter-badge <%= vv %>">
                                                                                                                                <%= vl
                                                                                                                                    %>
                                                                                                                            </span>
                                                                                                                        </div>
                                                                                                                        <% } }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <p
                                                                                                                                style="font-size: 12px; color: #9ca3af; padding: 6px 0;">
                                                                                                                                No
                                                                                                                                votes
                                                                                                                                yet.
                                                                                                                            </p>
                                                                                                                            <% }
                                                                                                                                %>
                                                                                                                </div>
                                                                                                    </div>
                                                                                                    <% } %>
                                                                                        </div>
                                                                                        <% } %>
                                                                        </div>

                                                                        <!-- Actions Bar -->
                                                                        <div class="mv-actions-bar">
                                                                            <a href="${pageContext.request.contextPath}/editevent?event_id=<%= eventIdParam %>"
                                                                                class="mv-action-btn secondary">
                                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <path
                                                                                        d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                                                                    </path>
                                                                                    <path
                                                                                        d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                                                                    </path>
                                                                                </svg>
                                                                                Edit
                                                                            </a>
                                                                            <button class="mv-action-btn danger"
                                                                                onclick="if(confirm('Delete this event? This cannot be undone.')){document.getElementById('deleteForm').submit();}">
                                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <polyline points="3 6 5 6 21 6">
                                                                                    </polyline>
                                                                                    <path
                                                                                        d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                                                                    </path>
                                                                                </svg>
                                                                                Delete
                                                                            </button>
                                                                            <% if (isPastEvent) { %>
                                                                                <a href="${pageContext.request.contextPath}/groupmemories?groupId=<%= event.getGroupId() %>"
                                                                                    class="mv-action-btn primary">
                                                                                    <svg viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2">
                                                                                        <rect x="3" y="3" width="18"
                                                                                            height="18" rx="2" ry="2">
                                                                                        </rect>
                                                                                        <circle cx="8.5" cy="8.5"
                                                                                            r="1.5"></circle>
                                                                                        <polyline
                                                                                            points="21 15 16 10 5 21">
                                                                                        </polyline>
                                                                                    </svg>
                                                                                    Memories
                                                                                </a>
                                                                                <% } %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <form id="deleteForm" method="POST"
                                                                action="${pageContext.request.contextPath}/deleteEvent"
                                                                style="display:none;">
                                                                <input type="hidden" name="event_id"
                                                                    value="<%= eventIdParam %>">
                                                            </form>

                                                            <script>
        const contextPath = '${pageContext.request.contextPath}';

        function castVote(eventId, groupId, vote, btnEl) {
            fetch(contextPath + '/eventVote', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'event_id=' + eventId + '&group_id=' + groupId + '&vote=' + vote
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('count-going-' + groupId).textContent = data.going;
                    document.getElementById('count-not_going-' + groupId).textContent = data.not_going;
                    document.getElementById('count-maybe-' + groupId).textContent = data.maybe;
                    document.getElementById('poll-total-' + groupId).textContent = data.total + ' vote' + (data.total !== 1 ? 's' : '');

                    const total = data.total || 1;
                    document.getElementById('bar-going-' + groupId).style.width = (data.going * 100 / total) + '%';
                    document.getElementById('bar-not_going-' + groupId).style.width = (data.not_going * 100 / total) + '%';
                    document.getElementById('bar-maybe-' + groupId).style.width = (data.maybe * 100 / total) + '%';

                    const container = btnEl.closest('.ev-poll-options');
                    container.querySelectorAll('.ev-poll-btn').forEach(btn => {
                        btn.classList.remove('selected', 'going', 'not_going', 'maybe');
                    });
                    if (data.userVote) {
                        const btns = container.querySelectorAll('.ev-poll-btn');
                        const idx = data.userVote === 'going' ? 0 : data.userVote === 'not_going' ? 1 : 2;
                        btns[idx].classList.add('selected', data.userVote);
                    }
                    refreshVoters(eventId, groupId);
                }
            })
            .catch(err => console.error('Vote error:', err));
        }

        function refreshVoters(eventId, groupId) {
            fetch(contextPath + '/eventVote?event_id=' + eventId + '&group_id=' + groupId + '&type=voters')
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    const list = document.getElementById('voters-list-' + groupId);
                    if (data.voters.length === 0) {
                        list.innerHTML = '<p style="font-size:12px;color:#9ca3af;padding:6px 0;">No votes yet.</p>';
                    } else {
                        let html = '';
                        data.voters.forEach(v => {
                            const label = v.vote === 'going' ? 'Going' : v.vote === 'not_going' ? 'Not Going' : 'Maybe';
                            html += '<div class="ev-poll-voter"><div class="ev-poll-voter-avatar">' + v.username.charAt(0).toUpperCase() + '</div><span class="ev-poll-voter-name">' + v.username + '</span><span class="ev-poll-voter-badge ' + v.vote + '">' + label + '</span></div>';
                        });
                        list.innerHTML = html;
                    }
                }
            });
        }

        function toggleVoters(groupId) {
            const list = document.getElementById('voters-list-' + groupId);
            list.classList.toggle('show');
            const btn = list.previousElementSibling;
            btn.textContent = list.classList.contains('show') ? 'Hide votes' : 'Show who voted';
        }
                                                            </script>
                                                        </body>

                                                        </html>