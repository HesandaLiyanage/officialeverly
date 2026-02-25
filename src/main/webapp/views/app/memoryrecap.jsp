<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <jsp:include page="../public/header2.jsp" />
            <html>

            <body>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/memories.css">
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/memoryrecap.css">

                <div class="page-wrapper">
                    <main class="main-content">
                        <!-- Tab Navigation -->
                        <div class="tab-nav">
                            <button onclick="window.location.href='/memories'">Memories</button>
                            <button onclick="window.location.href='/collabmemories'">Collab Memories</button>
                            <button class="active">Memory Recap</button>
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
                            <div class="recap-filter-pills">
                                <button class="recap-pill active" data-filter="all">All</button>
                                <button class="recap-pill" data-filter="time">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    By Time
                                </button>
                                <button class="recap-pill" data-filter="event">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                    By Event
                                </button>
                                <button class="recap-pill" data-filter="people">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                    By People
                                </button>
                            </div>
                        </div>

                        <!-- Recap Cards Grid - same layout as memories -->
                        <div class="memories-grid" id="recapGrid"
                            style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">

                            <!-- 2024 Year in Review -->
                            <div class="memory-card recap-card-item" data-title="2024 Year in Review"
                                data-category="time" onclick="openRecapViewer('2024-year')" style="cursor: pointer;">
                                <div class="memory-image recap-cover time-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                        </div>
                                        <div class="recap-cover-year">2024</div>
                                    </div>
                                    <div class="recap-badge time-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                        <span>Year</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">2024 Year in Review</h3>
                                    <p class="memory-date">127 memories · 45 events</p>
                                    <p class="recap-subtitle">Your incredible journey through 2024</p>
                                </div>
                            </div>

                            <!-- Summer 2024 -->
                            <div class="memory-card recap-card-item" data-title="Summer 2024" data-category="time"
                                onclick="openRecapViewer('summer')" style="cursor: pointer;">
                                <div class="memory-image recap-cover summer-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
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
                                        <div class="recap-cover-year">☀️</div>
                                    </div>
                                    <div class="recap-badge time-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                        <span>Season</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">Summer 2024</h3>
                                    <p class="memory-date">42 memories · 15 adventures</p>
                                    <p class="recap-subtitle">Sun-soaked memories from the best season</p>
                                </div>
                            </div>

                            <!-- This Month -->
                            <div class="memory-card recap-card-item" data-title="This Month" data-category="time"
                                onclick="openRecapViewer('this-month')" style="cursor: pointer;">
                                <div class="memory-image recap-cover month-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                            </svg>
                                        </div>
                                        <div class="recap-cover-year">📅</div>
                                    </div>
                                    <div class="recap-badge time-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                        <span>Month</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">This Month</h3>
                                    <p class="memory-date">18 memories · 8 events</p>
                                    <p class="recap-subtitle">What you've been up to this month</p>
                                </div>
                            </div>

                            <!-- Graduation Journey -->
                            <div class="memory-card recap-card-item" data-title="Graduation Journey"
                                data-category="event" onclick="openRecapViewer('graduation-journey')"
                                style="cursor: pointer;">
                                <div class="memory-image recap-cover event-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                                <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                                            </svg>
                                        </div>
                                        <div class="recap-cover-year">🎓</div>
                                    </div>
                                    <div class="recap-badge event-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                        <span>Event</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">Graduation Journey</h3>
                                    <p class="memory-date">35 moments · 12 friends</p>
                                    <p class="recap-subtitle">From first day to graduation cap toss</p>
                                </div>
                            </div>

                            <!-- Travel Adventures -->
                            <div class="memory-card recap-card-item" data-title="Travel Adventures"
                                data-category="event" onclick="openRecapViewer('travel-adventures')"
                                style="cursor: pointer;">
                                <div class="memory-image recap-cover travel-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                <circle cx="12" cy="10" r="3"></circle>
                                            </svg>
                                        </div>
                                        <div class="recap-cover-year">✈️</div>
                                    </div>
                                    <div class="recap-badge event-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                        <span>Event</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">Travel Adventures</h3>
                                    <p class="memory-date">28 places · 156 photos</p>
                                    <p class="recap-subtitle">All your wanderlust moments in one place</p>
                                </div>
                            </div>

                            <!-- Birthday Celebrations -->
                            <div class="memory-card recap-card-item" data-title="Birthday Celebrations"
                                data-category="event" onclick="openRecapViewer('birthday')" style="cursor: pointer;">
                                <div class="memory-image recap-cover birthday-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                        </div>
                                        <div class="recap-cover-year">🎂</div>
                                    </div>
                                    <div class="recap-badge event-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                        <span>Event</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">Birthday Celebrations</h3>
                                    <p class="memory-date">8 parties · 52 wishes</p>
                                    <p class="recap-subtitle">Special moments with special people</p>
                                </div>
                            </div>

                            <!-- Family Moments -->
                            <div class="memory-card recap-card-item" data-title="Family Moments" data-category="people"
                                onclick="openRecapViewer('family-moments')" style="cursor: pointer;">
                                <div class="memory-image recap-cover family-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                            </svg>
                                        </div>
                                        <div class="recap-cover-year">👨‍👩‍👧‍👦</div>
                                    </div>
                                    <div class="recap-badge people-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                        </svg>
                                        <span>People</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">Family Moments</h3>
                                    <p class="memory-date">64 memories · 8 members</p>
                                    <p class="recap-subtitle">Precious times with your loved ones</p>
                                </div>
                            </div>

                            <!-- Best Friends Forever -->
                            <div class="memory-card recap-card-item" data-title="Best Friends Forever"
                                data-category="people" onclick="openRecapViewer('best-friends-forever')"
                                style="cursor: pointer;">
                                <div class="memory-image recap-cover friends-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path
                                                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                </path>
                                            </svg>
                                        </div>
                                        <div class="recap-cover-year">❤️</div>
                                    </div>
                                    <div class="recap-badge people-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                        </svg>
                                        <span>People</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">Best Friends Forever</h3>
                                    <p class="memory-date">92 hangouts · 5 friends</p>
                                    <p class="recap-subtitle">Adventures with your ride-or-dies</p>
                                </div>
                            </div>

                            <!-- Work Squad -->
                            <div class="memory-card recap-card-item" data-title="Work Squad" data-category="people"
                                onclick="openRecapViewer('work-squad')" style="cursor: pointer;">
                                <div class="memory-image recap-cover work-gradient">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                                            </svg>
                                        </div>
                                        <div class="recap-cover-year">💼</div>
                                    </div>
                                    <div class="recap-badge people-badge">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                        </svg>
                                        <span>People</span>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">Work Squad</h3>
                                    <p class="memory-date">47 events · 12 colleagues</p>
                                    <p class="recap-subtitle">Team bonding and office celebrations</p>
                                </div>
                            </div>

                        </div>

                        <!-- Empty state container for search -->
                        <div id="emptyStateContainer" style="display: none; min-height: 600px;">
                            <p style="text-align: center; color: #6c757d; margin: 40px 0; font-size: 16px;">No recaps
                                found</p>
                        </div>
                    </main>

                    <aside class="sidebar">
                        <!-- Quick Stats Section -->
                        <div class="sidebar-section">
                            <h3 class="sidebar-title">Quick Stats</h3>
                            <ul class="favorites-list">
                                <li class="favorite-item">
                                    <div class="favorite-icon"
                                        style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">📸</div>
                                    <span class="favorite-name">Total Memories: 487</span>
                                </li>
                                <li class="favorite-item">
                                    <div class="favorite-icon"
                                        style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">🎉</div>
                                    <span class="favorite-name">Events: 156</span>
                                </li>
                                <li class="favorite-item">
                                    <div class="favorite-icon"
                                        style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">👥</div>
                                    <span class="favorite-name">People: 42</span>
                                </li>
                            </ul>
                        </div>

                        <!-- Top Moments Section -->
                        <div class="sidebar-section">
                            <h3 class="sidebar-title">Top Moments</h3>
                            <ul class="favorites-list">
                                <li class="favorite-item" onclick="openRecapViewer('graduation-journey')">
                                    <div class="favorite-icon"
                                        style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">🎓</div>
                                    <div class="favorite-content">
                                        <span class="favorite-name">Graduation Day</span>
                                        <span class="moment-date">May 2024</span>
                                    </div>
                                </li>
                                <li class="favorite-item" onclick="openRecapViewer('travel-adventures')">
                                    <div class="favorite-icon"
                                        style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">✈️</div>
                                    <div class="favorite-content">
                                        <span class="favorite-name">Europe Trip</span>
                                        <span class="moment-date">July 2024</span>
                                    </div>
                                </li>
                                <li class="favorite-item" onclick="openRecapViewer('birthday')">
                                    <div class="favorite-icon"
                                        style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">🎂</div>
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

                <!-- WhatsApp Status-Style Story Viewer Modal -->
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
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
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

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // ── Search functionality ──
                        const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');
                        const recapGrid = document.getElementById('recapGrid');
                        const emptyStateContainer = document.getElementById('emptyStateContainer');

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
                                    // Reset search results
                                    const cards = document.querySelectorAll('.recap-card-item');
                                    cards.forEach(card => card.style.display = 'block');
                                    if (recapGrid) recapGrid.style.display = 'grid';
                                    if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                    // Reset pill filters
                                    document.querySelectorAll('.recap-pill').forEach(p => p.classList.remove('active'));
                                    document.querySelector('.recap-pill[data-filter="all"]').classList.add('active');
                                };

                                searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

                                // Search functionality
                                input.addEventListener('input', function (e) {
                                    const query = e.target.value.toLowerCase();
                                    const recapCards = document.querySelectorAll('.recap-card-item');
                                    let visibleCount = 0;

                                    recapCards.forEach(card => {
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
                                        if (recapGrid) recapGrid.style.display = 'none';
                                        if (emptyStateContainer) emptyStateContainer.style.display = 'block';
                                    } else {
                                        if (recapGrid) recapGrid.style.display = 'grid';
                                        if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                    }
                                });
                            });
                        }

                        // ── Filter Pills ──
                        const filterPills = document.querySelectorAll('.recap-pill');
                        filterPills.forEach(pill => {
                            pill.addEventListener('click', function () {
                                filterPills.forEach(p => p.classList.remove('active'));
                                this.classList.add('active');

                                const filter = this.getAttribute('data-filter');
                                const recapCards = document.querySelectorAll('.recap-card-item');
                                let visibleCount = 0;

                                recapCards.forEach(card => {
                                    if (filter === 'all' || card.getAttribute('data-category') === filter) {
                                        card.style.display = 'block';
                                        visibleCount++;
                                    } else {
                                        card.style.display = 'none';
                                    }
                                });

                                if (visibleCount === 0) {
                                    if (recapGrid) recapGrid.style.display = 'none';
                                    if (emptyStateContainer) emptyStateContainer.style.display = 'block';
                                } else {
                                    if (recapGrid) recapGrid.style.display = 'grid';
                                    if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                }
                            });
                        });

                        // ── Card entrance animations ──
                        const cards = document.querySelectorAll('.recap-card-item');
                        cards.forEach((card, index) => {
                            card.style.opacity = '0';
                            card.style.transform = 'translateY(20px)';
                            setTimeout(() => {
                                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                                card.style.opacity = '1';
                                card.style.transform = 'translateY(0)';
                            }, index * 80);
                        });
                    });

                    // ── WhatsApp Status-Style Story Viewer ──
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
                        },
                        'this-month': {
                            name: 'This Month',
                            avatar: '📅',
                            memories: [
                                {
                                    image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
                                    title: 'Recent Moments',
                                    caption: 'Making every day count!'
                                }
                            ]
                        },
                        'graduation-journey': {
                            name: 'Graduation Journey',
                            avatar: '🎓',
                            memories: [
                                {
                                    image: 'https://images.unsplash.com/photo-1523050854058-8df90110c476?w=800',
                                    title: 'Cap & Gown',
                                    caption: 'The day we\'ve been waiting for!'
                                }
                            ]
                        },
                        'travel-adventures': {
                            name: 'Travel Adventures',
                            avatar: '✈️',
                            memories: [
                                {
                                    image: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800',
                                    title: 'Around the World',
                                    caption: 'Every destination tells a story!'
                                }
                            ]
                        },
                        'birthday': {
                            name: 'Birthday Celebrations',
                            avatar: '🎂',
                            memories: [
                                {
                                    image: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800',
                                    title: 'Birthday Bash',
                                    caption: 'Another year of amazing memories!'
                                }
                            ]
                        },
                        'family-moments': {
                            name: 'Family Moments',
                            avatar: '👨‍👩‍👧‍👦',
                            memories: [
                                {
                                    image: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800',
                                    title: 'Family Time',
                                    caption: 'Nothing beats time with family!'
                                }
                            ]
                        },
                        'best-friends-forever': {
                            name: 'Best Friends Forever',
                            avatar: '❤️',
                            memories: [
                                {
                                    image: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800',
                                    title: 'Squad Goals',
                                    caption: 'Friends who stay together!'
                                }
                            ]
                        },
                        'work-squad': {
                            name: 'Work Squad',
                            avatar: '💼',
                            memories: [
                                {
                                    image: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800',
                                    title: 'Team Building',
                                    caption: 'Great things happen when we work together!'
                                }
                            ]
                        }
                    };

                    let currentRecap = null;
                    let currentIndex = 0;
                    let progressTimer = null;

                    function openRecapViewer(recapId) {
                        currentRecap = recapData[recapId];
                        if (!currentRecap) return;
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
                        document.getElementById('progressBars').innerHTML = memories.map(function (_, i) {
                            return '<div class="progress-bar ' + (i < currentIndex ? 'completed' : '') + ' ' + (i === currentIndex ? 'active' : '') + '">' +
                                '<div class="progress-fill"></div>' +
                                '</div>';
                        }).join('');

                        // Create story slides
                        document.getElementById('storyContent').innerHTML = memories.map(function (memory, i) {
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
            </body>

            </html>