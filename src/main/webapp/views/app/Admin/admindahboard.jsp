<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <jsp:include page="../../public/header2.jsp" />
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Everly Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-styles.css">
    </head>

    <body>
        <div class="header">
            <div class="logo">Everly</div>
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
                <div class="nav-item active" onclick="window.location.href='${pageContext.request.contextPath}/admin'">
                    <span>○</span> Overview
                </div>
                <div class="nav-item"
                    onclick="window.location.href='${pageContext.request.contextPath}/adminanalytics'">
                    <span>▢</span> Analytics and Reports
                </div>
                <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/adminuser'">
                    <span>▢</span> User Management
                </div>
                <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/admincontent'">
                    <span>▢</span> Content Management
                </div>
                <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/adminsettings'">
                    <span>▢</span> Settings
                </div>
            </div>

            <div class="main-content">
                <div class="page-header">
                    <h1 class="page-title">Overview</h1>
                    <select class="date-selector" onchange="handleDateChange(this.value)">
                        <option value="today">Today</option>
                        <option value="week">This Week</option>
                        <option value="month">This Month</option>
                        <option value="year">This Year</option>
                    </select>
                </div>

                <div class="stats-grid">
                    <div class="stat-card" onclick="navigateTo('users')">
                        <div class="stat-label">Active Users</div>
                        <div class="stat-value">2,318</div>
                        <div class="stat-change positive">
                            ↑ +6.08%
                        </div>
                    </div>

                    <div class="stat-card" onclick="navigateTo('users')">
                        <div class="stat-label">New Users</div>
                        <div class="stat-value">156</div>
                        <div class="stat-change positive">
                            ↑ +15.03%
                        </div>
                    </div>

                    <div class="stat-card" onclick="navigateTo('content')">
                        <div class="stat-label">Total Content</div>
                        <div class="stat-value">3,671</div>
                        <div class="stat-change negative">
                            ↓ -0.03%
                        </div>
                    </div>

                </div>

                <div class="content-section">
                    <div class="chart-card">
                        <h2 class="card-title">User Analytics</h2>
                        <div class="chart-placeholder">
                            Interactive Chart Area - Click to view detailed analytics
                        </div>
                    </div>

                    <div class="right-sidebar">
                        <div class="alerts-card">
                            <h2 class="card-title">Alerts</h2>
                            <div class="alert-item critical" onclick="handleAlert('server')">
                                <div class="alert-title">Server load at 95%</div>
                                <div class="alert-time">Just now</div>
                            </div>
                            <div class="alert-item" onclick="handleAlert('backup')">
                                <div class="alert-title">Database backup pending</div>
                                <div class="alert-time">59 minutes ago</div>
                            </div>
                            <div class="alert-item info" onclick="handleAlert('registration')">
                                <div class="alert-title">New user registration spike</div>
                                <div class="alert-time">12 hours ago</div>
                            </div>
                        </div>

                        <div class="feedback-card">
                            <h2 class="card-title">Recent Feedback</h2>
                            <div class="feedback-item" onclick="viewFeedback(1)">
                                <div class="feedback-header">
                                    <span class="feedback-user">John Doe</span>
                                    <div class="star-rating">
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                    </div>
                                </div>
                                <div class="feedback-text">Love the new features! The interface is much more intuitive
                                    now.</div>
                            </div>
                            <div class="feedback-item" onclick="viewFeedback(2)">
                                <div class="feedback-header">
                                    <span class="feedback-user">Sarah Miller</span>
                                    <div class="star-rating">
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star empty">★</span>
                                        <span class="star empty">★</span>
                                    </div>
                                </div>
                                <div class="feedback-text">Good overall, but the UI could be improved in some areas.
                                </div>
                            </div>
                            <div class="feedback-item" onclick="viewFeedback(3)">
                                <div class="feedback-header">
                                    <span class="feedback-user">Mike Johnson</span>
                                    <div class="star-rating">
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star empty">★</span>
                                    </div>
                                </div>
                                <div class="feedback-text">Great product! Looking forward to future updates.</div>
                            </div>
                        </div>
                    </div>
                </div>


            </div>
        </div>

        <script>
            function navigateTo(page, subPage = null) {
                console.log(`Navigating to: ${page}${subPage ? '/' + subPage : ''}`);

                // Update active nav item
                document.querySelectorAll('.nav-item').forEach(item => {
                    item.classList.remove('active');
                });

                // Find and activate the clicked nav item
                const navItems = document.querySelectorAll('.nav-item');
                navItems.forEach(item => {
                    if ((page === 'overview' && item.textContent.includes('Overview')) ||
                        (page === 'users' && item.textContent.includes('User Management')) ||
                        (page === 'content' && item.textContent.includes('Content Management')) ||
                        (page === 'settings' && item.textContent.includes('Settings'))) {
                        item.classList.add('active');
                    }
                });

                // Simulate navigation
                if (page === 'overview') {
                    // Already on Overview - could reload or do nothing
                    console.log('Already on Overview page');
                } else if (page === 'users') {
                    alert('Navigating to User Management page...');
                    // window.location.href = 'user-management.html';
                } else if (page === 'content') {
                    alert('Navigating to Content Management page...');
                    // window.location.href = 'content-management.html';
                } else if (page === 'settings') {
                    const section = subPage ? ` - ${subPage.charAt(0).toUpperCase() + subPage.slice(1)}` : '';
                    alert(`Navigating to Settings${section} page...`);
                    // window.location.href = `settings.html${subPage ? '#' + subPage : ''}`;
                }
            }

            function handleLogout() {
                if (confirm('Are you sure you want to logout?')) {
                    window.location.href = '${pageContext.request.contextPath}/logout';
                }
            }

            function handleDateChange(period) {
                console.log(`Date range changed to: ${period}`);
                alert(`Updating dashboard data for: ${period}`);
                // Fetch and update dashboard data based on selected period
            }

            function handleAlert(type) {
                console.log(`Alert clicked: ${type}`);
                if (type === 'server') {
                    alert('Server Load Alert: CPU usage at 95%. Would you like to view server details?');
                    // navigateTo('analytics', 'server');
                } else if (type === 'backup') {
                    alert('Database Backup: Backup scheduled for 11:00 PM. View backup history?');
                    // navigateTo('settings', 'backup');
                } else if (type === 'registration') {
                    alert('User Registration Spike: 45 new users in the last hour. View details?');
                    // navigateTo('users', 'recent');
                }
            }

            function viewFeedback(id) {
                console.log(`Viewing feedback #${id}`);
                alert(`Opening detailed feedback view for feedback #${id}...`);
                // window.location.href = `feedback.html?id=${id}`;
            }

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', function (e) {
                const searchTerm = e.target.value.toLowerCase();
                if (searchTerm.length > 2) {
                    console.log(`Searching for: ${searchTerm}`);
                    // Implement search logic here
                }
            });

            document.getElementById('searchInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    const searchTerm = e.target.value;
                    if (searchTerm) {
                        alert(`Searching for: ${searchTerm}`);
                        // Perform search
                    }
                }
            });
        </script>
    </body>

    </html>