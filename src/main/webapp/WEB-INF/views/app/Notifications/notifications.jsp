<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}" />
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
                                <jsp:include page="/WEB-INF/views/public/header2.jsp" />

                                <div class="notif-page">
                                    <div class="notif-page-header">
                                        <h1 class="notif-page-title">Notifications</h1>
                                        <p class="notif-page-subtitle">
                                            <c:choose>
                                                <c:when test="${unreadCount > 0}">
                                                    You have <strong>${unreadCount}</strong> unread notification${unreadCount != 1 ? 's' : ''}.
                                                </c:when>
                                                <c:otherwise>
                                                    You're all caught up!
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>

                                    <!-- Tabs -->
                                    <div class="notif-tabs">
                                        <button class="notif-tab active" data-tab="all">All</button>
                                        <button class="notif-tab" data-tab="unread">
                                            Unread
                                            <c:if test="${unreadCount > 0}">
                                                <span class="tab-badge">${unreadCount}</span>
                                            </c:if>
                                        </button>
                                    </div>

                                    <!-- Notifications -->
                                    <div class="notif-list" id="notifList">
                                        <c:choose>
                                            <c:when test="${empty notifications}">
                                                <div class="notif-empty">
                                                    <div class="notif-empty-icon">&#128276;</div>
                                                    <h3>No notifications yet</h3>
                                                    <p>When something happens, you'll see it here.</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="n" items="${notifications}">
                                                    <c:set var="isRead" value="${n.isRead}" />
                                                    <c:set var="type" value="${n.notifType}" />
                                                    <c:set var="notifId" value="${n.notificationId}" />
                                                    <c:set var="link" value="${n.link}" />
                                                    <c:set var="hasActor" value="${not empty n.actorUsername}" />
                                                    <div class="notif-card ${!isRead ? 'unread' : ''}"
                                                        data-id="${notifId}" data-type="${type}" data-read="${isRead}"
                                                        data-link="${not empty link ? fn:escapeXml(link) : ''}"
                                                        <c:if test="${not empty link}">
                                                            onclick="goToNotif('${ctxPath}${link}', ${notifId})"
                                                        </c:if>>
                                                        <c:choose>
                                                            <c:when test="${hasActor}">
                                                                <div class="notif-avatar" style="background: ${n.gradient}">
                                                                    ${n.initials}
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="notif-avatar system">
                                                                    ${n.typeIcon}
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div class="notif-body">
                                                            <p class="notif-msg">
                                                                <c:if test="${hasActor}">
                                                                    <strong>${n.actorUsername}</strong>
                                                                </c:if>
                                                                ${n.message}
                                                            </p>
                                                            <div class="notif-meta">
                                                                <span class="notif-time">${n.timeAgo}</span>
                                                                <span class="notif-type-badge">${n.typeLabel}</span>
                                                            </div>
                                                        </div>
                                                        <c:if test="${!isRead}">
                                                            <div class="notif-unread-dot"></div>
                                                        </c:if>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <c:if test="${not empty notifications}">
                                        <div class="notif-actions">
                                            <button class="notif-action-btn primary" id="markAllReadBtn">
                                                &#10003; Mark all as read
                                            </button>
                                        </div>
                                    </c:if>

                                    <a href="${ctxPath}/settingsnotifications" class="notif-settings-link">
                                        &#9881; Manage notification preferences
                                    </a>
                                </div>

                                <div class="notif-toast" id="notifToast"></div>

                                <jsp:include page="/WEB-INF/views/public/footer.jsp" />

                                <script>
                                    const ctxPath = '${ctxPath}';
                                    const toastEl = document.getElementById('notifToast');

                                    function showToast(msg) {
                                        toastEl.textContent = msg;
                                        toastEl.classList.add('show');
                                        setTimeout(() => toastEl.classList.remove('show'), 1500);
                                    }

                                    function markNotificationCardRead(card) {
                                        if (!card || card.dataset.read === 'true') {
                                            return;
                                        }

                                        card.classList.remove('unread');
                                        card.dataset.read = 'true';
                                        const dot = card.querySelector('.notif-unread-dot');
                                        if (dot) dot.remove();

                                        const badge = document.querySelector('.tab-badge');
                                        if (badge) {
                                            const current = parseInt(badge.textContent, 10);
                                            if (!isNaN(current)) {
                                                const next = current - 1;
                                                if (next > 0) {
                                                    badge.textContent = next;
                                                } else {
                                                    badge.remove();
                                                }
                                            }
                                        }
                                    }

                                    function goToNotif(link, notifId) {
                                        fetch(ctxPath + '/notificationsapi', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                            body: 'action=markRead&notificationId=' + notifId
                                        }).finally(() => {
                                            const card = document.querySelector('.notif-card[data-id="' + notifId + '"]');
                                            markNotificationCardRead(card);
                                            window.location.href = link;
                                        });
                                    }

                                    document.querySelectorAll('.notif-card').forEach(card => {
                                        card.addEventListener('click', function (event) {
                                            if (this.dataset.link) {
                                                return;
                                            }

                                            const notifId = this.dataset.id;
                                            fetch(ctxPath + '/notificationsapi', {
                                                method: 'POST',
                                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                body: 'action=markRead&notificationId=' + notifId
                                            })
                                                .then(r => r.json())
                                                .then(data => {
                                                    if (data.success) {
                                                        markNotificationCardRead(this);
                                                        showToast('Notification marked as read');
                                                    }
                                                })
                                                .catch(() => showToast('Failed — try again'));
                                        });
                                    });

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
                                                            markNotificationCardRead(card);
                                                        });
                                                        showToast('All marked as read!');
                                                    }
                                                })
                                                .catch(() => showToast('Failed — try again'));
                                        });
                                    }
                                </script>
                            </body>

                            </html>
