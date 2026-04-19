<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <jsp:include page="/WEB-INF/views/public/header2.jsp" />
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
                            <button data-tab="memories">Memories</button>
                            <button class="active" data-tab="journals">Journals</button>
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
                        </div>

                        <!-- Journals Grid -->
                        <div class="journals-grid" id="journalsGrid"
                            style="max-height: calc(100vh - 400px); overflow-y: auto; padding-right: 10px;">
                            <c:choose>
                                <c:when test="${not empty journals}">
                                    <c:forEach var="journal" items="${journals}">
                                        <div class="journal-card" data-title="${journal.title}" onclick="window.location.href='${pageContext.request.contextPath}/journalview?id=${journal.journalId}'" style="cursor:pointer;">
                                            <div class="journal-header">
                                                <div class="journal-icon">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                                        <path
                                                            d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z">
                                                        </path>
                                                    </svg>
                                                </div>
                                                <div class="journal-lock">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                                    </svg>
                                                </div>
                                            </div>
                                            <div class="journal-content">
                                                <h3 class="journal-title">${journal.title}</h3>
                                                <p class="journal-date">Private Journal</p>
                                                <p class="journal-excerpt">${journalExcerpts[journal.journalId]}</p>
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
                                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z">
                                            </path>
                                        </svg>
                                        <h3 style="margin-bottom: 10px; color: #374151;">No vault journals yet</h3>
                                        <p>Move journals to your vault to keep them private and secure.</p>
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
                                    <a href="/vaultpassword" class="setting-link">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <span>Change Password</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </aside>
                </div>

                <jsp:include page="/WEB-INF/views/public/footer.jsp" />

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
          <input type="text" id="searchInput" placeholder="Search vault journals..." autofocus>
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
                                    const journalCards = document.querySelectorAll('.journal-card');
                                    journalCards.forEach(card => {
                                        const title = card.getAttribute('data-title')?.toLowerCase() || '';
                                        card.style.display = title.includes(query) ? 'block' : 'none';
                                    });
                                });
                            });
                        }

                        // Tab switching functionality
                        const tabButtons = document.querySelectorAll('.tab-nav button');

                        tabButtons.forEach(button => {
                            button.addEventListener('click', function () {
                                const tab = this.getAttribute('data-tab');

                                // Update active button
                                tabButtons.forEach(btn => btn.classList.remove('active'));
                                this.classList.add('active');

                                // Navigate to appropriate page
                                if (tab === 'memories') {
                                    window.location.href = '${pageContext.request.contextPath}/vaultmemories';
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
