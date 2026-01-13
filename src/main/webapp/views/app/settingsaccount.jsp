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
        <a href="${pageContext.request.contextPath}/settingsaccount" class="tab active">Account</a>
        <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy & Security</a>
        <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
        <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
        <a href="${pageContext.request.contextPath}/settingsappearance" class="tab">Appearance</a>
    </div>

    <div class="account-section">
        <h3>Account</h3>

        <div class="setting-item">
            <div class="icon">👤</div>
            <div>
                <a href="${pageContext.request.contextPath}/editprofile">
                    <p class="title">Profile</p>
                    <p class="desc">Manage your profile information</p>
                </a>
            </div>
        </div>

        <div class="setting-item">
            <div class="icon">📰</div>
            <div>
                <a href="${pageContext.request.contextPath}/feededitprofile">
                    <p class="title">Feed Profile</p>
                    <p class="desc">Manage your public profile information</p>
                </a>
            </div>
        </div>

        <div class="setting-item">
            <div class="icon">📱</div>
            <div>
                <a href="${pageContext.request.contextPath}/linkeddevices" style="text-decoration: none;">
                    <p class="title">Linked Devices</p>
                    <p class="desc">Manage devices logged into your account</p>
                </a>
            </div>
        </div>

        <button class="deactivate-btn" onclick="deactivateAccount()">Deactivate the Account</button>
    </div>
</div>

<script>
    function deactivateAccount() {
        if (confirm("Are you sure you want to deactivate your account?")) {
            alert("Your account has been deactivated.");
            window.location.href = "${pageContext.request.contextPath}/logout.jsp";
        }
    }
</script>

<jsp:include page="../public/footer.jsp" />
</body>
</html>