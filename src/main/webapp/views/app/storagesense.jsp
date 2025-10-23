<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings - Storage Sense</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="../public/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>

    <div class="settings-tabs">
        <a href="/settingsaccount" class="tab">Account</a>
        <a href="/settingsprivacy" class="tab">Privacy & Security</a>
        <a href="#" class="tab active">Storage Sense</a>
        <a href="/settingsnotifications" class="tab">Notifications</a>
        <a href="/settingsappearance" class="tab">Appearance</a>
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
                <p class="title">Duplicate Finder</p>
                <p class="desc">Review and delete duplicate files to free up space</p>
            </div>
        </div>

        <div class="setting-item" onclick="openTrashManagement()">
            <div class="icon">🗑️</div>
            <div>
                <p class="title">Trash Management</p>
                <p class="desc">View, recover, or permanently delete items in the trash</p>
            </div>
        </div>

        <a href="/plans" class="upgrade-btn" style="text-decoration: none; margin-top: 24px; display: inline-block; onclick="upgradeStorage(); return false;">Upgrade Storage</a>    </div>
</div>

<script>
    function navigateTo(tab) {
        window.location.href = tab + ".jsp";
    }

    function openDuplicateFinder() {
        window.location.href = "/duplicatefinder";
    }

    function openTrashManagement() {
        window.location.href = "/trashmgt";
    }

    function upgradeStorage() {
        alert("Redirecting to storage upgrade page...");
        window.location.href = "/plans";
    }
</script>
<jsp:include page="../public/footer.jsp" />
</body>
</html>
