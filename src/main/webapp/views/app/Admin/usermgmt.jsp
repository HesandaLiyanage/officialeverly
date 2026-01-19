<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>User Management - Everly Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-styles.css">
                <style>
                    .admin-topbar {
                        position: fixed;
                        top: 0;
                        right: 0;
                        left: 260px;
                        height: 60px;
                        background: white;
                        display: flex;
                        justify-content: flex-end;
                        align-items: center;
                        padding: 0 2rem;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
                        z-index: 100;
                    }

                    .sidebar {
                        position: fixed;
                        top: 0;
                        left: 0;
                        height: 100vh;
                    }

                    .container {
                        margin-left: 260px;
                        padding-top: 60px;
                    }

                    .main-content {
                        padding: 2rem;
                    }

                    .sidebar-logo {
                        font-size: 1.8rem;
                        font-weight: 700;
                        color: #5b4cdb;
                        padding: 1.5rem 2rem;
                        border-bottom: 1px solid #eee;
                    }

                    .nav-icon {
                        width: 20px;
                        text-align: center;
                    }

                    .stats-row {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
                        gap: 1.5rem;
                        margin-bottom: 2rem;
                    }

                    .activity-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 1.5rem;
                        margin-bottom: 2rem;
                    }

                    .activity-card {
                        background: white;
                        border-radius: 12px;
                        padding: 1.5rem;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
                    }

                    .activity-card h3 {
                        font-size: 1.1rem;
                        margin-bottom: 1rem;
                        color: #1a202c;
                    }

                    .activity-item {
                        display: flex;
                        justify-content: space-between;
                        padding: 0.75rem 0;
                        border-bottom: 1px solid #eee;
                    }

                    .activity-item:last-child {
                        border-bottom: none;
                    }

                    .activity-username {
                        font-weight: 500;
                        color: #2d3748;
                    }

                    .activity-count {
                        color: #5b4cdb;
                        font-weight: 600;
                    }

                    .delete-btn {
                        background: #e53e3e !important;
                        color: white !important;
                        border: none !important;
                    }

                    .delete-btn:hover {
                        background: #c53030 !important;
                    }
                </style>
            </head>

            <body>
                <div class="admin-topbar">
                    <button class="logout-btn" onclick="handleLogout()">
                        <span style="margin-right: 8px;">⎋</span> Logout
                    </button>
                </div>

                <div class="sidebar">
                    <div class="sidebar-logo">Everly</div>
                    <div class="sidebar-title">Admin Panel</div>
                    <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/admin'">
                        <span class="nav-icon">📊</span> Overview
                    </div>
                    <div class="nav-item"
                        onclick="window.location.href='${pageContext.request.contextPath}/adminanalytics'">
                        <span class="nav-icon">📈</span> Analytics
                    </div>
                    <div class="nav-item active"
                        onclick="window.location.href='${pageContext.request.contextPath}/adminuser'">
                        <span class="nav-icon">👥</span> Users
                    </div>
                    <div class="nav-item"
                        onclick="window.location.href='${pageContext.request.contextPath}/admincontent'">
                        <span class="nav-icon">📝</span> Content
                    </div>
                    <div class="nav-item"
                        onclick="window.location.href='${pageContext.request.contextPath}/adminsettings'">
                        <span class="nav-icon">⚙️</span> Settings
                    </div>
                </div>

                <div class="container">
                    <div class="main-content">
                        <div class="page-header">
                            <h1 class="page-title">User Management</h1>
                            <p style="color: #718096;">Total Users: ${totalUsers}</p>
                        </div>

                        <!-- Activity Analytics -->
                        <div class="activity-grid">
                            <div class="activity-card">
                                <h3>🏆 Most Active Users</h3>
                                <c:forEach var="user" items="${mostActive}">
                                    <div class="activity-item">
                                        <span class="activity-username">${user.username}</span>
                                        <span class="activity-count">${user.memoryCount} memories</span>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty mostActive}">
                                    <p style="color: #718096; text-align: center;">No users yet</p>
                                </c:if>
                            </div>
                            <div class="activity-card">
                                <h3>📉 Least Active Users</h3>
                                <c:forEach var="user" items="${leastActive}">
                                    <div class="activity-item">
                                        <span class="activity-username">${user.username}</span>
                                        <span class="activity-count">${user.memoryCount} memories</span>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty leastActive}">
                                    <p style="color: #718096; text-align: center;">No users yet</p>
                                </c:if>
                            </div>
                        </div>

                        <!-- Users Table -->
                        <div class="users-section">
                            <div class="section-header">
                                <h2 class="section-title">All Users</h2>
                                <input type="text" class="user-search" placeholder="Search users..." id="userSearch"
                                    onkeyup="filterUsers()">
                            </div>
                            <table class="users-table" id="usersTable">
                                <thead>
                                    <tr>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Joined</th>
                                        <th>Last Login</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr data-userid="${user.id}" data-username="${user.username}">
                                            <td>${user.username}</td>
                                            <td>${user.email}</td>
                                            <td>
                                                <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" />
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.lastLogin != null}">
                                                        <fmt:formatDate value="${user.lastLogin}"
                                                            pattern="MMM dd, yyyy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #a0aec0;">Never</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.is_active()}">
                                                        <span class="status-badge status-active">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-inactive">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button class="action-btn delete-btn"
                                                    onclick="deleteUser(${user.id}, '${user.username}')">
                                                    Delete
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="6" style="text-align: center; color: #718096; padding: 2rem;">
                                                No users found
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <script>
                    function handleLogout() {
                        if (confirm('Are you sure you want to logout?')) {
                            window.location.href = '${pageContext.request.contextPath}/logout';
                        }
                    }

                    function filterUsers() {
                        const searchTerm = document.getElementById('userSearch').value.toLowerCase();
                        const rows = document.querySelectorAll('#usersTable tbody tr');

                        rows.forEach(row => {
                            const username = row.getAttribute('data-username');
                            if (username && username.toLowerCase().includes(searchTerm)) {
                                row.style.display = '';
                            } else {
                                row.style.display = 'none';
                            }
                        });
                    }

                    function deleteUser(userId, username) {
                        if (!confirm('Are you sure you want to delete user "' + username + '"? This action cannot be undone and will delete all their data.')) {
                            return;
                        }

                        fetch('${pageContext.request.contextPath}/adminuser', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'action=delete&userId=' + userId
                        })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    // Remove the row from table
                                    const row = document.querySelector('tr[data-userid="' + userId + '"]');
                                    if (row) {
                                        row.remove();
                                    }
                                    alert('User deleted successfully');
                                    // Reload to update activity stats
                                    window.location.reload();
                                } else {
                                    alert('Error: ' + data.error);
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('Error deleting user');
                            });
                    }
                </script>
            </body>

            </html>