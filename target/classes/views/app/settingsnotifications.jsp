<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Notifications Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>

    <div class="settings-tabs">
        <button class="tab" onclick="navigateTo('settingsaccount')">Account</button>
        <button class="tab" onclick="navigateTo('settingsprivacy')">Privacy & Security</button>
        <button class="tab" onclick="navigateTo('storagesense')">Storage Sense</button>
        <button class="tab active">Notifications</button>
        <button class="tab" onclick="navigateTo('settingsappearance')">Appearance</button>
    </div>

    <div class="account-section">
        <h3>Notifications</h3>

        <div class="notification-item">
            <div class="icon">📤</div>
            <div class="text">
                <p class="title">New Memory Uploads</p>
                <p class="desc">Receive push notifications for new memories uploaded by friends.</p>
            </div>
            <label class="switch">
                <input type="checkbox" id="notif1">
                <span class="slider"></span>
            </label>
        </div>

        <div class="notification-item">
            <div class="icon">💬</div>
            <div class="text">
                <p class="title">Comments and Reactions</p>
                <p class="desc">Get notified when someone comments or reacts to your memories.</p>
            </div>
            <label class="switch">
                <input type="checkbox" id="notif2">
                <span class="slider"></span>
            </label>
        </div>

        <div class="notification-item">
            <div class="icon">📢</div>
            <div class="text">
                <p class="title">Group Announcements</p>
                <p class="desc">Receive notifications for new announcements in your groups.</p>
            </div>
            <label class="switch">
                <input type="checkbox" id="notif3">
                <span class="slider"></span>
            </label>
        </div>

        <div class="notification-item">
            <div class="icon">📅</div>
            <div class="text">
                <p class="title">Event Updates</p>
                <p class="desc">Stay updated on event details and changes.</p>
            </div>
            <label class="switch">
                <input type="checkbox" id="notif4">
                <span class="slider"></span>
            </label>
        </div>
    </div>
</div>

<script>
    // --- Save toggle states using localStorage ---
    document.querySelectorAll('.switch input').forEach((toggle, index) => {
        const key = 'notificationToggle' + index;
        toggle.checked = localStorage.getItem(key) === 'true';
        toggle.addEventListener('change', () => {
            localStorage.setItem(key, toggle.checked);
        });
    });
    function navigateTo(page) {
        window.location.href = page + ".jsp";
    }
</script>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
