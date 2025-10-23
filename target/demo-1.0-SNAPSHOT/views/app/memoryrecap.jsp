<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/recap.css">

<!-- Wrap everything after header -->
<div class="page-wrapper">
    <main class="main-content">
        <!-- Tab Navigation -->
        <div class="tab-nav">
            <button data-tab="memories">Memories</button>
            <button data-tab="collab">Collab Memories</button>
            <button class="active" data-tab="recap">Memory Recap</button>
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
            <button class="filter-btn" id="yearFilter">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                Year
            </button>
        </div>

        <!-- Recap Grid - 3 Columns -->
        <div class="recap-grid" id="recapGrid" style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">

            <!-- Time-Based Recaps Column -->
            <div class="recap-column">
                <h2 class="recap-column-title">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                    By Time
                </h2>

                <div class="recap-card" data-title="2024 Year in Review">
                    <div class="recap-header time-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <h3 class="recap-title">2024 Year in Review</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">127</span>
                                <span class="stat-label">Memories</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">45</span>
                                <span class="stat-label">Events</span>
                            </div>
                        </div>
                        <p class="recap-description">Your incredible journey through 2024</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('2024-year')">View Recap</button>
                    </div>
                </div>

                <div class="recap-card" data-title="Summer 2024">
                    <div class="recap-header time-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="5"></circle>
                                <line x1="12" y1="1" x2="12" y2="3"></line>
                                <line x1="12" y1="21" x2="12" y2="23"></line>
                                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                                <line x1="1" y1="12" x2="3" y2="12"></line>
                                <line x1="21" y1="12" x2="23" y2="12"></line>
                                <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                            </svg>
                        </div>
                        <h3 class="recap-title">Summer 2024</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">42</span>
                                <span class="stat-label">Memories</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">15</span>
                                <span class="stat-label">Adventures</span>
                            </div>
                        </div>
                        <p class="recap-description">Sun-soaked memories from the best season</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('summer-2024')">View Recap</button>
                    </div>
                </div>

                <div class="recap-card" data-title="This Month">
                    <div class="recap-header time-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                        </div>
                        <h3 class="recap-title">This Month</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">18</span>
                                <span class="stat-label">Memories</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">8</span>
                                <span class="stat-label">Events</span>
                            </div>
                        </div>
                        <p class="recap-description">What you've been up to this month</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('this-month')">View Recap</button>
                    </div>
                </div>
            </div>

            <!-- Event-Based Recaps Column -->
            <div class="recap-column">
                <h2 class="recap-column-title">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                    By Event
                </h2>

                <div class="recap-card" data-title="Graduation Journey">
                    <div class="recap-header event-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                            </svg>
                        </div>
                        <h3 class="recap-title">Graduation Journey</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">35</span>
                                <span class="stat-label">Moments</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">12</span>
                                <span class="stat-label">Friends</span>
                            </div>
                        </div>
                        <p class="recap-description">From first day to graduation cap toss</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('graduation-journey')">View Recap</button>
                    </div>
                </div>

                <div class="recap-card" data-title="Travel Adventures">
                    <div class="recap-header event-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                        </div>
                        <h3 class="recap-title">Travel Adventures</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">28</span>
                                <span class="stat-label">Places</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">156</span>
                                <span class="stat-label">Photos</span>
                            </div>
                        </div>
                        <p class="recap-description">All your wanderlust moments in one place</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('travel-adventures')">View Recap</button>
                    </div>
                </div>

                <div class="recap-card" data-title="Birthday Celebrations">
                    <div class="recap-header event-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                        </div>
                        <h3 class="recap-title">Birthday Celebrations</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">8</span>
                                <span class="stat-label">Parties</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">52</span>
                                <span class="stat-label">Wishes</span>
                            </div>
                        </div>
                        <p class="recap-description">Special moments with special people</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('2024-year')">View Recap</button>
                    </div>
                </div>
            </div>

            <!-- Group/People-Based Recaps Column -->
            <div class="recap-column">
                <h2 class="recap-column-title">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    By People
                </h2>

                <div class="recap-card" data-title="Family Moments">
                    <div class="recap-header group-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                            </svg>
                        </div>
                        <h3 class="recap-title">Family Moments</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">64</span>
                                <span class="stat-label">Memories</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">8</span>
                                <span class="stat-label">Members</span>
                            </div>
                        </div>
                        <p class="recap-description">Precious times with your loved ones</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('family-moments')">View Recap</button>
                    </div>
                </div>

                <div class="recap-card" data-title="Best Friends Forever">
                    <div class="recap-header group-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                            </svg>
                        </div>
                        <h3 class="recap-title">Best Friends Forever</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">92</span>
                                <span class="stat-label">Hangouts</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">5</span>
                                <span class="stat-label">Friends</span>
                            </div>
                        </div>
                        <p class="recap-description">Adventures with your ride-or-dies</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('best-friends-forever')">View Recap</button>
                    </div>
                </div>

                <div class="recap-card" data-title="Work Squad">
                    <div class="recap-header group-gradient">
                        <div class="recap-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                            </svg>
                        </div>
                        <h3 class="recap-title">Work Squad</h3>
                    </div>
                    <div class="recap-content">
                        <div class="recap-stats">
                            <div class="stat-item">
                                <span class="stat-number">47</span>
                                <span class="stat-label">Events</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">12</span>
                                <span class="stat-label">Colleagues</span>
                            </div>
                        </div>
                        <p class="recap-description">Team bonding and office celebrations</p>
                        <button class="view-recap-btn" onclick="openRecapViewer('work-squad')">View Recap</button>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <aside class="sidebar">
        <!-- Year Summary Section -->
        <div class="sidebar-section">
            <h3 class="sidebar-title">Year Summary</h3>
            <div class="year-summary">
                <div class="summary-stat">
                    <div class="summary-icon">📸</div>
                    <div class="summary-info">
                        <span class="summary-number">487</span>
                        <span class="summary-label">Total Memories</span>
                    </div>
                </div>
                <div class="summary-stat">
                    <div class="summary-icon">🎉</div>
                    <div class="summary-info">
                        <span class="summary-number">156</span>
                        <span class="summary-label">Events</span>
                    </div>
                </div>
                <div class="summary-stat">
                    <div class="summary-icon">👥</div>
                    <div class="summary-info">
                        <span class="summary-number">42</span>
                        <span class="summary-label">People</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Moments Section -->
        <div class="sidebar-section">
            <h3 class="sidebar-title">Top Moments</h3>
            <ul class="favorites-list">
                <li class="favorite-item">
                    <div class="favorite-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">🎓</div>
                    <div class="favorite-content">
                        <span class="favorite-name">Graduation Day</span>
                        <span class="moment-date">May 2024</span>
                    </div>
                </li>
                <li class="favorite-item">
                    <div class="favorite-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">✈️</div>
                    <div class="favorite-content">
                        <span class="favorite-name">Europe Trip</span>
                        <span class="moment-date">July 2024</span>
                    </div>
                </li>
                <li class="favorite-item">
                    <div class="favorite-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">🎂</div>
                    <div class="favorite-content">
                        <span class="favorite-name">Birthday Bash</span>
                        <span class="moment-date">March 2024</span>
                    </div>
                </li>
            </ul>
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
          <input type="text" id="searchInput" placeholder="Search recaps..." autofocus>
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
                    const recapCards = document.querySelectorAll('.recap-card');
                    recapCards.forEach(card => {
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
                    window.location.href = '/memories';
                } else if (tab === 'collab') {
                    window.location.href = '/memories'; // Will show collab tab
                }
            });
        });

        // View Recap button functionality
