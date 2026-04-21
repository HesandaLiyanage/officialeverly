<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Content Management - Everly</title>
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

        /* Modal */
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
            max-width: 480px;
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
            margin-bottom: 1rem;
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

        .reason-tag {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: capitalize;
        }
        .reason-spam { background: #fef3c7; color: #92400e; }
        .reason-harassment { background: #fee2e2; color: #991b1b; }
        .reason-inappropriate { background: #fce7f3; color: #9d174d; }
        .reason-hate_speech { background: #fef2f2; color: #b91c1c; }
        .reason-other { background: #e2e8f0; color: #4a5568; }

        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #718096;
        }
        .empty-state p {
            margin-top: 0.5rem;
            font-size: 0.95rem;
        }

        textarea.admin-notes {
            width: 100%;
            padding: 0.6rem;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            resize: vertical;
            min-height: 60px;
            font-family: inherit;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo" onclick="navigateTo('analytics')"><img src="${pageContext.request.contextPath}/resources/assets/everlylogo.png" alt="Everly"></div>
        <div class="header-right">
            <button class="logout-btn" onclick="handleLogout()">Logout</button>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <div class="sidebar-title">ADMIN DASHBOARD</div>
            
            <div class="nav-item" onclick="navigateTo('analytics')">
                Analytics & Reports
            </div>
            <div class="nav-item" onclick="navigateTo('users')">
                User Management
            </div>
            <div class="nav-item active" onclick="navigateTo('content')">
                Content Management
            </div>
            <div class="nav-item" onclick="navigateTo('settings')">
                Settings
            </div>
        </div>

        <div class="main-content">
            <div class="page-header">
                <div class="page-title-section">
                    <h1 class="page-title">Content Management</h1>
                    <p class="page-subtitle">REPORTED POSTS ONLY</p>
                </div>
            </div>

            <!-- Flash message -->
            <c:if test="${not empty sessionScope.adminFlashMessage}">
                <div class="flash-message ${sessionScope.adminFlashType}" id="flashMsg">
                    <span>${sessionScope.adminFlashMessage}</span>
                    <button class="flash-close" onclick="document.getElementById('flashMsg').style.display='none'">✕</button>
                </div>
                <c:remove var="adminFlashMessage" scope="session"/>
                <c:remove var="adminFlashType" scope="session"/>
            </c:if>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Reports</div>
                    <div class="stat-value">${totalReports != null ? totalReports : 0}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Pending</div>
                    <div class="stat-value">${pendingCount != null ? pendingCount : 0}</div>
                    <c:if test="${pendingCount > 0}">
                        <div class="stat-change negative">⚠ Needs review</div>
                    </c:if>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Action Taken</div>
                    <div class="stat-value">${actionTakenCount != null ? actionTakenCount : 0}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Dismissed</div>
                    <div class="stat-value">${dismissedCount != null ? dismissedCount : 0}</div>
                </div>
            </div>

            <!-- Reported posts table -->
            <div class="posts-section">
                <h2 class="section-title">Reported Content</h2>
                <c:choose>
                    <c:when test="${not empty reportedPosts}">
                        <table class="posts-table">
                            <thead>
                                <tr>
                                    <th>Poster</th>
                                    <th>Reported By</th>
                                    <th>Reason</th>
                                    <th>Caption</th>
                                    <th>Report Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="report" items="${reportedPosts}">
                                    <tr>
                                        <td><strong>${report.posterUsername}</strong></td>
                                        <td>${report.reporterUsername}</td>
                                        <td>
                                            <span class="reason-tag reason-${fn:replace(report.reason, ' ', '_')}">
                                                ${report.reason}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.caption != null && fn:length(report.caption) > 50}">
                                                    ${fn:substring(report.caption, 0, 50)}...
                                                </c:when>
                                                <c:when test="${report.caption != null}">
                                                    ${report.caption}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #a0aec0;">No caption</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${report.createdAt}" pattern="MMM d, yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.status == 'pending'}">
                                                    <span class="status-badge status-pending">Pending</span>
                                                </c:when>
                                                <c:when test="${report.status == 'reviewed'}">
                                                    <span class="status-badge status-active">Reviewed</span>
                                                </c:when>
                                                <c:when test="${report.status == 'dismissed'}">
                                                    <span class="status-badge status-inactive">Dismissed</span>
                                                </c:when>
                                                <c:when test="${report.status == 'action_taken'}">
                                                    <span class="status-badge status-deleted">Action Taken</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-btns">
                                                <c:if test="${report.status == 'pending'}">
                                                    <button class="action-btn"
                                                        onclick="showActionModal('dismiss', ${report.reportId}, ${report.postId}, '${report.posterUsername}')">
                                                        Dismiss
                                                    </button>
                                                    <button class="action-btn danger"
                                                        onclick="showActionModal('delete_post', ${report.reportId}, ${report.postId}, '${report.posterUsername}')">
                                                        Delete Post
                                                    </button>
                                                </c:if>
                                                <c:if test="${report.status != 'pending'}">
                                                    <span style="color: #a0aec0; font-size: 0.85rem;">Resolved</span>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p style="font-size: 2rem;">📋</p>
                            <p>No reported posts found.</p>
                            <p style="font-size: 0.85rem; color: #a0aec0;">Reports from users will appear here when they report posts in the feed.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Action Modal -->
    <div class="modal-overlay" id="actionModal">
        <div class="modal-box">
            <div class="modal-title" id="modalTitle">Confirm Action</div>
            <div class="modal-text" id="modalText">Are you sure?</div>
            <textarea class="admin-notes" id="adminNotes" placeholder="Admin notes (optional)..."></textarea>
            <div class="modal-actions">
                <button class="modal-btn cancel" onclick="closeModal()">Cancel</button>
                <form id="actionForm" method="POST" action="${pageContext.request.contextPath}/admincontentaction" style="display:inline;">
                    <input type="hidden" name="action" id="modalAction">
                    <input type="hidden" name="reportId" id="modalReportId">
                    <input type="hidden" name="postId" id="modalPostId">
                    <input type="hidden" name="adminNotes" id="modalAdminNotes">
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

        function showActionModal(action, reportId, postId, posterUsername) {
            document.getElementById('modalAction').value = action;
            document.getElementById('modalReportId').value = reportId;
            document.getElementById('modalPostId').value = postId;
            document.getElementById('adminNotes').value = '';

            const submitBtn = document.getElementById('modalSubmitBtn');

            if (action === 'dismiss') {
                document.getElementById('modalTitle').textContent = 'Dismiss Report';
                document.getElementById('modalText').textContent =
                    'Dismiss the report against "' + posterUsername + '"\'s post? The post will remain visible.';
                submitBtn.textContent = 'Dismiss';
                submitBtn.className = 'modal-btn confirm';
            } else if (action === 'delete_post') {
                document.getElementById('modalTitle').textContent = 'Delete Post';
                document.getElementById('modalText').textContent =
                    'Permanently delete "' + posterUsername + '"\'s reported post? This cannot be undone.';
                submitBtn.textContent = 'Delete Post';
                submitBtn.className = 'modal-btn danger';
            }

            document.getElementById('actionModal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('actionModal').classList.remove('active');
        }

        // Copy admin notes to hidden field before submit
        document.getElementById('actionForm').addEventListener('submit', function() {
            document.getElementById('modalAdminNotes').value = document.getElementById('adminNotes').value;
        });

        // Close modal on overlay click
        document.getElementById('actionModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });

        // Search filter
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.posts-table tbody tr');

            rows.forEach(function(row) {
                const text = row.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // Auto-hide flash message
        const flashMsg = document.getElementById('flashMsg');
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
