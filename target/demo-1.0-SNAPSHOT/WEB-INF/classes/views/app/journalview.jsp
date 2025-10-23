<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/journalviewer.css">
    <style>
        /* Floating Action Buttons - Positioned at bottom right */
        .floating-buttons {
            position: fixed;
            bottom: 30px;
            right: 30px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            z-index: 100;
        }
        .floating-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px 24px;
            border: none;
            border-radius: 24px;
            background: #9A74D8;
            box-shadow: 0 4px 14px rgba(154, 116, 216, 0.35);
            font-family: "Plus Jakarta Sans", sans-serif;
            font-size: 15px;
            font-weight: 600;
            color: #ffffff;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            white-space: nowrap;
            min-width: 140px;
        }
        .floating-btn:hover {
            background: #8a64c8;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(154, 116, 216, 0.45);
        }
        .floating-btn:active {
            transform: translateY(0);
        }
        .floating-btn svg {
            flex-shrink: 0;
        }
        .floating-btn.delete-btn {
            background: #EADDFF;
            color: #9A74D8;
            box-shadow: 0 4px 14px rgba(234, 221, 255, 0.5);
        }
        .floating-btn.delete-btn:hover {
            background: #FFFFFF;
            color: #8a64c8;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(234, 221, 255, 0.6);
        }
        /* Responsive Design */
        @media (max-width: 768px) {
            .floating-buttons {
                bottom: 20px;
                right: 20px;
            }
            .floating-btn {
                padding: 10px 20px;
                font-size: 14px;
                min-width: 120px;
            }
            .floating-btn svg {
                width: 16px;
                height: 16px;
            }
        }
        @media (max-width: 480px) {
            .floating-buttons {
                bottom: 15px;
                right: 15px;
            }
            .floating-btn {
                padding: 9px 18px;
                font-size: 13px;
                gap: 8px;
                min-width: 110px;
            }
        }
    </style>
</head>
<body>

<div class="journal-viewer-wrapper">
    <div class="journal-viewer-container">
        <!-- Navigation Header -->
        <div class="viewer-header">
            <button class="nav-btn prev-journal" id="prevJournal">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Previous
            </button>
            <h1 class="journal-title" id="journalTitle">July 21st - Birthday party</h1>
            <button class="nav-btn next-journal" id="nextJournal">
                Next
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
        </div>

        <!-- Journal Content Viewer -->
        <div class="page-viewer">
            <button class="arrow-btn left-arrow" id="prevPage">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
            </button>

            <div class="page-container" id="pageContainer">
                <!-- Journal P Content -->
                <div class="journal-page">
                    <!-- Favorite Heart -->
                    <button class="favorite-heart" id="favoriteHeart">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                        </svg>
                    </button>

                    <!-- Entry Content -->
                    <div class="page-content" id="pageContent">
                        <!-- Content will be dynamically loaded -->
                    </div>

                    <!-- Entry Date -->
                    <div class="page-date" id="pageDate">July 15, 2024</div>
                </div>
            </div>

            <button class="arrow-btn right-arrow" id="nextPage">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
        </div>

        <!-- Entry Info -->
        <div class="page-info">
            <p class="page-tag" id="pageTag">#vacation</p>
        </div>
    </div>
</div>

<!-- Hidden form for deletion -->
<form id="deleteJournalForm" action="${pageContext.request.contextPath}/deletejournal" method="post" style="display: none;">
    <input type="hidden" name="journalId" id="journalIdInput" value="">
</form>

