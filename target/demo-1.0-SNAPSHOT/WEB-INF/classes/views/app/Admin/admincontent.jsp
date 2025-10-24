<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admincontent.css">

<!-- Page Wrapper -->
<div class="admin-page-wrapper">
    <main class="admin-main-content">
        <!-- Page Header with Back Button -->
        <div class="page-header-nav">
            <a href="/admin" class="back-button">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
            </a>
            <h1 class="page-title">Content Management</h1>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <div class="user-search-bar">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <path d="m21 21-4.35-4.35"></path>
                </svg>
                <input type="text" id="contentSearch" placeholder="search content by user or caption">
            </div>
        </div>

        <!-- Content Lists Grid -->
        <div class="user-lists-grid">
            <!-- Approved Content -->
            <div class="user-list-section active">
                <h2>Content</h2>
                <div class="user-list">
                    <div class="user-item">
                        <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=100" alt="Content" class="content-thumbnail">
                        <div class="user-item-info">
                            <span class="user-item-name">dave_wanderer</span>
                            <span class="content-caption">Beach sunset vibes...</span>
                            <span class="user-item-status">Approved</span>
                        </div>
                        <button class="action-btn delete-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            </svg>
                        </button>
                    </div>

                    <div class="user-item">
                        <img src="https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=100" alt="Content" class="content-thumbnail">
                        <div class="user-item-info">
                            <span class="user-item-name">city_explorer_jane</span>
                            <span class="content-caption">Paris streets are magical...</span>
                            <span class="user-item-status">Approved</span>
                        </div>
                        <button class="action-btn delete-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            </svg>
                        </button>
                    </div>

                    <div class="user-item">
                        <img src="https://images.unsplash.com/photo-1511920170033-f8396924c348?w=100" alt="Content" class="content-thumbnail">
                        <div class="user-item-info">
                            <span class="user-item-name">coffeeaddict_mark</span>
                            <span class="content-caption">Perfect morning coffee...</span>
                            <span class="user-item-status">Approved</span>
                        </div>
                        <button class="action-btn delete-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            </svg>
                        </button>
                    </div>

                    <div class="user-item">
                        <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100" alt="Content" class="content-thumbnail">
                        <div class="user-item-info">
                            <span class="user-item-name">nature_admirer</span>
                            <span class="content-caption">Mountains calling...</span>
                            <span class="user-item-status">Approved</span>
                        </div>
                        <button class="action-btn delete-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Pending Review Content -->


    </main>

    <!-- Content Stats Sidebar -->
    <aside class="admin-sidebar">
        <div class="sidebar-section">
            <h3 class="sidebar-title">Content Statistics</h3>
            <div class="stats-list">
                <div class="stat-item">
                    <span class="stat-label">Total Posts</span>
                    <span class="stat-value">27,900</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">Approved Today</span>
                    <span class="stat-value approved">156</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">Pending Review</span>
                    <span class="stat-value pending">23</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">Rejected Today</span>
                    <span class="stat-value rejected">8</span>
                </div>
            </div>
        </div>

        <div class="sidebar-section">
            <h3 class="sidebar-title">Recent Activity</h3>
            <ul class="recent-joined-list">
                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">D</div>
                    <div class="activity-info">
                        <span class="recent-joined-name">dave_wanderer</span>
                        <span class="activity-time">Posted 5 mins ago</span>
                    </div>
                </li>

                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">C</div>
                    <div class="activity-info">
                        <span class="recent-joined-name">city_explorer_jane</span>
                        <span class="activity-time">Posted 15 mins ago</span>
                    </div>
                </li>

                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">M</div>
                    <div class="activity-info">
                        <span class="recent-joined-name">coffeeaddict_mark</span>
                        <span class="activity-time">Posted 1 hour ago</span>
                    </div>
                </li>

                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">N</div>
                    <div class="activity-info">
                        <span class="recent-joined-name">nature_admirer</span>
                        <span class="activity-time">Posted 2 hours ago</span>
                    </div>
                </li>

                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">T</div>
                    <div class="activity-info">
                        <span class="recent-joined-name">travel_bug_lisa</span>
                        <span class="activity-time">Posted 3 hours ago</span>
                    </div>
                </li>
            </ul>
        </div>
    </aside>
</div>

<jsp:include page="../../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Content search functionality
        const searchInput = document.getElementById('contentSearch');
        if (searchInput) {
            searchInput.addEventListener('input', function(e) {
                const query = e.target.value.toLowerCase();
                const contentItems = document.querySelectorAll('.user-item');

                contentItems.forEach(item => {
                    const name = item.querySelector('.user-item-name').textContent.toLowerCase();
                    const caption = item.querySelector('.content-caption').textContent.toLowerCase();
                    if (name.includes(query) || caption.includes(query)) {
                        item.style.display = 'flex';
                    } else {
                        item.style.display = 'none';
                    }
                });
            });
        }

        // Approve button functionality
        const approveButtons = document.querySelectorAll('.approve-btn');
        approveButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                const contentItem = this.closest('.user-item');
                const username = contentItem.querySelector('.user-item-name').textContent;

                // Show confirmation
                if (confirm(`Approve content from ${username}?`)) {
                    contentItem.style.background = '#d4f4dd';
                    contentItem.querySelector('.user-item-status').textContent = 'Approved';
                    contentItem.querySelector('.user-item-status').style.color = '#28a745';

                    // Remove action buttons
                    const actionButtons = contentItem.querySelector('.action-buttons');
                    actionButtons.innerHTML = '<span style="color: #28a745; font-weight: 600; font-size: 14px;">✓ Approved</span>';

                    console.log('Approved content from:', username);
                }
            });
        });

        // Reject button functionality
        const rejectButtons = document.querySelectorAll('.reject-btn');
        rejectButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                const contentItem = this.closest('.user-item');
                const username = contentItem.querySelector('.user-item-name').textContent;

                // Show confirmation
                if (confirm(`Reject content from ${username}?`)) {
                    contentItem.style.opacity = '0.5';
                    contentItem.querySelector('.user-item-status').textContent = 'Rejected';
                    contentItem.querySelector('.user-item-status').style.color = '#dc3545';

                    // Disable action buttons
                    const actionButtons = contentItem.querySelector('.action-buttons');
                    actionButtons.innerHTML = '<span style="color: #dc3545; font-weight: 600; font-size: 14px;">✗ Rejected</span>';

                    console.log('Rejected content from:', username);
                }
            });
        });

        // Delete button functionality
        const deleteButtons = document.querySelectorAll('.delete-btn');
        deleteButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                const contentItem = this.closest('.user-item');
                const username = contentItem.querySelector('.user-item-name').textContent;

                // Show confirmation
                if (confirm(`Delete content from ${username}? This action cannot be undone.`)) {
                    contentItem.style.transition = 'all 0.3s ease';
                    contentItem.style.opacity = '0';
                    contentItem.style.transform = 'translateX(-20px)';

                    setTimeout(() => {
                        contentItem.remove();
                    }, 300);

                    console.log('Deleted content from:', username);
                }
            });
        });

        // Add click handlers for content items to view details
        const contentItems = document.querySelectorAll('.content-thumbnail');
        contentItems.forEach(item => {
            item.style.cursor = 'pointer';
            item.addEventListener('click', function() {
                const contentItem = this.closest('.user-item');
                const username = contentItem.querySelector('.user-item-name').textContent;
                console.log('Viewing content details for:', username);
                // Add modal or navigation logic here
            });
        });
    });
</script>
</body>
</html>