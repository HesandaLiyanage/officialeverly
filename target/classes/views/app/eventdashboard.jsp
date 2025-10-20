<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/events.css">

<!-- Wrap everything after header -->
<div class="page-wrapper">
    <main class="main-content">
        <!-- Tab Navigation -->
        <div class="tab-nav">
            <button class="active" data-tab="upcoming">Upcoming</button>
            <button data-tab="past">Past Events</button>
        </div>

        <!-- Search and Filters -->
        <div class="search-filters" style="margin-top: 10px; margin-bottom: 15px;">
            <div class="events-search-container">
                <button class="events-search-btn" id="eventsSearchBtn">
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
            <button class="filter-btn" id="typeFilter">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
                    <line x1="7" y1="7" x2="7.01" y2="7"></line>
                </svg>
                Type
            </button>
        </div>

        <!-- Events Grid -->
        <div class="events-grid" id="eventsGrid" style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
            <!-- Upcoming Events -->
            <div class="event-card upcoming" data-title="Family Reunion" data-tab="upcoming">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800')"></div>
                <div class="event-content">

                    <span class="event-status upcoming-status">Upcoming</span>
                    <h3 class="event-title">Family Reunion</h3>
                    <p class="event-date">July 15, 2024</p>
                </div>
            </div>

            <div class="event-card upcoming" data-title="Summer Vacation" data-tab="upcoming">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800')"></div>
                <div class="event-content">
                    <span class="event-status upcoming-status">Upcoming</span>
                    <h3 class="event-title">Summer Vacation</h3>
                    <p class="event-date">August 5, 2024</p>
                </div>
            </div>

            <div class="event-card upcoming" data-title="Beach Party" data-tab="upcoming">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800')"></div>
                <div class="event-content">
                    <span class="event-status upcoming-status">Upcoming</span>
                    <h3 class="event-title">Beach Party</h3>
                    <p class="event-date">August 20, 2024</p>
                </div>
            </div>

            <!-- Past Events -->
            <div class="event-card past" data-title="Sarah's Birthday" data-tab="past" style="display: none;">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800')"></div>
                <div class="event-content">
                    <span class="event-status past-status">Past</span>
                    <h3 class="event-title">Sarah's Birthday</h3>
                    <p class="event-date">June 20, 2024</p>
                </div>
            </div>

            <div class="event-card past" data-title="Anniversary" data-tab="past" style="display: none;">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800')"></div>
                <div class="event-content">
                    <span class="event-status past-status">Past</span>
                    <h3 class="event-title">Anniversary</h3>
                    <p class="event-date">May 10, 2024</p>
                </div>
            </div>

            <div class="event-card past" data-title="Graduation Day" data-tab="past" style="display: none;">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800')"></div>
                <div class="event-content">
                    <span class="event-status past-status">Past</span>
                    <h3 class="event-title">Graduation Day</h3>
                    <p class="event-date">April 15, 2024</p>
                </div>
            </div>

            <div class="event-card past" data-title="Concert Night" data-tab="past" style="display: none;">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800')"></div>
                <div class="event-content">
                    <span class="event-status past-status">Past</span>
                    <h3 class="event-title">Concert Night</h3>
                    <p class="event-date">March 25, 2024</p>
                </div>
            </div>

            <div class="event-card past" data-title="Holiday Dinner" data-tab="past" style="display: none;">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800')"></div>
                <div class="event-content">
                    <span class="event-status past-status">Past</span>
                    <h3 class="event-title">Holiday Dinner</h3>
                    <p class="event-date">December 25, 2023</p>
                </div>
            </div>

            <div class="event-card past" data-title="Road Trip" data-tab="past" style="display: none;">
                <div class="event-image" style="background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800')"></div>
                <div class="event-content">
                    <span class="event-status past-status">Past</span>
                    <h3 class="event-title">Road Trip</h3>
                    <p class="event-date">November 10, 2023</p>
                </div>
            </div>
        </div>
    </main>

    <aside class="sidebar">
        <!-- Calendar Section -->
        <div class="sidebar-section">
            <h3 class="sidebar-title">Event Dashboard</h3>
            <ul class="stats-list">
                <li class="stat-item">
                    <div class="stat-icon upcoming">📅</div>
                    <div class="stat-info">
                        <span class="stat-label">Upcoming</span>
                        <span class="stat-value">3 Events</span>
                    </div>
                </li>
                <li class="stat-item">
                    <div class="stat-icon past">📋</div>
                    <div class="stat-info">
                        <span class="stat-label">Past</span>
                        <span class="stat-value">6 Events</span>
                    </div>
                </li>
                <li class="stat-item">
                    <div class="stat-icon total">📊</div>
                    <div class="stat-info">
                        <span class="stat-label">Total</span>
                        <span class="stat-value">9 Events</span>
                    </div>
                </li>
            </ul>
        </div>

        <!-- Floating Action Buttons -->
        <div class="floating-buttons" style="position: static; margin-top: 20px;">
            <a href="/createevent" class="floating-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Create Event
            </a>
        </div>
    </aside>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    const eventCard = document.querySelector('.event-card.upcoming');

    // Add a click event listener
    eventCard.addEventListener('click', () => {
        // Redirect to desired path
        window.location.href = '/eventinfo';
    });

    // Optional: make it look clickable
    eventCard.style.cursor = 'pointer';
    // Modern Search Functionality
    document.addEventListener('DOMContentLoaded', function() {
        const eventsSearchBtn = document.getElementById('eventsSearchBtn');

        if (eventsSearchBtn) {
            eventsSearchBtn.addEventListener('click', function(event) {
                event.stopPropagation();

                const searchBtnElement = this;
                const searchContainer = searchBtnElement.parentElement;

                const searchBox = document.createElement('div');
                searchBox.className = 'events-search-expanded';
                searchBox.innerHTML = `
          <div class="events-search-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          </div>
          <input type="text" id="searchInput" placeholder="Search events..." autofocus>
          <button class="events-search-close">
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
                    newSearchBtn.className = 'events-search-btn';
                    newSearchBtn.id = 'eventsSearchBtn';
                    newSearchBtn.innerHTML = `
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          `;
                    searchContainer.replaceChild(newSearchBtn, searchBox);
                    newSearchBtn.addEventListener('click', arguments.callee);
                };

                searchBox.querySelector('.events-search-close').addEventListener('click', closeSearch);

                input.addEventListener('blur', function() {
                    setTimeout(() => {
                        if (!document.activeElement.closest('.events-search-expanded')) {
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
                    const eventCards = document.querySelectorAll('.event-card');
                    eventCards.forEach(card => {
                        const title = card.getAttribute('data-title')?.toLowerCase() || '';
                        card.style.display = title.includes(query) ? 'block' : 'none';
                    });
                });
            });
        }

        // Tab switching functionality
        const tabButtons = document.querySelectorAll('.tab-nav button');
        const eventCards = document.querySelectorAll('.event-card');

        tabButtons.forEach(button => {
            button.addEventListener('click', function() {
                const tab = this.getAttribute('data-tab');

                // Update active button
                tabButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');

                // Show/hide events based on tab
                eventCards.forEach(card => {
                    const cardTab = card.getAttribute('data-tab');
                    if (tab === cardTab) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    });
</script>
</body>
</html>