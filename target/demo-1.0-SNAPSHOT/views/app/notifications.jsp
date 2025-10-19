<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notifications.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<jsp:include page="../public/header2.jsp" />

<div class="page-wrapper">
    <div class="notifications-container">

        <!-- Page Header -->
        <div class="notifications-header">
            <h1 class="page-title">Notifications</h1>
            <p class="page-subtitle">Stay up-to-date with the latest activities and updates.</p>
        </div>

        <!-- Tab Navigation -->
        <div class="notification-tabs">
            <button class="tab-btn active" data-tab="all">All</button>
            <button class="tab-btn" data-tab="unread">Unread</button>
            <button class="tab-btn" data-tab="comments">Comments</button>
            <button class="tab-btn" data-tab="announcements">Announcements</button>
        </div>

        <!-- Notifications List -->
        <div class="notifications-list" id="notificationsList">

            <!-- Notification Item - Comment -->
            <div class="notification-item unread" data-type="comment">
                <div class="notification-avatar">
                    <div class="avatar-circle" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <span>SC</span>
                    </div>
                </div>
                <div class="notification-content">
                    <p class="notification-text">
                        <strong>Sarah</strong> commented on your memory
                    </p>
                    <span class="notification-time">2 hours ago</span>
                </div>
                <div class="notification-badge unread-badge"></div>
            </div>

            <!-- Notification Item - Announcement -->
            <div class="notification-item" data-type="announcement">
                <div class="notification-avatar">
                    <div class="avatar-icon announcement-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                        </svg>
                    </div>
                </div>
                <div class="notification-content">
                    <p class="notification-text">
                        <strong>New announcement</strong> in Family Group
                    </p>
                    <span class="notification-time">Yesterday</span>
                </div>
            </div>

            <!-- Notification Item - Like -->
            <div class="notification-item" data-type="comment">
                <div class="notification-avatar">
                    <div class="avatar-circle" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <span>MK</span>
                    </div>
                </div>
                <div class="notification-content">
                    <p class="notification-text">
                        <strong>Mark</strong> liked your memory
                    </p>
                    <span class="notification-time">2 days ago</span>
                </div>
            </div>

            <!-- Notification Item - Group Invite -->
            <div class="notification-item" data-type="announcement">
                <div class="notification-avatar">
                    <div class="avatar-icon group-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                    </div>
                </div>
                <div class="notification-content">
                    <p class="notification-text">
                        You have been invited to join the <strong>Friends Group</strong>
                    </p>
                    <span class="notification-time">3 days ago</span>
                </div>
            </div>

            <!-- Notification Item - Memory Added -->
            <div class="notification-item" data-type="comment">
                <div class="notification-avatar">
                    <div class="avatar-circle" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
                        <span>EA</span>
                    </div>
                </div>
                <div class="notification-content">
                    <p class="notification-text">
                        <strong>Emily</strong> added a new memory to the Vacation 2023 group
                    </p>
                    <span class="notification-time">4 days ago</span>
                </div>
            </div>

            <!-- Notification Item - Mention -->
            <div class="notification-item" data-type="comment">
                <div class="notification-avatar">
                    <div class="avatar-circle" style="background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);">
                        <span>DM</span>
                    </div>
                </div>
                <div class="notification-content">
                    <p class="notification-text">
                        <strong>David</strong> mentioned you in a comment
                    </p>
                    <span class="notification-time">5 days ago</span>
                </div>
            </div>

            <!-- Notification Item - Announcement -->
            <div class="notification-item" data-type="announcement">
                <div class="notification-avatar">
                    <div class="avatar-icon announcement-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                        </svg>
                    </div>
                </div>
                <div class="notification-content">
                    <p class="notification-text">
                        <strong>New announcement</strong> in Work Team
                    </p>
                    <span class="notification-time">6 days ago</span>
                </div>
            </div>

            <!-- Notification Item - Like -->
            <div class="notification-item" data-type="comment">
                <div class="notification-avatar">
                    <div class="avatar-circle" style="background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);">
                        <span>JL</span>
                    </div>
                </div>
                <div class="notification-content">
                    <p class="notification-text">
                        <strong>Jessica</strong> liked your memory
                    </p>
                    <span class="notification-time">1 week ago</span>
                </div>
            </div>

        </div>

        <!-- Mark All as Read Button -->
        <div class="notifications-actions">
            <button class="mark-read-btn" id="markAllRead">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
                Mark All as Read
            </button>
        </div>

    </div>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {

        // Tab switching
        const tabButtons = document.querySelectorAll('.tab-btn');
        const notificationItems = document.querySelectorAll('.notification-item');

        tabButtons.forEach(button => {
            button.addEventListener('click', function() {
                const tab = this.getAttribute('data-tab');

                // Update active tab
                tabButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');

                // Filter notifications
                notificationItems.forEach(item => {
                    if (tab === 'all') {
                        item.style.display = 'flex';
                    } else if (tab === 'unread') {
                        item.style.display = item.classList.contains('unread') ? 'flex' : 'none';
                    } else if (tab === 'comments') {
                        item.style.display = item.getAttribute('data-type') === 'comment' ? 'flex' : 'none';
                    } else if (tab === 'announcements') {
                        item.style.display = item.getAttribute('data-type') === 'announcement' ? 'flex' : 'none';
                    }
                });
            });
        });

        // Mark all as read
        const markAllReadBtn = document.getElementById('markAllRead');
        if (markAllReadBtn) {
            markAllReadBtn.addEventListener('click', function() {
                notificationItems.forEach(item => {
                    item.classList.remove('unread');
                    const badge = item.querySelector('.unread-badge');
                    if (badge) {
                        badge.style.display = 'none';
                    }
                });

                // Show success message
                this.innerHTML = `
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    All Read!
                `;
                this.style.background = '#10b981';

                setTimeout(() => {
                    this.innerHTML = `
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        Mark All as Read
                    `;
                    this.style.background = '#9A74D8';
                }, 2000);
            });
        }

        // Click on notification item
        notificationItems.forEach(item => {
            item.addEventListener('click', function() {
                // Mark as read
                this.classList.remove('unread');
                const badge = this.querySelector('.unread-badge');
                if (badge) {
                    badge.style.display = 'none';
                }

                // Add click effect
                this.style.transform = 'scale(0.98)';
                setTimeout(() => {
                    this.style.transform = 'scale(1)';
                }, 100);

                // Navigate to relevant page
                console.log('Notification clicked');
                // window.location.href = '/memory/123';
            });
        });

    });
</script>

</body>
</html>