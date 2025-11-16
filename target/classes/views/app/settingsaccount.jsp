<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings - Account</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="../public/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>
    <div class="settings-tabs">
        <a href="#" class="tab active">Account</a>
        <a href="/settingsprivacy" class="tab">Privacy & Security</a>
        <a href="/storagesense" class="tab">Storage Sense</a>
        <a href="/settingsnotifications" class="tab">Notifications</a>
        <a href="/settingsappearance" class="tab">Appearance</a>
    </div>

    <div class="account-section">
        <h3>Account</h3>

        <div class="setting-item" >
            <div class="icon">👤</div>
            <div>
                <a href="/editprofile" />
                <p class="title">Profile</p>
                <p class="desc">Manage your profile information</p>
            </div>
        </div>

        <div class="setting-item" ">
            <div class="icon">📄</div>
            <div>
                <a href="/feededitprofile" />
                <p class="title">Feed Profile</p>
                <p class="desc">Manage your public profile information</p>
            </div>
        </div>

        <div class="setting-item">
            <div class="icon">📱</div>
            <div>
                <a href="/linkeddevices" />
                <p class="title"><a href="${pageContext.request.contextPath}/linkeddevices" style="text-decoration: none;">Linked Devices</a></p>
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
<jsp:include page="../public/footer.jsp" />
</body>
</html>
