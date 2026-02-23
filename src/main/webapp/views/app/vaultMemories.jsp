<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <jsp:include page="../public/header2.jsp" />
            <html>

            <body>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/vaultmemories.css">

                <!-- Wrap everything after header -->
                <div class="page-wrapper">
                    <main class="main-content">
                        <!-- Vault Header -->
                        <div class="vault-header">
                            <h1 class="vault-title">
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                                Vault
                            </h1>
                            <p class="vault-desc">Your private secure vault for events you want to keep hidden from your
                                main journal and memories.</p>
                        </div>

                        <!-- Tab Navigation -->
                        <div class="tab-nav">
                            <button class="active" data-tab="memories">Memories</button>
                            <button data-tab="journals"
                                onclick="window.location.href='${pageContext.request.contextPath}/vaultjournals'">Journals</button>
                        </div>

                        <!-- Search and Filters -->
                        <div class="search-filters" style="margin-top: 10px; margin-bottom: 15px;">
                            <div class="memories-search-container">
                                <button class="memories-search-btn" id="memoriesSearchBtn">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <path d="m21 21-4.35-4.35"></path>
                                    </svg>
                                </button>
                            </div>
                            <button class="filter-btn" id="dateFilter">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <polyline points="19 12 12 19 5 12"></polyline>
                                </svg>
                                Date
                            </button>
                            <button class="filter-btn" id="locationFilter">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                    <circle cx="12" cy="10" r="3"></circle>
                                </svg>
                                Location
                            </button>
                        </div>

                        <!-- Memories Grid -->
                        <div class="memories-grid" id="memoriesGrid"
                            style="max-height: calc(100vh - 400px); overflow-y: auto; padding-right: 10px;">
                            <c:choose>
                                <c:when test="${not empty memories}">
                                    <c:forEach var="memory" items="${memories}">
                                        <div class="memory-card" data-title="${memory.title}">
                                            <div class="memory-image"
                                                style="background-image: url('${not empty memory.coverUrl ? memory.coverUrl : "
                                                https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800"}')">
                                            </div>
                                            <div class="memory-content">
                                                <h3 class="memory-title">${memory.title}</h3>
                                                <p class="memory-date">
                                                    <fmt:formatDate value="${memory.createdTimestamp}"
                                                        pattern="MMMM d, yyyy" />
                                                </p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div
                                        style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: #6b7280;">
                                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="1.5"
                                            style="margin: 0 auto 20px; opacity: 0.5;">
                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                            <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                            <polyline points="21 15 16 10 5 21"></polyline>
                                        </svg>
                                        <h3 style="margin-bottom: 10px; color: #374151;">No vault memories yet</h3>
                                        <p>Move memories to your vault to keep them private and secure.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </main>

                    <aside class="sidebar">
                        <!-- Settings Section -->
                        <div class="sidebar-section">
                            <h3 class="sidebar-title">Settings</h3>
                            <ul class="settings-list">
                                <li class="setting-item">
                                    <a href="vaultpassword" class="setting-link">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <span>Change Password</span>
                                    </a>
                                </li>
                                <li class="setting-item">
                                    <a href="#" class="setting-link">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="3"></circle>
                                            <path
                                                d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z">
                                            </path>
                                        </svg>
                                        <span>Security Settings</span>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <!-- Storage Section -->
                        <div class="sidebar-section expandable-section" data-section="storage">
                            <div class="section-header">
                                <h3 class="sidebar-title">Storage</h3>
                                <svg class="expand-icon" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="expandable-content">
                                <div class="storage-info">
                                    <div class="storage-text">
                                        <span>75% used</span>
                                    </div>
                                    <div class="storage-bar">
                                        <div class="storage-fill" style="width: 75%"></div>
                                    </div>
                                    <div class="storage-text" style="margin-top: 8px;">
                                        <span>150 GB of 200 GB</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recycle Bin Section -->
                        <div class="sidebar-section expandable-section" data-section="recycle">
                            <div class="section-header">
                                <h3 class="sidebar-title">Recycle Bin</h3>
                                <svg class="expand-icon" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                            <div class="expandable-content">
                                <p class="empty-text">No items in recycle bin</p>
                            </div>
                        </div>
                    </aside>
                </div>

                <jsp:include page="../public/footer.jsp" />

                <script>
                    // Modern Search Functionality
                    document.addEventListener('DOMContentLoaded', function () {
                        const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');

                        if (memoriesSearchBtn) {
                            memoriesSearchBtn.addEventListener('click', function (event) {
                                event.stopPropagation();

                                const searchBtnElement = this;
                                const searchContainer = searchBtnElement.parentElement;

                                const searchBox = document.createElement('div');
                                searchBox.className = 'memories-search-expanded';
                                searchBox.innerHTML = `
          <div class="memories-search-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          </div>
          <input type="text" id="searchInput" placeholder="Search vault memories..." autofocus>
          <button class="memories-search-close">
            <svg viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        `;

                                searchContainer.replaceChild(searchBox, searchBtnElement);

                                const input = searchBox.querySelector('input');
                                input.focus();

                                const closeSearch = () => {
                                    const newSearchBtn = document.createElement('button');
                                    newSearchBtn.className = 'memories-search-btn';
                                    newSearchBtn.id = 'memoriesSearchBtn';
                                    newSearchBtn.innerHTML = `
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          `;
                                    searchContainer.replaceChild(newSearchBtn, searchBox);
                                    newSearchBtn.addEventListener('click', arguments.callee);
                                };

                                searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

                                input.addEventListener('blur', function () {
                                    setTimeout(() => {
                                        if (!document.activeElement.closest('.memories-search-expanded')) {
                                            closeSearch();
                                        }
                                    }, 150);
                                });

                                searchBox.addEventListener('mousedown', function (e) {
                                    e.preventDefault();
                                    input.focus();
                                });

                                // Search functionality
                                input.addEventListener('input', function (e) {
                                    const query = e.target.value.toLowerCase();
                                    const memoryCards = document.querySelectorAll('.memory-card');
                                    memoryCards.forEach(card => {
                                        const title = card.getAttribute('data-title')?.toLowerCase() || '';
                                        card.style.display = title.includes(query) ? 'block' : 'none';
                                    });
                                });
                            });
                        }

                        // Tab switching functionality
                        const tabButtons = document.querySelectorAll('.tab-nav button');
                        const memoriesGrid = document.getElementById('memoriesGrid');

                        tabButtons.forEach(button => {
                            button.addEventListener('click', function () {
                                const tab = this.getAttribute('data-tab');

                                // Update active button
                                tabButtons.forEach(btn => btn.classList.remove('active'));
                                this.classList.add('active');

                                // Update content based on tab
                                if (tab === 'memories') {
                                    // Show all memories
                                    const memoryCards = document.querySelectorAll('.memory-card');
                                    memoryCards.forEach(card => card.style.display = 'block');
                                } else if (tab === 'journals') {
                                    // Show no journals message
                                    memoriesGrid.innerHTML = '<p style="text-align: center; color: #6c757d; grid-column: 1 / -1; margin: 40px 0; font-size: 16px;">No private journals yet</p>';
                                }
                            });
                        });

                        // Expandable sections functionality
                        const expandableSections = document.querySelectorAll('.expandable-section');
                        expandableSections.forEach(section => {
                            const header = section.querySelector('.section-header');
                            if (header) {
                                header.addEventListener('click', function () {
                                    section.classList.toggle('expanded');
                                });
                            }
                        });
                    });
                </script>
            </body>

            </html>