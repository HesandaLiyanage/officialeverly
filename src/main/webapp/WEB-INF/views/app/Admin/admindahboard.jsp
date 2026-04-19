<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Overview - Everly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-styles.css">
</head>
<body>
    <div class="header">
        <div class="logo" onclick="navigateTo('analytics')"><img src="${pageContext.request.contextPath}/resources/assets/everlylogo.png" alt="Everly"></div>
        <div class="header-right">
            <button class="logout-btn" onclick="handleLogout()">Logout</button>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <div class="sidebar-title">ADMIN DASHBOARD</div>
            
            <div class="nav-item" onclick="navigateTo('analytics')">
                Analytics & Reports
            </div>
            <div class="nav-item" onclick="navigateTo('users')">
                User Management
            </div>
            <div class="nav-item" onclick="navigateTo('content')">
                Content Management
            </div>
            <div class="nav-item" onclick="navigateTo('settings')">
                Settings
            </div>
        </div>

        <div class="main-content">
            <div class="page-header">
                <div class="page-title-section">
                    <h1 class="page-title">Overview</h1>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card" onclick="navigateTo('users')">
                    <div class="stat-label">Total Users</div>
                    <div class="stat-value">${totalUsers != null ? totalUsers : 0}</div>
                    <div class="stat-change positive">
                        ● Active: ${activeUsers != null ? activeUsers : 0}
                    </div>
                </div>

                <div class="stat-card" onclick="navigateTo('users')">
                    <div class="stat-label">New Users (7 days)</div>
                    <div class="stat-value">${newUsersWeek != null ? newUsersWeek : 0}</div>
                    <div class="stat-change positive">
                        ↑ Recent signups
                    </div>
                </div>

                <div class="stat-card" onclick="navigateTo('content')">
                    <div class="stat-label">Total Content</div>
                    <div class="stat-value">${totalContent != null ? totalContent : 0}</div>
                    <div class="stat-change positive">
                        Posts + Memories + Journals
                    </div>
                </div>

                <div class="stat-card" onclick="navigateTo('content')">
                    <div class="stat-label">Pending Reports</div>
                    <div class="stat-value">${pendingReports != null ? pendingReports : 0}</div>
                    <c:choose>
                        <c:when test="${pendingReports > 0}">
                            <div class="stat-change negative">⚠ Needs attention</div>
                        </c:when>
                        <c:otherwise>
                            <div class="stat-change positive">✓ All clear</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="content-section">
                <div class="chart-card">
                    <h2 class="card-title">Content Breakdown</h2>
                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; padding: 1rem 0;">
                        <div style="text-align: center; padding: 1.5rem; background: #eef2ff; border-radius: 10px;">
                            <div style="font-size: 2rem; font-weight: 700; color: #5b4cdb;">${contentBreakdown.posts != null ? contentBreakdown.posts : 0}</div>
                            <div style="color: #718096; font-size: 0.9rem; margin-top: 0.3rem;">Feed Posts</div>
                        </div>
                        <div style="text-align: center; padding: 1.5rem; background: #d1fae5; border-radius: 10px;">
                            <div style="font-size: 2rem; font-weight: 700; color: #065f46;">${contentBreakdown.memories != null ? contentBreakdown.memories : 0}</div>
                            <div style="color: #718096; font-size: 0.9rem; margin-top: 0.3rem;">Memories</div>
                        </div>
                        <div style="text-align: center; padding: 1.5rem; background: #fef3c7; border-radius: 10px;">
                            <div style="font-size: 2rem; font-weight: 700; color: #92400e;">${contentBreakdown.journals != null ? contentBreakdown.journals : 0}</div>
                            <div style="color: #718096; font-size: 0.9rem; margin-top: 0.3rem;">Journals</div>
                        </div>
                    </div>
                </div>

                <div class="right-sidebar">
                    <div class="alerts-card">
                        <h2 class="card-title">Recent Signups</h2>
                        <c:choose>
                            <c:when test="${not empty recentSignups}">
                                <c:forEach var="user" items="${recentSignups}">
                                    <div class="feedback-item">
                                        <div class="feedback-header">
                                            <span class="feedback-user">${user.username}</span>
                                        </div>
                                        <div class="feedback-text">${user.email}</div>
                                        <div style="font-size: 0.8rem; color: #a0aec0; margin-top: 0.3rem;">
                                            <c:if test="${user.joinedAt != null}">
                                                <fmt:formatDate value="${user.joinedAt}" pattern="MMM d, yyyy" />
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 2rem; color: #a0aec0;">No recent signups</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="feedback-card">
                        <h2 class="card-title">Report Summary</h2>
                        <div class="feedback-item">
                            <div class="feedback-header">
                                <span class="feedback-user">Pending</span>
                                <span class="status-badge status-pending">${reportStats.pending != null ? reportStats.pending : 0}</span>
                            </div>
                        </div>
                        <div class="feedback-item">
                            <div class="feedback-header">
                                <span class="feedback-user">Reviewed</span>
                                <span class="status-badge status-active">${reportStats.reviewed != null ? reportStats.reviewed : 0}</span>
                            </div>
                        </div>
                        <div class="feedback-item">
                            <div class="feedback-header">
                                <span class="feedback-user">Dismissed</span>
                                <span class="status-badge status-inactive">${reportStats.dismissed != null ? reportStats.dismissed : 0}</span>
                            </div>
                        </div>
                        <div class="feedback-item">
                            <div class="feedback-header">
                                <span class="feedback-user">Action Taken</span>
                                <span class="status-badge status-deleted">${reportStats.action_taken != null ? reportStats.action_taken : 0}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function navigateTo(page) {
            if (page === 'overview') {
                window.location.href = '${pageContext.request.contextPath}/admin';
            } else if (page === 'analytics') {
                window.location.href = '${pageContext.request.contextPath}/adminanalytics';
            } else if (page === 'users') {
                window.location.href = '${pageContext.request.contextPath}/adminuser';
            } else if (page === 'content') {
                window.location.href = '${pageContext.request.contextPath}/admincontent';
            } else if (page === 'settings') {
                window.location.href = '${pageContext.request.contextPath}/adminsettings';
            }
        }

        function handleLogout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/logoutservlet';
            }
        }
    </script>
</body>
</html>
