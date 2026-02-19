<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <jsp:include page="../../public/header2.jsp" />
    <html>

    <head>
        <link rel="stylesheet" type="text/css"
            href="${pageContext.request.contextPath}/resources/css/autographviewer.css">
        <style>
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

            .no-entries-message {
                text-align: center;
                padding: 60px 20px;
                color: #6b7280;
            }

            .no-entries-message h2 {
                color: #374151;
                margin-bottom: 10px;
            }

            .no-entries-message p {
                font-size: 15px;
            }
        </style>
    </head>

    <body>
        <div class="autograph-viewer-wrapper">
            <div class="autograph-viewer-container">
                <div class="viewer-header">
                    <button class="nav-btn prev-book" id="prevBook">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="15 18 9 12 15 6"></polyline>
                        </svg>
                        Previous
                    </button>
                    <h1 class="book-title" id="bookTitle">${autograph.title}</h1>
                    <button class="nav-btn next-book" id="nextBook">
                        Next
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </button>
                </div>
                <div class="page-viewer">
                    <button class="arrow-btn left-arrow" id="prevPage">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="15 18 9 12 15 6"></polyline>
                        </svg>
                    </button>
                    <div class="page-container" id="pageContainer">
                        <div class="autograph-page">
                            <button class="favorite-heart" id="favoriteHeart">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                    </path>
                                </svg>
                            </button>
                            <div class="page-content" id="pageContent"></div>
                            <div class="page-number" id="pageNumber"></div>
                        </div>
                    </div>
                    <button class="arrow-btn right-arrow" id="nextPage">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </button>
                </div>
                <div class="page-info" style="display: none;">
                    <p class="page-date" id="pageDate"></p>
                </div>
            </div>
        </div>

        <form id="deleteAutographForm" action="${pageContext.request.contextPath}/deleteautograph" method="post"
            style="display: none;">
            <input type="hidden" name="autographId" id="autographIdInput" value="${autograph.autographId}">
        </form>

        <div class="floating-buttons">
            <a href="/editautograph?id=${autograph.autographId}" class="floating-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                    stroke-linecap="round" stroke-linejoin="round">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                </svg>
                Edit
            </a>
            <button class="floating-btn delete-btn" id="deleteBtn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                    stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="3 6 5 6 21 6"></polyline>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    <line x1="10" y1="11" x2="10" y2="17"></line>
                    <line x1="14" y1="11" x2="14" y2="17"></line>
                </svg>
                Delete
            </button>
        </div>

        <jsp:include page="../../public/footer.jsp" />
        <input type="hidden" id="entriesData" value='${entriesJson}' />
        <input type="hidden" id="autographIdValue" value="${autograph.autographId}" />
        <input type="hidden" id="autographTitleValue" value="${autograph.title}" />
        <script>
            class AutographViewer {
                constructor() {
                    this.currentAutographId = document.getElementById('autographIdValue').value;
                    this.currentAutographTitle = document.getElementById('autographTitleValue').value;
                    this.entries = [];
                    try {
                        this.entries = JSON.parse(document.getElementById('entriesData').value || '[]');
                    } catch (e) {
                        console.error('Error parsing entries:', e);
                        this.entries = [];
                    }
                    this.currentPageIndex = 0;
                    this.favorites = new Set();
                    this.initializeElements();
                    this.attachEventListeners();
                    this.loadPage(0);
                }
                initializeElements() {
                    this.titleEl = document.getElementById('bookTitle');
                    this.pageContentEl = document.getElementById('pageContent');
                    this.pageDateEl = document.getElementById('pageDate');
                    this.pageNumberEl = document.getElementById('pageNumber');
                    this.favoriteBtn = document.getElementById('favoriteHeart');
                }
                attachEventListeners() {
                    document.getElementById('prevPage').addEventListener('click', function () { this.previousPage(); }.bind(this));
                    document.getElementById('nextPage').addEventListener('click', function () { this.nextPage(); }.bind(this));
                    var self = this;
                    document.addEventListener('keydown', function (e) {
                        if (e.key === 'ArrowLeft') self.previousPage();
                        if (e.key === 'ArrowRight') self.nextPage();
                    });
                    this.favoriteBtn.addEventListener('click', function () { this.toggleFavorite(); }.bind(this));
                }
                loadPage(index) {
                    if (this.entries.length === 0) {
                        this.pageContentEl.innerHTML = '<div class="no-entries-message"><h2>No entries yet</h2><p>Share your autograph book link to start collecting entries!</p></div>';
                        this.pageNumberEl.textContent = 'Page 0 of 0';
                        return;
                    }
                    if (index < 0 || index >= this.entries.length) return;
                    this.currentPageIndex = index;
                    var entry = this.entries[index];
                    this.pageContentEl.style.opacity = '0';
                    var self = this;
                    setTimeout(function () {
                        self.pageContentEl.innerHTML =
                            '<div class="message-text">' + entry.content + '</div>' +
                            '<div class="author-name">- ' + entry.author + '</div>';
                        self.pageDateEl.textContent = 'Written on ' + entry.date;
                        self.pageNumberEl.textContent = 'Page ' + (index + 1) + ' of ' + self.entries.length;
                        self.pageContentEl.style.opacity = '1';
                    }, 300);
                }
                previousPage() {
                    if (this.currentPageIndex > 0) {
                        this.loadPage(this.currentPageIndex - 1);
                    }
                }
                nextPage() {
                    if (this.currentPageIndex < this.entries.length - 1) {
                        this.loadPage(this.currentPageIndex + 1);
                    }
                }
                toggleFavorite() {
                    var bookId = this.currentAutographId;
                    if (this.favorites.has(bookId)) {
                        this.favorites.delete(bookId);
                    } else {
                        this.favorites.add(bookId);
                    }
                    this.updateFavoriteButton();
                }
                updateFavoriteButton() {
                    var bookId = this.currentAutographId;
                    if (this.favorites.has(bookId)) {
                        this.favoriteBtn.classList.add('favorited');
                    } else {
                        this.favoriteBtn.classList.remove('favorited');
                    }
                }
            }
            document.addEventListener('DOMContentLoaded', function () {
                new AutographViewer();
                var deleteBtn = document.getElementById('deleteBtn');
                var deleteForm = document.getElementById('deleteAutographForm');
                if (deleteBtn && deleteForm) {
                    deleteBtn.addEventListener('click', function (event) {
                        event.preventDefault();
                        var confirmDelete = confirm('Are you sure you want to delete this autograph book? This action cannot be undone.');
                        if (confirmDelete) { deleteForm.submit(); }
                    });
                }
            });
        </script>
    </body>

    </html>