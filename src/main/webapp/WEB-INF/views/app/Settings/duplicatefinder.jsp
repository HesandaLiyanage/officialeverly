<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Duplicate Finder - Everly</title>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/settings.css">
    <style>
        .dup-header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .dup-back-btn {
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

        .dup-back-btn:hover {
            background: #f3f0ff;
        }

        .dup-page-title {
            font-size: 20px;
            font-weight: 700;
            color: #1f2937;
        }

        .dup-summary {
            background: linear-gradient(135deg, #fef9e7 0%, #fef3c7 100%);
            border: 1px solid #fde68a;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 20px;
        }

        .dup-summary-text {
            font-size: 13px;
            font-weight: 600;
            color: #92400e;
        }

        .dup-summary-text strong {
            font-size: 16px;
        }

        .dup-group {
            background: white;
            border: 1px solid #f3f4f6;
            border-radius: 12px;
            margin-bottom: 12px;
            overflow: hidden;
        }

        .dup-group-header {
            background: #faf8ff;
            padding: 12px 20px;
            font-size: 12px;
            font-weight: 700;
            color: #6b7280;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dup-group-size {
            font-size: 11px;
            font-weight: 600;
            color: #9A74D8;
            background: #f3f0ff;
            padding: 2px 10px;
            border-radius: 10px;
        }

        .dup-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 20px;
            border-bottom: 1px solid #f9fafb;
            transition: background 0.15s;
        }

        .dup-item:last-child {
            border-bottom: none;
        }

        .dup-item:hover {
            background: #faf8ff;
        }

        .dup-item-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .dup-item-info {
            flex: 1;
            min-width: 0;
        }

        .dup-item-title {
            font-size: 13px;
            font-weight: 600;
            color: #1f2937;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dup-item-meta {
            font-size: 11px;
            color: #9ca3af;
        }

        .dup-view-link {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            font-weight: 600;
            color: #9A74D8;
            text-decoration: none;
            padding: 5px 12px;
            border-radius: 8px;
            border: 1px solid #e8e0ff;
            transition: all 0.2s;
            flex-shrink: 0;
        }

        .dup-view-link:hover {
            background: #f3f0ff;
            border-color: #9A74D8;
        }

        .dup-empty {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border: 1px solid #f3f4f6;
            border-radius: 12px;
        }

        .dup-empty-icon {
            font-size: 48px;
            margin-bottom: 12px;
            opacity: 0.5;
        }

        .dup-empty h3 {
            font-size: 16px;
            font-weight: 600;
            color: #16a34a;
            margin-bottom: 4px;
        }

        .dup-empty p {
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
            <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy &amp; Security</a>
            <a href="${pageContext.request.contextPath}/storagesense" class="tab active">Storage Sense</a>
            <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
        </div>

        <div class="dup-header-bar">
            <a href="${pageContext.request.contextPath}/storagesense" class="dup-back-btn">&larr; Back</a>
            <div class="dup-page-title">Duplicate Finder</div>
            <div style="width: 60px;"></div>
        </div>

        <c:choose>
            <c:when test="${totalDuplicates > 0}">
                <div class="dup-summary">
                    <div class="dup-summary-text">
                        Found <strong>${totalDuplicates}</strong> potential duplicates using
                        <strong><c:out value="${totalDupSizeFormatted}" /></strong>
                    </div>
                </div>

                <c:forEach var="group" items="${groupDisplayData}">
                    <div class="dup-group">
                        <div class="dup-group-header">
                            <span>${group.count} similar files (<c:out value="${group.mimeType}" />)</span>
                            <span class="dup-group-size"><c:out value="${group.sizeFormatted}" /> each</span>
                        </div>
                        <c:forEach var="item" items="${group.items}">
                            <div class="dup-item">
                                <div class="dup-item-icon">${item.icon}</div>
                                <div class="dup-item-info">
                                    <div class="dup-item-title"><c:out value="${item.title}" /></div>
                                    <div class="dup-item-meta">
                                        <c:if test="${not empty item.memoryTitle}">
                                            In: <c:out value="${item.memoryTitle}" /> &middot;
                                        </c:if>
                                        Uploaded <c:out value="${item.dateStr}" /> &middot;
                                        <c:out value="${item.sizeFormatted}" />
                                    </div>
                                </div>
                                <c:if test="${item.memoryId > 0}">
                                    <a href="${pageContext.request.contextPath}/memoryview?id=${item.memoryId}"
                                        class="dup-view-link">
                                        View Memory &rarr;
                                    </a>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="dup-empty">
                    <div class="dup-empty-icon">&#9989;</div>
                    <h3>No duplicates found!</h3>
                    <p>Your storage is clean. No duplicate files detected.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <jsp:include page="/WEB-INF/views/public/footer.jsp" />
</body>

</html>