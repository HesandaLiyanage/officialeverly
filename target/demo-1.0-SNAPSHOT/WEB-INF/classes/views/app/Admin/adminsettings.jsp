<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminsettings.css">

<!-- Page Wrapper -->
<div class="settings-page-wrapper">
    <main class="settings-main-content">
        <!-- Page Header with Back Button -->
        <div class="page-header-nav">
            <a href="/admin" class="back-button">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
            </a>
            <h1 class="page-title">Settings</h1>
        </div>

        <!-- Settings Grid -->
        <div class="settings-grid">
            <!-- Left Column - User & Content Settings -->
            <div class="settings-column">
                <!-- User Settings -->
                <div class="settings-section">
                    <h2 class="section-title">User Settings</h2>

                    <div class="setting-item">
                        <div class="setting-info">
                            <span class="setting-label">Registration</span>
                            <span class="setting-value">Auto</span>
                        </div>
                        <svg class="chevron-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </div>

                    <div class="setting-item">
                        <div class="setting-info">
                            <span class="setting-label">Permissions</span>
                            <span class="setting-value">Camera, Photos</span>
                        </div>
                        <svg class="chevron-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </div>
                </div>

                <!-- Content Settings -->
                <div class="settings-section">
                    <h2 class="section-title">Content Settings</h2>

                    <div class="setting-item">
                        <div class="setting-info">
                            <span class="setting-label">Storage Limits</span>
                            <span class="setting-value">100 GB</span>
                        </div>
                        <svg class="chevron-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </div>

                    <div class="setting-item">
                        <div class="setting-info">
                            <span class="setting-label">Content Moderation</span>
                            <span class="setting-value">Automatic</span>
                        </div>
                        <svg class="chevron-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Divider -->
            <div class="vertical-divider"></div>

            <!-- Right Column - General Settings & Notifications -->
            <div class="settings-column">
                <!-- General Settings -->
                <div class="settings-section">
                    <h2 class="section-title">General Settings</h2>

                    <div class="setting-item">
                        <div class="setting-info">
                            <span class="setting-label">Default Language</span>
                            <span class="setting-value">English</span>
                        </div>
                        <svg class="chevron-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </div>

                    <div class="setting-item">
                        <div class="setting-info">
                            <span class="setting-label">App Name</span>
                            <span class="setting-value">Photos & Social</span>
                        </div>
                        <svg class="chevron-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </div>
                </div>

                <!-- Notifications -->
                <div class="settings-section">
                    <h2 class="section-title">Notifications</h2>

                    <div class="notification-row">
                        <div class="notification-item">
                            <span class="notification-label">System Notifications</span>
                            <span class="notification-status">On</span>
                        </div>
                        <div class="notification-item">
                            <span class="notification-label">Admin Alerts</span>
                            <span class="notification-status">On</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add click handlers for settings items
        const settingItems = document.querySelectorAll('.setting-item');
        settingItems.forEach(item => {
            item.addEventListener('click', function() {
                const label = this.querySelector('.setting-label').textContent;
                console.log('Opening settings for:', label);
                // Add navigation or modal logic here
            });
        });
    });
</script>
</body>
</html>