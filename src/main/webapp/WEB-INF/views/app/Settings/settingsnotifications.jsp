<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
    <title>Notifications Settings - Everly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/settings.css">
    <style>
        .notif-settings {
            margin-top: 8px;
        }

        .notif-section-title {
            font-size: 15px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 16px;
        }

        .notif-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 28px;
        }

        .notif-row {
            display: flex;
            align-items: center;
            gap: 16px;
            background: white;
            border: 1px solid #f3f4f6;
            border-radius: 12px;
            padding: 16px 20px;
            transition: all 0.2s;
        }

        .notif-row:hover {
            border-color: #e8e0ff;
            box-shadow: 0 2px 8px rgba(154, 116, 216, 0.08);
        }

        .notif-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }

        .notif-icon.uploads {
            background: #f3f0ff;
        }

        .notif-icon.comments {
            background: #e0f2fe;
        }

        .notif-icon.announcements {
            background: #fef3c7;
        }

        .notif-icon.events {
            background: #ede9fe;
        }

        .notif-icon.invites {
            background: #d1fae5;
        }

        .notif-icon.recaps {
            background: #fce7f3;
        }

        .notif-info {
            flex: 1;
            min-width: 0;
        }

        .notif-title {
            font-size: 14px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 2px;
        }

        .notif-desc {
            font-size: 12px;
            color: #9ca3af;
            line-height: 1.4;
        }

        /* Toggle switch */
        .toggle-switch {
            position: relative;
            width: 48px;
            height: 26px;
            flex-shrink: 0;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            inset: 0;
            background: #d1d5db;
            border-radius: 26px;
            transition: all 0.3s;
        }

        .toggle-slider::before {
            content: "";
            position: absolute;
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background: white;
            border-radius: 50%;
            transition: all 0.3s;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.15);
        }

        .toggle-switch input:checked+.toggle-slider {
            background: #9A74D8;
        }

        .toggle-switch input:checked+.toggle-slider::before {
            transform: translateX(22px);
        }

        /* Status message */
        .notif-status {
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

        .notif-status.show {
            opacity: 1;
        }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/views/public/header2.jsp" />
    <div class="settings-container">
        <h2>Settings</h2>
        <div class="settings-tabs">
            <a href="${pageContext.request.contextPath}/settingsaccount" class="tab">Account</a>
            <a href="${pageContext.request.contextPath}/settingssubscription"
                class="tab">Subscription</a>
            <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy &amp;
                Security</a>
            <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
            <a href="#" class="tab active">Notifications</a>
        </div>

        <div class="notif-settings">
            <div class="notif-section-title">Push Notifications</div>
            <div class="notif-list">
                <div class="notif-row">
                    <div class="notif-icon uploads">&#128248;</div>
                    <div class="notif-info">
                        <div class="notif-title">New Memory Uploads</div>
                        <div class="notif-desc">Get notified when friends upload new memories to shared
                            groups.</div>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" data-type="memory_uploads" <c:if test="${notifPrefs['memory_uploads']}">checked</c:if>>
                        <span class="toggle-slider"></span>
                    </label>
                </div>

                <div class="notif-row">
                    <div class="notif-icon comments">&#128172;</div>
                    <div class="notif-info">
                        <div class="notif-title">Comments &amp; Reactions</div>
                        <div class="notif-desc">Get notified when someone comments or reacts to your
                            memories.</div>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" data-type="comments_reactions" <c:if test="${notifPrefs['comments_reactions']}">checked</c:if>>
                        <span class="toggle-slider"></span>
                    </label>
                </div>

                <div class="notif-row">
                    <div class="notif-icon announcements">&#128227;</div>
                    <div class="notif-info">
                        <div class="notif-title">Group Announcements</div>
                        <div class="notif-desc">Receive notifications for new announcements in your
                            groups.</div>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" data-type="group_announcements" <c:if test="${notifPrefs['group_announcements']}">checked</c:if>>
                        <span class="toggle-slider"></span>
                    </label>
                </div>

                <div class="notif-row">
                    <div class="notif-icon events">&#128197;</div>
                    <div class="notif-info">
                        <div class="notif-title">Event Updates</div>
                        <div class="notif-desc">Stay updated on event details, voting, and schedule
                            changes.</div>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" data-type="event_updates" <c:if test="${notifPrefs['event_updates']}">checked</c:if>>
                        <span class="toggle-slider"></span>
                    </label>
                </div>

                <div class="notif-row">
                    <div class="notif-icon invites">&#128101;</div>
                    <div class="notif-info">
                        <div class="notif-title">Group Invites</div>
                        <div class="notif-desc">Get notified when you're invited to join a group.</div>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" data-type="group_invites" <c:if test="${notifPrefs['group_invites']}">checked</c:if>>
                        <span class="toggle-slider"></span>
                    </label>
                </div>

                <div class="notif-row">
                    <div class="notif-icon recaps">&#128247;</div>
                    <div class="notif-info">
                        <div class="notif-title">Memory Recaps</div>
                        <div class="notif-desc">Reminders about past memories — "Remember this day?"
                        </div>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" data-type="memory_recaps" <c:if test="${notifPrefs['memory_recaps']}">checked</c:if>>
                        <span class="toggle-slider"></span>
                    </label>
                </div>
            </div>
        </div>
    </div>

    <div class="notif-status" id="notifStatus">Saved!</div>

    <script>
        const ctxPath = '${pageContext.request.contextPath}';
        const statusEl = document.getElementById('notifStatus');

        function showStatus(msg) {
            statusEl.textContent = msg;
            statusEl.classList.add('show');
            setTimeout(() => statusEl.classList.remove('show'), 1500);
        }

        document.querySelectorAll('.toggle-switch input').forEach(toggle => {
            toggle.addEventListener('change', function () {
                const notifType = this.dataset.type;
                const enabled = this.checked;

                fetch(ctxPath + '/notificationprefsapi', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'notifType=' + encodeURIComponent(notifType) + '&enabled=' + enabled
                })
                .then(r => r.json())
                .then(data => {
                    showStatus(data.success ? 'Preference saved!' : 'Failed to save');
                })
                .catch(() => showStatus('Network error'));
            });
        });
    </script>
    <jsp:include page="/WEB-INF/views/public/footer.jsp" />
</body>

</html>