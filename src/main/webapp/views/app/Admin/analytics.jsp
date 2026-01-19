<%-- Created by IntelliJ IDEA. User: hesandaliyanage Date: 2026-01-19 Time: 10:47 To change this template use File |
    Settings | File Templates. --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                    <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/admin'">
                        <span>○</span> Overview
                    </div>
                    <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/adminuser'">
                        <span>▢</span> User Management
                    </div>
                    <div class="nav-item"
                        onclick="window.location.href='${pageContext.request.contextPath}/admincontent'">
                        <span>▢</span> Content Management
                    </div>
                    <div class="nav-item active"
                        onclick="window.location.href='${pageContext.request.contextPath}/adminanalytics'">
                        <span>▢</span> Analytics & Reports
                    </div>
                    <div class="nav-item"
                        onclick="window.location.href='${pageContext.request.contextPath}/adminsettings'">
                        <span>▢</span> Settings
                    </div>
                </div>

                <div class="main-content">
                    <div class="page-header">
                        <div class="page-title-section">
                            <h1 class="page-title">Analytics & Reports</h1>
                            <p class="page-subtitle">ADMIN DASHBOARD</p>
                        </div>
                        <div class="header-actions">
                            <select class="date-selector" onchange="handleDateChange(this.value)">
                                <option value="today">Today</option>
                                <option value="week">This Week</option>
                                <option value="month">This Month</option>
                                <option value="year">This Year</option>
                            </select>
                            <button class="export-btn" onclick="exportReport()">Export Report</button>
                        </div>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-label">Total Views</div>
                            <div class="stat-value">45,682</div>
                            <div class="stat-change positive">
                                ↑ +12.3%
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-label">Engagement Rate</div>
                            <div class="stat-value">68.4%</div>
                            <div class="stat-change positive">
                                ↑ +5.2%
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-label">Avg. Session Time</div>
                            <div class="stat-value">8m 24s</div>
                            <div class="stat-change negative">
                                ↓ -2.1%
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-label">Bounce Rate</div>
                            <div class="stat-value">42.1%</div>
                            <div class="stat-change positive">
                                ↓ -3.4%
                            </div>
                        </div>
                    </div>

                    <div class="content-layout">
                        <div class="chart-section">
                            <div class="chart-card">
                                <div class="card-header">
                                    <h2 class="card-title">User Growth Trends</h2>
                                    <div class="view-tabs">
                                        <button class="tab active" onclick="switchTab(this, 'daily')">Daily</button>
                                        <button class="tab" onclick="switchTab(this, 'weekly')">Weekly</button>
                                        <button class="tab" onclick="switchTab(this, 'monthly')">Monthly</button>
                                    </div>
                                </div>
                                <div class="chart-placeholder">
                                    User Growth Chart - Line graph showing daily active users, new registrations, and
                                    retention rates over time
                                </div>
                            </div>

                            <div class="chart-card">
                                <div class="card-header">
                                    <h2 class="card-title">Content Performance</h2>
                                    <div class="view-tabs">
                                        <button class="tab active" onclick="switchTab(this, 'views')">Views</button>
                                        <button class="tab" onclick="switchTab(this, 'engagement')">Engagement</button>
                                        <button class="tab" onclick="switchTab(this, 'shares')">Shares</button>
                                    </div>
                                </div>
                                <div class="chart-placeholder">
                                    Content Performance Chart - Bar chart comparing different content types and their
                                    engagement metrics
                                </div>
                            </div>
                        </div>

                        <div class="right-sidebar">
                            <div class="insights-card">
                                <h2 class="card-title">Key Insights</h2>
                                <div class="insight-item" onclick="viewInsight('peak')">
                                    <div class="insight-title">Peak Activity Hours</div>
                                    <div class="insight-text">Most users are active between 2-6 PM. Consider scheduling
                                        content during these hours.</div>
                                </div>
                                <div class="insight-item" onclick="viewInsight('retention')">
                                    <div class="insight-title">User Retention Up</div>
                                    <div class="insight-text">30-day retention improved by 8% this month compared to
                                        last month.</div>
                                </div>
                                <div class="insight-item" onclick="viewInsight('content')">
                                    <div class="insight-title">Top Content Type</div>
                                    <div class="insight-text">Video content receives 3x more engagement than other
                                        formats.</div>
                                </div>
                            </div>

                            <div class="insights-card">
                                <h2 class="card-title">Performance Metrics</h2>
                                <div class="metrics-grid">
                                    <div class="metric-box">
                                        <div class="metric-label">Page Views</div>
                                        <div class="metric-value">156K</div>
                                    </div>
                                    <div class="metric-box">
                                        <div class="metric-label">Sessions</div>
                                        <div class="metric-value">42K</div>
                                    </div>
                                    <div class="metric-box">
                                        <div class="metric-label">Conversions</div>
                                        <div class="metric-value">2,341</div>
                                    </div>
                                    <div class="metric-box">
                                        <div class="metric-label">Revenue</div>
                                        <div class="metric-value">$18K</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="reports-section">
                        <h2 class="card-title">Generated Reports</h2>
                        <div class="report-item" onclick="viewReport('monthly')">
                            <div class="report-info">
                                <div class="report-title">Monthly Performance Report - November 2024</div>
                                <div class="report-date">Generated on Dec 1, 2024</div>
                            </div>
                            <button class="download-btn" onclick="downloadReport('monthly', event)">Download</button>
                        </div>
                        <div class="report-item" onclick="viewReport('user')">
                            <div class="report-info">
                                <div class="report-title">User Analytics Report - Q4 2024</div>
                                <div class="report-date">Generated on Nov 28, 2024</div>
                            </div>
                            <button class="download-btn" onclick="downloadReport('user', event)">Download</button>
                        </div>
                        <div class="report-item" onclick="viewReport('content')">
                            <div class="report-info">
                                <div class="report-title">Content Engagement Report - October 2024</div>
                                <div class="report-date">Generated on Nov 1, 2024</div>
                            </div>
                            <button class="download-btn" onclick="downloadReport('content', event)">Download</button>
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
                        alert('Navigating to User Management page...');
                        // window.location.href = 'user-management.html';
                    } else if (page === 'content') {
                        alert('Navigating to Content Management page...');
                        // window.location.href = 'content-management.html';
                    } else if (page === 'analytics') {
                        console.log('Already on Analytics & Reports page');
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

                function handleDateChange(period) {
                    console.log(`Date range changed to: ${period}`);
                    alert(`Updating analytics data for: ${period}`);
                    // Fetch and update analytics data based on selected period
                }

                function exportReport() {
                    alert('Exporting current analytics report as PDF...');
                    // Generate and download PDF report
                }

                function switchTab(element, view) {
                    // Remove active class from all tabs in the same group
                    const tabs = element.parentElement.querySelectorAll('.tab');
                    tabs.forEach(tab => tab.classList.remove('active'));

                    // Add active class to clicked tab
                    element.classList.add('active');

                    console.log(`Switched to ${view} view`);
                    alert(`Updating chart to show ${view} data...`);
                    // Update chart based on selected view
                }

                function viewInsight(type) {
                    alert(`Opening detailed insight view for: ${type}`);
                    // Navigate to detailed insight page or show modal
                }

                function viewReport(reportType) {
                    console.log(`Viewing ${reportType} report`);
                    alert(`Opening ${reportType} report viewer...`);
                    // Navigate to report viewer page
                }

                function downloadReport(reportType, event) {
                    event.stopPropagation();
                    alert(`Downloading ${reportType} report...`);
                    // Download report file
                }

                // Search functionality
                document.getElementById('searchInput').addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        const searchTerm = e.target.value;
                        if (searchTerm) {
                            alert(`Searching analytics for: ${searchTerm}`);
                        }
                    }
                });
            </script>
        </body>

        </html>