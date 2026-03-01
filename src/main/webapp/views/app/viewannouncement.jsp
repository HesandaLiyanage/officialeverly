<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.GroupAnnouncement" %>
        <%@ page import="com.demo.web.model.user" %>
            <%@ page import="com.demo.web.dao.EventVoteDAO" %>
                <%@ page import="java.util.Map" %>
                    <%@ page import="java.util.List" %>
                        <jsp:include page="../public/header2.jsp" />
                        <html>

                        <head>
                            <title>Announcement Details - Everly</title>
                            <link rel="stylesheet" type="text/css"
                                href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
                            <style>
                                .announcement-detail-container {
                                    max-width: 900px;
                                    margin: 40px auto;
                                    background: white;
                                    padding: 50px;
                                    border-radius: 24px;
                                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
                                }

                                .detail-header {
                                    border-bottom: 2px solid #f3f4f6;
                                    margin-bottom: 30px;
                                    padding-bottom: 20px;
                                }

                                .detail-title {
                                    font-size: 36px;
                                    font-weight: 800;
                                    color: #111827;
                                    margin-bottom: 20px;
                                    line-height: 1.2;
                                    letter-spacing: -1px;
                                }

                                .author-meta {
                                    display: flex;
                                    align-items: center;
                                    gap: 12px;
                                }

                                .author-avatar {
                                    width: 44px;
                                    height: 44px;
                                    border-radius: 50%;
                                    background: #9A74D8;
                                    color: white;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    font-weight: 700;
                                    font-size: 16px;
                                }

                                .author-info {
                                    display: flex;
                                    flex-direction: column;
                                }

                                .author-name {
                                    font-weight: 700;
                                    color: #374151;
                                    font-size: 15px;
                                }

                                .post-date {
                                    font-size: 13px;
                                    color: #9ca3af;
                                    font-weight: 500;
                                }

                                .detail-content {
                                    font-size: 18px;
                                    line-height: 1.8;
                                    color: #374151;
                                    white-space: pre-wrap;
                                    margin-bottom: 40px;
                                }

                                .detail-footer {
                                    border-top: 2px solid #f3f4f6;
                                    padding-top: 30px;
                                }

                                .back-link {
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 8px;
                                    color: #9A74D8;
                                    text-decoration: none;
                                    font-weight: 700;
                                    font-size: 15px;
                                    transition: all 0.2s ease;
                                }

                                .back-link:hover {
                                    color: #8a64c8;
                                    transform: translateX(-4px);
                                }

                                /* ======================== */
                                /* Event Poll / Voting UI   */
                                /* ======================== */
                                .event-poll-container {
                                    background: #f9fafb;
                                    border: 1px solid #e5e7eb;
                                    border-radius: 16px;
                                    padding: 24px;
                                    margin-bottom: 30px;
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

                                .poll-option-btn.selected {
                                    border-color: #9A74D8;
                                    background: linear-gradient(135deg, #f3e8ff, #ede9fe);
                                    color: #7c3aed;
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
                            <% GroupAnnouncement ga=(GroupAnnouncement) request.getAttribute("announcement"); Integer
                                currentUserId=(Integer) session.getAttribute("user_id"); %>
                                <div class="page-wrapper">
                                    <div class="announcement-detail-container">
                                        <div class="detail-header">
                                            <h1 class="detail-title">
                                                <%= ga !=null ? ga.getTitle() : "Announcement" %>
                                            </h1>
                                            <div class="author-meta">
                                                <div class="author-avatar">
                                                    <%= ga !=null && ga.getPostedBy() !=null ?
                                                        ga.getPostedBy().getUsername().substring(0, 1).toUpperCase()
                                                        : "A" %>
                                                </div>
                                                <div class="author-info">
                                                    <span class="author-name">Posted by <%= ga !=null &&
                                                            ga.getPostedBy() !=null ? ga.getPostedBy().getUsername()
                                                            : "Unknown" %></span>
                                                    <span class="post-date">
                                                        <%= ga !=null ? ga.getCreatedAt().toString() : "" %>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="detail-content">
                                            <%= ga !=null ? ga.getContent() : "" %>
                                        </div>

                                        <% if (ga !=null && ga.getEventId() !=null) { %>
                                            <!-- "Go to Event" button -->
                                            <div style="margin-bottom: 24px;">
                                                <a href="${pageContext.request.contextPath}/eventinfo?id=<%= ga.getEventId() %>"
                                                    style="display: inline-flex; align-items: center; gap: 10px; padding: 14px 28px; background: linear-gradient(135deg, #9A74D8, #7c5cbf); color: white; text-decoration: none; border-radius: 14px; font-weight: 700; font-size: 15px; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(154, 116, 216, 0.3);"
                                                    onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 20px rgba(154, 116, 216, 0.4)';"
                                                    onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 15px rgba(154, 116, 216, 0.3)';">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                        stroke-linejoin="round">
                                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                                    </svg>
                                                    Go to Event
                                                </a>
                                            </div>

                                            <!-- Event Voting Poll (only for this group's context) -->
                                            <% EventVoteDAO voteDAO=new EventVoteDAO(); int pollEventId=ga.getEventId();
                                                int pollGroupId=ga.getGroupId(); Map<String, Integer> voteCounts =
                                                voteDAO.getVoteCounts(pollEventId, pollGroupId);
                                                String userCurrentVote = voteDAO.getUserVote(pollEventId, pollGroupId,
                                                currentUserId);
                                                List<Map<String, Object>> voters = voteDAO.getVoters(pollEventId,
                                                    pollGroupId);
                                                    int totalVotes = voteCounts.get("total");
                                                    int goingCount = voteCounts.get("going");
                                                    int notGoingCount = voteCounts.get("not_going");
                                                    int maybeCount = voteCounts.get("maybe");
                                                    %>
                                                    <div class="event-poll-container" id="pollContainer"
                                                        data-event-id="<%= pollEventId %>"
                                                        data-group-id="<%= pollGroupId %>">
                                                        <div class="poll-title">
                                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                                stroke="#9A74D8" stroke-width="2.5"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                                            </svg>
                                                            Are you going?
                                                        </div>
                                                        <p class="poll-subtitle">Tap an option to vote. Tap again to
                                                            un-vote.</p>

                                                        <div class="poll-options">
                                                            <!-- Going -->
                                                            <button type="button" class="poll-option-btn <%= "going".equals(userCurrentVote) ? "selected going" : ""
                                                                %>"
                                                                onclick="castVote(<%= pollEventId %>, <%= pollGroupId %>
                                                                        , 'going', this)">
                                                                        <span class="poll-option-left">
                                                                            <span class="poll-option-icon">✅</span>
                                                                            <span>Going</span>
                                                                        </span>
                                                                        <span class="poll-option-count"
                                                                            id="count-going-<%= pollGroupId %>">
                                                                            <%= goingCount %>
                                                                        </span>
                                                            </button>
                                                            <div class="poll-bar-container">
                                                                <div class="poll-bar going"
                                                                    id="bar-going-<%= pollGroupId %>"
                                                                    style="width: <%= totalVotes > 0 ? (goingCount * 100 / totalVotes) : 0 %>%">
                                                                </div>
                                                            </div>

                                                            <!-- Not Going -->
                                                            <button type="button" class="poll-option-btn <%= "not_going".equals(userCurrentVote)
                                                                ? "selected not_going" : "" %>"
                                                                onclick="castVote(<%= pollEventId %>, <%= pollGroupId %>
                                                                        , 'not_going', this)">
                                                                        <span class="poll-option-left">
                                                                            <span class="poll-option-icon">❌</span>
                                                                            <span>Not Going</span>
                                                                        </span>
                                                                        <span class="poll-option-count"
                                                                            id="count-not_going-<%= pollGroupId %>">
                                                                            <%= notGoingCount %>
                                                                        </span>
                                                            </button>
                                                            <div class="poll-bar-container">
                                                                <div class="poll-bar not_going"
                                                                    id="bar-not_going-<%= pollGroupId %>"
                                                                    style="width: <%= totalVotes > 0 ? (notGoingCount * 100 / totalVotes) : 0 %>%">
                                                                </div>
                                                            </div>

                                                            <!-- Maybe -->
                                                            <button type="button" class="poll-option-btn <%= "maybe".equals(userCurrentVote) ? "selected maybe" : ""
                                                                %>"
                                                                onclick="castVote(<%= pollEventId %>, <%= pollGroupId %>
                                                                        , 'maybe', this)">
                                                                        <span class="poll-option-left">
                                                                            <span class="poll-option-icon">🤔</span>
                                                                            <span>Maybe</span>
                                                                        </span>
                                                                        <span class="poll-option-count"
                                                                            id="count-maybe-<%= pollGroupId %>">
                                                                            <%= maybeCount %>
                                                                        </span>
                                                            </button>
                                                            <div class="poll-bar-container">
                                                                <div class="poll-bar maybe"
                                                                    id="bar-maybe-<%= pollGroupId %>"
                                                                    style="width: <%= totalVotes > 0 ? (maybeCount * 100 / totalVotes) : 0 %>%">
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <p class="poll-total" id="poll-total-<%= pollGroupId %>">
                                                            <%= totalVotes %> vote<%= totalVotes !=1 ? "s" : "" %>
                                                        </p>

                                                        <!-- Voters Section -->
                                                        <div class="poll-voters-section">
                                                            <button type="button" class="poll-voters-toggle"
                                                                onclick="toggleVoters(<%= pollGroupId %>)">
                                                                Show who voted
                                                            </button>
                                                            <div class="poll-voters-list"
                                                                id="voters-list-<%= pollGroupId %>">
                                                                <% if (voters !=null && !voters.isEmpty()) { for
                                                                    (Map<String, Object> voter : voters) {
                                                                    String voterName = (String) voter.get("username");
                                                                    String voterVote = (String) voter.get("vote");
                                                                    String voteLabel = "going".equals(voterVote) ?
                                                                    "Going" :
                                                                    "not_going".equals(voterVote) ? "Not Going" :
                                                                    "Maybe";
                                                                    %>
                                                                    <div class="poll-voter-item">
                                                                        <div class="poll-voter-avatar">
                                                                            <%= voterName.substring(0, 1).toUpperCase()
                                                                                %>
                                                                        </div>
                                                                        <span class="poll-voter-name">
                                                                            <%= voterName %>
                                                                        </span>
                                                                        <span class="poll-voter-vote <%= voterVote %>">
                                                                            <%= voteLabel %>
                                                                        </span>
                                                                    </div>
                                                                    <% } } else { %>
                                                                        <p
                                                                            style="font-size: 13px; color: #9ca3af; padding: 8px 0;">
                                                                            No votes yet.</p>
                                                                        <% } %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>

                                                        <div class="detail-footer">
                                                            <a href="${pageContext.request.contextPath}/groupannouncement?groupId=<%= ga != null ? ga.getGroupId() : "" %>"
                                                                class="back-link">
                                                                <svg width="20" height="20" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2.5"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <line x1="19" y1="12" x2="5" y2="12"></line>
                                                                    <polyline points="12 19 5 12 12 5"></polyline>
                                                                </svg>
                                                                Back to All Announcements
                                                            </a>
                                                        </div>
                                    </div>
                                </div>

                                <jsp:include page="../public/footer.jsp" />

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
                                                    // Update counts
                                                    document.getElementById('count-going-' + groupId).textContent = data.going;
                                                    document.getElementById('count-not_going-' + groupId).textContent = data.not_going;
                                                    document.getElementById('count-maybe-' + groupId).textContent = data.maybe;
                                                    document.getElementById('poll-total-' + groupId).textContent =
                                                        data.total + ' vote' + (data.total !== 1 ? 's' : '');

                                                    // Update bars
                                                    const total = data.total || 1;
                                                    document.getElementById('bar-going-' + groupId).style.width = (data.going * 100 / total) + '%';
                                                    document.getElementById('bar-not_going-' + groupId).style.width = (data.not_going * 100 / total) + '%';
                                                    document.getElementById('bar-maybe-' + groupId).style.width = (data.maybe * 100 / total) + '%';

                                                    // Update selected states
                                                    const container = btnEl.closest('.poll-options');
                                                    container.querySelectorAll('.poll-option-btn').forEach(btn => {
                                                        btn.classList.remove('selected', 'going', 'not_going', 'maybe');
                                                    });
                                                    if (data.userVote) {
                                                        // Find the button for this vote
                                                        const btns = container.querySelectorAll('.poll-option-btn');
                                                        const idx = data.userVote === 'going' ? 0 : data.userVote === 'not_going' ? 1 : 2;
                                                        btns[idx].classList.add('selected', data.userVote);
                                                    }

                                                    // Refresh voter list
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
                                                                '<span class="poll-voter-vote ' + v.vote + '">' + label + '</span>' +
                                                                '</div>';
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
