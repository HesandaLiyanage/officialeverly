<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings - Account</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>
    <div class="settings-tabs">
        <button class="tab active">Account</button>
        <button class="tab" onclick="navigateTo('settingsprivacy')">Privacy & Security</button>
        <button class="tab" onclick="navigateTo('storagesense')">Storage Sense</button>
        <button class="tab" onclick="navigateTo('settingsnotifications')">Notifications</button>
        <button class="tab" onclick="navigateTo('settingsappearance')">Appearance</button>
    </div>

    <div class="account-section">
        <h3>Account</h3>

        <div class="setting-item" onclick="openProfile()">
            <div class="icon">👤</div>
            <div>
                <p class="title">Profile</p>
                <p class="desc">Manage your profile information</p>
            </div>
        </div>

        <div class="setting-item" onclick="openFeedProfile()">
            <div class="icon">📄</div>
            <div>
                <p class="title">Feed Profile</p>
                <p class="desc">Manage your public profile information</p>
            </div>
        </div>

        <div class="setting-item" onclick="openLinkedDevices()">
            <div class="icon">📱</div>
            <div>
                <p class="title">Linked Devices</p>
                <p class="desc">Manage devices logged into your account</p>
            </div>
        </div>

        <button class="deactivate-btn" onclick="deactivateAccount()">Deactivate the Account</button>
    </div>
</div>

<script>
    function openProfile() {
        window.location.href = "profile.jsp";
    }

    function openFeedProfile() {
        window.location.href = "feedProfile.jsp";
    }

    function openLinkedDevices() {
        window.location.href = "linkedDevices.jsp";
    }

    function deactivateAccount() {
        if (confirm("Are you sure you want to deactivate your account?")) {
            // Example: simulate server action
            alert("Your account has been deactivated.");
            window.location.href = "logout.jsp";
        }
    }

    function navigateTo(tab) {
        window.location.href = tab + ".jsp";
    }
</script>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