// View Recap button functionality - UPDATED
        const viewRecapButtons = document.querySelectorAll('.view-recap-btn');
        viewRecapButtons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                // Get the recap ID from the button's data attribute or parent card
                const recapCard = this.closest('.recap-card');
                const recapTitle = recapCard.getAttribute('data-title');

                // Map titles to recap IDs
                const recapIdMap = {
                    '2024 Year in Review': '2024-year',
                    'Summer 2024': 'summer',
                    'This Month': 'this-month',
                    'Graduation Journey': 'graduation',
                    'Travel Adventures': 'travel',
                    'Birthday Celebrations': 'birthday',
                    'Family Moments': 'family',
                    'Best Friends Forever': 'friends',
                    'Work Squad': 'work'
                };

                const recapId = recapIdMap[recapTitle] || '2024-year';
                openRecapViewer(recapId);
            });
        });
    });
    // Memory Recap Viewer - Add this to your existing script section

    const recapData = {
        '2024-year': {
            name: '2024 Year in Review',
            avatar: '🎉',
            memories: [
                {
                    image: 'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=800',
                    title: 'New Year Celebration',
                    caption: 'Started the year with amazing friends!'
                },
                {
                    image: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800',
                    title: 'Team Success',
                    caption: 'Achieved incredible milestones this year!'
                }
                // Add more memories
            ]
        },
        'summer': {
            name: 'Summer 2024',
            avatar: '☀️',
            memories: [
                {
                    image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
                    title: 'Beach Days',
                    caption: 'Sun, sand, and perfect summer vibes!'
                }
            ]
        }
        // Add more recaps
    };

    let currentRecap = null;
    let currentIndex = 0;
    let progressTimer = null;

    function openRecapViewer(recapId) {
        currentRecap = recapData[recapId];
        currentIndex = 0;

        const modal = document.getElementById('recapModal');
        document.getElementById('storyName').textContent = currentRecap.name;
        document.getElementById('storyAvatar').textContent = currentRecap.avatar;

        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
        loadStory();
    }

    function closeRecapViewer() {
        document.getElementById('recapModal').classList.remove('active');
        document.body.style.overflow = 'auto';
        if (progressTimer) clearTimeout(progressTimer);
    }

    function loadStory() {
        if (!currentRecap) return;

        const memories = currentRecap.memories;

        // Create progress bars
        document.getElementById('progressBars').innerHTML = memories.map(function(_, i) {
            return '<div class="progress-bar ' + (i < currentIndex ? 'completed' : '') + ' ' + (i === currentIndex ? 'active' : '') + '">' +
                '<div class="progress-fill"></div>' +
                '</div>';
        }).join('');

// Create story slides
        document.getElementById('storyContent').innerHTML = memories.map(function(memory, i) {
            return '<div class="story-slide ' + (i === currentIndex ? 'active' : '') + '">' +
                '<img src="' + memory.image + '" alt="' + memory.title + '" class="story-image">' +
                '<div class="story-caption">' +
                '<div class="caption-title">' + memory.title + '</div>' +
                '<div class="caption-text">' + memory.caption + '</div>' +
                '</div>' +
                '</div>';
        }).join('');

        startProgress();
    }

    function startProgress() {
        if (progressTimer) clearTimeout(progressTimer);
        progressTimer = setTimeout(() => nextStory(), 5000);
    }

    function nextStory() {
        if (!currentRecap) return;
        if (currentIndex < currentRecap.memories.length - 1) {
            currentIndex++;
            loadStory();
        } else {
            closeRecapViewer();
        }
    }

    function previousStory() {
        if (!currentRecap) return;
        if (currentIndex > 0) {
            currentIndex--;
            loadStory();
        }
    }

    function addReaction() {
        const btn = document.querySelector('.story-reaction-btn');
        btn.style.transform = 'scale(1.3)';
        setTimeout(() => btn.style.transform = 'scale(1)', 300);
        console.log('Reaction added!');
    }

    // Keyboard navigation
    document.addEventListener('keydown', (e) => {
        const modal = document.getElementById('recapModal');
        if (!modal.classList.contains('active')) return;

        if (e.key === 'ArrowRight') nextStory();
        else if (e.key === 'ArrowLeft') previousStory();
        else if (e.key === 'Escape') closeRecapViewer();
    });

    // Close when clicking outside
    document.getElementById('recapModal')?.addEventListener('click', (e) => {
        if (e.target.id === 'recapModal') closeRecapViewer();
    });
</script>

<!-- Modal Overlay with Blurred Background -->
<div class="recap-modal-overlay" id="recapModal">
    <div class="story-viewer" id="storyViewer">
        <!-- Progress Bars -->
        <div class="story-progress-bars" id="progressBars"></div>

        <!-- Header -->
        <div class="story-header">
            <div class="story-info">
                <div class="story-avatar" id="storyAvatar">📸</div>
                <div class="story-details">
                    <div class="story-name" id="storyName">My Memories</div>
                    <div class="story-time" id="storyTime">Just now</div>
                </div>
            </div>
            <button class="story-close-btn" onclick="closeRecapViewer()">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>

        <!-- Story Content -->
        <div class="story-content" id="storyContent"></div>

        <!-- Navigation Areas -->
        <div class="story-nav story-nav-prev" onclick="previousStory()"></div>
        <div class="story-nav story-nav-next" onclick="nextStory()"></div>

        <!-- Reaction Button -->
        <button class="story-reaction-btn" onclick="addReaction()">❤️</button>
    </div>
</div>
</body>
</html>

