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

                                        <% /* Check session */ Integer userId=(Integer) session.getAttribute("user_id");
                                            if (userId==null) { response.sendRedirect(request.getContextPath()
                                            + "/login" ); return; } /* Get event ID */ String
                                            eventIdParam=request.getParameter("id"); if (eventIdParam==null ||
                                            eventIdParam.trim().isEmpty()) {
                                            session.setAttribute("errorMessage", "Event ID is required" );
                                            response.sendRedirect(request.getContextPath() + "/events" ); return; } /*
                                            Optional: specific group context (when coming from a group announcement) */
                                            String groupIdParam=request.getParameter("groupId"); Integer
                                            filterGroupId=null; if (groupIdParam !=null &&
                                            !groupIdParam.trim().isEmpty()) { try {
                                            filterGroupId=Integer.parseInt(groupIdParam); } catch (NumberFormatException
                                            ignore) {} } /* Fetch event data */ Event event=null; Group
                                            primaryGroup=null; List<Group> eventGroups = new ArrayList<>();
                                                try {
                                                int eventId = Integer.parseInt(eventIdParam);
                                                EventDAO eventDAO = new EventDAO();
                                                event = eventDAO.findById(eventId);
                                                if (event == null) {
                                                session.setAttribute("errorMessage", "Event not found");
                                                response.sendRedirect(request.getContextPath() + "/events");
                                                return;
                                                }

                                                /* Get ALL groups for this event from event_group junction table */
                                                GroupDAO groupDAO = new GroupDAO();
                                                List<Integer> groupIds = eventDAO.getGroupIdsForEvent(eventId);
                                                    if (groupIds.isEmpty()) {
                                                    // Fallback: use legacy group_id
                                                    groupIds.add(event.getGroupId());
                                                    }
                                                    for (int gid : groupIds) {
                                                    Group g = groupDAO.findById(gid);
                                                    if (g != null) eventGroups.add(g);
                                                    }

                                                    primaryGroup = eventGroups.isEmpty() ? null : eventGroups.get(0);

                                                    /* Security check: user must own at least one of the groups, OR be a
                                                    member */
                                                    // For now, allow access if user owns any group (admin) - keeping existing behavior
                                                    boolean hasAccess = false;
                                                    for (Group g : eventGroups) {
                                                    if (g.getUserId() == userId) { hasAccess = true; break; }
                                                    }
                                                    if (!hasAccess) {
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
                                                    eventPicUrl =
                                                    "https://images.unsplash.com/photo-1511895426328-dc8714191300?w=1200";
                                                    } else {
                                                    eventPicUrl = request.getContextPath() + "/" + eventPicUrl;
                                                    }
                                                    boolean isPastEvent = event.getEventDate().before(new
                                                    java.util.Date());

                                                    // Build group names string
                                                    StringBuilder groupNamesStr = new StringBuilder();
                                                    for (int i = 0; i
                                                    < eventGroups.size(); i++) {
                                                        groupNamesStr.append(eventGroups.get(i).getName()); if (i <
                                                        eventGroups.size() - 1) groupNamesStr.append(", ");
    }

    // Determine which groups to show polls for
    List<Group> pollGroups;
    if (filterGroupId != null) {
        // Show only the specific group's poll
        pollGroups = new ArrayList<>();
        for (Group g : eventGroups) {
            if (g.getGroupId() == filterGroupId) { pollGroups.add(g); break; }
        }
    } else {
        // Show all groups' polls
        pollGroups = eventGroups;
    }
%>

<jsp:include page=" ../public/header2.jsp" />
                                                    <html>

                                                    <head>
                                                        <link rel="stylesheet" type="text/css"
                                                            href="${pageContext.request.contextPath}/resources/css/eventinfo.css">
                                                        <style>
                                                            /* ======================== */
                                                            /* Event Poll / Voting UI   */
                                                            /* ======================== */
                                                            .polls-section {
                                                                margin-top: 24px;
                                                            }

                                                            .polls-section-title {
                                                                font-size: 18px;
                                                                font-weight: 700;
                                                                color: #111827;
                                                                margin-bottom: 16px;
                                                                display: flex;
                                                                align-items: center;
                                                                gap: 8px;
                                                            }

                                                            .event-poll-container {
                                                                background: #f9fafb;
                                                                border: 1px solid #e5e7eb;
                                                                border-radius: 16px;
                                                                padding: 24px;
                                                                margin-bottom: 16px;
                                                            }

                                                            .poll-group-name {
                                                                font-size: 14px;
                                                                font-weight: 700;
                                                                color: #9A74D8;
                                                                margin-bottom: 12px;
                                                                display: flex;
                                                                align-items: center;
                                                                gap: 6px;
                                                            }

                                                            .poll-title {
                                                                font-size: 16px;
                                                                font-weight: 700;
                                                                color: #111827;
                                                                margin-bottom: 4px;
                                                                display: flex;
                                                                align-items: center;
                                                                gap: 8px;
                                                            }

                                                            .poll-subtitle {
                                                                font-size: 13px;
                                                                color: #6b7280;
                                                                margin-bottom: 16px;
                                                            }

                                                            .poll-options {
                                                                display: flex;
                                                                flex-direction: column;
                                                                gap: 8px;
                                                                margin-bottom: 16px;
                                                            }

                                                            .poll-option-btn {
                                                                display: flex;
                                                                align-items: center;
                                                                justify-content: space-between;
                                                                padding: 12px 16px;
                                                                border: 2px solid #e5e7eb;
                                                                border-radius: 12px;
                                                                background: white;
                                                                cursor: pointer;
                                                                transition: all 0.2s ease;
                                                                font-size: 14px;
                                                                font-weight: 600;
                                                                color: #374151;
                                                            }

                                                            .poll-option-btn:hover {
                                                                border-color: #9A74D8;
                                                                background: #faf5ff;
                                                            }

                                                            .poll-option-btn.selected.going {
                                                                border-color: #22c55e;
                                                                background: #f0fdf4;
                                                                color: #16a34a;
                                                            }

                                                            .poll-option-btn.selected.not_going {
                                                                border-color: #ef4444;
                                                                background: #fef2f2;
                                                                color: #dc2626;
                                                            }

                                                            .poll-option-btn.selected.maybe {
                                                                border-color: #f59e0b;
                                                                background: #fffbeb;
                                                                color: #d97706;
                                                            }

                                                            .poll-option-left {
                                                                display: flex;
                                                                align-items: center;
                                                                gap: 10px;
                                                            }

                                                            .poll-option-icon {
                                                                width: 28px;
                                                                height: 28px;
                                                                border-radius: 8px;
                                                                display: flex;
                                                                align-items: center;
                                                                justify-content: center;
                                                                font-size: 16px;
                                                            }

                                                            .poll-option-count {
                                                                font-size: 13px;
                                                                color: #9ca3af;
                                                                font-weight: 500;
                                                            }

                                                            .poll-bar-container {
                                                                height: 4px;
                                                                background: #e5e7eb;
                                                                border-radius: 2px;
                                                                margin-top: 6px;
                                                                overflow: hidden;
                                                            }

                                                            .poll-bar {
                                                                height: 100%;
                                                                border-radius: 2px;
                                                                transition: width 0.5s ease;
                                                            }

                                                            .poll-bar.going {
                                                                background: #22c55e;
                                                            }

                                                            .poll-bar.not_going {
                                                                background: #ef4444;
                                                            }

                                                            .poll-bar.maybe {
                                                                background: #f59e0b;
                                                            }

                                                            .poll-total {
                                                                font-size: 13px;
                                                                color: #6b7280;
                                                                text-align: center;
                                                                padding-top: 8px;
                                                            }

                                                            .poll-voters-section {
                                                                margin-top: 16px;
                                                                border-top: 1px solid #e5e7eb;
                                                                padding-top: 12px;
                                                            }

                                                            .poll-voters-toggle {
                                                                font-size: 13px;
                                                                color: #9A74D8;
                                                                cursor: pointer;
                                                                font-weight: 600;
                                                                background: none;
                                                                border: none;
                                                                padding: 0;
                                                            }

                                                            .poll-voters-toggle:hover {
                                                                text-decoration: underline;
                                                            }

                                                            .poll-voters-list {
                                                                margin-top: 12px;
                                                                display: none;
                                                            }

                                                            .poll-voters-list.show {
                                                                display: block;
                                                            }

                                                            .poll-voter-item {
                                                                display: flex;
                                                                align-items: center;
                                                                gap: 10px;
                                                                padding: 8px 0;
                                                                border-bottom: 1px solid #f3f4f6;
                                                            }

                                                            .poll-voter-item:last-child {
                                                                border-bottom: none;
                                                            }

                                                            .poll-voter-avatar {
                                                                width: 32px;
                                                                height: 32px;
                                                                border-radius: 50%;
                                                                background: #e5e7eb;
                                                                display: flex;
                                                                align-items: center;
                                                                justify-content: center;
                                                                font-size: 12px;
                                                                font-weight: 700;
                                                                color: #6b7280;
                                                                flex-shrink: 0;
                                                            }

                                                            .poll-voter-name {
                                                                font-size: 14px;
                                                                font-weight: 500;
                                                                color: #374151;
                                                                flex: 1;
                                                            }

                                                            .poll-voter-vote {
                                                                font-size: 12px;
                                                                padding: 3px 10px;
                                                                border-radius: 20px;
                                                                font-weight: 600;
                                                            }

                                                            .poll-voter-vote.going {
                                                                background: #dcfce7;
                                                                color: #16a34a;
                                                            }

                                                            .poll-voter-vote.not_going {
                                                                background: #fee2e2;
                                                                color: #dc2626;
                                                            }

                                                            .poll-voter-vote.maybe {
                                                                background: #fef3c7;
                                                                color: #d97706;
                                                            }
                                                        </style>
                                                    </head>

                                                    <body>
                                                        <div class="event-viewer-wrapper">
                                                            <div class="event-viewer-container">
                                                                <!-- Navigation Header -->
                                                                <div class="viewer-header">
                                                                    <button class="nav-btn prev-event" id="prevEvent"
                                                                        onclick="window.history.back();"
                                                                        style="cursor: pointer;">
                                                                        <svg width="20" height="20" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2.5" stroke-linecap="round"
                                                                            stroke-linejoin="round">
                                                                            <polyline points="15 18 9 12 15 6">
                                                                            </polyline>
                                                                        </svg>
                                                                        Back
                                                                    </button>
                                                                    <h1 class="event-title" id="eventTitle">
                                                                        <%= event.getTitle() %>
                                                                    </h1>
                                                                    <button class="nav-btn next-event" id="nextEvent"
                                                                        style="visibility: hidden;">Next
                                                                        <svg width="20" height="20" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2.5" stroke-linecap="round"
                                                                            stroke-linejoin="round">
                                                                            <polyline points="9 18 15 12 9 6">
                                                                            </polyline>
                                                                        </svg>
                                                                    </button>
                                                                </div>

                                                                <!-- Event Banner -->
                                                                <div class="event-banner-container">
                                                                    <img src="<%= eventPicUrl %>"
                                                                        alt="<%= event.getTitle() %>" id="eventBanner"
                                                                        class="event-banner-img">
                                                                </div>

                                                                <!-- Event Info -->
                                                                <div class="event-info-section">
                                                                    <div class="info-row">
                                                                        <div class="info-item">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2"
                                                                                stroke-linecap="round"
                                                                                stroke-linejoin="round">
                                                                                <rect x="3" y="4" width="18" height="18"
                                                                                    rx="2" ry="2"></rect>
                                                                                <line x1="16" y1="2" x2="16" y2="6">
                                                                                </line>
                                                                                <line x1="8" y1="2" x2="8" y2="6">
                                                                                </line>
                                                                                <line x1="3" y1="10" x2="21" y2="10">
                                                                                </line>
                                                                            </svg>
                                                                            <span id="eventDate">
                                                                                <%= formattedDate %>
                                                                            </span>
                                                                        </div>
                                                                        <div class="info-item">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2"
                                                                                stroke-linecap="round"
                                                                                stroke-linejoin="round">
                                                                                <path
                                                                                    d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2">
                                                                                </path>
                                                                                <circle cx="9" cy="7" r="4"></circle>
                                                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87">
                                                                                </path>
                                                                                <path d="M16 3.13a4 4 0 0 1 0 7.75">
                                                                                </path>
                                                                            </svg>
                                                                            <span id="eventGroup">
                                                                                <%= groupNamesStr.toString() %>
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Event Description -->
                                                                <div class="event-description-section">
                                                                    <h3 class="section-title">About This Event</h3>
                                                                    <p class="event-description" id="eventDescription">
                                                                        <%= event.getDescription() !=null &&
                                                                            !event.getDescription().isEmpty() ?
                                                                            event.getDescription()
                                                                            : "No description available for this event."
                                                                            %>
                                                                    </p>
                                                                </div>

                                                                <!-- Voting Polls Section -->
                                                                <% if (!pollGroups.isEmpty()) { EventVoteDAO voteDAO=new
                                                                    EventVoteDAO(); %>
                                                                    <div class="polls-section">
                                                                        <div class="polls-section-title">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="#9A74D8" stroke-width="2.5"
                                                                                stroke-linecap="round"
                                                                                stroke-linejoin="round">
                                                                                <path
                                                                                    d="M22 11.08V12a10 10 0 1 1-5.93-9.14">
                                                                                </path>
                                                                                <polyline
                                                                                    points="22 4 12 14.01 9 11.01">
                                                                                </polyline>
                                                                            </svg>
                                                                            Event Polls
                                                                        </div>

                                                                        <% for (Group pollGroup : pollGroups) { int
                                                                            pgId=pollGroup.getGroupId(); int
                                                                            eId=event.getEventId(); Map<String, Integer>
                                                                            vc = voteDAO.getVoteCounts(eId, pgId);
                                                                            String uv = voteDAO.getUserVote(eId, pgId,
                                                                            userId);
                                                                            List<Map<String, Object>> voters =
                                                                                voteDAO.getVoters(eId, pgId);
                                                                                int total = vc.get("total");
                                                                                int gc = vc.get("going");
                                                                                int ngc = vc.get("not_going");
                                                                                int mc = vc.get("maybe");
                                                                                %>
                                                                                <div class="event-poll-container"
                                                                                    data-event-id="<%= eId %>"
                                                                                    data-group-id="<%= pgId %>">
                                                                                    <div class="poll-group-name">
                                                                                        <svg width="16" height="16"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2">
                                                                                            <path
                                                                                                d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2">
                                                                                            </path>
                                                                                            <circle cx="9" cy="7" r="4">
                                                                                            </circle>
                                                                                        </svg>
                                                                                        <%= pollGroup.getName() %>
                                                                                    </div>
                                                                                    <div class="poll-title">Are you
                                                                                        going?</div>
                                                                                    <p class="poll-subtitle">Tap an
                                                                                        option to vote. Tap again to
                                                                                        un-vote.</p>

                                                                                    <div class="poll-options">
                                                                                        <button type="button"
                                                                                            class="poll-option-btn <%= "going".equals(uv)
                                                                                            ? "selected going" : "" %>"
                                                                                            onclick="castVote(<%= eId %>
                                                                                                , <%= pgId %>, 'going',
                                                                                                    this)">
                                                                                                    <span
                                                                                                        class="poll-option-left"><span
                                                                                                            class="poll-option-icon">✅</span><span>Going</span></span>
                                                                                                    <span
                                                                                                        class="poll-option-count"
                                                                                                        id="count-going-<%= pgId %>">
                                                                                                        <%= gc %>
                                                                                                    </span>
                                                                                        </button>
                                                                                        <div class="poll-bar-container">
                                                                                            <div class="poll-bar going"
                                                                                                id="bar-going-<%= pgId %>"
                                                                                                style="width: <%= total > 0 ? (gc * 100 / total) : 0 %>%">
                                                                                            </div>
                                                                                        </div>

                                                                                        <button type="button"
                                                                                            class="poll-option-btn <%= "not_going".equals(uv)
                                                                                            ? "selected not_going" : ""
                                                                                            %>"
                                                                                            onclick="castVote(<%= eId %>
                                                                                                , <%= pgId %>,
                                                                                                    'not_going', this)">
                                                                                                    <span
                                                                                                        class="poll-option-left"><span
                                                                                                            class="poll-option-icon">❌</span><span>Not
                                                                                                            Going</span></span>
                                                                                                    <span
                                                                                                        class="poll-option-count"
                                                                                                        id="count-not_going-<%= pgId %>">
                                                                                                        <%= ngc %>
                                                                                                    </span>
                                                                                        </button>
                                                                                        <div class="poll-bar-container">
                                                                                            <div class="poll-bar not_going"
                                                                                                id="bar-not_going-<%= pgId %>"
                                                                                                style="width: <%= total > 0 ? (ngc * 100 / total) : 0 %>%">
                                                                                            </div>
                                                                                        </div>

                                                                                        <button type="button"
                                                                                            class="poll-option-btn <%= "maybe".equals(uv)
                                                                                            ? "selected maybe" : "" %>"
                                                                                            onclick="castVote(<%= eId %>
                                                                                                , <%= pgId %>, 'maybe',
                                                                                                    this)">
                                                                                                    <span
                                                                                                        class="poll-option-left"><span
                                                                                                            class="poll-option-icon">🤔</span><span>Maybe</span></span>
                                                                                                    <span
                                                                                                        class="poll-option-count"
                                                                                                        id="count-maybe-<%= pgId %>">
                                                                                                        <%= mc %>
                                                                                                    </span>
                                                                                        </button>
                                                                                        <div class="poll-bar-container">
                                                                                            <div class="poll-bar maybe"
                                                                                                id="bar-maybe-<%= pgId %>"
                                                                                                style="width: <%= total > 0 ? (mc * 100 / total) : 0 %>%">
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>

                                                                                    <p class="poll-total"
                                                                                        id="poll-total-<%= pgId %>">
                                                                                        <%= total %> vote<%= total !=1
                                                                                                ? "s" : "" %>
                                                                                    </p>

                                                                                    <div class="poll-voters-section">
                                                                                        <button type="button"
                                                                                            class="poll-voters-toggle"
                                                                                            onclick="toggleVoters(<%= pgId %>)">Show
                                                                                            who voted</button>
                                                                                        <div class="poll-voters-list"
                                                                                            id="voters-list-<%= pgId %>">
                                                                                            <% if (voters !=null &&
                                                                                                !voters.isEmpty()) { for
                                                                                                (Map<String, Object>
                                                                                                voter : voters) {
                                                                                                String vn = (String)
                                                                                                voter.get("username");
                                                                                                String vv = (String)
                                                                                                voter.get("vote");
                                                                                                String vl =
                                                                                                "going".equals(vv) ?
                                                                                                "Going" :
                                                                                                "not_going".equals(vv) ?
                                                                                                "Not Going" : "Maybe";
                                                                                                %>
                                                                                                <div
                                                                                                    class="poll-voter-item">
                                                                                                    <div
                                                                                                        class="poll-voter-avatar">
                                                                                                        <%= vn.substring(0,
                                                                                                            1).toUpperCase()
                                                                                                            %>
                                                                                                    </div>
                                                                                                    <span
                                                                                                        class="poll-voter-name">
                                                                                                        <%= vn %>
                                                                                                    </span>
                                                                                                    <span
                                                                                                        class="poll-voter-vote <%= vv %>">
                                                                                                        <%= vl %>
                                                                                                    </span>
                                                                                                </div>
                                                                                                <% } } else { %>
                                                                                                    <p
                                                                                                        style="font-size: 13px; color: #9ca3af; padding: 8px 0;">
                                                                                                        No votes yet.
                                                                                                    </p>
                                                                                                    <% } %>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>
                                                                    </div>
                                                                    <% } %>

                                                                        <!-- Action Buttons -->
                                                                        <div class="action-buttons-section">
                                                                            <% if (isPastEvent) { %>
                                                                                <button class="primary-action-btn"
                                                                                    id="goToMemoryBtn">
                                                                                    <svg width="20" height="20"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2.5"
                                                                                        stroke-linecap="round"
                                                                                        stroke-linejoin="round">
                                                                                        <rect x="3" y="3" width="18"
                                                                                            height="18" rx="2" ry="2">
                                                                                        </rect>
                                                                                        <circle cx="8.5" cy="8.5"
                                                                                            r="1.5"></circle>
                                                                                        <polyline
                                                                                            points="21 15 16 10 5 21">
                                                                                        </polyline>
                                                                                    </svg>
                                                                                    Go to the Memory
                                                                                </button>
                                                                                <% } %>
                                                                                    <div class="secondary-actions">
                                                                                        <button
                                                                                            class="secondary-action-btn edit-btn"
                                                                                            id="editEventBtn">
                                                                                            <svg width="18" height="18"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2"
                                                                                                stroke-linecap="round"
                                                                                                stroke-linejoin="round">
                                                                                                <path
                                                                                                    d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                                                                                </path>
                                                                                                <path
                                                                                                    d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                                                                                </path>
                                                                                            </svg>
                                                                                            Edit Event
                                                                                        </button>
                                                                                        <button
                                                                                            class="secondary-action-btn delete-btn"
                                                                                            id="deleteEventBtn">
                                                                                            <svg width="18" height="18"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2"
                                                                                                stroke-linecap="round"
                                                                                                stroke-linejoin="round">
                                                                                                <polyline
                                                                                                    points="3 6 5 6 21 6">
                                                                                                </polyline>
                                                                                                <path
                                                                                                    d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                                                                                </path>
                                                                                            </svg>
                                                                                            Delete Event
                                                                                        </button>
                                                                                    </div>
                                                                        </div>
                                                            </div>
                                                        </div>

                                                        <!-- Hidden form for delete -->
                                                        <form id="deleteEventForm" method="POST"
                                                            action="${pageContext.request.contextPath}/deleteEvent"
                                                            style="display: none;">
                                                            <input type="hidden" name="event_id"
                                                                value="<%= eventIdParam %>">
                                                        </form>

                                                        <jsp:include page="../public/footer.jsp" />

                                                        <script>
                                                            document.addEventListener('DOMContentLoaded', () => {
                                                                const eventId = '<%= eventIdParam %>';
                                                                const contextPath = '${pageContext.request.contextPath}';
                                                                const groupId = '<%= event.getGroupId() %>';

                                                                const goToMemoryBtn = document.getElementById('goToMemoryBtn');
                                                                if (goToMemoryBtn) {
                                                                    goToMemoryBtn.addEventListener('click', () => {
                                                                        window.location.href = contextPath + '/groupmemories?groupId=' + groupId;
                                                                    });
                                                                }

                                                                document.getElementById('editEventBtn').addEventListener('click', () => {
                                                                    window.location.href = contextPath + '/editevent?event_id=' + eventId;
                                                                });

                                                                document.getElementById('deleteEventBtn').addEventListener('click', () => {
                                                                    if (confirm('Are you sure you want to delete this event?\n\nThis action cannot be undone.')) {
                                                                        document.getElementById('deleteEventForm').submit();
                                                                    }
                                                                });
                                                            });

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
                                                                            document.getElementById('poll-total-' + groupId).textContent =
                                                                                data.total + ' vote' + (data.total !== 1 ? 's' : '');

                                                                            const total = data.total || 1;
                                                                            document.getElementById('bar-going-' + groupId).style.width = (data.going * 100 / total) + '%';
                                                                            document.getElementById('bar-not_going-' + groupId).style.width = (data.not_going * 100 / total) + '%';
                                                                            document.getElementById('bar-maybe-' + groupId).style.width = (data.maybe * 100 / total) + '%';

                                                                            const container = btnEl.closest('.poll-options');
                                                                            container.querySelectorAll('.poll-option-btn').forEach(btn => {
                                                                                btn.classList.remove('selected', 'going', 'not_going', 'maybe');
                                                                            });
                                                                            if (data.userVote) {
                                                                                const btns = container.querySelectorAll('.poll-option-btn');
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
                                                                                list.innerHTML = '<p style="font-size: 13px; color: #9ca3af; padding: 8px 0;">No votes yet.</p>';
                                                                            } else {
                                                                                let html = '';
                                                                                data.voters.forEach(v => {
                                                                                    const label = v.vote === 'going' ? 'Going' : v.vote === 'not_going' ? 'Not Going' : 'Maybe';
                                                                                    html += '<div class="poll-voter-item">' +
                                                                                        '<div class="poll-voter-avatar">' + v.username.charAt(0).toUpperCase() + '</div>' +
                                                                                        '<span class="poll-voter-name">' + v.username + '</span>' +
                                                                                        '<span class="poll-voter-vote ' + v.vote + '">' + label + '</span></div>';
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
