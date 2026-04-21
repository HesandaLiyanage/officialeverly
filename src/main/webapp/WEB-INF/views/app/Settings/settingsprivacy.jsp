<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Settings - Privacy & Security</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/public/header2.jsp" />
        <div class="settings-container">
            <h2>Settings</h2>

            <div class="settings-tabs">
                <a href="${pageContext.request.contextPath}/settingsaccount" class="tab">Account</a>
                <a href="${pageContext.request.contextPath}/settingssubscription" class="tab">Subscription</a>
                <a href="#" class="tab active">Privacy & Security</a>
                <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
            </div>

            <div class="account-section">
                <h3>Privacy & Security</h3>

                <div class="setting-item" onclick="openVaultSettings()">
                    <div class="icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="10" rx="2"></rect>
                            <path d="M7 11V8a5 5 0 0 1 10 0v3"></path>
                        </svg>
                    </div>
                    <div>
                        <p class="title">Vault Settings</p>
                        <p class="desc">Set or change your vault password and manage vault-protected memories</p>
                    </div>
                </div>

                <div class="setting-item" onclick="openSharedLinks()">
                    <div class="icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M10 13a5 5 0 0 1 0-7l1.5-1.5a5 5 0 0 1 7 7L17 13"></path>
                            <path d="M14 11a5 5 0 0 1 0 7L12.5 19.5a5 5 0 0 1-7-7L7 11"></path>
                        </svg>
                    </div>
                    <div>
                        <p class="title">Shared Links</p>
                        <p class="desc">View and revoke active share links</p>
                    </div>
                </div>

                <div class="setting-item" onclick="openBlockedUsers()">
                    <div class="icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="9"></circle>
                            <line x1="8" y1="16" x2="16" y2="8"></line>
                        </svg>
                    </div>
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
                window.location.href = "${pageContext.request.contextPath}/vaultpassword";
            }

            function openSharedLinks() {
                window.location.href = "${pageContext.request.contextPath}/sharedlinks";
            }

            function openBlockedUsers() {
                window.location.href = "${pageContext.request.contextPath}/blockedusers";
            }
        </script>
        <jsp:include page="/WEB-INF/views/public/footer.jsp" />
    </body>

    </html>
