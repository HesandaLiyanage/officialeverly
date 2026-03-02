<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.*" %>
        <%@ page import="java.sql.Timestamp" %>
            <%! String timeAgo(Timestamp ts) { if (ts==null) return "" ; long diff=System.currentTimeMillis() -
                ts.getTime(); long seconds=diff / 1000; if (seconds < 60) return "Just now" ; long minutes=seconds / 60;
                if (minutes < 60) return minutes + (minutes==1 ? " minute ago" : " minutes ago" ); long hours=minutes /
                60; if (hours < 24) return hours + (hours==1 ? " hour ago" : " hours ago" ); long days=hours / 24; if
                (days < 7) return days + (days==1 ? " day ago" : " days ago" ); long weeks=days / 7; if (weeks < 4)
                return weeks + (weeks==1 ? " week ago" : " weeks ago" ); long months=days / 30; if (months < 12) return
                months + (months==1 ? " month ago" : " months ago" ); return (days / 365) + " year(s) ago" ; } String
                getInitials(String username) { if (username==null || username.isEmpty()) return "EV" ; String[]
                parts=username.trim().split("\\s+"); if (parts.length>= 2) {
                return ("" + parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
                }
                return username.substring(0, Math.min(2, username.length())).toUpperCase();
                }

                String getGradient(String type) {
                if ("memory_uploads".equals(type)) return "linear-gradient(135deg, #667eea 0%, #764ba2 100%)";
                if ("comments_reactions".equals(type)) return "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)";
                if ("group_announcements".equals(type)) return "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)";
                if ("event_updates".equals(type)) return "linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%)";
                if ("group_invites".equals(type)) return "linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)";
                if ("memory_recaps".equals(type)) return "linear-gradient(135deg, #fa709a 0%, #fee140 100%)";
                return "linear-gradient(135deg, #9A74D8 0%, #c4a7e7 100%)";
                }

                String getTypeIcon(String type) {
                if ("memory_uploads".equals(type)) return "&#128248;";
                if ("comments_reactions".equals(type)) return "&#128172;";
                if ("group_announcements".equals(type)) return "&#128227;";
                if ("event_updates".equals(type)) return "&#128197;";
                if ("group_invites".equals(type)) return "&#128101;";
                if ("memory_recaps".equals(type)) return "&#128247;";
                return "&#128276;";
                }

                String getTypeLabel(String type) {
                if ("memory_uploads".equals(type)) return "Memory";
                if ("comments_reactions".equals(type)) return "Social";
                if ("group_announcements".equals(type)) return "Group";
                if ("event_updates".equals(type)) return "Event";
                if ("group_invites".equals(type)) return "Invite";
                if ("memory_recaps".equals(type)) return "Recap";
                return "Notification";
                }
                %>
                <% List<Map<String, Object>> notifications = (List<Map<String, Object>>)
                        request.getAttribute("notifications");
                        Integer unreadCount = (Integer) request.getAttribute("unreadCount");
                        if (notifications == null) notifications = new ArrayList<>();
                            if (unreadCount == null) unreadCount = 0;
                            String ctxPath = request.getContextPath();
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Notifications - Everly</title>
                                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                                <link rel="stylesheet"
                                    href="${pageContext.request.contextPath}/resources/css/header.css">
                                <link
                                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                                    rel="stylesheet">
                                <style>
                                    .notif-page {
                                        width: 90%;
                                        max-width: 720px;
                                        margin: 0 auto;
                                        padding: 32px 0 60px;
                                    }

                                    .notif-page-header {
                                        margin-bottom: 24px;
                                    }

                                    .notif-page-title {
                                        font-size: 28px;
                                        font-weight: 700;
                                        color: #1f2937;
                                        margin: 0 0 4px;
                                        font-family: "Plus Jakarta Sans", sans-serif;
                                    }

                                    .notif-page-subtitle {
                                        font-size: 14px;
                                        color: #9ca3af;
                                        margin: 0;
                                    }

                                    .notif-page-subtitle strong {
                                        color: #9A74D8;
                                    }

                                    /* Tabs */
                                    .notif-tabs {
                                        display: flex;
                                        gap: 6px;
                                        margin-bottom: 20px;
                                        border-bottom: 2px solid #f3f4f6;
                                        padding-bottom: 0;
                                    }

                                    .notif-tab {
                                        background: transparent;
                                        border: none;
                                        padding: 10px 18px;
                                        font-size: 13px;
                                        font-weight: 600;
                                        color: #9ca3af;
                                        cursor: pointer;
                                        border-radius: 8px 8px 0 0;
                                        position: relative;
                                        transition: all 0.2s;
                                        font-family: "Plus Jakarta Sans", sans-serif;
                                    }

                                    .notif-tab:hover {
                                        color: #9A74D8;
                                        background: #faf8ff;
                                    }

                                    .notif-tab.active {
                                        color: #9A74D8;
                                        background: #f3f0ff;
                                    }

                                    .notif-tab.active::after {
                                        content: "";
                                        position: absolute;
                                        bottom: -2px;
                                        left: 0;
                                        right: 0;
                                        height: 2px;
                                        background: #9A74D8;
                                        border-radius: 2px 2px 0 0;
                                    }

                                    .notif-tab .tab-badge {
                                        display: inline-flex;
                                        align-items: center;
                                        justify-content: center;
                                        background: #ef4444;
                                        color: white;
                                        font-size: 10px;
                                        font-weight: 700;
                                        min-width: 18px;
                                        height: 18px;
                                        border-radius: 9px;
                                        margin-left: 6px;
                                        padding: 0 5px;
                                    }

                                    /* Notification list */
                                    .notif-list {
                                        display: flex;
                                        flex-direction: column;
                                        gap: 8px;
                                    }

                                    .notif-card {
                                        display: flex;
                                        align-items: flex-start;
                                        gap: 14px;
                                        padding: 14px 18px;
                                        background: white;
                                        border: 1px solid #f3f4f6;
                                        border-radius: 12px;
                                        cursor: pointer;
                                        transition: all 0.2s;
                                        position: relative;
                                    }

                                    .notif-card:hover {
                                        border-color: #e8e0ff;
                                        box-shadow: 0 2px 8px rgba(154, 116, 216, 0.08);
                                        transform: translateY(-1px);
                                    }

                                    .notif-card.unread {
                                        background: #faf8ff;
                                        border-left: 3px solid #9A74D8;
                                    }

                                    .notif-card.unread:hover {
                                        background: #f3f0ff;
                                    }

                                    /* Avatar */
                                    .notif-avatar {
                                        width: 42px;
                                        height: 42px;
                                        border-radius: 12px;
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        flex-shrink: 0;
                                        font-size: 14px;
                                        font-weight: 700;
                                        color: white;
                                    }

                                    .notif-avatar.system {
                                        font-size: 18px;
                                        background: #f3f0ff;
                                        color: #9A74D8;
                                    }

                                    /* Content */
                                    .notif-body {
                                        flex: 1;
                                        min-width: 0;
                                    }

                                    .notif-msg {
                                        font-size: 13px;
                                        color: #374151;
                                        line-height: 1.5;
                                        margin: 0 0 4px;
                                    }

                                    .notif-msg strong {
                                        font-weight: 600;
                                        color: #1f2937;
                                    }

                                    .notif-meta {
                                        display: flex;
                                        align-items: center;
                                        gap: 8px;
                                    }

                                    .notif-time {
                                        font-size: 11px;
                                        color: #9ca3af;
                                        font-weight: 500;
                                    }

                                    .notif-type-badge {
                                        display: inline-block;
                                        font-size: 10px;
                                        font-weight: 600;
                                        color: #9A74D8;
                                        background: #f3f0ff;
                                        padding: 2px 8px;
                                        border-radius: 6px;
                                    }

                                    /* Unread dot */
                                    .notif-unread-dot {
                                        width: 8px;
                                        height: 8px;
                                        border-radius: 50%;
                                        background: #9A74D8;
                                        flex-shrink: 0;
                                        margin-top: 6px;
                                        box-shadow: 0 0 6px rgba(154, 116, 216, 0.4);
                                    }

                                    /* Actions bar */
                                    .notif-actions {
                                        display: flex;
                                        justify-content: center;
                                        gap: 12px;
                                        margin-top: 20px;
                                        padding-top: 16px;
                                        border-top: 1px solid #f3f4f6;
                                    }

                                    .notif-action-btn {
                                        display: inline-flex;
                                        align-items: center;
                                        gap: 6px;
                                        padding: 10px 20px;
                                        border: none;
                                        border-radius: 10px;
                                        font-size: 13px;
                                        font-weight: 600;
                                        cursor: pointer;
                                        transition: all 0.2s;
                                        font-family: "Plus Jakarta Sans", sans-serif;
                                    }

                                    .notif-action-btn.primary {
                                        background: #9A74D8;
                                        color: white;
                                        box-shadow: 0 4px 12px rgba(154, 116, 216, 0.3);
                                    }

                                    .notif-action-btn.primary:hover {
                                        background: #8a64c8;
                                        transform: translateY(-1px);
                                    }

                                    /* Empty state */
                                    .notif-empty {
                                        text-align: center;
                                        padding: 80px 20px;
                                        background: white;
                                        border: 1px solid #f3f4f6;
                                        border-radius: 16px;
                                    }

                                    .notif-empty-icon {
                                        font-size: 48px;
                                        margin-bottom: 12px;
                                        opacity: 0.4;
                                    }

                                    .notif-empty h3 {
                                        font-size: 16px;
                                        font-weight: 600;
                                        color: #374151;
                                        margin: 0 0 4px;
                                    }

                                    .notif-empty p {
                                        font-size: 13px;
                                        color: #9ca3af;
                                        margin: 0;
                                    }

                                    /* Settings link */
                                    .notif-settings-link {
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        gap: 6px;
                                        margin-top: 16px;
                                        font-size: 13px;
                                        color: #9ca3af;
                                        text-decoration: none;
                                        transition: color 0.2s;
                                    }

                                    .notif-settings-link:hover {
                                        color: #9A74D8;
                                    }

                                    /* Toast */
                                    .notif-toast {
                                        position: fixed;
                                        bottom: 20px;
                                        left: 50%;
                                        transform: translateX(-50%);
                                        background: #1f2937;
                                        color: white;
                                        padding: 10px 20px;
                                        border-radius: 10px;
                                        font-size: 13px;
                                        font-weight: 600;
                                        opacity: 0;
                                        transition: opacity 0.3s;
                                        pointer-events: none;
                                        z-index: 1000;
                                    }

                                    .notif-toast.show {
                                        opacity: 1;
                                    }
                                </style>
                            </head>

                            <body>
                                <jsp:include page="../public/header2.jsp" />

                                <div class="notif-page">
                                    <div class="notif-page-header">
                                        <h1 class="notif-page-title">Notifications</h1>
                                        <p class="notif-page-subtitle">
                                            <% if (unreadCount> 0) { %>
                                                You have <strong>
                                                    <%= unreadCount %>
                                                </strong> unread notification<%= unreadCount !=1 ? "s" : "" %>.
                                                    <% } else { %>
                                                        You're all caught up!
                                                        <% } %>
                                        </p>
                                    </div>

                                    <!-- Tabs -->
                                    <div class="notif-tabs">
                                        <button class="notif-tab active" data-tab="all">All</button>
                                        <button class="notif-tab" data-tab="unread">
                                            Unread
                                            <% if (unreadCount> 0) { %><span class="tab-badge">
                                                    <%= unreadCount %>
                                                </span>
                                                <% } %>
                                        </button>
                                        <button class="notif-tab" data-tab="comments_reactions">Comments</button>
                                        <button class="notif-tab" data-tab="group_announcements">Announcements</button>
                                        <button class="notif-tab" data-tab="event_updates">Events</button>
                                    </div>

                                    <!-- Notifications -->
                                    <div class="notif-list" id="notifList">
                                        <% if (notifications.isEmpty()) { %>
                                            <div class="notif-empty">
                                                <div class="notif-empty-icon">&#128276;</div>
                                                <h3>No notifications yet</h3>
                                                <p>When something happens, you'll see it here.</p>
                                            </div>
                                            <% } else { for (Map<String, Object> n : notifications) {
                                                boolean isRead = (Boolean) n.get("isRead");
                                                String type = (String) n.get("notifType");
                                                String message = (String) n.get("message");
                                                String link = (String) n.get("link");
                                                Timestamp createdAt = (Timestamp) n.get("createdAt");
                                                String actorUsername = (String) n.get("actorUsername");
                                                int notifId = (Integer) n.get("notificationId");
                                                String initials = getInitials(actorUsername);
                                                boolean hasActor = (actorUsername != null && !actorUsername.isEmpty());
                                                %>
                                                <div class="notif-card <%= !isRead ? " unread" : "" %>"
                                                    data-id="<%= notifId %>" data-type="<%= type %>" data-read="<%=
                                                                isRead %>"
                                                                <% if (link !=null && !link.isEmpty()) { %>
                                                                    onclick="goToNotif('<%= ctxPath + link %>', <%=
                                                                            notifId %>)"<% } %>>
                                                                                <% if (hasActor) { %>
                                                                                    <div class="notif-avatar"
                                                                                        style="background: <%= getGradient(type) %>">
                                                                                        <%= initials %>
                                                                                    </div>
                                                                                    <% } else { %>
                                                                                        <div
                                                                                            class="notif-avatar system">
                                                                                            <%= getTypeIcon(type) %>
                                                                                        </div>
                                                                                        <% } %>
                                                                                            <div class="notif-body">
                                                                                                <p class="notif-msg">
                                                                                                    <% if (hasActor) {
                                                                                                        %><strong>
                                                                                                            <%= actorUsername
                                                                                                                %>
                                                                                                        </strong>
                                                                                                        <% } %>
                                                                                                            <%= message
                                                                                                                %>
                                                                                                </p>
                                                                                                <div class="notif-meta">
                                                                                                    <span
                                                                                                        class="notif-time">
                                                                                                        <%= timeAgo(createdAt)
                                                                                                            %>
                                                                                                    </span>
                                                                                                    <span
                                                                                                        class="notif-type-badge">
                                                                                                        <%= getTypeLabel(type)
                                                                                                            %>
                                                                                                    </span>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% if (!isRead) { %>
                                                                                                <div
                                                                                                    class="notif-unread-dot">
                                                                                                </div>
                                                                                                <% } %>
                                                </div>
                                                <% } } %>
                                    </div>

                                    <% if (!notifications.isEmpty()) { %>
                                        <div class="notif-actions">
                                            <button class="notif-action-btn primary" id="markAllReadBtn">
                                                &#10003; Mark all as read
                                            </button>
                                        </div>
                                        <% } %>

                                            <a href="<%= ctxPath %>/settingsnotifications" class="notif-settings-link">
                                                &#9881; Manage notification preferences
                                            </a>
                                </div>

                                <div class="notif-toast" id="notifToast"></div>

                                <jsp:include page="../public/footer.jsp" />

                                <script>
                                    const ctxPath = '<%= ctxPath %>';
                                    const toastEl = document.getElementById('notifToast');

                                    function showToast(msg) {
                                        toastEl.textContent = msg;
                                        toastEl.classList.add('show');
                                        setTimeout(() => toastEl.classList.remove('show'), 1500);
                                    }

                                    function goToNotif(link, notifId) {
                                        fetch(ctxPath + '/notificationsapi', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                            body: 'action=markRead&notificationId=' + notifId
                                        }).finally(() => {
                                            window.location.href = link;
                                        });
                                    }

                                    // Tab filtering
                                    document.querySelectorAll('.notif-tab').forEach(tab => {
                                        tab.addEventListener('click', function () {
                                            document.querySelectorAll('.notif-tab').forEach(t => t.classList.remove('active'));
                                            this.classList.add('active');
                                            const filter = this.dataset.tab;
                                            document.querySelectorAll('.notif-card').forEach(card => {
                                                if (filter === 'all') {
                                                    card.style.display = 'flex';
                                                } else if (filter === 'unread') {
                                                    card.style.display = card.dataset.read === 'false' ? 'flex' : 'none';
                                                } else {
                                                    card.style.display = card.dataset.type === filter ? 'flex' : 'none';
                                                }
                                            });
                                        });
                                    });

                                    // Mark all as read
                                    const markAllBtn = document.getElementById('markAllReadBtn');
                                    if (markAllBtn) {
                                        markAllBtn.addEventListener('click', function () {
                                            fetch(ctxPath + '/notificationsapi', {
                                                method: 'POST',
                                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                body: 'action=markAllRead'
                                            })
                                                .then(r => r.json())
                                                .then(data => {
                                                    if (data.success) {
                                                        document.querySelectorAll('.notif-card.unread').forEach(card => {
                                                            card.classList.remove('unread');
                                                            card.dataset.read = 'true';
                                                            const dot = card.querySelector('.notif-unread-dot');
                                                            if (dot) dot.remove();
                                                        });
                                                        const badge = document.querySelector('.tab-badge');
                                                        if (badge) badge.remove();
                                                        showToast('All marked as read!');
                                                    }
                                                })
                                                .catch(() => showToast('Failed — try again'));
                                        });
                                    }
                                </script>
                            </body>

                            </html>