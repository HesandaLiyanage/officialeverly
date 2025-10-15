<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Linked Devices | Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>

    <!-- Tabs -->
    <div class="settings-tabs">
        <button class="tab active">Account</button>
        <button class="tab" onclick="navigateTo('settingsprivacy')">Privacy & Security</button>
        <button class="tab" onclick="navigateTo('storagesense')">Storage Sense</button>
        <button class="tab" onclick="navigateTo('settingsnotifications')">Notifications</button>
        <button class="tab" onclick="navigateTo('settingsappearance')">Appearance</button>
    </div>

    <div class="account-section">
        <!-- 🔙 Back to Settings Account -->
        <div class="back-option">
            <h2><a href="${pageContext.request.contextPath}/fragments/settingsaccount.jsp" class="back-link">&#8592; Linked Devices</a></h2>
        </div>

        <%
            class Device {
                String name, type, lastLogin;
                Device(String n, String t, String l) {
                    name = n; type = t; lastLogin = l;
                }
            }

            List<Device> devices = new ArrayList<>();
            devices.add(new Device("iPhone 13", "iPhone 13", "2024-01-20"));
            devices.add(new Device("Windows PC", "Windows PC", "2024-01-15"));
            devices.add(new Device("Android Phone", "Android Phone", "2024-01-10"));

            for (Device d : devices) {
        %>
        <div class="device-item">
            <div class="device-info">
                <div class="device-name"><%= d.name %></div>
                <div class="device-details"><%= d.type %>, Last login: <%= d.lastLogin %></div>
            </div>
            <form method="post" action="removeDevice.jsp" class="remove-form">
                <input type="hidden" name="deviceName" value="<%= d.name %>">
                <button type="submit" class="remove-btn">×</button>
            </form>
        </div>
        <% } %>

        <form method="post" action="logoutAllDevices.jsp">
            <button type="submit" class="logout-all-btn">Logout from all devices</button>
        </form>
    </div>
</div>
<script>
    function navigateTo(tab) {
        window.location.href = tab + ".jsp";
    }
</script>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
