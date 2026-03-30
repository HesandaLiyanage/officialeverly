<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics & Reports - Everly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-styles.css">
</head>
<body>
    <div class="header">
        <div class="logo" onclick="navigateTo('overview')">Everly</div>
        <div class="header-right">
            <div class="search-box">
                <input type="text" placeholder="Search..." id="searchInput">
                <span class="search-icon">⌕</span>
            </div>
            <button class="logout-btn" onclick="handleLogout()">Logout</button>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <div class="sidebar-title">Dashboard</div>
            <div class="nav-item" onclick="navigateTo('overview')">
                <span>○</span> Overview
            </div>
            <div class="nav-item active" onclick="navigateTo('analytics')">
                <span>▢</span> Analytics & Reports
            </div>
            <div class="nav-item" onclick="navigateTo('users')">
                <span>▢</span> User Management
            </div>
            <div class="nav-item" onclick="navigateTo('content')">
                <span>▢</span> Content Management
            </div>
            <div class="nav-item" onclick="navigateTo('settings')">
                <span>▢</span> Settings
            </div>
        </div>

        <div class="main-content">
            <div class="page-header">
                <div class="page-title-section">
                    <h1 class="page-title">Analytics & Reports</h1>
                    <p class="page-subtitle">ADMIN DASHBOARD</p>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Users</div>
                    <div class="stat-value">${totalUsers != null ? totalUsers : 0}</div>
                    <div class="stat-change positive">
                        Active: ${activeUsers != null ? activeUsers : 0}
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">New Users (30 days)</div>
                    <div class="stat-value">${newUsersMonth != null ? newUsersMonth : 0}</div>
                    <div class="stat-change positive">
                        ↑ Recent registrations
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">Total Posts</div>
                    <div class="stat-value">${totalPosts != null ? totalPosts : 0}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">Total Memories</div>
                    <div class="stat-value">${totalMemories != null ? totalMemories : 0}</div>
                </div>
            </div>

            <div class="content-layout">
                <div class="chart-section">
                    <div class="chart-card">
                        <h2 class="card-title">Content Breakdown</h2>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; padding: 1rem 0;">
                            <div style="text-align: center; padding: 1.5rem; background: #eef2ff; border-radius: 10px;">
                                <div style="font-size: 2rem; font-weight: 700; color: #5b4cdb;">${contentBreakdown.posts != null ? contentBreakdown.posts : 0}</div>
                                <div style="color: #718096; font-size: 0.9rem;">Feed Posts</div>
                            </div>
                            <div style="text-align: center; padding: 1.5rem; background: #d1fae5; border-radius: 10px;">
                                <div style="font-size: 2rem; font-weight: 700; color: #065f46;">${contentBreakdown.memories != null ? contentBreakdown.memories : 0}</div>
                                <div style="color: #718096; font-size: 0.9rem;">Memories</div>
                            </div>
                            <div style="text-align: center; padding: 1.5rem; background: #fef3c7; border-radius: 10px;">
                                <div style="font-size: 2rem; font-weight: 700; color: #92400e;">${contentBreakdown.journals != null ? contentBreakdown.journals : 0}</div>
                                <div style="color: #718096; font-size: 0.9rem;">Journals</div>
                            </div>
                            <div style="text-align: center; padding: 1.5rem; background: #fce7f3; border-radius: 10px;">
                                <div style="font-size: 2rem; font-weight: 700; color: #9d174d;">${contentBreakdown.groups != null ? contentBreakdown.groups : 0}</div>
                                <div style="color: #718096; font-size: 0.9rem;">Groups</div>
                            </div>
                        </div>
                    </div>

                    <div class="chart-card">
                        <h2 class="card-title">Most Liked Posts</h2>
                        <c:choose>
                            <c:when test="${not empty mostLikedPosts}">
                                <table class="posts-table">
                                    <thead>
                                        <tr>
                                            <th>User</th>
                                            <th>Caption</th>
                                            <th>Likes</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="post" items="${mostLikedPosts}">
                                            <tr>
                                                <td>${post.username}</td>
                                                <td>${fn:length(post.caption) > 40 ? fn:substring(post.caption, 0, 40) : post.caption}${fn:length(post.caption) > 40 ? '...' : ''}</td>
                                                <td><strong>${post.likeCount}</strong></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 2rem; color: #a0aec0;">No post data available yet.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="right-sidebar">
                    <div class="insights-card" style="background: white; padding: 1.8rem; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.08);">
                        <h2 class="card-title">Top Posters</h2>
                        <c:choose>
                            <c:when test="${not empty topPosters}">
                                <c:forEach var="poster" items="${topPosters}">
                                    <div class="user-item">
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                ${fn:toUpperCase(fn:substring(poster.username, 0, 1))}
                                            </div>
                                            <div class="user-details">
                                                <span class="user-name">${poster.username}</span>
                                                <span class="user-role-small">${poster.postCount} posts</span>
                                            </div>
                                        </div>
                                        <span class="activity-count">${poster.postCount}</span>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 2rem; color: #a0aec0;">No poster data available.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="insights-card" style="background: white; padding: 1.8rem; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.08);">
                        <h2 class="card-title">Platform Summary</h2>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.8rem;">
                            <div style="text-align: center; padding: 1rem; background: #f7fafc; border-radius: 8px;">
                                <div style="font-size: 1.5rem; font-weight: 700; color: #1a202c;">${totalUsers != null ? totalUsers : 0}</div>
                                <div style="font-size: 0.8rem; color: #718096;">Users</div>
                            </div>
                            <div style="text-align: center; padding: 1rem; background: #f7fafc; border-radius: 8px;">
                                <div style="font-size: 1.5rem; font-weight: 700; color: #1a202c;">${totalPosts != null ? totalPosts : 0}</div>
                                <div style="font-size: 0.8rem; color: #718096;">Posts</div>
                            </div>
                            <div style="text-align: center; padding: 1rem; background: #f7fafc; border-radius: 8px;">
                                <div style="font-size: 1.5rem; font-weight: 700; color: #1a202c;">${totalMemories != null ? totalMemories : 0}</div>
                                <div style="font-size: 0.8rem; color: #718096;">Memories</div>
                            </div>
                            <div style="text-align: center; padding: 1rem; background: #f7fafc; border-radius: 8px;">
                                <div style="font-size: 1.5rem; font-weight: 700; color: #1a202c;">${totalJournals != null ? totalJournals : 0}</div>
                                <div style="font-size: 0.8rem; color: #718096;">Journals</div>
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
                window.location.href = '${pageContext.request.contextPath}/login';
            }
        }
    </script>
</body>
</html>