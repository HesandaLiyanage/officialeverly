<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <jsp:include page="../public/header2.jsp" />
            <html>

            <body>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/memories.css">

                <div class="page-wrapper">
                    <main class="main-content">
                        <div class="tab-nav">
                            <button class="active">Memories</button>
                            <button onclick="window.location.href='/memoryrecap'">Memory Recap</button>
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
                        </div>

                        <!-- Show error message if any -->
                        <c:if test="${not empty errorMessage}">
                            <div
                                style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 15px; margin: 15px 0; border-radius: 8px;">
                                <strong>Error:</strong> ${errorMessage}
                            </div>
                        </c:if>

                        <div class="memories-grid" id="memoriesGrid"
                            style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
                            <c:choose>
                                <c:when test="${empty memories}">
                                    <!-- No memories - show empty state -->
                                    <div style="grid-column: 1/-1; text-align: center; padding: 60px; color: #888;">
                                        <div style="font-size: 64px; margin-bottom: 20px;">📸</div>
                                        <h3 style="margin-bottom: 10px;">No memories yet</h3>
                                        <p style="margin-bottom: 30px;">Start creating your first memory!</p>
                                        <a href="/creatememory" class="floating-btn"
                                            style="display: inline-block; padding: 12px 30px; text-decoration: none;">
                                            Create Your First Memory
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Display memories -->
                                    <c:forEach var="memory" items="${memories}">
                                        <!-- Get cover URL (set by servlet) -->
                                        <c:set var="coverUrl"
                                            value="${requestScope['cover_'.concat(memory.memoryId)]}" />

                                        <!-- Use cover if available, otherwise use default -->
                                        <c:set var="finalCover"
                                            value="${not empty coverUrl ? coverUrl : pageContext.request.contextPath.concat('/resources/images/default-memory.jpg')}" />

                                        <div class="memory-card" data-title="${memory.title}"
                                            onclick="location.href='/memoryview?id=${memory.memoryId}'"
                                            style="cursor: pointer;">
                                            <!-- Cover image -->
                                            <div class="memory-image" style="background-image: url('${finalCover}');">
                                            </div>

                                            <!-- Memory details -->
                                            <div class="memory-content">
                                                <h3 class="memory-title">${memory.title}</h3>
                                                <p class="memory-date">
                                                    <fmt:formatDate value="${memory.createdTimestamp}"
                                                        pattern="MMMM d, yyyy" />
                                                </p>

                                                <!-- Optional: Show description if available -->
                                                <c:if test="${not empty memory.description}">
                                                    <p class="memory-description"
                                                        style="margin: 8px 0 0 0; color: #888; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                        ${memory.description}
                                                    </p>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Empty state container for search -->
                        <div id="emptyStateContainer" style="display: none; min-height: 600px;">
                            <p style="text-align: center; color: #6c757d; margin: 40px 0; font-size: 16px;">No memories
                                found</p>
                        </div>
                    </main>

                    <aside class="sidebar">
                        <!-- Quick Actions Section -->
                        <div class="sidebar-section">
                            <h3 class="sidebar-title">Quick Stats</h3>
                            <ul class="favorites-list">
                                <li class="favorite-item">
                                    <div class="favorite-icon"
                                        style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">📷</div>
                                    <span class="favorite-name">Total Memories:
                                        <c:out value="${memories.size()}" default="0" />
                                    </span>
                                </li>
                            </ul>
                        </div>

                        <!-- Floating Action Buttons -->
                        <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
                            <a href="/creatememory" class="floating-btn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                Add Memory
                            </a>
                            <a href="/vaultmemories" class="floating-btn vault-btn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                                Vault
                            </a>
                        </div>
                    </aside>
                </div>

                <jsp:include page="../public/footer.jsp" />

                <style>
                    .memory-card {
                        transition: transform 0.2s ease, box-shadow 0.2s ease;
                    }

                    .memory-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
                    }

                    .favorite-icon {
                        width: 36px;
                        height: 36px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-weight: 700;
                        font-size: 14px;
                    }
                </style>

                <!-- Search functionality -->
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');
                        const memoriesGrid = document.getElementById('memoriesGrid');
                        const emptyStateContainer = document.getElementById('emptyStateContainer');

                        // Search functionality
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
                    <input type="text" id="searchInput" placeholder="Search memories..." autofocus>
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
                                    // Reset search results
                                    const cards = document.querySelectorAll('.memory-card');
                                    cards.forEach(card => card.style.display = 'block');
                                    if (memoriesGrid) memoriesGrid.style.display = 'grid';
                                    if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                };

                                searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

                                // Search functionality
                                input.addEventListener('input', function (e) {
                                    const query = e.target.value.toLowerCase();
                                    const memoryCards = document.querySelectorAll('.memory-card');
                                    let visibleCount = 0;

                                    memoryCards.forEach(card => {
                                        const title = card.getAttribute('data-title')?.toLowerCase() || '';
                                        const matches = title.includes(query);

                                        if (matches) {
                                            card.style.display = 'block';
                                            visibleCount++;
                                        } else {
                                            card.style.display = 'none';
                                        }
                                    });

                                    // Show/hide empty state
                                    if (visibleCount === 0 && query !== '') {
                                        if (memoriesGrid) memoriesGrid.style.display = 'none';
                                        if (emptyStateContainer) emptyStateContainer.style.display = 'block';
                                    } else {
                                        if (memoriesGrid) memoriesGrid.style.display = 'grid';
                                        if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                    }
                                });
                            });
                        }
                    });
                </script>
            </body>

            </html>