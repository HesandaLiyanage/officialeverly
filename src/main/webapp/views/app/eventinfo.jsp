<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/eventinfo.css">
</head>
<body>

<div class="event-viewer-wrapper">
    <div class="event-viewer-container">
        <!-- Navigation Header -->
        <div class="viewer-header">
            <button class="nav-btn prev-event" id="prevEvent">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Previous
            </button>
            <h1 class="event-title" id="eventTitle">Family Reunion</h1>
            <button class="nav-btn next-event" id="nextEvent">
                Next
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
        </div>

        <!-- Event Banner -->
        <div class="event-banner-container">
            <img src="https://images.unsplash.com/photo-1511895426328-dc8714191300?w=1200" alt="Event Banner" id="eventBanner" class="event-banner-img">
        </div>

        <!-- Event Info -->
        <div class="event-info-section">
            <div class="info-row">
                <div class="info-item">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span id="eventDate">July 15, 2024</span>
                </div>
                <div class="info-item">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
                        <line x1="7" y1="7" x2="7.01" y2="7"></line>
                    </svg>
                    <span id="eventCategory">Family</span>
                </div>
                <div class="info-item">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span id="eventGroup">Uni Friends</span>
                </div>
            </div>
        </div>

        <!-- Event Description -->
        <div class="event-description-section">
            <h3 class="section-title">About This Event</h3>
            <p class="event-description" id="eventDescription">
                The Family Reunion was an unforgettable gathering of loved ones. We shared stories, laughter, and created beautiful new memories together. The day was filled with delicious food, fun activities, and the warmth of family bonds. From the youngest to the oldest, everyone had a wonderful time reconnecting and celebrating our shared history. It's moments like these that remind us of what truly matters in life.
            </p>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons-section">
            <button class="primary-action-btn" id="goToMemoryBtn">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                    <polyline points="21 15 16 10 5 21"></polyline>
                </svg>
                Go to the Memory
            </button>
            <div class="secondary-actions">
                <button class="secondary-action-btn edit-btn" id="editEventBtn">

                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>

                    </svg>
                    Edit Event

                </button>
                <button class="secondary-action-btn delete-btn" id="deleteEventBtn">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="3 6 5 6 21 6"></polyline>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    </svg>
                    Delete Event
                </button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    // Event Info Viewer Application
    class EventInfoViewer {
        constructor() {
            this.events = this.getEvents();
            this.currentEventIndex = 0;

            this.initializeElements();
            this.attachEventListeners();
            this.loadEvent(this.currentEventIndex);
        }

        getEvents() {
            return [
                {
                    id: 1,
                    title: "Family Reunion",
                    date: "July 15, 2024",
                    category: "Family",
                    group: "Uni Friends",
                    banner: "https://images.unsplash.com/photo-1511895426328-dc8714191300?w=1200",
                    description: "The Family Reunion was an unforgettable gathering of loved ones. We shared stories, laughter, and created beautiful new memories together. The day was filled with delicious food, fun activities, and the warmth of family bonds. From the youngest to the oldest, everyone had a wonderful time reconnecting and celebrating our shared history. It's moments like these that remind us of what truly matters in life."
                },
                {
                    id: 2,
                    title: "Summer Vacation",
                    date: "August 5, 2024",
                    category: "Travel",
                    group: "Friends",
                    banner: "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=1200",
                    description: "Our summer vacation was an adventure of a lifetime! We explored beautiful beaches, hiked through stunning mountains, and experienced different cultures. Every day brought new discoveries and unforgettable moments. The perfect blend of relaxation and adventure made this trip truly special."
                },
                {
                    id: 3,
                    title: "Beach Party",
                    date: "August 20, 2024",
                    category: "Social",
                    group: "College Friends",
                    banner: "https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=1200",
                    description: "The beach party was absolutely amazing! Sun, sand, music, and great company made it a day to remember. We played beach volleyball, had a barbecue, and watched the sunset together. The bonfire and stargazing at night were the perfect ending to an incredible day."
                }
            ];
        }

        initializeElements() {
            this.titleEl = document.getElementById('eventTitle');
            this.bannerEl = document.getElementById('eventBanner');
            this.dateEl = document.getElementById('eventDate');
            this.categoryEl = document.getElementById('eventCategory');
            this.groupEl = document.getElementById('eventGroup');
            this.descriptionEl = document.getElementById('eventDescription');
        }

        attachEventListeners() {
            // Event navigation
            document.getElementById('prevEvent').addEventListener('click', () => this.previousEvent());
            document.getElementById('nextEvent').addEventListener('click', () => this.nextEvent());

            // Action buttons
            document.getElementById('goToMemoryBtn').addEventListener('click', () => this.goToMemory());
            document.getElementById('editEventBtn').addEventListener('click', () => this.editEvent());
            document.getElementById('deleteEventBtn').addEventListener('click', () => this.deleteEvent());
        }

        loadEvent(index) {
            if (index < 0 || index >= this.events.length) return;

            this.currentEventIndex = index;
            const event = this.events[index];

            // Fade out
            this.bannerEl.style.opacity = '0';

            setTimeout(() => {
                this.titleEl.textContent = event.title;
                this.bannerEl.src = event.banner;
                this.dateEl.textContent = event.date;
                this.categoryEl.textContent = event.category;
                this.groupEl.textContent = event.group;
                this.descriptionEl.textContent = event.description;

                // Fade in
                this.bannerEl.style.opacity = '1';
            }, 300);
        }

        previousEvent() {
            if (this.currentEventIndex > 0) {
                this.loadEvent(this.currentEventIndex - 1);
            }
        }

        nextEvent() {
            if (this.currentEventIndex < this.events.length - 1) {
                this.loadEvent(this.currentEventIndex + 1);
            }
        }

        goToMemory() {
            console.log('Go to memory for event:', this.events[this.currentEventIndex].title);
            window.location.href = '/memoryview';
        }

        editEvent() {
            console.log('Edit event:', this.events[this.currentEventIndex].title);
            window.location.href = '/createevent';
        }

        deleteEvent() {
            const event = this.events[this.currentEventIndex];
            if (confirm(`Are you sure you want to delete "${event.title}"?`)) {
                console.log('Delete event:', event.title);
                // Handle deletion logic here
                window.location.href = '/events';
            }
        }
    }

    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', () => {
        new EventInfoViewer();
    });
</script>

</body>
</html>