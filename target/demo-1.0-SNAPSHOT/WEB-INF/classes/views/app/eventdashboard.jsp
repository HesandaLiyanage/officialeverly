<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/events.css">
<div class="events-container">
    <h1>Events</h1>

    <!-- Search & Sort -->
    <div class="search-sort-bar">
        <div class="search-box">
            <input type="text" placeholder="Search events" />
            <span class="search-icon">🔍</span>
        </div>
        <div class="sort-options">
            <select class="sort-select">
                <option value="">Sort by Date</option>
                <option value="newest">Newest First</option>
                <option value="oldest">Oldest First</option>
            </select>
            <select class="sort-select">
                <option value="">Sort by Type</option>
                <option value="concert">Concert</option>
                <option value="family">Family</option>
                <option value="vacation">Vacation</option>
            </select>
            <select class="sort-select">
                <option value="">Sort by Tags</option>
                <option value="birthday">Birthday</option>
                <option value="anniversary">Anniversary</option>
                <option value="reunion">Reunion</option>
            </select>
        </div>
    </div>

    <!-- Upcoming Events -->
    <section class="events-section">
        <h2>Upcoming Events</h2>
        <div class="events-grid">
            <div class="event-card">
                <div class="event-image">
                    <img src="https://via.placeholder.com/300x180?text=Family+Reunion" alt="Family Reunion" />
                </div>
                <div class="event-details">
                    <span class="event-status">Upcoming</span>
                    <h3>Family Reunion</h3>
                    <p>July 15, 2024</p>
                </div>
            </div>

            <div class="event-card">
                <div class="event-image">
                    <img src="https://via.placeholder.com/300x180?text=Summer+Vacation" alt="Summer Vacation" />
                </div>
                <div class="event-details">
                    <span class="event-status">Upcoming</span>
                    <h3>Summer Vacation</h3>
                    <p>August 5, 2024</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Past Events -->
    <section class="events-section">
        <h2>Past Events</h2>
        <div class="events-grid">
            <div class="event-card">
                <div class="event-image">
                    <img src="https://via.placeholder.com/300x180?text=Sarah%27s+Birthday" alt="Sarah's Birthday" />
                </div>
                <div class="event-details">
                    <span class="event-status">Past</span>
                    <h3>Sarah’s Birthday</h3>
                    <p>June 20, 2024</p>
                </div>
            </div>

            <div class="event-card">
                <div class="event-image">
                    <img src="https://via.placeholder.com/300x180?text=Anniversary" alt="Anniversary" />
                </div>
                <div class="event-details">
                    <span class="event-status">Past</span>
                    <h3>Anniversary</h3>
                    <p>May 10, 2024</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Create New Event Button -->
    <div class="create-event-btn-wrapper">
        <a href="create-event.jsp" class="create-event-btn">Create New Event</a>
    </div>
</div>

<%@ include file="footer.jsp" %>