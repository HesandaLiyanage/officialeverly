<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <jsp:include page="../public/header2.jsp" />
            <html>

            <body>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/memories.css">

                <style>
                    /* Filter dropdown styles */
                    .filter-dropdown-container {
                        position: relative;
                        display: inline-block;
                    }

                    .filter-dropdown {
                        display: none;
                        position: absolute;
                        top: 100%;
                        left: 0;
                        margin-top: 8px;
                        background: white;
                        border-radius: 12px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                        min-width: 180px;
                        z-index: 100;
                        overflow: hidden;
                    }

                    .filter-dropdown.active {
                        display: block;
                    }

                    .filter-dropdown-item {
                        padding: 12px 16px;
                        cursor: pointer;
                        font-size: 14px;
                        color: #374151;
                        transition: background 0.2s ease;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .filter-dropdown-item:hover {
                        background: #f3f4f6;
                    }

                    .filter-dropdown-item.selected {
                        background: rgba(154, 116, 216, 0.1);
                        color: #9A74D8;
                    }

                    .filter-dropdown-item svg {
                        width: 16px;
                        height: 16px;
                    }

                    /* Empty state styles - clean, no gradients */
                    .empty-state {
                        text-align: center;
                        padding: 80px 40px;
                        color: #6b7280;
                    }

                    .empty-state-icon {
                        width: 80px;
                        height: 80px;
                        margin: 0 auto 24px;
                        background: #9A74D8;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .empty-state-icon svg {
                        width: 40px;
                        height: 40px;
                        stroke: white;
                    }

                    .empty-state h3 {
                        font-size: 20px;
                        color: #1f2937;
                        margin: 0 0 8px 0;
                    }

                    .empty-state p {
                        font-size: 14px;
                        margin: 0;
                    }

                    /* Collab badge - clean styling */
                    .collab-badge {
                        position: absolute;
                        top: 12px;
                        right: 12px;
                        background: #9A74D8;
                        color: white;
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                        display: flex;
                        align-items: center;
                        gap: 6px;
                        box-shadow: 0 2px 8px rgba(154, 116, 216, 0.3);
                        z-index: 2;
                    }

                    .collab-badge svg {
                        width: 14px;
                        height: 14px;
                    }

                    .memory-collaborators {
                        font-size: 13px;
                        color: #9A74D8;
                        margin-top: 4px;
                        font-weight: 500;
                    }

                    /* Owner badge */
                    .owner-badge {
                        position: absolute;
                        top: 12px;
                        left: 12px;
                        background: #10b981;
                        color: white;
                        padding: 4px 10px;
                        border-radius: 12px;
                        font-size: 11px;
                        font-weight: 600;
                        z-index: 2;
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

                    /* Floating buttons - consistent light purple */
                    .floating-btn {
                        background: #9A74D8 !important;
                    }

                    .floating-btn:hover {
                        background: #8B65C9 !important;
                    }
                </style>

                <div class="page-wrapper">
                    <main class="main-content">
                        <!-- Tab Navigation -->
                        <div class="tab-nav">
                            <button data-tab="memories"
                                onclick="window.location.href='${pageContext.request.contextPath}/memories'">Memories</button>
                            <button class="active" data-tab="collab">Collab Memories</button>
                            <button data-tab="recap"
                                onclick="window.location.href='${pageContext.request.contextPath}/memoryrecap'">Memory
                                Recap</button>
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

                            <!-- Sort Dropdown -->
                            <div class="filter-dropdown-container">
                                <button class="filter-btn" id="sortFilterBtn">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <line x1="12" y1="5" x2="12" y2="19"></line>
                                        <polyline points="19 12 12 19 5 12"></polyline>
                                    </svg>
                                    Sort by
                                </button>
                                <div class="filter-dropdown" id="sortDropdown">
                                    <div class="filter-dropdown-item selected" data-sort="date-created-desc">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                        </svg>
                                        Date Created (Newest)
                                    </div>
                                    <div class="filter-dropdown-item" data-sort="date-created-asc">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                        </svg>
                                        Date Created (Oldest)
                                    </div>
                                    <div class="filter-dropdown-item" data-sort="last-edited-desc">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                        </svg>
                                        Last Edited (Recent)
                                    </div>
                                    <div class="filter-dropdown-item" data-sort="last-edited-asc">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                        </svg>
                                        Last Edited (Oldest)
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Collab Memories Grid -->
                        <c:choose>
                            <c:when test="${empty collabMemories}">
                                <!-- Empty state - clean, no button -->
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                        </svg>
                                    </div>
                                    <h3>No Collab Memories Yet</h3>
                                    <p>Create a collab memory to share moments with friends and family</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="memories-grid" id="collabMemoriesGrid"
                                    style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
                                    <c:forEach var="memory" items="${collabMemories}">
                                        <c:set var="coverUrl"
                                            value="${requestScope['cover_'.concat(memory.memoryId)]}" />
                                        <c:set var="memberCount"
                                            value="${requestScope['memberCount_'.concat(memory.memoryId)]}" />
                                        <c:set var="isOwner"
                                            value="${requestScope['isOwner_'.concat(memory.memoryId)]}" />

                                        <div class="memory-card" data-title="${memory.title}"
                                            onclick="location.href='${pageContext.request.contextPath}/memoryview?id=${memory.memoryId}'"
                                            style="cursor: pointer;">
                                            <div class="memory-image"
                                                style="background-image: url('${not empty coverUrl ? coverUrl : pageContext.request.contextPath.concat('/resources/images/default-memory.jpg')}');">
                                            </div>

                                            <!-- Owner badge -->
                                            <c:if test="${isOwner}">
                                                <div class="owner-badge">Owner</div>
                                            </c:if>

                                            <!-- Member count badge -->
                                            <div class="collab-badge">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2.5">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                    <circle cx="9" cy="7" r="4"></circle>
                                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                </svg>
                                                <span>${memberCount}</span>
                                            </div>

                                            <div class="memory-content">
                                                <h3 class="memory-title">${memory.title}</h3>
                                                <p class="memory-date">
                                                    <fmt:formatDate value="${memory.createdTimestamp}"
                                                        pattern="MMMM d, yyyy" />
                                                </p>
                                                <p class="memory-collaborators">${memberCount} collaborator<c:if
                                                        test="${memberCount != 1}">s</c:if>
                                                </p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </main>

                    <aside class="sidebar">
                        <!-- Quick Stats Section -->
                        <div class="sidebar-section">
                            <h3 class="sidebar-title">Quick Stats</h3>
                            <div style="padding: 16px; background: #f8f9fb; border-radius: 12px;">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                                    <span style="color: #6b7280; font-size: 14px;">Total Collabs</span>
                                    <span style="font-weight: 600; color: #1f2937;">${not empty collabMemories ?
                                        collabMemories.size() : 0}</span>
                                </div>
                            </div>
                        </div>

                        <!-- Floating Action Buttons -->
                        <div class="floating-buttons" style="position: static; margin-top: 20px;">
                            <a href="${pageContext.request.contextPath}/creatememory?tab=collab" class="floating-btn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                Add Collab
                            </a>
                            <a href="${pageContext.request.contextPath}/vaultmemories" class="floating-btn vault-btn">
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

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');
                        const sortFilterBtn = document.getElementById('sortFilterBtn');
                        const sortDropdown = document.getElementById('sortDropdown');

                        // Sort dropdown toggle
                        if (sortFilterBtn && sortDropdown) {
                            sortFilterBtn.addEventListener('click', function (e) {
                                e.stopPropagation();
                                sortDropdown.classList.toggle('active');
                            });

                            document.addEventListener('click', function (e) {
                                if (!sortDropdown.contains(e.target) && e.target !== sortFilterBtn) {
                                    sortDropdown.classList.remove('active');
                                }
                            });

                            const sortItems = sortDropdown.querySelectorAll('.filter-dropdown-item');
                            sortItems.forEach(item => {
                                item.addEventListener('click', function () {
                                    sortItems.forEach(i => i.classList.remove('selected'));
                                    this.classList.add('selected');

                                    const sortText = this.textContent.trim();
                                    sortFilterBtn.innerHTML = `
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <polyline points="19 12 12 19 5 12"></polyline>
                        </svg>
                        ${sortText}
                    `;

                                    sortDropdown.classList.remove('active');
                                });
                            });
                        }

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
                        <svg viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    </div>
                    <input type="text" id="searchInput" placeholder="Search collab memories..." autofocus>
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
                                    const cards = document.querySelectorAll('.memory-card');
                                    cards.forEach(card => card.style.display = 'block');
                                };

                                searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

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
                    });
                </script>
            </body>

            </html>