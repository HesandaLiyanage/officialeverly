<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/vaultmemories.css">

<!-- Wrap everything after header -->
<div class="page-wrapper">
    <main class="main-content">
        <!-- Vault Header -->
        <div class="vault-header">
            <h1 class="vault-title">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                </svg>
                Vault
            </h1>
            <p class="vault-desc">Your private secure vault for events you want to keep hidden from your main journal and memories.</p>
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
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                </button>
            </div>
            <button class="filter-btn" id="dateFilter">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <polyline points="19 12 12 19 5 12"></polyline>
                </svg>
                Date
            </button>
            <button class="filter-btn" id="moodFilter">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <path d="M8 14s1.5 2 4 2 4-2 4-2"></path>
                    <line x1="9" y1="9" x2="9.01" y2="9"></line>
                    <line x1="15" y1="9" x2="15.01" y2="9"></line>
                </svg>
                Mood
            </button>
        </div>

        <!-- Journals Grid -->
        <div class="journals-grid" id="journalsGrid" style="max-height: calc(100vh - 400px); overflow-y: auto; padding-right: 10px;">
            <div class="journal-card" data-title="Reflection on Growth">
                <div class="journal-header">
                    <div class="journal-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                    </div>
                    <div class="journal-lock">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </div>
                </div>
                <div class="journal-content">
                    <h3 class="journal-title">Reflection on Growth</h3>
                    <p class="journal-date">March 10, 2024</p>
                    <p class="journal-excerpt">Today I realized how far I've come. The challenges I faced last year shaped me in ways I never expected...</p>
                </div>
            </div>

            <div class="journal-card" data-title="Private Thoughts">
                <div class="journal-header">
                    <div class="journal-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                    </div>
                    <div class="journal-lock">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </div>
                </div>
                <div class="journal-content">
                    <h3 class="journal-title">Private Thoughts</h3>
                    <p class="journal-date">February 22, 2024</p>
                    <p class="journal-excerpt">Sometimes silence speaks louder than words. I've been thinking about the people who truly matter...</p>
                </div>
            </div>

            <div class="journal-card" data-title="Dreams & Goals">
                <div class="journal-header">
                    <div class="journal-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                    </div>
                    <div class="journal-lock">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </div>
                </div>
                <div class="journal-content">
                    <h3 class="journal-title">Dreams & Goals</h3>
                    <p class="journal-date">January 15, 2024</p>
                    <p class="journal-excerpt">I want to travel more, write a book, and learn to play the piano. This year is about turning dreams into plans...</p>
                </div>
            </div>

            <div class="journal-card" data-title="Gratitude List">
                <div class="journal-header">
                    <div class="journal-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                    </div>
                    <div class="journal-lock">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </div>
                </div>
                <div class="journal-content">
                    <h3 class="journal-title">Gratitude List</h3>
                    <p class="journal-date">December 30, 2023</p>
                    <p class="journal-excerpt">I'm grateful for my health, my family, and the small moments of joy that made this year special...</p>
                </div>
            </div>

            <div class="journal-card" data-title="Midnight Musings">
                <div class="journal-header">
                    <div class="journal-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                    </div>
                    <div class="journal-lock">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </div>
                </div>
                <div class="journal-content">
                    <h3 class="journal-title">Midnight Musings</h3>
                    <p class="journal-date">November 5, 2023</p>
                    <p class="journal-excerpt">The quiet of the night brings clarity. I find myself reflecting on choices made and paths not taken...</p>
                </div>
            </div>

            <div class="journal-card" data-title="Self Discovery">
                <div class="journal-header">
                    <div class="journal-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                        </svg>
                    </div>
                    <div class="journal-lock">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </div>
                </div>
                <div class="journal-content">
                    <h3 class="journal-title">Self Discovery</h3>
                    <p class="journal-date">October 18, 2023</p>
                    <p class="journal-excerpt">Learning to be comfortable with who I am, not who others expect me to be. This journey is mine alone...</p>
                </div>
            </div>
        </div>
    </main>

    <aside class="sidebar">
        <!-- Settings Section -->
        <div class="sidebar-section">
            <h3 class="sidebar-title">Settings</h3>
            <ul class="settings-list">
                <li class="setting-item">
                    <a href="/vaultpassword" class="setting-link">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <span>Change Password</span>
                    </a>
                </li>
                <li class="setting-item">
                    <a href="#" class="setting-link">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="3"></circle>
                            <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
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
                <svg class="expand-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
                <svg class="expand-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
    document.addEventListener('DOMContentLoaded', function() {
        const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');

        if (memoriesSearchBtn) {
            memoriesSearchBtn.addEventListener('click', function(event) {
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

                input.addEventListener('blur', function() {
                    setTimeout(() => {
                        if (!document.activeElement.closest('.memories-search-expanded')) {
                            closeSearch();
                        }
                    }, 150);
                });

                searchBox.addEventListener('mousedown', function(e) {
                    e.preventDefault();
                    input.focus();
                });

                // Search functionality
                input.addEventListener('input', function(e) {
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
            button.addEventListener('click', function() {
                const tab = this.getAttribute('data-tab');

                // Update active button
                tabButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');

                // Navigate to appropriate page
                if (tab === 'memories') {
                    window.location.href = '/vaultmemories';
                }
            });
        });

        // Expandable sections functionality
        const expandableSections = document.querySelectorAll('.expandable-section');
        expandableSections.forEach(section => {
            const header = section.querySelector('.section-header');
            if (header) {
                header.addEventListener('click', function() {
                    section.classList.toggle('expanded');
                });
            }
        });
    });
</script>
</body>
</html>