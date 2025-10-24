<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

<!-- Page Wrapper -->
<div class="admin-page-wrapper">
    <main class="admin-main-content">
        <!-- Welcome Header -->
        <div class="welcome-header">
            <h1 class="welcome-title">Admin Dashboard</h1>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">Active users</div>
                <div class="stat-number">14,024</div>
                <div class="stat-change positive">+1258 users</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">Total content</div>
                <div class="stat-number">27,900</div>
                <div class="stat-change positive">+74.3%</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">New content</div>
                <div class="stat-number">900</div>
                <div class="stat-change positive">+125.7%</div>
            </div>
        </div>

        <!-- Admin Navigation Cards -->
        <div class="admin-nav-grid">
            <a href="/adminanalytics" class="admin-nav-card">
                <div class="card-icon">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="20" x2="12" y2="10"></line>
                        <line x1="18" y1="20" x2="18" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="16"></line>
                    </svg>
                </div>
                <h3 class="card-title">Analytics & Reports</h3>
            </a>

            <a href="/adminuser" class="admin-nav-card">
                <div class="card-icon">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </div>
                <h3 class="card-title">User Management</h3>
            </a>

            <a href="/admincontent" class="admin-nav-card">
                <div class="card-icon">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="16" y1="13" x2="8" y2="13"></line>
                        <line x1="16" y1="17" x2="8" y2="17"></line>
                        <polyline points="10 9 9 9 8 9"></polyline>
                    </svg>
                </div>
                <h3 class="card-title">Content Management</h3>
            </a>

            <a href="/adminsettings" class="admin-nav-card">
                <div class="card-icon">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                </div>
                <h3 class="card-title">Settings</h3>
            </a>
        </div>
    </main>

    <!-- Alerts & Feedbacks Sidebar -->
    <aside class="admin-sidebar">
        <!-- Alerts Section -->
        <div class="sidebar-section">
            <div class="section-icon-title">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <h3 class="sidebar-title">Alerts</h3>
            </div>
            <ul class="alerts-list">
                <li class="alert-item critical">
                    <div class="alert-indicator"></div>
                    <div class="alert-content">
                        <span class="alert-text">Server load at 95%</span>
                        <span class="alert-time">5 mins ago</span>
                    </div>
                </li>
                <li class="alert-item warning">
                    <div class="alert-indicator"></div>
                    <div class="alert-content">
                        <span class="alert-text">Database backup pending</span>
                        <span class="alert-time">1 hour ago</span>
                    </div>
                </li>
                <li class="alert-item info">
                    <div class="alert-indicator"></div>
                    <div class="alert-content">
                        <span class="alert-text">New user registration spike</span>
                        <span class="alert-time">2 hours ago</span>
                    </div>
                </li>
            </ul>
        </div>

        <!-- Feedbacks Section -->
        <div class="sidebar-section">
            <div class="section-icon-title">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                </svg>
                <h3 class="sidebar-title">Feedbacks</h3>
            </div>
            <ul class="feedbacks-list">
                <li class="feedback-item">
                    <div class="feedback-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">JD</div>
                    <div class="feedback-content">
                        <span class="feedback-user">John Doe</span>
                        <span class="feedback-text">Love the new features!</span>
                        <span class="feedback-rating">⭐⭐⭐⭐⭐</span>
                    </div>
                </li>
                <li class="feedback-item">
                    <div class="feedback-avatar" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">SM</div>
                    <div class="feedback-content">
                        <span class="feedback-user">Sarah Miller</span>
                        <span class="feedback-text">UI could be improved</span>
                        <span class="feedback-rating">⭐⭐⭐⭐</span>
                    </div>
                </li>
                <li class="feedback-item">
                    <div class="feedback-avatar" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">MJ</div>
                    <div class="feedback-content">
                        <span class="feedback-user">Mike Johnson</span>
                        <span class="feedback-text">Great app overall!</span>
                        <span class="feedback-rating">⭐⭐⭐⭐⭐</span>
                    </div>
                </li>
            </ul>
        </div>
    </aside>
</div>

<jsp:include page="../../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Animate stat numbers
        const statNumbers = document.querySelectorAll('.stat-number');
        statNumbers.forEach(stat => {
            const finalValue = parseInt(stat.textContent.replace(/,/g, ''));
            animateValue(stat, 0, finalValue, 1500);
        });

        function animateValue(element, start, end, duration) {
            let startTimestamp = null;
            const step = (timestamp) => {
                if (!startTimestamp) startTimestamp = timestamp;
                const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                const value = Math.floor(progress * (end - start) + start);
                element.textContent = value.toLocaleString();
                if (progress < 1) {
                    window.requestAnimationFrame(step);
                }
            };
            window.requestAnimationFrame(step);
        }

        // Add hover effects for navigation cards
        const navCards = document.querySelectorAll('.admin-nav-card');
        navCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px)';
            });
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    });
</script>
</body>
</html>