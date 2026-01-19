<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/adminanalytics'">
                <span class="nav-icon">📈</span> Analytics
            </div>
            <div class="nav-item active" onclick="window.location.href='${pageContext.request.contextPath}/adminuser'">
                <span class="nav-icon">👥</span> Users
            </div>
            <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/admincontent'">
                <span class="nav-icon">📝</span> Content
            </div>
            <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/adminsettings'">
                <span class="nav-icon">⚙️</span> Settings
            </div>
        </div>

        <div class="container">
            <div class="main-content">
                <div class="page-header">
                    <h1 class="page-title">User Management</h1>
                </div>

                <div class="content-layout">
                    <div class="users-section">
                        <div class="section-header">
                            <h2 class="section-title">All Users</h2>
                            <input type="text" class="user-search" placeholder="Search users" id="userSearch">
                        </div>
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
                                <tr>
                                    <td>user1</td>
                                    <td><span class="role-badge role-admin">Admin</span></td>
                                    <td><span class="status-badge status-active">Active</span></td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-btn edit-btn"
                                                onclick="editUser('user1')">Edit</button>
                                            <button class="action-btn delete-btn"
                                                onclick="deleteUser('user1')">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>user2</td>
                                    <td><span class="role-badge role-editor">Editor</span></td>
                                    <td><span class="status-badge status-inactive">Inactive</span></td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-btn edit-btn"
                                                onclick="editUser('user2')">Edit</button>
                                            <button class="action-btn delete-btn"
                                                onclick="deleteUser('user2')">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>user3</td>
                                    <td><span class="role-badge role-subscriber">Subscriber</span></td>
                                    <td><span class="status-badge status-active">Active</span></td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-btn edit-btn"
                                                onclick="editUser('user3')">Edit</button>
                                            <button class="action-btn delete-btn"
                                                onclick="deleteUser('user3')">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>user4</td>
                                    <td><span class="role-badge role-contributor">Contributor</span></td>
                                    <td><span class="status-badge status-active">Active</span></td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-btn edit-btn"
                                                onclick="editUser('user4')">Edit</button>
                                            <button class="action-btn delete-btn"
                                                onclick="deleteUser('user4')">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>user5</td>
                                    <td><span class="role-badge role-editor">Editor</span></td>
                                    <td><span class="status-badge status-inactive">Inactive</span></td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-btn edit-btn"
                                                onclick="editUser('user5')">Edit</button>
                                            <button class="action-btn delete-btn"
                                                onclick="deleteUser('user5')">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>user6</td>
                                    <td><span class="role-badge role-subscriber">Subscriber</span></td>
                                    <td><span class="status-badge status-active">Active</span></td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="action-btn edit-btn"
                                                onclick="editUser('user6')">Edit</button>
                                            <button class="action-btn delete-btn"
                                                onclick="deleteUser('user6')">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="right-sidebar">
                        <div class="activity-card">
                            <h2 class="section-title">Most Active Users</h2>
                            <div class="user-item" onclick="viewUserDetails('user1')">
                                <div class="user-info">
                                    <div class="user-avatar">U1</div>
                                    <div class="user-details">
                                        <span class="user-name">user1</span>
                                        <span class="user-role-small">Admin</span>
                                    </div>
                                </div>
                                <span class="activity-count">1,247</span>
                            </div>
                            <div class="user-item" onclick="viewUserDetails('user3')">
                                <div class="user-info">
                                    <div class="user-avatar">U3</div>
                                    <div class="user-details">
                                        <span class="user-name">user3</span>
                                        <span class="user-role-small">Subscriber</span>
                                    </div>
                                </div>
                                <span class="activity-count">892</span>
                            </div>
                            <div class="user-item" onclick="viewUserDetails('user4')">
                                <div class="user-info">
                                    <div class="user-avatar">U4</div>
                                    <div class="user-details">
                                        <span class="user-name">user4</span>
                                        <span class="user-role-small">Contributor</span>
                                    </div>
                                </div>
                                <span class="activity-count">645</span>
                            </div>
                        </div>

                        <div class="activity-card">
                            <h2 class="section-title">Least Active Users</h2>
                            <div class="user-item" onclick="viewUserDetails('user2')">
                                <div class="user-info">
                                    <div class="user-avatar">U2</div>
                                    <div class="user-details">
                                        <span class="user-name">user2</span>
                                        <span class="user-role-small">Editor</span>
                                    </div>
                                </div>
                                <span class="activity-count">12</span>
                            </div>
                            <div class="user-item" onclick="viewUserDetails('user5')">
                                <div class="user-info">
                                    <div class="user-avatar">U5</div>
                                    <div class="user-details">
                                        <span class="user-name">user5</span>
                                        <span class="user-role-small">Editor</span>
                                    </div>
                                </div>
                                <span class="activity-count">8</span>
                            </div>
                            <div class="user-item" onclick="viewUserDetails('user6')">
                                <div class="user-info">
                                    <div class="user-avatar">U6</div>
                                    <div class="user-details">
                                        <span class="user-name">user6</span>
                                        <span class="user-role-small">Subscriber</span>
                                    </div>
                                </div>
                                <span class="activity-count">3</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function navigateTo(page) {
                console.log(`Navigating to: ${page}`);

                if (page === 'overview') {
                    alert('Navigating to Overview page...');
                    // window.location.href = 'index.html';
                } else if (page === 'users') {
                    console.log('Already on User Management page');
                } else if (page === 'content') {
                    alert('Navigating to Content Management page...');
                    // window.location.href = 'content-management.html';
                } else if (page === 'settings') {
                    alert('Navigating to Settings page...');
                    // window.location.href = 'settings.html';
                }
            }

            function handleLogout() {
                if (confirm('Are you sure you want to logout?')) {
                    window.location.href = '${pageContext.request.contextPath}/logout';
                }
            }

            function editUser(username) {
                alert(`Opening edit panel for ${username}...`);
                // Open edit modal or navigate to edit page
            }

            function deleteUser(username) {
                if (confirm(`Are you sure you want to delete ${username}?`)) {
                    alert(`Deleting ${username}...`);
                    // Perform delete operation
                }
            }

            function viewUserDetails(username) {
                alert(`Viewing detailed profile for ${username}...`);
                // Navigate to user detail page
            }

            // Search functionality
            document.getElementById('searchInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    const searchTerm = e.target.value;
                    if (searchTerm) {
                        alert(`Searching for: ${searchTerm}`);
                    }
                }
            });

            document.getElementById('userSearch').addEventListener('input', function (e) {
                const searchTerm = e.target.value.toLowerCase();
                const rows = document.querySelectorAll('.users-table tbody tr');

                rows.forEach(row => {
                    const username = row.querySelector('td:first-child').textContent.toLowerCase();
                    if (username.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        </script>
    </body>

    </html>