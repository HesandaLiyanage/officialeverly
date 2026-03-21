<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Trash Management - Everly</title>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/settings.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">
    <style>
        /* Trash Management specific styles */
        .trash-header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .trash-back-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #9A74D8;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.2s;
            padding: 8px 14px;
            border-radius: 8px;
        }

        .trash-back-btn:hover {
            background: #f3f0ff;
        }

        .trash-page-title {
            font-size: 20px;
            font-weight: 700;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .trash-count-badge {
            font-size: 12px;
            font-weight: 700;
            color: #9A74D8;
            background: #f3f0ff;
            padding: 3px 10px;
            border-radius: 12px;
        }

        /* Message banners */
        .trash-msg {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 16px;
        }

        .trash-msg.success {
            background: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }

        .trash-msg.error {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        /* Trash items */
        .trash-card {
            background: white;
            border: 1px solid #f3f4f6;
            border-radius: 12px;
            overflow: hidden;
        }

        .trash-card-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 16px 20px;
            border-bottom: 1px solid #f9fafb;
            transition: background 0.15s;
        }

        .trash-card-item:last-child {
            border-bottom: none;
        }

        .trash-card-item:hover {
            background: #faf8ff;
        }

        .trash-item-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }

        .trash-item-icon.journal {
            background: #dbeafe;
        }

        .trash-item-icon.autograph {
            background: #fef3c7;
        }

        .trash-item-icon.memory {
            background: #f3e8ff;
        }

        .trash-item-info {
            flex: 1;
            min-width: 0;
        }

        .trash-item-title {
            font-size: 14px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .trash-item-meta {
            font-size: 12px;
            color: #9ca3af;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .trash-item-type {
            display: inline-flex;
            align-items: center;
            gap: 3px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            padding: 2px 8px;
            border-radius: 8px;
        }

        .trash-item-type.journal {
            background: #dbeafe;
            color: #2563eb;
        }

        .trash-item-type.autograph {
            background: #fef3c7;
            color: #d97706;
        }

        .trash-item-type.memory {
            background: #f3e8ff;
            color: #9A74D8;
        }

        .trash-item-actions {
            display: flex;
            gap: 6px;
            flex-shrink: 0;
        }

        .trash-btn {
            padding: 7px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .trash-btn.restore {
            background: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }

        .trash-btn.restore:hover {
            background: #dcfce7;
        }

        .trash-btn.delete {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .trash-btn.delete:hover {
            background: #fee2e2;
        }

        /* Empty state */
        .trash-empty {
            text-align: center;
            padding: 60px 20px;
        }

        .trash-empty-icon {
            font-size: 48px;
            margin-bottom: 12px;
            opacity: 0.5;
        }

        .trash-empty h3 {
            font-size: 16px;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 4px;
        }

        .trash-empty p {
            font-size: 13px;
            color: #9ca3af;
        }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/views/public/header2.jsp" />

    <div class="settings-container">
        <h2>Settings</h2>

        <div class="settings-tabs">
            <a href="${pageContext.request.contextPath}/settingsaccount" class="tab">Account</a>
            <a href="${pageContext.request.contextPath}/settingssubscription" class="tab">Subscription</a>
            <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy & Security</a>
            <a href="${pageContext.request.contextPath}/storagesense" class="tab active">Storage Sense</a>
            <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
        </div>

        <!-- Header bar -->
        <div class="trash-header-bar">
            <a href="${pageContext.request.contextPath}/storagesense" class="trash-back-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                    stroke-width="2.5">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Back
            </a>
            <div class="trash-page-title">
                &#x1F5D1;&#xFE0F; Trash Management
                <c:if test="${not empty trashItems}">
                    <span class="trash-count-badge">${fn:length(trashItems)} items</span>
                </c:if>
            </div>
            <div style="width: 60px;"></div> <!-- spacer -->
        </div>

        <!-- Messages -->
        <c:if test="${not empty param.msg}">
            <div class="trash-msg success">&#x2705; ${fn:escapeXml(param.msg)}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="trash-msg error">&#x26A0;&#xFE0F; ${fn:escapeXml(param.error)}</div>
        </c:if>

        <!-- Trash Items -->
        <c:choose>
            <c:when test="${empty trashItems}">
                <div class="trash-card">
                    <div class="trash-empty">
                        <div class="trash-empty-icon">&#x1F5D1;&#xFE0F;</div>
                        <h3>Trash is empty</h3>
                        <p>Deleted journals and autographs will appear here for recovery</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="trash-card">
                    <c:forEach items="${trashItems}" var="item">
                        <c:set var="isAutograph" value="${item.itemType == 'autograph'}" />
                        <c:set var="isMemory" value="${item.itemType == 'memory'}" />
                        <c:choose>
                            <c:when test="${not empty item.title and not empty fn:trim(item.title)}">
                                <c:set var="displayTitle" value="${item.title}" />
                            </c:when>
                            <c:when test="${isAutograph}">
                                <c:set var="displayTitle" value="Untitled Autograph" />
                            </c:when>
                            <c:when test="${isMemory}">
                                <c:set var="displayTitle" value="Untitled Memory" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="displayTitle" value="Untitled Journal" />
                            </c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${isAutograph}">
                                <c:set var="icon" value="&#x270D;&#xFE0F;" />
                                <c:set var="typeLabel" value="Autograph" />
                            </c:when>
                            <c:when test="${isMemory}">
                                <c:set var="icon" value="&#x1F4F8;" />
                                <c:set var="typeLabel" value="Memory" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="icon" value="&#x1F4DD;" />
                                <c:set var="typeLabel" value="Journal" />
                            </c:otherwise>
                        </c:choose>

                        <div class="trash-card-item">
                            <div class="trash-item-icon ${fn:escapeXml(item.itemType)}">${icon}</div>
                            <div class="trash-item-info">
                                <div class="trash-item-title">${fn:escapeXml(displayTitle)}</div>
                                <div class="trash-item-meta">
                                    <span class="trash-item-type ${fn:escapeXml(item.itemType)}">${typeLabel}</span>
                                    <span>Deleted
                                        <c:choose>
                                            <c:when test="${not empty item.deletedAt}">
                                                <fmt:formatDate value="${item.deletedAt}" pattern="MMM dd, yyyy 'at' h:mm a" />
                                            </c:when>
                                            <c:otherwise>Unknown</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <div class="trash-item-actions">
                                <form method="post" action="${pageContext.request.contextPath}/trashmgt"
                                    style="margin:0;">
                                    <input type="hidden" name="action" value="restore">
                                    <input type="hidden" name="recycleBinId" value="${item.id}">
                                    <button type="submit" class="trash-btn restore">Restore</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/trashmgt"
                                    style="margin:0;">
                                    <input type="hidden" name="action" value="permanentDelete">
                                    <input type="hidden" name="recycleBinId" value="${item.id}">
                                    <button type="submit" class="trash-btn delete"
                                        onclick="return confirm('Permanently delete this item? This cannot be undone.')">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="/WEB-INF/views/public/footer.jsp" />
</body>

</html>