<!-- Floating Action Buttons -->
<div class="floating-buttons">
    <a href="/editjournal" class="floating-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
        </svg>
        Edit
    </a>
    <button class="floating-btn delete-btn" id="deleteBtn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="3 6 5 6 21 6"></polyline>
            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
            <line x1="10" y1="11" x2="10" y2="17"></line>
            <line x1="14" y1="11" x2="14" y2="17"></line>
        </svg>
        Delete
    </button>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    // Journal Viewer Application
    class JournalViewer {
        constructor() {
            this.journals = this.getJournals();
            this.currentJournalIndex = 0;
            this.currentPageIndex = 0;
            this.favorites = new Set();

            this.initializeElements();
            this.attachEventListeners();
            this.loadJournal(this.currentJournalIndex);
        }

        getJournals() {
            return [
                {
                    id: 1,
                    title: "July 21st - Birthday party",
                    tag: "#vacation",
                    entries: [
                        {
                            date: "July 15, 2024",
                            content: `
                                <div class="page-text">
                                    <h2 class="page-heading">An Unforgettable Day</h2>
                                    <p>Today was absolutely magical! The birthday celebration exceeded all expectations. Friends and family gathered to make this day truly special.</p>
                                    <p>The decorations were stunning - pastel balloons everywhere, a beautiful cake, and the atmosphere was filled with love and laughter. Every moment felt like a precious memory being created.</p>
                                    <p>I'm so grateful for everyone who made this day possible. These are the moments that remind me how blessed I am to have such amazing people in my life.</p>
                                </div>
                                <div class="page-image" style="background-image: url('https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800'); height: 300px; background-size: cover; background-position: center; border-radius: 12px; margin-top: 20px;"></div>
                            `
                        }
                    ]
                },
                {
                    id: 2,
                    title: "July 31st",
                    tag: "#travel",
                    entries: [
                        {
                            date: "June 22, 2024",
                            content: `
                                <div class="page-text">
                                    <h2 class="page-heading">Travel Adventures</h2>
                                    <p>Exploring new places always fills my heart with joy. Today's journey took me to breathtaking landscapes that words can barely describe.</p>
                                    <p>The mountains stood tall against the azure sky, and the air was crisp and refreshing. Every step felt like walking into a postcard.</p>
                                    <p>Traveling teaches us so much about ourselves and the world. I'm grateful for these experiences that shape who I am.</p>
                                </div>
                                <div class="page-image" style="background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800'); height: 300px; background-size: cover; background-position: center; border-radius: 12px; margin-top: 20px;"></div>
                            `
                        }
                    ]
                },
                {
                    id: 3,
                    title: "June 30",
                    tag: "#family",
                    entries: [
                        {
                            date: "May 10, 2024",
                            content: `
                                <div class="page-text">
                                    <h2 class="page-heading">Family Time</h2>
                                    <p>Spent quality time with family today. These moments are priceless and remind me of what truly matters in life.</p>
                                    <p>We shared stories, laughter, and created new memories together. The warmth of family love is something that nothing else can replace.</p>
                                    <p>Grateful for these beautiful souls who make life meaningful.</p>
                                </div>
                                <div class="page-image" style="background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800'); height: 300px; background-size: cover; background-position: center; border-radius: 12px; margin-top: 20px;"></div>
                            `
                        }
                    ]
                }
            ];
        }

        initializeElements() {
            this.titleEl = document.getElementById('journalTitle');
            this.entryContentEl = document.getElementById('entryContent');
            this.entryDateEl = document.getElementById('entryDate');
            this.entryTagEl = document.getElementById('entryTag');
            this.favoriteBtn = document.getElementById('favoriteHeart');
        }

        attachEventListeners() {
            // Journal navigation
            document.getElementById('prevJournal').addEventListener('click', () => this.previousJournal());
            document.getElementById('nextJournal').addEventListener('click', () => this.nextJournal());

            // Entry navigation
            document.getElementById('prevEntry').addEventListener('click', () => this.previousEntry());
            document.getElementById('nextEntry').addEventListener('click', () => this.nextEntry());

            // Keyboard navigation
            document.addEventListener('keydown', (e) => {
                if (e.key === 'ArrowLeft') this.previousEntry();
                if (e.key === 'ArrowRight') this.nextEntry();
            });

            // Favorite button
            this.favoriteBtn.addEventListener('click', () => this.toggleFavorite());

            // Delete button
            const deleteBtn = document.getElementById('deleteBtn');
            const deleteForm = document.getElementById('deleteJournalForm');
            const journalIdInput = document.getElementById('journalIdInput');

            if (deleteBtn && deleteForm && journalIdInput) {
                deleteBtn.addEventListener('click', (event) => {
                    event.preventDefault();
                    const confirmDelete = confirm('Are you sure you want to delete this journal entry? This action cannot be undone.');
                    if (confirmDelete) {
                        // Set the journal ID
                        journalIdInput.value = this.journals[this.currentJournalIndex].id;
                        deleteForm.submit();
                    }
                });
            }
        }

        loadJournal(index) {
            if (index < 0 || index >= this.journals.length) return;

            this.currentJournalIndex = index;
            this.currentEntryIndex = 0;
            const journal = this.journals[index];

            this.titleEl.textContent = journal.title;
            this.entryTagEl.textContent = journal.tag;
            this.titleEl.style.animation = 'fadeInUp 0.5s ease';

            this.updateFavoriteButton();
            this.loadEntry(0);
        }

        loadEntry(index) {
            const journal = this.journals[this.currentJournalIndex];
            if (index < 0 || index >= journal.entries.length) return;

            this.currentEntryIndex = index;
            const entry = journal.entries[index];

            // Add fade effect
            this.entryContentEl.style.opacity = '0';

            setTimeout(() => {
                this.entryContentEl.innerHTML = entry.content;
                this.entryDateEl.textContent = entry.date;

                // Fade in
                this.entryContentEl.style.opacity = '1';
            }, 300);
        }

        previousJournal() {
            if (this.currentJournalIndex > 0) {
                this.loadJournal(this.currentJournalIndex - 1);
            }
        }

        nextJournal() {
            if (this.currentJournalIndex < this.journals.length - 1) {
                this.loadJournal(this.currentJournalIndex + 1);
            }
        }

        previousEntry() {
            const journal = this.journals[this.currentJournalIndex];
            if (this.currentEntryIndex > 0) {
                this.loadEntry(this.currentEntryIndex - 1);
            }
        }

        nextEntry() {
            const journal = this.journals[this.currentJournalIndex];
            if (this.currentEntryIndex < journal.entries.length - 1) {
                this.loadEntry(this.currentEntryIndex + 1);
            }
        }

        toggleFavorite() {
            const journalId = this.journals[this.currentJournalIndex].id;

            if (this.favorites.has(journalId)) {
                this.favorites.delete(journalId);
            } else {
                this.favorites.add(journalId);
            }

            this.updateFavoriteButton();
        }

        updateFavoriteButton() {
            const journalId = this.journals[this.currentJournalIndex].id;

            if (this.favorites.has(journalId)) {
                this.favoriteBtn.classList.add('favorited');
            } else {
                this.favoriteBtn.classList.remove('favorited');
            }
        }
    }

    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', () => {
        new JournalViewer();
    });
</script>

</body>
</html>