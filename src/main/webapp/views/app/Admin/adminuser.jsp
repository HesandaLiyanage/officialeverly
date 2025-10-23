<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

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
            <h1 class="page-title">User Management</h1>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <div class="user-search-bar">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <path d="m21 21-4.35-4.35"></path>
                </svg>
                <input type="text" id="userSearch" placeholder="search users">
            </div>
        </div>


        <!-- User Lists Grid -->
        <div class="user-lists-grid">
            <!-- Most Active Users -->
            <div class="user-list-section active">
                <h2>Most Active users</h2>
                <div class="user-list">
                    <div class="user-item">
                        <img src="https://i.pravatar.cc/150?img=12" alt="Ravi" class="user-item-avatar">
                        <div class="user-item-info">
                            <span class="user-item-name">Ravi</span>
                            <span class="user-item-status">Active</span>
                        </div>
                    </div>

                    <div class="user-item">
                        <img src="https://i.pravatar.cc/150?img=45" alt="Oviya" class="user-item-avatar">
                        <div class="user-item-info">
                            <span class="user-item-name">Oviya</span>
                            <span class="user-item-status">Active</span>
                        </div>
                    </div>

                    <div class="user-item">
                        <img src="https://i.pravatar.cc/150?img=33" alt="Dhoni" class="user-item-avatar">
                        <div class="user-item-info">
                            <span class="user-item-name">Dhoni</span>
                            <span class="user-item-status">Active</span>
                        </div>
                    </div>

                    <div class="user-item">
                        <img src="https://i.pravatar.cc/150?img=47" alt="Queency" class="user-item-avatar">
                        <div class="user-item-info">
                            <span class="user-item-name">Queency</span>
                            <span class="user-item-status">Active</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Low Active Users -->
            <div class="user-list-section inactive">
                <h2>Low Active Users</h2>
                <div class="user-list">
                    <div class="user-item">
                        <img src="https://i.pravatar.cc/150?img=48" alt="Sophia" class="user-item-avatar">
                        <div class="user-item-info">
                            <span class="user-item-name">Sophia</span>
                            <span class="user-item-status">Inactive</span>
                        </div>
                    </div>

                    <div class="user-item">
                        <img src="https://i.pravatar.cc/150?img=49" alt="Elisa" class="user-item-avatar">
                        <div class="user-item-info">
                            <span class="user-item-name">Elisa</span>
                            <span class="user-item-status">Inactive</span>
                        </div>
                    </div>

                    <div class="user-item">
                        <img src="https://i.pravatar.cc/150?img=51" alt="vijay" class="user-item-avatar">
                        <div class="user-item-info">
                            <span class="user-item-name">vijay</span>
                            <span class="user-item-status">Inactive</span>
                        </div>
                    </div>

                    <div class="user-item">
                        <img src="https://i.pravatar.cc/150?img=52" alt="Ajith" class="user-item-avatar">
                        <div class="user-item-info">
                            <span class="user-item-name">Ajith</span>
                            <span class="user-item-status">Active</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Recent Joined Sidebar -->
    <aside class="admin-sidebar">
        <div class="sidebar-section">
            <h3 class="sidebar-title">Recent Joined</h3>
            <ul class="recent-joined-list">
                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">H</div>
                    <span class="recent-joined-name">hess</span>
                </li>

                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">A</div>
                    <span class="recent-joined-name">Anu</span>
                </li>

                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">R</div>
                    <span class="recent-joined-name">Roy</span>
                </li>

                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">N</div>
                    <span class="recent-joined-name">Nishaka</span>
                </li>

                <li class="recent-joined-item">
                    <div class="recent-joined-avatar" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">S</div>
                    <span class="recent-joined-name">Sinali</span>
                </li>
            </ul>
        </div>
    </aside>
</div>

<jsp:include page="../../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // User search functionality
        const searchInput = document.getElementById('userSearch');
        if (searchInput) {
            searchInput.addEventListener('input', function(e) {
                const query = e.target.value.toLowerCase();
                const userItems = document.querySelectorAll('.user-item');

                userItems.forEach(item => {
                    const name = item.querySelector('.user-item-name').textContent.toLowerCase();
                    if (name.includes(query)) {
                        item.style.display = 'flex';
                    } else {
                        item.style.display = 'none';
                    }
                });
            });
        }

        // Add click handlers for user items
        const userItems = document.querySelectorAll('.user-item');
        userItems.forEach(item => {
            item.style.cursor = 'pointer';
            item.addEventListener('click', function() {
                const userName = this.querySelector('.user-item-name').textContent;
                console.log('Viewing user profile:', userName);
                // Add navigation or modal logic here
            });
        });
    });
</script>
</body>
</html>