<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Everly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-styles.css">
    <style>
        /* Flash message styles */
        .flash-message {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: space-between;
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .flash-message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .flash-message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .flash-close {
            background: none;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            color: inherit;
            padding: 0 0.5rem;
        }

        /* Confirmation modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.active {
            display: flex;
        }
        .modal-box {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            max-width: 420px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .modal-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 0.8rem;
        }
        .modal-text {
            color: #4a5568;
            margin-bottom: 1.5rem;
            line-height: 1.5;
        }
        .modal-actions {
            display: flex;
            gap: 0.8rem;
            justify-content: flex-end;
        }
        .modal-btn {
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            font-size: 0.9rem;
            transition: all 0.3s;
        }
        .modal-btn.cancel {
            background: #e2e8f0;
            color: #4a5568;
        }
        .modal-btn.cancel:hover {
            background: #cbd5e0;
        }
        .modal-btn.danger {
            background: #e53e3e;
            color: white;
        }
        .modal-btn.danger:hover {
            background: #c53030;
        }
        .modal-btn.confirm {
            background: #5b4cdb;
            color: white;
        }
        .modal-btn.confirm:hover {
            background: #4a3cc0;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #718096;
        }
        .empty-state p {
            margin-top: 0.5rem;
            font-size: 0.95rem;
        }

        /* User search input */
        .user-search {
            padding: 0.6rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.9rem;
            width: 220px;
            transition: all 0.3s;
        }
        .user-search:focus {
            outline: none;
            border-color: #5b4cdb;
            box-shadow: 0 0 0 3px rgba(91, 76, 219, 0.1);
        }
    </style>
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
            <div class="nav-item" onclick="navigateTo('analytics')">
                <span>▢</span> Analytics & Reports
            </div>
            <div class="nav-item active" onclick="navigateTo('users')">
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
                <h1 class="page-title">User Management</h1>
                <p class="page-subtitle">ADMIN DASHBOARD</p>
            </div>

            <!-- Flash message -->
            <c:if test="${not empty flashMessage}">
                <div class="flash-message ${flashType}" id="flashMsg">
                    <span>${flashMessage}</span>
                    <button class="flash-close" onclick="document.getElementById('flashMsg').style.display='none'">✕</button>
                </div>
            </c:if>

            <div class="content-layout">
                <div class="users-section">
                    <div class="section-header">
                        <h2 class="section-title">All Users</h2>
                        <input type="text" class="user-search" placeholder="Search users" id="userSearch">
                    </div>
                    <c:choose>
                        <c:when test="${not empty allUsers}">
                            <table class="users-table">
                                <thead>
                                    <tr>
                                        <th>Username</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${allUsers}">
                                        <tr>
                                            <td>${user.username}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.username == 'admin' || user.username == 'Admin'}">
                                                        <span class="role-badge role-admin">Admin</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="role-badge role-subscriber">Member</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.isActive}">
                                                        <span class="status-badge status-active">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-inactive">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <c:choose>
                                                        <c:when test="${user.isActive}">
                                                            <button class="action-btn edit-btn"
                                                                onclick="showConfirmModal('deactivate', ${user.userId}, '${user.username}')">
                                                                Deactivate
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="action-btn edit-btn"
                                                                onclick="showConfirmModal('activate', ${user.userId}, '${user.username}')">
                                                                Activate
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button class="action-btn delete-btn"
                                                        onclick="showConfirmModal('delete', ${user.userId}, '${user.username}')">
                                                        Delete
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <p>No users found in the system.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="right-sidebar">
                    <div class="activity-card">
                        <h2 class="section-title">Most Active Users</h2>
                        <c:choose>
                            <c:when test="${not empty mostActiveUsers}">
                                <c:forEach var="user" items="${mostActiveUsers}">
                                    <div class="user-item">
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                ${fn:toUpperCase(fn:substring(user.username, 0, 1))}${fn:length(user.username) > 1 ? fn:substring(user.username, 1, 2) : ''}
                                            </div>
                                            <div class="user-details">
                                                <span class="user-name">${user.username}</span>
                                                <span class="user-role-small">${user.activityCount} actions</span>
                                            </div>
                                        </div>
                                        <span class="activity-count">${user.activityCount}</span>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state"><p>No activity data available.</p></div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="activity-card">
                        <h2 class="section-title">Least Active Users</h2>
                        <c:choose>
                            <c:when test="${not empty leastActiveUsers}">
                                <c:forEach var="user" items="${leastActiveUsers}">
                                    <div class="user-item">
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                ${fn:toUpperCase(fn:substring(user.username, 0, 1))}${fn:length(user.username) > 1 ? fn:substring(user.username, 1, 2) : ''}
                                            </div>
                                            <div class="user-details">
                                                <span class="user-name">${user.username}</span>
                                                <span class="user-role-small">${user.activityCount} actions</span>
                                            </div>
                                        </div>
                                        <span class="activity-count">${user.activityCount}</span>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state"><p>No activity data available.</p></div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div class="modal-overlay" id="confirmModal">
        <div class="modal-box">
            <div class="modal-title" id="modalTitle">Confirm Action</div>
            <div class="modal-text" id="modalText">Are you sure?</div>
            <div class="modal-actions">
                <button class="modal-btn cancel" onclick="closeModal()">Cancel</button>
                <form id="actionForm" method="POST" action="${pageContext.request.contextPath}/adminuseraction" style="display:inline;">
                    <input type="hidden" name="action" id="modalAction">
                    <input type="hidden" name="userId" id="modalUserId">
                    <button type="submit" class="modal-btn danger" id="modalSubmitBtn">Confirm</button>
                </form>
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

        /* User search filter */
        document.getElementById('userSearch').addEventListener('input', function(e) {
            var searchTerm = e.target.value.toLowerCase();
            var rows = document.querySelectorAll('.users-table tbody tr');

            rows.forEach(function(row) {
                var username = row.querySelector('td:first-child').textContent.toLowerCase();
                if (username.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        /* Confirmation modal */
        function showConfirmModal(action, userId, username) {
            document.getElementById('modalAction').value = action;
            document.getElementById('modalUserId').value = userId;

            var submitBtn = document.getElementById('modalSubmitBtn');

            if (action === 'delete') {
                document.getElementById('modalTitle').textContent = 'Delete User';
                document.getElementById('modalText').textContent =
                    'Are you sure you want to permanently delete "' + username + '"? This action cannot be undone and all their data will be removed.';
                submitBtn.textContent = 'Delete';
                submitBtn.className = 'modal-btn danger';
            } else if (action === 'deactivate') {
                document.getElementById('modalTitle').textContent = 'Deactivate User';
                document.getElementById('modalText').textContent =
                    'Are you sure you want to deactivate "' + username + '"? They will not be able to log in until reactivated.';
                submitBtn.textContent = 'Deactivate';
                submitBtn.className = 'modal-btn danger';
            } else if (action === 'activate') {
                document.getElementById('modalTitle').textContent = 'Activate User';
                document.getElementById('modalText').textContent =
                    'Are you sure you want to activate "' + username + '"? They will be able to log in again.';
                submitBtn.textContent = 'Activate';
                submitBtn.className = 'modal-btn confirm';
            }

            document.getElementById('confirmModal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('confirmModal').classList.remove('active');
        }

        // Close modal on overlay click
        document.getElementById('confirmModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });

        // Auto-hide flash message after 5 seconds
        var flashMsg = document.getElementById('flashMsg');
        if (flashMsg) {
            setTimeout(function() {
                flashMsg.style.transition = 'opacity 0.5s';
                flashMsg.style.opacity = '0';
                setTimeout(function() { flashMsg.style.display = 'none'; }, 500);
            }, 5000);
        }
    </script>
</body>
</html>
