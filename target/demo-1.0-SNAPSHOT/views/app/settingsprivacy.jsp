<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings - Privacy & Security</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>

    <div class="settings-tabs">
        <button class="tab" onclick="navigateTo('settingsaccount')">Account</button>
        <button class="tab active">Privacy & Security</button>
        <button class="tab" onclick="navigateTo('storagesense')">Storage Sense</button>
        <button class="tab" onclick="navigateTo('settingsnotifications')">Notifications</button>
        <button class="tab" onclick="navigateTo('settingsappearance')">Appearance</button>
    </div>

    <div class="account-section">
        <h3>Privacy & Security</h3>

        <div class="setting-item" onclick="openVaultSettings()">
            <div class="icon">🔒</div>
            <div>
                <p class="title">Vault Settings</p>
                <p class="desc">Set or change your vault password and manage vault-protected memories</p>
            </div>
        </div>

        <div class="setting-item" onclick="openSharedLinks()">
            <div class="icon">🔗</div>
            <div>
                <p class="title">Shared Links</p>
                <p class="desc">View and revoke active share links</p>
            </div>
        </div>

        <div class="setting-item" onclick="openBlockedUsers()">
            <div class="icon">🙅‍♀️</div>
            <div>
                <p class="title">Blocked Users</p>
                <p class="desc">Manage your list of blocked users</p>
            </div>
        </div>
    </div>
</div>

<script>
    function navigateTo(tab) {
        window.location.href = tab + ".jsp";
    }

    function openVaultSettings() {
        window.location.href = "vaultSettings.jsp";
    }

    function openSharedLinks() {
        window.location.href = "sharedLinks.jsp";
    }

    function openBlockedUsers() {
        window.location.href = "blockedUsers.jsp";
    }
</script>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
