<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings - Storage Sense</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>

    <div class="settings-tabs">
        <button class="tab" onclick="navigateTo('settingsaccount')">Account</button>
        <button class="tab" onclick="navigateTo('settingsprivacy')">Privacy & Security</button>
        <button class="tab active">Storage Sense</button>
        <button class="tab" onclick="navigateTo('settingsnotifications')">Notifications</button>
        <button class="tab" onclick="navigateTo('settingsappearance')">Appearance</button>
    </div>

    <div class="account-section">
        <h3>Storage Sense</h3>

        <p class="storage-label">Storage Used</p>
        <div class="progress-bar">
            <div class="progress-fill" style="width: 75%;"></div>
        </div>
        <p class="storage-info">150 GB of 200 GB used</p>

        <div class="content-card">
            <h4>Content Breakdown</h4>
            <h1>150 GB</h1>

            <div class="chart">
                <div class="bar-group">
                    <div class="bar photos"></div>
                    <p>Photos</p>
                </div>
                <div class="bar-group">
                    <div class="bar videos"></div>
                    <p>Videos</p>
                </div>
                <div class="bar-group">
                    <div class="bar audio"></div>
                    <p>Audio</p>
                </div>
                <div class="bar-group">
                    <div class="bar journals"></div>
                    <p>Journals</p>
                </div>
            </div>
        </div>

        <h4 class="manage-title">Manage Storage</h4>

        <div class="setting-item" onclick="openDuplicateFinder()">
            <div class="icon">🗂️</div>
            <div>
                <p class="title"><a href="${pageContext.request.contextPath}/fragments/duplicatefinder.jsp" style="text-decoration: none;">Duplicate Finder</a></p>
                <p class="desc">Review and delete duplicate files to free up space</p>
            </div>
        </div>

        <div class="setting-item" onclick="openTrashManagement()">
            <div class="icon">🗑️</div>
            <div>
                <p class="title"><a href="${pageContext.request.contextPath}/fragments/trashmgt.jsp" style="text-decoration: none;"> Trash Management</a></p>
                <p class="desc">View, recover, or permanently delete items in the trash</p>
            </div>
        </div>

        <button class="upgrade-btn" onclick="upgradeStorage()">Upgrade Storage</button>
    </div>
</div>

<script>
    function navigateTo(tab) {
        window.location.href = tab + ".jsp";
    }

    function openDuplicateFinder() {
        window.location.href = "duplicateFinder.jsp";
    }

    function openTrashManagement() {
        window.location.href = "trashManagement.jsp";
    }

    function upgradeStorage() {
        alert("Redirecting to storage upgrade page...");
        window.location.href = "upgradeStorage.jsp";
    }
</script>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
