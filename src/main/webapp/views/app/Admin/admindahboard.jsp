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
    <a href="/admin" class="logo" style="text-decoration: none; color: inherit; cursor: pointer;">Everly</a>
    <div class="header-right">
        <div class="search-box">
            <input type="text" placeholder="Search..." id="searchInput">
            <span class="search-icon">⌕</span>
        </div>
        <a href="/logout" class="logout-btn" style="text-decoration: none;">Logout</a>
    </div>
</div>

<div class="container">
    <div class="sidebar">
        <div class="sidebar-title">Dashboard</div>
        <a href="/admin" class="nav-item active" style="text-decoration: none; color: inherit; display: block;">
            <span>○</span> Overview
        </a>
        <a href="/adminuser" class="nav-item" style="text-decoration: none; color: inherit; display: block;">
            <span>▢</span> User Management
        </a>
        <a href="/admincontent" class="nav-item" style="text-decoration: none; color: inherit; display: block;">
            <span>▢</span> Content Management
        </a>
        <a href="/adminanalytics" class="nav-item" style="text-decoration: none; color: inherit; display: block;">
            <span>▢</span> Analytics and Reports
        </a>
        <a href="/settings" class="nav-item" style="text-decoration: none; color: inherit; display: block;">
            <span>▢</span> Settings
        </a>
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
            <a href="/adminuser" class="stat-card" style="text-decoration: none; color: inherit; display: block;">
                <div class="stat-label">Active Users</div>
                <div class="stat-value">2,318</div>
                <div class="stat-change positive">
                    ↑ +6.08%
                </div>
            </a>

            <a href="/adminuser" class="stat-card" style="text-decoration: none; color: inherit; display: block;">
                <div class="stat-label">New Users</div>
                <div class="stat-value">156</div>
                <div class="stat-change positive">
                    ↑ +15.03%
                </div>
            </a>

            <a href="/admincontent" class="stat-card" style="text-decoration: none; color: inherit; display: block;">
                <div class="stat-label">Total Content</div>
                <div class="stat-value">3,671</div>
                <div class="stat-change negative">
                    ↓ -0.03%
                </div>
            </a>
        </div>

        <div class="content-section">
            <div class="chart-card">
                <h2 class="card-title">User Analytics</h2>
                <a href="/adminanalytics" style="text-decoration: none; color: inherit;">
                    <div class="chart-placeholder">
                        Interactive Chart Area - Click to view detailed analytics
                    </div>
                </a>
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
                    <a href="/feedback?id=1" class="feedback-item" style="text-decoration: none; color: inherit; display: block;">
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
                        <div class="feedback-text">Love the new features! The interface is much more intuitive now.</div>
                    </a>
                    <a href="/feedback?id=2" class="feedback-item" style="text-decoration: none; color: inherit; display: block;">
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
                        <div class="feedback-text">Good overall, but the UI could be improved in some areas.</div>
                    </a>
                    <a href="/feedback?id=3" class="feedback-item" style="text-decoration: none; color: inherit; display: block;">
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
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function handleDateChange(period) {
        console.log(`Date range changed to: ${period}`);
        // Fetch and update dashboard data based on selected period
        // You can make an AJAX call here to update the data without page reload
    }

    function handleAlert(type) {
        console.log(`Alert clicked: ${type}`);
        if (type === 'server') {
            if (confirm('Server Load Alert: CPU usage at 95%. Would you like to view server details?')) {
                window.location.href = '/adminanalytics';
            }
        } else if (type === 'backup') {
            if (confirm('Database Backup: Backup scheduled for 11:00 PM. View backup history?')) {
                window.location.href = '/settings';
            }
        } else if (type === 'registration') {
            if (confirm('User Registration Spike: 45 new users in the last hour. View details?')) {
                window.location.href = '/adminuser';
            }
        }
    }

    // Search functionality
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('searchInput');

        searchInput.addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            if (searchTerm.length > 2) {
                console.log(`Searching for: ${searchTerm}`);
                // Implement search logic here
            }
        });

        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                const searchTerm = e.target.value;
                if (searchTerm) {
                    // Redirect to search results page
                    window.location.href = `/search?q=${encodeURIComponent(searchTerm)}`;
                }
            }
        });
    });
</script>
</body>
</html>