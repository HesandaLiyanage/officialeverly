<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Linked Devices | Everly</title>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>

<body>
    <jsp:include page="/WEB-INF/views/public/header2.jsp" />
    <div class="settings-container">
        <h2>Settings</h2>

        <!-- Tabs -->
        <div class="settings-tabs">
            <a href="${pageContext.request.contextPath}/settingsaccount" class="tab active">Account</a>
            <a href="${pageContext.request.contextPath}/settingssubscription" class="tab">Subscription</a>
            <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy &
                Security</a>
            <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
        </div>

        <div class="account-section">
            <!-- Back to Settings Account -->
            <div class="back-option">
                <h2><a href="${pageContext.request.contextPath}/settingsaccount"
                        class="back-link">&#8592; Linked Devices</a></h2>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <c:out value="${success}" />
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <!-- Device List -->
            <c:choose>
                <c:when test="${not empty deviceDisplayData}">
                    <c:forEach var="device" items="${deviceDisplayData}">
                        <div class="device-item">
                            <div class="device-info">
                                <div class="device-name">
                                    <c:out value="${device.deviceName}" />
                                </div>
                                <div class="device-details">
                                    <c:out value="${device.deviceType}" />, Last login: <c:out value="${device.lastLogin}" />
                                </div>
                            </div>
                            <c:choose>
                                <c:when test="${device.isCurrentDevice}">
                                    <span class="current-device-badge">Current</span>
                                </c:when>
                                <c:otherwise>
                                    <form method="post"
                                        action="${pageContext.request.contextPath}/linkeddevicesservlet"
                                        class="remove-form">
                                        <input type="hidden" name="action" value="removeDevice">
                                        <input type="hidden" name="sessionId" value="${fn:escapeXml(device.sessionId)}">
                                        <button type="submit" class="remove-btn"
                                            onclick="return confirm('Remove this device?')">×</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>No linked devices found.</p>
                </c:otherwise>
            </c:choose>

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
    <jsp:include page="/WEB-INF/views/public/footer.jsp" />
</body>

</html>
