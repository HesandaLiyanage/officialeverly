<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.demo.web.model.UserSession" %>
            <%@ page import="java.text.SimpleDateFormat" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <title>Linked Devices | Everly</title>
                    <link rel="stylesheet" type="text/css"
                        href="${pageContext.request.contextPath}/resources/css/settings.css">
                </head>

                <body>
                    <jsp:include page="../public/header2.jsp" />
                    <div class="settings-container">
                        <h2>Settings</h2>

                        <!-- Tabs -->
                        <div class="settings-tabs">
                            <a href="${pageContext.request.contextPath}/settingsaccount" class="tab active">Account</a>
                            <a href="${pageContext.request.contextPath}/settingssubscription"
                                class="tab">Subscription</a>
                            <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy &
                                Security</a>
                            <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
                            <a href="${pageContext.request.contextPath}/settingsnotifications"
                                class="tab">Notifications</a>
                            <a href="${pageContext.request.contextPath}/settingsappearance" class="tab">Appearance</a>
                        </div>

                        <div class="account-section">
                            <!-- 🔙 Back to Settings Account -->
                            <div class="back-option">
                                <h2><a href="${pageContext.request.contextPath}/settingsaccount"
                                        class="back-link">&#8592; Linked Devices</a></h2>
                            </div>

                            <!-- Success/Error Messages -->
                            <% String success=(String) request.getAttribute("success"); String error=(String)
                                request.getAttribute("error"); if (success !=null) { %>
                                <div class="alert alert-success">
                                    <%= success %>
                                </div>
                                <% } %>
                                    <% if (error !=null) { %>
                                        <div class="alert alert-error">
                                            <%= error %>
                                        </div>
                                        <% } %>

                                            <!-- Device List -->
                                            <% List<UserSession> devices = (List<UserSession>)
                                                    request.getAttribute("devices");
                                                    String currentSessionId = (String)
                                                    request.getAttribute("currentSessionId");
                                                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd
                                                    HH:mm");

                                                    if (devices != null && !devices.isEmpty()) {
                                                    for (UserSession device : devices) {
                                                    String lastLogin = dateFormat.format(device.getCreatedAt());
                                                    boolean isCurrentDevice =
                                                    device.getSessionId().equals(currentSessionId);
                                                    %>
                                                    <div class="device-item">
                                                        <div class="device-info">
                                                            <div class="device-name">
                                                                <%= device.getDeviceName() %>
                                                            </div>
                                                            <div class="device-details">
                                                                <%= device.getDeviceType() %>, Last login: <%= lastLogin
                                                                        %>
                                                            </div>
                                                        </div>
                                                        <% if (!isCurrentDevice) { %>
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/linkeddevicesservlet"
                                                                class="remove-form">
                                                                <input type="hidden" name="action" value="removeDevice">
                                                                <input type="hidden" name="sessionId"
                                                                    value="<%= device.getSessionId() %>">
                                                                <button type="submit" class="remove-btn"
                                                                    onclick="return confirm('Remove this device?')">×</button>
                                                            </form>
                                                            <% } else { %>
                                                                <span class="current-device-badge">Current</span>
                                                                <% } %>
                                                    </div>
                                                    <% } } else { %>
                                                        <p>No linked devices found.</p>
                                                        <% } %>

                                                            <!-- Logout All Devices Button -->
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/linkeddevicesservlet">
                                                                <input type="hidden" name="action" value="logoutAll">
                                                                <button type="submit" class="logout-all-btn"
                                                                    onclick="return confirm('Logout from all other devices?')">Logout
                                                                    from all devices</button>
                                                            </form>
                        </div>
                    </div>
                    <script>
                        function navigateTo(tab) {
                            window.location.href = tab + ".jsp";
                        }
                    </script>
                    <jsp:include page="../public/footer.jsp" />
                </body>

                </html>