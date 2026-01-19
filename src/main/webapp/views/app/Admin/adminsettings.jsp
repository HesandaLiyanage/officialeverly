<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Settings - Everly Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-styles.css">
        <style>
            .admin-topbar {
                position: fixed;
                top: 0;
                right: 0;
                left: 260px;
                height: 60px;
                background: white;
                display: flex;
                justify-content: flex-end;
                align-items: center;
                padding: 0 2rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
                z-index: 100;
            }

            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
            }

            .container {
                margin-left: 260px;
                padding-top: 60px;
            }

            .main-content {
                padding: 2rem;
            }

            .sidebar-logo {
                font-size: 1.8rem;
                font-weight: 700;
                color: #5b4cdb;
                padding: 1.5rem 2rem;
                border-bottom: 1px solid #eee;
            }

            .nav-icon {
                width: 20px;
                text-align: center;
            }

            .settings-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 2rem;
            }

            .settings-card {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
            }

            .settings-card h2 {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 1.2rem;
                color: #1a202c;
            }

            .setting-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1rem;
                background: #f7fafc;
                border-radius: 8px;
                margin-bottom: 0.8rem;
                cursor: pointer;
                transition: all 0.2s;
            }

            .setting-row:hover {
                background: #edf2f7;
            }

            .setting-label {
                font-weight: 500;
                color: #2d3748;
            }

            .setting-value {
                color: #718096;
                font-size: 0.9rem;
            }

            .toggle-switch {
                width: 44px;
                height: 24px;
                background: #cbd5e0;
                border-radius: 12px;
                position: relative;
                cursor: pointer;
                transition: all 0.3s;
            }

            .toggle-switch.on {
                background: #5b4cdb;
            }

            .toggle-switch::after {
                content: '';
                position: absolute;
                width: 20px;
                height: 20px;
                background: white;
                border-radius: 50%;
                top: 2px;
                left: 2px;
                transition: all 0.3s;
            }

            .toggle-switch.on::after {
                left: 22px;
            }
        </style>
    </head>

    <body>
        <div class="admin-topbar">
            <button class="logout-btn" onclick="handleLogout()">
                <span style="margin-right: 8px;">⎋</span> Logout
            </button>
        </div>

        <div class="sidebar">
            <div class="sidebar-logo">Everly</div>
            <div class="sidebar-title">Admin Panel</div>
            <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/admin'">
                <span class="nav-icon">📊</span> Overview
            </div>
            <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/adminanalytics'">
                <span class="nav-icon">📈</span> Analytics
            </div>
            <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/adminuser'">
                <span class="nav-icon">👥</span> Users
            </div>
            <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/admincontent'">
                <span class="nav-icon">📝</span> Content
            </div>
            <div class="nav-item active"
                onclick="window.location.href='${pageContext.request.contextPath}/adminsettings'">
                <span class="nav-icon">⚙️</span> Settings
            </div>
        </div>

        <div class="container">
            <div class="main-content">
                <div class="page-header">
                    <h1 class="page-title">Settings</h1>
                </div>

                <div class="settings-grid">
                    <!-- User Settings -->
                    <div class="settings-card">
                        <h2>👤 User Settings</h2>
                        <div class="setting-row">
                            <span class="setting-label">Registration</span>
                            <span class="setting-value">Auto</span>
                        </div>
                        <div class="setting-row">
                            <span class="setting-label">Permissions</span>
                            <span class="setting-value">Camera, Photos</span>
                        </div>
                        <div class="setting-row">
                            <span class="setting-label">Account Verification</span>
                            <span class="setting-value">Email</span>
                        </div>
                    </div>

                    <!-- Content Settings -->
                    <div class="settings-card">
                        <h2>📁 Content Settings</h2>
                        <div class="setting-row">
                            <span class="setting-label">Storage Limits</span>
                            <span class="setting-value">100 GB</span>
                        </div>
                        <div class="setting-row">
                            <span class="setting-label">Content Moderation</span>
                            <span class="setting-value">Automatic</span>
                        </div>
                        <div class="setting-row">
                            <span class="setting-label">File Types</span>
                            <span class="setting-value">Images, Videos</span>
                        </div>
                    </div>

                    <!-- General Settings -->
                    <div class="settings-card">
                        <h2>🌐 General Settings</h2>
                        <div class="setting-row">
                            <span class="setting-label">Default Language</span>
                            <span class="setting-value">English</span>
                        </div>
                        <div class="setting-row">
                            <span class="setting-label">App Name</span>
                            <span class="setting-value">Everly</span>
                        </div>
                        <div class="setting-row">
                            <span class="setting-label">Timezone</span>
                            <span class="setting-value">UTC+5:30</span>
                        </div>
                    </div>

                    <!-- Notifications -->
                    <div class="settings-card">
                        <h2>🔔 Notifications</h2>
                        <div class="setting-row">
                            <span class="setting-label">System Notifications</span>
                            <div class="toggle-switch on" onclick="this.classList.toggle('on')"></div>
                        </div>
                        <div class="setting-row">
                            <span class="setting-label">Admin Alerts</span>
                            <div class="toggle-switch on" onclick="this.classList.toggle('on')"></div>
                        </div>
                        <div class="setting-row">
                            <span class="setting-label">Email Reports</span>
                            <div class="toggle-switch" onclick="this.classList.toggle('on')"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function handleLogout() {
                if (confirm('Are you sure you want to logout?')) {
                    window.location.href = '${pageContext.request.contextPath}/logout';
                }
            }
        </script>
    </body>

    </html>