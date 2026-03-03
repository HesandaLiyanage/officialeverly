<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.demo.web.model.Event" %>
            <%@ page import="java.text.SimpleDateFormat" %>
                <%@ page import="java.util.Date" %>

                    <jsp:include page="../public/header2.jsp" />
                    <html>

                    <head>
                        <link rel="stylesheet" type="text/css"
                            href="${pageContext.request.contextPath}/resources/css/events.css">
                        <% String successMessage=(String) session.getAttribute("successMessage"); if (successMessage
                            !=null) { session.removeAttribute("successMessage"); %>
                            <div class="alert alert-success"
                                style="background: #d1fae5; border: 1px solid #6ee7b7; padding: 12px; border-radius: 8px; margin: 20px; color: #065f46;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                                <%= successMessage %>
                            </div>
                            <% } %>


                    </head>

                    <body>

                        <% List<Event> upcomingEvents = (List<Event>) request.getAttribute("upcomingEvents");
                                List<Event> pastEvents = (List<Event>) request.getAttribute("pastEvents");
                                        Integer upcomingCount = (Integer) request.getAttribute("upcomingCount");
                                        Integer pastCount = (Integer) request.getAttribute("pastCount");
                                        Integer totalCount = (Integer) request.getAttribute("totalCount");
                                        Boolean isGroupAdmin = (Boolean) request.getAttribute("isGroupAdmin");

                                        // Set defaults if null
                                        if (upcomingCount == null) upcomingCount = 0;
                                        if (pastCount == null) pastCount = 0;
                                        if (totalCount == null) totalCount = 0;
                                        if (isGroupAdmin == null) isGroupAdmin = false;

                                        SimpleDateFormat displayFormat = new SimpleDateFormat("MMMM dd, yyyy");
                                        %>

                                        <!-- Wrap everything after header -->
                                        <div class="page-wrapper">
                                            <main class="main-content">
                                                <!-- Page Title -->
                                                <div class="tab-nav">
                                                    <div class="page-title">Events
                                                        <p class="page-subtitle">Plan, track, and relive your special
                                                            occasions.</p>
                                                    </div>
                                                </div>
                                                <!-- Tab Navigation -->
                                                <div class="tab-nav" style="margin-top: 0;">
                                                    <button class="active" data-tab="upcoming">Upcoming</button>
                                                    <button data-tab="past">Past Events</button>
                                                </div>

                                                <!-- Search and Filters -->
                                                <div class="search-filters"
                                                    style="margin-top: 10px; margin-bottom: 15px;">
                                                    <div class="events-search-container">
                                                        <button class="events-search-btn" id="eventsSearchBtn">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                                stroke-width="2" stroke-linecap="round"
                                                                stroke-linejoin="round">
                                                                <circle cx="11" cy="11" r="8"></circle>
                                                                <path d="m21 21-4.35-4.35"></path>
                                                            </svg>
                                                        </button>
                                                    </div>
                                                    <button class="filter-btn" id="dateFilter">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <line x1="12" y1="5" x2="12" y2="19"></line>
                                                            <polyline points="19 12 12 19 5 12"></polyline>
                                                        </svg>
                                                        Date
                                                    </button>
                                                    <button class="filter-btn" id="typeFilter">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path
                                                                d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z">
                                                            </path>
                                                            <line x1="7" y1="7" x2="7.01" y2="7"></line>
                                                        </svg>
                                                        Type
                                                    </button>
                                                </div>

                                                <!-- Events Grid -->
                                                <div class="events-grid" id="eventsGrid"
                                                    style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">

                                                    <%-- Display message if user is not a group admin --%>
                                                        <% if (!isGroupAdmin) { %>
                                                            <div
                                                                style="text-align: center; padding: 40px; color: #6b7280; background: #fef3c7; border: 2px solid #fbbf24; border-radius: 12px; margin: 20px;">
                                                                <svg width="64" height="64" viewBox="0 0 24 24"
                                                                    fill="none" stroke="#f59e0b" stroke-width="1.5"
                                                                    style="margin: 0 auto 20px;">
                                                                    <path
                                                                        d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z">
                                                                    </path>
                                                                    <line x1="12" y1="9" x2="12" y2="13"></line>
                                                                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                                                </svg>
                                                                <h3 style="margin: 0 0 10px; color: #92400e;">You're Not
                                                                    a Group Admin</h3>
                                                                <p style="margin: 0; color: #78350f;">Only group admins
                                                                    can create and view events. Please create a group
                                                                    first to access event features.</p>
                                                                <a href="${pageContext.request.contextPath}/creategroup"
                                                                    style="display: inline-block; margin-top: 20px; padding: 10px 20px; background: #f59e0b; color: white; text-decoration: none; border-radius: 8px; font-weight: 600;">
                                                                    Create Your First Group
                                                                </a>
                                                            </div>
                                                            <% } else if ((upcomingEvents==null ||
                                                                upcomingEvents.isEmpty()) && (pastEvents==null ||
                                                                pastEvents.isEmpty())) { %>
                                                                <%-- Display message if no events exist but user is
                                                                    admin --%>
                                                                    <div
                                                                        style="text-align: center; padding: 40px; color: #6b7280;">
                                                                        <svg width="64" height="64" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="1.5"
                                                                            style="margin: 0 auto 20px; opacity: 0.5;">
                                                                            <rect x="3" y="4" width="18" height="18"
                                                                                rx="2" ry="2"></rect>
                                                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                                                        </svg>
                                                                        <h3 style="margin: 0 0 10px; color: #374151;">No
                                                                            Events Yet</h3>
                                                                        <p style="margin: 0;">Create your first event to
                                                                            get started!</p>
                                                                    </div>
                                                                    <% } %>

                                                                        <%-- Upcoming Events --%>
                                                                            <% if (upcomingEvents !=null &&
                                                                                !upcomingEvents.isEmpty()) { for (Event
                                                                                event : upcomingEvents) { String
                                                                                imageUrl=event.getEventPicUrl() !=null
                                                                                && !event.getEventPicUrl().isEmpty() ?
                                                                                request.getContextPath() + "/" +
                                                                                event.getEventPicUrl()
                                                                                : "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800"
                                                                                ; String
                                                                                formattedDate=displayFormat.format(new
                                                                                Date(event.getEventDate().getTime()));
                                                                                %>
                                                                                <div class="event-card upcoming"
                                                                                    data-title="<%= event.getTitle() %>"
                                                                                    data-tab="upcoming"
                                                                                    data-event-id="<%= event.getEventId() %>">
                                                                                    <div class="event-image"
                                                                                        style="background-image: url('<%= imageUrl %>')">
                                                                                    </div>
                                                                                    <div class="event-content">
                                                                                        <span
                                                                                            class="event-status upcoming-status">Upcoming</span>
                                                                                        <h3 class="event-title">
                                                                                            <%= event.getTitle() %>
                                                                                        </h3>
                                                                                        <p class="event-date">
                                                                                            <%= formattedDate %>
                                                                                        </p>
                                                                                        <% if (event.getDescription()
                                                                                            !=null &&
                                                                                            !event.getDescription().isEmpty())
                                                                                            { %>
                                                                                            <p class="event-description"
                                                                                                style="font-size: 0.875rem; color: #6b7280; margin-top: 8px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                                                                                <%= event.getDescription()
                                                                                                    %>
                                                                                            </p>
                                                                                            <% } %>
                                                                                    </div>
                                                                                </div>
                                                                                <% } } %>

                                                                                    <%-- Past Events --%>
                                                                                        <% if (pastEvents !=null &&
                                                                                            !pastEvents.isEmpty()) { for
                                                                                            (Event event : pastEvents) {
                                                                                            String
                                                                                            imageUrl=event.getEventPicUrl()
                                                                                            !=null &&
                                                                                            !event.getEventPicUrl().isEmpty()
                                                                                            ? request.getContextPath()
                                                                                            + "/" +
                                                                                            event.getEventPicUrl()
                                                                                            : "https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800"
                                                                                            ; String
                                                                                            formattedDate=displayFormat.format(new
                                                                                            Date(event.getEventDate().getTime()));
                                                                                            %>
                                                                                            <div class="event-card past"
                                                                                                data-title="<%= event.getTitle() %>"
                                                                                                data-tab="past"
                                                                                                data-event-id="<%= event.getEventId() %>"
                                                                                                style="display: none;">
                                                                                                <div class="event-image"
                                                                                                    style="background-image: url('<%= imageUrl %>')">
                                                                                                </div>
                                                                                                <div
                                                                                                    class="event-content">
                                                                                                    <span
                                                                                                        class="event-status past-status">Past</span>
                                                                                                    <h3
                                                                                                        class="event-title">
                                                                                                        <%= event.getTitle()
                                                                                                            %>
                                                                                                    </h3>
                                                                                                    <p
                                                                                                        class="event-date">
                                                                                                        <%= formattedDate
                                                                                                            %>
                                                                                                    </p>
                                                                                                    <% if
                                                                                                        (event.getDescription()
                                                                                                        !=null &&
                                                                                                        !event.getDescription().isEmpty())
                                                                                                        { %>
                                                                                                        <p class="event-description"
                                                                                                            style="font-size: 0.875rem; color: #6b7280; margin-top: 8px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                                                                                            <%= event.getDescription()
                                                                                                                %>
                                                                                                        </p>
                                                                                                        <% } %>
                                                                                                            <a href="${pageContext.request.contextPath}/groupmemories?groupId=<%= event.getGroupId() %>"
                                                                                                                class="go-to-memory-btn"
                                                                                                                onclick="event.stopPropagation();"
                                                                                                                style="display: inline-flex; align-items: center; gap: 6px; margin-top: 12px; padding: 8px 16px; background: linear-gradient(135deg, #8b5cf6, #6366f1); color: white; border-radius: 8px; text-decoration: none; font-size: 0.85rem; font-weight: 600; transition: all 0.2s ease;">
                                                                                                                <svg width="16"
                                                                                                                    height="16"
                                                                                                                    viewBox="0 0 24 24"
                                                                                                                    fill="none"
                                                                                                                    stroke="currentColor"
                                                                                                                    stroke-width="2"
                                                                                                                    stroke-linecap="round"
                                                                                                                    stroke-linejoin="round">
                                                                                                                    <path
                                                                                                                        d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z">
                                                                                                                    </path>
                                                                                                                    <circle
                                                                                                                        cx="12"
                                                                                                                        cy="13"
                                                                                                                        r="4">
                                                                                                                    </circle>
                                                                                                                </svg>
                                                                                                                Go to
                                                                                                                Memories
                                                                                                            </a>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } } %>
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
                                                                <span class="stat-value">
                                                                    <%= upcomingCount %> Event<%= upcomingCount !=1
                                                                            ? "s" : "" %>
                                                                </span>
                                                            </div>
                                                        </li>
                                                        <li class="stat-item">
                                                            <div class="stat-icon past">📋</div>
                                                            <div class="stat-info">
                                                                <span class="stat-label">Past</span>
                                                                <span class="stat-value">
                                                                    <%= pastCount %> Event<%= pastCount !=1 ? "s" : ""
                                                                            %>
                                                                </span>
                                                            </div>
                                                        </li>
                                                        <li class="stat-item">
                                                            <div class="stat-icon total">📊</div>
                                                            <div class="stat-info">
                                                                <span class="stat-label">Total</span>
                                                                <span class="stat-value">
                                                                    <%= totalCount %> Event<%= totalCount !=1 ? "s" : ""
                                                                            %>
                                                                </span>
                                                            </div>
                                                        </li>
                                                    </ul>
                                                </div>

                                                <!-- Floating Action Buttons -->
                                                <div class="floating-buttons"
                                                    style="position: static; margin-top: 20px;">
                                                    <% if (isGroupAdmin) { %>
                                                        <a href="${pageContext.request.contextPath}/createevent"
                                                            class="floating-btn">
                                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2.5"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                                            </svg>
                                                            Create Event
                                                        </a>
                                                        <% } else { %>
                                                            <a href="${pageContext.request.contextPath}/creategroup"
                                                                class="floating-btn" style="background: #f59e0b;">
                                                                <svg width="18" height="18" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2.5"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                                                </svg>
                                                                Create Group First
                                                            </a>
                                                            <% } %>
                                                </div>
                                            </aside>
                                        </div>

                                        <jsp:include page="../public/footer.jsp" />

                                        <script>
                                            // Event card click handler - now works for all event cards
                                            document.addEventListener('DOMContentLoaded', function () {
                                                const eventCards = document.querySelectorAll('.event-card');

                                                eventCards.forEach(card => {
                                                    card.style.cursor = 'pointer';
                                                    card.addEventListener('click', function () {
                                                        const eventId = this.getAttribute('data-event-id');
                                                        if (eventId) {
                                                            window.location.href = '${pageContext.request.contextPath}/eventinfo?id=' + eventId;
                                                        }
                                                    });
                                                });
                                            });

                                            // Modern Search Functionality
                                            document.addEventListener('DOMContentLoaded', function () {
                                                const eventsSearchBtn = document.getElementById('eventsSearchBtn');

                                                if (eventsSearchBtn) {
                                                    eventsSearchBtn.addEventListener('click', function (event) {
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

                                                        input.addEventListener('blur', function () {
                                                            setTimeout(() => {
                                                                if (!document.activeElement.closest('.events-search-expanded')) {
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
                                                            const eventCards = document.querySelectorAll('.event-card');
                                                            const activeTab = document.querySelector('.tab-nav button.active').getAttribute('data-tab');

                                                            eventCards.forEach(card => {
                                                                const title = card.getAttribute('data-title')?.toLowerCase() || '';
                                                                const cardTab = card.getAttribute('data-tab');

                                                                // Only show cards that match both the search and the active tab
                                                                if (cardTab === activeTab && title.includes(query)) {
                                                                    card.style.display = 'block';
                                                                } else {
                                                                    card.style.display = 'none';
                                                                }
                                                            });
                                                        });
                                                    });
                                                }

                                                // Tab switching functionality
                                                const tabButtons = document.querySelectorAll('.tab-nav button');
                                                const eventCards = document.querySelectorAll('.event-card');

                                                tabButtons.forEach(button => {
                                                    button.addEventListener('click', function () {
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