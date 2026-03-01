<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.GroupAnnouncement" %>
        <%@ page import="com.demo.web.model.user" %>
            <%@ page import="com.demo.web.model.Event" %>
                <%@ page import="com.demo.web.dao.EventVoteDAO" %>
                    <%@ page import="com.demo.web.dao.EventDAO" %>
                        <%@ page import="java.util.Map" %>
                            <%@ page import="java.util.List" %>
                                <%@ page import="java.text.SimpleDateFormat" %>
                                    <% GroupAnnouncement ga=(GroupAnnouncement) request.getAttribute("announcement");
                                        Integer currentUserId=(Integer) session.getAttribute("user_id"); if
                                        (currentUserId==null) { response.sendRedirect(request.getContextPath()
                                        + "/login" ); return; } if (ga==null) {
                                        response.sendRedirect(request.getContextPath() + "/events" ); return; } String
                                        authorInitial=(ga.getPostedBy() !=null) ?
                                        ga.getPostedBy().getUsername().substring(0, 1).toUpperCase() : "A" ; String
                                        authorName=(ga.getPostedBy() !=null) ? ga.getPostedBy().getUsername()
                                        : "Unknown" ; String postDate=ga.getCreatedAt() !=null ?
                                        ga.getCreatedAt().toString() : "" ; boolean hasEvent=(ga.getEventId() !=null);
                                        // Load event data if linked Event linkedEvent=null; String eventPicUrl=null;
                                        String formattedEventDate="" ; if (hasEvent) { try { EventDAO eventDAO=new
                                        EventDAO(); linkedEvent=eventDAO.findById(ga.getEventId()); if (linkedEvent
                                        !=null) { if (linkedEvent.getEventPicUrl() !=null &&
                                        !linkedEvent.getEventPicUrl().isEmpty()) { eventPicUrl=request.getContextPath()
                                        + "/" + linkedEvent.getEventPicUrl(); } formattedEventDate=new
                                        SimpleDateFormat("MMMM dd, yyyy").format(linkedEvent.getEventDate()); } } catch
                                        (Exception e) { System.err.println("Error loading linked event: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang=" en">

                                        <head>
                                            <meta charset="UTF-8">
                                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                            <title>
                                                <%= ga.getTitle() %> - Everly
                                            </title>
                                            <link
                                                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                                                rel="stylesheet">
                                            <link rel="stylesheet"
                                                href="${pageContext.request.contextPath}/resources/css/base.css">
                                            <link rel="stylesheet"
                                                href="${pageContext.request.contextPath}/resources/css/memoryviewer.css">
                                            <style>
                                                /* Announcement-specific overrides */
                                                .mv-media-section {
                                                    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
                                                    position: relative;
                                                }

                                                /* Announcement content display in left pane */
                                                .ann-content-area {
                                                    width: 100%;
                                                    height: 500px;
                                                    display: flex;
                                                    align-items: center;
                                                    justify-content: center;
                                                    position: relative;
                                                    overflow: hidden;
                                                }

                                                .ann-content-page {
                                                    width: 88%;
                                                    max-height: 90%;
                                                    background: white;
                                                    border-radius: 8px;
                                                    box-shadow: 0 4px 24px rgba(0, 0, 0, 0.15);
                                                    padding: 36px 32px;
                                                    overflow-y: auto;
                                                }

                                                .ann-content-page::-webkit-scrollbar {
                                                    width: 3px;
                                                }

                                                .ann-content-page::-webkit-scrollbar-thumb {
                                                    background: rgba(0, 0, 0, 0.12);
                                                    border-radius: 2px;
                                                }

                                                .ann-content-text {
                                                    font-family: 'Plus Jakarta Sans', sans-serif;
                                                    font-size: 16px;
                                                    line-height: 1.85;
                                                    color: #1e293b;
                                                    white-space: pre-wrap;
                                                }

                                                /* Event banner display instead of text */
                                                .ann-event-banner {
                                                    width: 100%;
                                                    height: 500px;
                                                    overflow: hidden;
                                                }

                                                .ann-event-banner img {
                                                    width: 100%;
                                                    height: 100%;
                                                    object-fit: cover;
                                                }

                                                /* ========== Voting Poll Styles (compact for right panel) ========== */
                                                .ev-poll-card {
                                                    background: #f9fafb;
                                                    border: 1px solid #f3f4f6;
                                                    border-radius: 12px;
                                                    padding: 16px;
                                                    margin-bottom: 8px;
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

                                                /* Event link badge */
                                                .ev-event-link {
                                                    display: inline-flex;
                                                    align-items: center;
                                                    gap: 6px;
                                                    font-size: 12px;
                                                    font-weight: 600;
                                                    color: #9A74D8;
                                                    background: #f3f0ff;
                                                    padding: 4px 10px;
                                                    border-radius: 12px;
                                                    text-decoration: none;
                                                    transition: background 0.15s;
                                                    margin-top: 4px;
                                                }

                                                .ev-event-link:hover {
                                                    background: #e8e0ff;
                                                }
                                            </style>
                                        </head>

                                        <body>
                                            <div class="mv-page">
                                                <!-- Close button -->
                                                <a href="${pageContext.request.contextPath}/groupannouncement?groupId=<%= ga.getGroupId() %>"
                                                    class="mv-close-btn">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                                    </svg>
                                                </a>

                                                <div class="mv-wrapper">
                                                    <!-- LEFT: Announcement Content or Event Banner -->
                                                    <div class="mv-media-section">
                                                        <% if (hasEvent && eventPicUrl !=null) { %>
                                                            <div class="ann-event-banner">
                                                                <img src="<%= eventPicUrl %>" alt="Event">
                                                            </div>
                                                            <% } else { %>
                                                                <div class="ann-content-area">
                                                                    <div class="ann-content-page">
                                                                        <div class="ann-content-text">
                                                                            <%= ga.getContent() %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <% } %>
                                                    </div>

                                                    <!-- RIGHT: Details Section -->
                                                    <div class="mv-details-section">
                                                        <!-- Header -->
                                                        <div class="mv-header">
                                                            <div class="mv-header-left">
                                                                <div class="mv-avatar">
                                                                    <%= authorInitial %>
                                                                </div>
                                                                <div class="mv-header-text">
                                                                    <h3>
                                                                        <%= authorName %>
                                                                    </h3>
                                                                    <div class="mv-type-badge">
                                                                        <svg width="10" height="10" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2.5">
                                                                            <path
                                                                                d="M22 11.08V12a10 10 0 1 1-5.93-9.14">
                                                                            </path>
                                                                            <polyline points="22 4 12 14.01 9 11.01">
                                                                            </polyline>
                                                                        </svg>
                                                                        Announcement
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Scrollable Content -->
                                                        <div class="mv-content">
                                                            <!-- Title -->
                                                            <div class="mv-info-group">
                                                                <div class="mv-info-value title">
                                                                    <%= ga.getTitle() %>
                                                                </div>
                                                            </div>

                                                            <div class="mv-divider"></div>

                                                            <!-- Date -->
                                                            <div class="mv-info-group">
                                                                <div class="mv-info-label">Posted</div>
                                                                <div class="mv-info-value date">
                                                                    <svg viewBox="0 0 24 24" fill="none"
                                                                        stroke="currentColor" stroke-width="2">
                                                                        <circle cx="12" cy="12" r="10"></circle>
                                                                        <polyline points="12 6 12 12 16 14"></polyline>
                                                                    </svg>
                                                                    <%= postDate %>
                                                                </div>
                                                            </div>

                                                            <!-- If event banner was shown on left, show content here -->
                                                            <% if (hasEvent && eventPicUrl !=null) { %>
                                                                <div class="mv-info-group">
                                                                    <div class="mv-info-label">Content</div>
                                                                    <div class="mv-info-value"
                                                                        style="white-space: pre-wrap; font-size: 13px;">
                                                                        <%= ga.getContent() %>
                                                                    </div>
                                                                </div>
                                                                <% } %>

                                                                    <!-- Linked Event Info -->
                                                                    <% if (hasEvent && linkedEvent !=null) { %>
                                                                        <div class="mv-divider"></div>
                                                                        <div class="mv-info-group">
                                                                            <div class="mv-info-label">Event</div>
                                                                            <div class="mv-info-value"
                                                                                style="font-weight: 600;">
                                                                                <%= linkedEvent.getTitle() %>
                                                                            </div>
                                                                            <div class="mv-info-value date"
                                                                                style="margin-top: 4px;">
                                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <rect x="3" y="4" width="18"
                                                                                        height="18" rx="2" ry="2">
                                                                                    </rect>
                                                                                    <line x1="16" y1="2" x2="16" y2="6">
                                                                                    </line>
                                                                                    <line x1="8" y1="2" x2="8" y2="6">
                                                                                    </line>
                                                                                    <line x1="3" y1="10" x2="21"
                                                                                        y2="10"></line>
                                                                                </svg>
                                                                                <%= formattedEventDate %>
                                                                            </div>
                                                                            <a href="${pageContext.request.contextPath}/eventinfo?id=<%= ga.getEventId() %>"
                                                                                class="ev-event-link">
                                                                                <svg width="10" height="10"
                                                                                    viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2.5">
                                                                                    <rect x="3" y="4" width="18"
                                                                                        height="18" rx="2" ry="2">
                                                                                    </rect>
                                                                                    <line x1="16" y1="2" x2="16" y2="6">
                                                                                    </line>
                                                                                    <line x1="8" y1="2" x2="8" y2="6">
                                                                                    </line>
                                                                                </svg>
                                                                                View Full Event
                                                                            </a>
                                                                        </div>

                                                                        <!-- Voting Poll (scoped to this group only) -->
                                                                        <% EventVoteDAO voteDAO=new EventVoteDAO(); int
                                                                            pollEventId=ga.getEventId(); int
                                                                            pollGroupId=ga.getGroupId(); Map<String,
                                                                            Integer> voteCounts =
                                                                            voteDAO.getVoteCounts(pollEventId,
                                                                            pollGroupId);
                                                                            String userCurrentVote =
                                                                            voteDAO.getUserVote(pollEventId,
                                                                            pollGroupId, currentUserId);
                                                                            List<Map<String, Object>> voters =
                                                                                voteDAO.getVoters(pollEventId,
                                                                                pollGroupId);
                                                                                int totalVotes =
                                                                                voteCounts.get("total");
                                                                                int goingCount =
                                                                                voteCounts.get("going");
                                                                                int notGoingCount =
                                                                                voteCounts.get("not_going");
                                                                                int maybeCount =
                                                                                voteCounts.get("maybe");
                                                                                %>
                                                                                <div class="mv-divider"></div>
                                                                                <div class="mv-info-group">
                                                                                    <div class="mv-info-label"
                                                                                        style="display: flex; align-items: center; gap: 5px;">
                                                                                        <svg width="10" height="10"
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
                                                                                        Poll
                                                                                    </div>

                                                                                    <div class="ev-poll-card">
                                                                                        <div class="ev-poll-question">
                                                                                            Are you going?</div>
                                                                                        <p class="ev-poll-hint">Tap to
                                                                                            vote. Tap again to un-vote.
                                                                                        </p>

                                                                                        <div class="ev-poll-options">
                                                                                            <button type="button"
                                                                                                class="ev-poll-btn <%= "
                                                                                                going".equals(userCurrentVote)
                                                                                                ? "selected going" : ""
                                                                                                %>" onclick="castVote(
                                                                                                <%= pollEventId %>, <%=
                                                                                                        pollGroupId %>,
                                                                                                        'going', this)">
                                                                                                        <span
                                                                                                            class="ev-poll-btn-left"><span
                                                                                                                class="ev-poll-btn-icon">✅</span>Going</span>
                                                                                                        <span
                                                                                                            class="ev-poll-count"
                                                                                                            id="count-going-<%= pollGroupId %>">
                                                                                                            <%= goingCount
                                                                                                                %>
                                                                                                        </span>
                                                                                            </button>
                                                                                            <div
                                                                                                class="ev-poll-bar-wrap">
                                                                                                <div class="ev-poll-bar going"
                                                                                                    id="bar-going-<%= pollGroupId %>"
                                                                                                    style="width:<%= totalVotes > 0 ? (goingCount * 100 / totalVotes) : 0 %>%">
                                                                                                </div>
                                                                                            </div>

                                                                                            <button type="button"
                                                                                                class="ev-poll-btn <%= "
                                                                                                not_going".equals(userCurrentVote)
                                                                                                ? "selected not_going"
                                                                                                : "" %>"
                                                                                                onclick="castVote(<%=
                                                                                                    pollEventId %>, <%=
                                                                                                        pollGroupId %>,
                                                                                                        'not_going',
                                                                                                        this)">
                                                                                                        <span
                                                                                                            class="ev-poll-btn-left"><span
                                                                                                                class="ev-poll-btn-icon">❌</span>Not
                                                                                                            Going</span>
                                                                                                        <span
                                                                                                            class="ev-poll-count"
                                                                                                            id="count-not_going-<%= pollGroupId %>">
                                                                                                            <%= notGoingCount
                                                                                                                %>
                                                                                                        </span>
                                                                                            </button>
                                                                                            <div
                                                                                                class="ev-poll-bar-wrap">
                                                                                                <div class="ev-poll-bar not_going"
                                                                                                    id="bar-not_going-<%= pollGroupId %>"
                                                                                                    style="width:<%= totalVotes > 0 ? (notGoingCount * 100 / totalVotes) : 0 %>%">
                                                                                                </div>
                                                                                            </div>

                                                                                            <button type="button"
                                                                                                class="ev-poll-btn <%= "
                                                                                                maybe".equals(userCurrentVote)
                                                                                                ? "selected maybe" : ""
                                                                                                %>" onclick="castVote(
                                                                                                <%= pollEventId %>, <%=
                                                                                                        pollGroupId %>,
                                                                                                        'maybe', this)">
                                                                                                        <span
                                                                                                            class="ev-poll-btn-left"><span
                                                                                                                class="ev-poll-btn-icon">🤔</span>Maybe</span>
                                                                                                        <span
                                                                                                            class="ev-poll-count"
                                                                                                            id="count-maybe-<%= pollGroupId %>">
                                                                                                            <%= maybeCount
                                                                                                                %>
                                                                                                        </span>
                                                                                            </button>
                                                                                            <div
                                                                                                class="ev-poll-bar-wrap">
                                                                                                <div class="ev-poll-bar maybe"
                                                                                                    id="bar-maybe-<%= pollGroupId %>"
                                                                                                    style="width:<%= totalVotes > 0 ? (maybeCount * 100 / totalVotes) : 0 %>%">
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>

                                                                                        <p class="ev-poll-total"
                                                                                            id="poll-total-<%= pollGroupId %>">
                                                                                            <%= totalVotes %> vote<%=
                                                                                                    totalVotes !=1 ? "s"
                                                                                                    : "" %>
                                                                                        </p>

                                                                                        <button type="button"
                                                                                            class="ev-poll-voters-toggle"
                                                                                            onclick="toggleVoters(<%= pollGroupId %>)">Show
                                                                                            who voted</button>
                                                                                        <div class="ev-poll-voters-list"
                                                                                            id="voters-list-<%= pollGroupId %>">
                                                                                            <% if (voters !=null &&
                                                                                                !voters.isEmpty()) { for
                                                                                                (Map<String, Object>
                                                                                                voter : voters) {
                                                                                                String voterName =
                                                                                                (String)
                                                                                                voter.get("username");
                                                                                                String voterVote =
                                                                                                (String)
                                                                                                voter.get("vote");
                                                                                                String voteLabel =
                                                                                                "going".equals(voterVote)
                                                                                                ? "Going" :
                                                                                                "not_going".equals(voterVote)
                                                                                                ? "Not Going" : "Maybe";
                                                                                                %>
                                                                                                <div
                                                                                                    class="ev-poll-voter">
                                                                                                    <div
                                                                                                        class="ev-poll-voter-avatar">
                                                                                                        <%= voterName.substring(0,
                                                                                                            1).toUpperCase()
                                                                                                            %>
                                                                                                    </div>
                                                                                                    <span
                                                                                                        class="ev-poll-voter-name">
                                                                                                        <%= voterName %>
                                                                                                    </span>
                                                                                                    <span
                                                                                                        class="ev-poll-voter-badge <%= voterVote %>">
                                                                                                        <%= voteLabel %>
                                                                                                    </span>
                                                                                                </div>
                                                                                                <% } } else { %>
                                                                                                    <p
                                                                                                        style="font-size: 12px; color: #9ca3af; padding: 6px 0;">
                                                                                                        No votes yet.
                                                                                                    </p>
                                                                                                    <% } %>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>
                                                        </div>

                                                        <!-- Actions Bar -->
                                                        <div class="mv-actions-bar">
                                                            <a href="${pageContext.request.contextPath}/groupannouncement?groupId=<%= ga.getGroupId() %>"
                                                                class="mv-action-btn secondary">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <line x1="19" y1="12" x2="5" y2="12"></line>
                                                                    <polyline points="12 19 5 12 12 5"></polyline>
                                                                </svg>
                                                                Back
                                                            </a>
                                                            <% if (hasEvent) { %>
                                                                <a href="${pageContext.request.contextPath}/eventinfo?id=<%= ga.getEventId() %>"
                                                                    class="mv-action-btn primary">
                                                                    <svg viewBox="0 0 24 24" fill="none"
                                                                        stroke="currentColor" stroke-width="2">
                                                                        <rect x="3" y="4" width="18" height="18" rx="2"
                                                                            ry="2"></rect>
                                                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                                                    </svg>
                                                                    Full Event
                                                                </a>
                                                                <% } %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

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