<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Storage Sense | Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/subscription.css">
    <style>
        .storage-sense-wrapper {
            margin-top: 20px;
        }

        .storage-sense-header {
            text-align: left;
            margin-bottom: 36px;
        }

        .storage-sense-header h3 {
            margin: 0 0 8px 0;
            font-size: 28px;
            color: #1a1a2e;
        }

        .storage-sense-header p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
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
        </div>

        <div class="storage-sense-wrapper">
            <div class="storage-sense-header">
                <h3>
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                        <line x1="6" y1="18" x2="6" y2="10"></line>
                        <line x1="12" y1="18" x2="12" y2="6"></line>
                        <line x1="18" y1="18" x2="18" y2="13"></line>
                    </svg>
                    Storage Sense
                </h3>
                <p>Understand and manage your storage usage.</p>
            </div>

            <!-- Overall usage card -->
            <div class="sub-card" style="margin-bottom: 28px;">
                <h3>
                    <span class="card-icon purple">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M5 4h14v16H5z"></path>
                            <path d="M8 4v6h8V4"></path>
                        </svg>
                    </span>
                    Total Storage
                </h3>
                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                    <span style="font-size: 14px; font-weight: 600; color: #1a1a2e;">
                        <c:out value="${usedFormatted}" /> used
                    </span>
                    <span style="font-size: 14px; color: #9ca3af;">
                        <c:out value="${totalFormatted}" /> total
                    </span>
                </div>
                <div class="storage-bar-bg">
                    <div class="storage-bar-fill"
                        style="width: ${usedPercent}%; background: ${progressBarColor};">
                    </div>
                </div>
                <span style="font-size: 13px; color: #9ca3af;">${usedPercent}% used</span>
            </div>

            <!-- Content type breakdown -->
            <div class="sub-card" style="margin-bottom: 28px;">
                <h3>
                    <span class="card-icon blue">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M3 7h6l2 2h10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        </svg>
                    </span>
                    By Content Type
                </h3>
                <c:choose>
                    <c:when test="${not empty contentTypeDisplay}">
                        <c:forEach var="ct" items="${contentTypeDisplay}">
                            <div style="margin-bottom: 14px;">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 4px;">
                                    <span style="font-size: 14px; font-weight: 500; color: #1a1a2e;">
                                        <c:out value="${ct.name}" />
                                    </span>
                                    <span style="font-size: 13px; color: #9ca3af;">
                                        <c:out value="${ct.sizeFormatted}" />
                                    </span>
                                </div>
                                <div class="storage-bar-bg" style="height: 6px;">
                                    <div style="width: ${ct.percent}%; background: ${ct.color}; height: 100%; border-radius: 3px;"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #9ca3af; text-align: center; padding: 20px;">No content data available</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Top Memories by Storage -->
            <div class="sub-card" style="margin-bottom: 28px;">
                <h3>
                    <span class="card-icon green">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                            <circle cx="12" cy="13" r="4"></circle>
                        </svg>
                    </span>
                    Top Memories by Storage
                </h3>
                <c:choose>
                    <c:when test="${not empty topMemoryDisplay}">
                        <c:forEach var="mem" items="${topMemoryDisplay}">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid #f3f4f6;">
                                <span style="font-size: 14px; color: #1a1a2e;">
                                    <c:out value="${mem.title}" />
                                </span>
                                <span style="font-size: 13px; color: #9ca3af; font-weight: 500;">
                                    <c:out value="${mem.sizeFormatted}" />
                                </span>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #9ca3af; text-align: center; padding: 20px;">No memories yet</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Top Groups by Storage -->
            <div class="sub-card" style="margin-bottom: 28px;">
                <h3>
                    <span class="card-icon orange">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M16 21v-2a4 4 0 0 0-8 0v2"></path>
                            <circle cx="12" cy="8" r="4"></circle>
                            <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M2 21v-2a4 4 0 0 1 3-3.87"></path>
                        </svg>
                    </span>
                    Top Groups by Storage
                </h3>
                <c:choose>
                    <c:when test="${not empty topGroupDisplay}">
                        <c:forEach var="grp" items="${topGroupDisplay}">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid #f3f4f6;">
                                <span style="font-size: 14px; color: #1a1a2e;">
                                    <c:out value="${grp.groupName}" />
                                </span>
                                <span style="font-size: 13px; color: #9ca3af; font-weight: 500;">
                                    <c:out value="${grp.sizeFormatted}" />
                                </span>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #9ca3af; text-align: center; padding: 20px;">No group data</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Quick Actions -->
            <div class="sub-card" style="margin-bottom: 28px;">
                <h3>
                    <span class="card-icon purple">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M13 2 4 14h6l-1 8 9-12h-6z"></path>
                        </svg>
                    </span>
                    Quick Actions
                </h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
                    <!-- Duplicate Finder -->
                    <a href="${pageContext.request.contextPath}/duplicatefinder"
                        style="display: flex; align-items: center; gap: 12px; padding: 16px; background: #fdfbff; border-radius: 12px; border: 1px solid #f0e6ff; text-decoration: none; transition: all 0.2s;">
                        <span style="display: inline-flex; align-items: center; justify-content: center;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2">
                                <circle cx="11" cy="11" r="7"></circle>
                                <line x1="16.65" y1="16.65" x2="21" y2="21"></line>
                            </svg>
                        </span>
                        <div>
                            <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">Find Duplicates</div>
                            <div style="font-size: 12px; color: #9ca3af;">
                                ${duplicateCount} duplicate files • <c:out value="${duplicateSizeFormatted}" />
                            </div>
                        </div>
                    </a>

                    <!-- Empty Trash -->
                    <a href="${pageContext.request.contextPath}/trashmgt"
                        style="display: flex; align-items: center; gap: 12px; padding: 16px; background: #fdfbff; border-radius: 12px; border: 1px solid #f0e6ff; text-decoration: none; transition: all 0.2s;">
                        <span style="display: inline-flex; align-items: center; justify-content: center;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M8 6V4a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2"></path>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>
                            </svg>
                        </span>
                        <div>
                            <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">Empty Trash</div>
                            <div style="font-size: 12px; color: #9ca3af;">${trashCount} items in trash</div>
                        </div>
                    </a>

                    <!-- Upgrade Storage -->
                    <a href="${pageContext.request.contextPath}/changeplan"
                        style="display: flex; align-items: center; gap: 12px; padding: 16px; background: #fdfbff; border-radius: 12px; border: 1px solid #f0e6ff; text-decoration: none; transition: all 0.2s;">
                        <span style="display: inline-flex; align-items: center; justify-content: center;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2">
                                <path d="M4 14c4-7 9-10 16-10-1 7-4 12-11 16l-5-6z"></path>
                                <path d="M8 16l-1 4 4-1"></path>
                            </svg>
                        </span>
                        <div>
                            <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">Upgrade Storage</div>
                            <div style="font-size: 12px; color: #9ca3af;">Get more space</div>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Stats summary -->
            <div class="sub-card" style="margin-bottom: 40px;">
                <h3>
                    <span class="card-icon blue">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="3 17 9 11 13 15 21 7"></polyline>
                        </svg>
                    </span>
                    Account Stats
                </h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(120px, 1fr)); gap: 16px; text-align: center;">
                    <div style="padding: 16px; background: #fdfbff; border-radius: 10px;">
                        <div style="font-size: 24px; font-weight: 800; color: #9A74D8;">${memoryCount}</div>
                        <div style="font-size: 12px; color: #9ca3af;">Memories</div>
                    </div>
                    <div style="padding: 16px; background: #fdfbff; border-radius: 10px;">
                        <div style="font-size: 24px; font-weight: 800; color: #9A74D8;">${journalCount}</div>
                        <div style="font-size: 12px; color: #9ca3af;">Journals</div>
                    </div>
                    <div style="padding: 16px; background: #fdfbff; border-radius: 10px;">
                        <div style="font-size: 24px; font-weight: 800; color: #9A74D8;">${autographCount}</div>
                        <div style="font-size: 12px; color: #9ca3af;">Autographs</div>
                    </div>
                    <div style="padding: 16px; background: #fdfbff; border-radius: 10px;">
                        <div style="font-size: 24px; font-weight: 800; color: #9A74D8;">${otherContentCount}</div>
                        <div style="font-size: 12px; color: #9ca3af;">Other Content</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/public/footer.jsp" />
</body>

</html>
