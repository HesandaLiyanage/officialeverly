<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Collab Memories Page Content -->
<jsp:include page="../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/memories.css">

<!-- Wrap everything after header -->
<div class="page-wrapper">
    <main class="main-content">
        <!-- Tab Navigation -->
        <div class="tab-nav">
            <button data-tab="memories" onclick="window.location.href='/memories'">Memories</button>
            <button class="active" data-tab="collab">Collab Memories</button>
            <button data-tab="recap" onclick="window.location.href='/memories'">Memory Recap</button>
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
            <button class="filter-btn" id="collaboratorFilter">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
                Collaborators
            </button>
        </div>

        <!-- Collab Memories Grid -->
        <div class="memories-grid" id="collabMemoriesGrid" style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
            <div class="memory-card" data-title="Weekend Beach Trip" data-collaborators="Sarah, Mike">
                <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800')"></div>
                <div class="collab-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>3</span>
                </div>
                <div class="memory-content">
                    <h3 class="memory-title">Weekend Beach Trip</h3>
                    <p class="memory-date">July 15, 2024</p>
                    <p class="memory-collaborators">With Sarah, Mike</p>
                </div>
            </div>

            <div class="memory-card" data-title="Birthday Surprise Party" data-collaborators="Emma, John, Lisa">
                <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800')"></div>
                <div class="collab-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>4</span>
                </div>
                <div class="memory-content">
                    <h3 class="memory-title">Birthday Surprise Party</h3>
                    <p class="memory-date">June 20, 2024</p>
                    <p class="memory-collaborators">With Emma, John, Lisa</p>
                </div>
            </div>

            <div class="memory-card" data-title="Team Building Hike" data-collaborators="Alex, Ryan">
                <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800')"></div>
                <div class="collab-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>3</span>
                </div>
                <div class="memory-content">
                    <h3 class="memory-title">Team Building Hike</h3>
                    <p class="memory-date">May 10, 2024</p>
                    <p class="memory-collaborators">With Alex, Ryan</p>
                </div>
            </div>

            <div class="memory-card" data-title="Food Festival Adventure" data-collaborators="Jessica, Tom, Anna">
                <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800')"></div>
                <div class="collab-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>4</span>
                </div>
                <div class="memory-content">
                    <h3 class="memory-title">Food Festival Adventure</h3>
                    <p class="memory-date">April 18, 2024</p>
                    <p class="memory-collaborators">With Jessica, Tom, Anna</p>
                </div>
            </div>

            <div class="memory-card" data-title="Concert Night" data-collaborators="David, Sophie">
                <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800')"></div>
                <div class="collab-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>3</span>
                </div>
                <div class="memory-content">
                    <h3 class="memory-title">Concert Night</h3>
                    <p class="memory-date">March 25, 2024</p>
                    <p class="memory-collaborators">With David, Sophie</p>
                </div>
            </div>

            <div class="memory-card" data-title="Art Gallery Visit" data-collaborators="Maria, Chris, Ben">
                <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=800')"></div>
                <div class="collab-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>4</span>
                </div>
                <div class="memory-content">
                    <h3 class="memory-title">Art Gallery Visit</h3>
                    <p class="memory-date">February 14, 2024</p>
                    <p class="memory-collaborators">With Maria, Chris, Ben</p>
                </div>
            </div>

            <div class="memory-card" data-title="Ski Trip Getaway" data-collaborators="Kevin, Laura">
                <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800')"></div>
                <div class="collab-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>3</span>
                </div>
                <div class="memory-content">
                    <h3 class="memory-title">Ski Trip Getaway</h3>
                    <p class="memory-date">January 8, 2024</p>
                    <p class="memory-collaborators">With Kevin, Laura</p>
                </div>
            </div>

            <div class="memory-card" data-title="Holiday Dinner" data-collaborators="Family, Friends">
                <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800')"></div>
                <div class="collab-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>6+</span>
                </div>
                <div class="memory-content">
                    <h3 class="memory-title">Holiday Dinner</h3>
                    <p class="memory-date">December 24, 2023</p>
                    <p class="memory-collaborators">With Family, Friends</p>
                </div>
            </div>
        </div>

        <!-- Empty state container -->
        <div id="emptyStateContainer" style="display: none; min-height: 600px;">
            <p style="text-align: center; color: #6c757d; margin: 40px 0; font-size: 16px;">No memories found</p>
        </div>
    </main>

    <aside class="sidebar">
        <!-- Recent Collaborators Section -->
        <div class="sidebar-section">
            <h3 class="sidebar-title">Recent Collaborators</h3>
            <ul class="favorites-list">
                <li class="favorite-item">
                    <div class="favorite-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">S</div>
                    <span class="favorite-name">Sarah</span>
                </li>
                <li class="favorite-item">
                    <div class="favorite-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">M</div>
                    <span class="favorite-name">Mike</span>
                </li>
                <li class="favorite-item">
                    <div class="favorite-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">E</div>
                    <span class="favorite-name">Emma</span>
                </li>
                <li class="favorite-item">
                    <div class="favorite-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">J</div>
                    <span class="favorite-name">John</span>
                </li>
                <li class="favorite-item">
                    <div class="favorite-icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">A</div>
                    <span class="favorite-name">Alex</span>
                </li>
            </ul>
        </div>

        <!-- Floating Action Buttons -->
        <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
            <a href="/createcollabmemory" class="floating-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Add Collab
            </a>
            <a href="/vaultmemories" class="floating-btn vault-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
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
    // Modern Search Functionality for Collab Memories Page
    document.addEventListener('DOMContentLoaded', function() {
        const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');
        const collabMemoriesGrid = document.getElementById('collabMemoriesGrid');
        const emptyStateContainer = document.getElementById('emptyStateContainer');

        // Search functionality
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

                // Search functionality - searches both title and collaborators
                input.addEventListener('input', function(e) {
                    const query = e.target.value.toLowerCase();
                    const memoryCards = document.querySelectorAll('.memory-card');
                    let visibleCount = 0;

                    memoryCards.forEach(card => {
                        const title = card.getAttribute('data-title')?.toLowerCase() || '';
                        const collaborators = card.getAttribute('data-collaborators')?.toLowerCase() || '';
                        const matches = title.includes(query) || collaborators.includes(query);

                        if (matches) {
                            card.style.display = 'block';
                            visibleCount++;
                        } else {
                            card.style.display = 'none';
                        }
                    });

                    // Show/hide empty state
                    if (visibleCount === 0) {
                        collabMemoriesGrid.style.display = 'none';
                        emptyStateContainer.style.display = 'block';
                    } else {
                        collabMemoriesGrid.style.display = 'grid';
                        emptyStateContainer.style.display = 'none';
                    }
                });
            });
        }

        // Memory card click handlers
        const memoryCards = document.querySelectorAll('.memory-card');
        memoryCards.forEach(card => {
            card.addEventListener('click', function() {
                // Redirect to collab memory view page
                window.location.href = '/collabmemoryview';
            });
        });

        // Date filter functionality
        const dateFilter = document.getElementById('dateFilter');
        if (dateFilter) {
            dateFilter.addEventListener('click', function() {
                const memoryCards = Array.from(document.querySelectorAll('.memory-card'));
                const isAscending = this.dataset.sortOrder !== 'asc';

                memoryCards.sort((a, b) => {
                    const dateA = new Date(a.querySelector('.memory-date').textContent);
                    const dateB = new Date(b.querySelector('.memory-date').textContent);
                    return isAscending ? dateA - dateB : dateB - dateA;
                });

                const grid = document.getElementById('collabMemoriesGrid');
                memoryCards.forEach(card => grid.appendChild(card));

                this.dataset.sortOrder = isAscending ? 'asc' : 'desc';

                // Update button text
                const svg = this.querySelector('svg');
                this.innerHTML = '';
                this.appendChild(svg);
                this.appendChild(document.createTextNode(isAscending ? 'Date ↑' : 'Date ↓'));
            });
        }

        // Collaborator filter functionality
        const collaboratorFilter = document.getElementById('collaboratorFilter');
        if (collaboratorFilter) {
            collaboratorFilter.addEventListener('click', function() {
                alert('Collaborator filter feature - You can implement a dropdown to filter by specific collaborators');
            });
        }

        // Recent collaborators click handlers
        const collaboratorItems = document.querySelectorAll('.sidebar-section .favorite-item');
        collaboratorItems.forEach(item => {
            item.addEventListener('click', function() {
                const collaboratorName = this.querySelector('.favorite-name').textContent.toLowerCase();
                const memoryCards = document.querySelectorAll('.memory-card');
                let visibleCount = 0;

                memoryCards.forEach(card => {
                    const collaborators = card.getAttribute('data-collaborators')?.toLowerCase() || '';
                    if (collaborators.includes(collaboratorName)) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });

                // Show/hide empty state
                if (visibleCount === 0) {
                    collabMemoriesGrid.style.display = 'none';
                    emptyStateContainer.style.display = 'block';
                } else {
                    collabMemoriesGrid.style.display = 'grid';
                    emptyStateContainer.style.display = 'none';
                }

                // Highlight selected collaborator
                collaboratorItems.forEach(i => i.classList.remove('selected'));
                this.classList.add('selected');
            });
        });
    });
</script>

<style>
    /* Additional styles for collab memories */
    .collab-badge {
        position: absolute;
        top: 12px;
        right: 12px;
        background: rgba(154, 116, 216, 0.95);
        color: white;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 6px;
        box-shadow: 0 2px 8px rgba(154, 116, 216, 0.4);
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

    .favorite-item.selected {
        background: rgba(154, 116, 216, 0.1);
        border-left: 3px solid #9A74D8;
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
</body>
</html>