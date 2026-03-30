<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blocked Users - Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/blockedusers.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
        rel="stylesheet">
</head>

<body>

    <jsp:include page="/WEB-INF/views/public/header2.jsp" />

    <main class="blocked-container">
        <h1>Blocked Users</h1>
        <p>Manage the users you've blocked from your feed</p>

        <c:if test="${not empty successMessage}">
            <div class="success">
                ✓ ${fn:escapeXml(successMessage)}
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="error">
                ⚠ ${fn:escapeXml(errorMessage)}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty blockedUsers}">
                <div class="user-list">
                    <c:forEach items="${blockedUsers}" var="blockedUser">
                        <c:set var="displayName" value="${blockedUser.feedUsername}" />
                        <c:set var="username" value="${blockedUser.feedUsername}" />
                        <c:set var="profilePicture" value="${blockedUser.feedProfilePictureUrl}" />
                        <c:set var="initials" value="${blockedUser.initials}" />
                        <c:set var="profileId" value="${blockedUser.feedProfileId}" />
                        <c:set var="hasPic" value="${not empty profilePicture && !fn:contains(profilePicture, 'default')}" />

                        <div class="user-item">
                            <div class="user-info">
                                <c:choose>
                                    <c:when test="${hasPic}">
                                        <img src="${fn:escapeXml(profilePicture)}" alt="${fn:escapeXml(displayName)}" class="user-avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="user-avatar placeholder"
                                            style="background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 14px;">
                                            ${fn:escapeXml(initials)}
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="user-details">
                                    <div class="user-name">
                                        ${not empty displayName ? fn:escapeXml(displayName) : 'Unknown User'}
                                    </div>
                                    <div class="user-username">@${not empty username ? fn:escapeXml(username) : 'user'}
                                    </div>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/unblockuser" method="POST"
                                style="display: inline;">
                                <input type="hidden" name="profileId" value="${profileId}">
                                <button type="submit" class="btn-unblock"
                                    onclick="return confirm('Are you sure you want to unblock @${fn:escapeXml(username)}?');">
                                    Unblock
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">🚫</div>
                    <h3>No Blocked Users</h3>
                    <p>You haven't blocked anyone yet. You can block users from the feed by clicking the •••
                        menu on their posts.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="extra-links">
            <a href="${pageContext.request.contextPath}/feed">← Back to Feed</a>
            <a href="${pageContext.request.contextPath}/settingsprivacy">Account Settings</a>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/public/footer.jsp" />

</body>

</html>