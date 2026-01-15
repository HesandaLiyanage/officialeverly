<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.autographEntry" %>
        <%@ page import="java.util.List" %>
            <% List<autographEntry> entries = (List<autographEntry>) request.getAttribute("entries");
                    %>
                    <jsp:include page="../../public/header2.jsp" />
                    <html>

                    <head>
                        <link rel="stylesheet" type="text/css"
                            href="${pageContext.request.contextPath}/resources/css/autographviewer.css">
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
                        <div class="autograph-viewer-wrapper">
                            <div class="autograph-viewer-container">
                                <!-- Navigation Header -->
                                <div class="viewer-header">
                                    <button class="nav-btn prev-book" id="prevBook">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <polyline points="15 18 9 12 15 6"></polyline>
                                        </svg>
                                        Previous
                                    </button>
                                    <h1 class="book-title" id="bookTitle">${autograph.title}</h1>
                                    <!-- Use EL to get title from server object -->
                                    <button class="nav-btn next-book" id="nextBook">
                                        Next
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </button>
                                </div>
                                <!-- Page Viewer -->
                                <div class="page-viewer">
                                    <button class="arrow-btn left-arrow" id="prevPage">
                                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <polyline points="15 18 9 12 15 6"></polyline>
                                        </svg>
                                    </button>
                                    <div class="page-container" id="pageContainer">
                                        <!-- Autograph Page Content -->
                                        <div class="autograph-page">
                                            <!-- Favorite Heart -->
                                            <button class="favorite-heart" id="favoriteHeart">
                                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <path
                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                    </path>
                                                </svg>
                                            </button>
                                            <!-- Page Content -->
                                            <div class="page-content" id="pageContent">
                                                <!-- Content will be dynamically loaded -->
                                            </div>
                                            <!-- Page Number -->
                                            <div class="page-number" id="pageNumber">Page 1 of 4</div>
                                        </div>
                                    </div>
                                    <button class="arrow-btn right-arrow" id="nextPage">
                                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </button>
                                </div>
                                <!-- Page Info -->
                                <div class="page-info" style="display: none;">
                                    <p class="page-date" id="pageDate">Written on October 5, 2025</p>
                                </div>
                            </div>
                        </div>

                        <!-- Hidden form for deletion -->
                        <form id="deleteAutographForm" action="${pageContext.request.contextPath}/deleteautograph"
                            method="post" style="display: none;">
                            <input type="hidden" name="autographId" id="autographIdInput"
                                value="${autograph.autographId}">
                            <!-- Use EL to get ID from server object -->
                        </form>

                        <!-- Floating Action Buttons -->
                        <div class="floating-buttons">
                            <!-- Updated Edit Link to include the autograph ID using EL -->
                            <a href="/editautograph?id=${autograph.autographId}" class="floating-btn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                </svg>
                                Edit
                            </a>

                            <button class="floating-btn delete-btn" id="deleteBtn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="3 6 5 6 21 6"></polyline>
                                    <path
                                        d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                    </path>
                                    <line x1="10" y1="11" x2="10" y2="17"></line>
                                    <line x1="14" y1="11" x2="14" y2="17"></line>
                                </svg>
                                Delete
                            </button>
                        </div>

                        <jsp:include page="../../public/footer.jsp" />
                        <script>
                            // Autograph Viewer Application
                            class AutographViewer {
                                constructor() {
                                    this.currentAutographId = ${ autograph.autographId };
                                    this.currentAutographTitle = '${autograph.title}';

                                    try {
                                        const entriesData = document.getElementById('entriesData').value;
                                        this.entries = JSON.parse(entriesData);
                                    } catch (e) {
                                        console.error("Error parsing entries", e);
                                        this.entries = [];
                                    }

                                    this.currentPageIndex = 0;
                                    this.favorites = new Set();
                                    this.initializeElements();
                                    this.attachEventListeners();

                                    if (this.entries.length > 0) {
                                        this.loadPage(0);
                                    } else {
                                        this.showNoEntries();
                                    }
                                }

                                showNoEntries() {
                                    this.pageContentEl.innerHTML = `
                                        <div class="no-entries" style="text-align: center; padding-top: 100px;">
                                            <p style="font-size: 18px; color: #666;">No autographs yet. ✨</p>
                                        </div>
                                    `;
                                    this.pageNumberEl.textContent = "";
                                }

                                initializeElements() {
                                    this.titleEl = document.getElementById('bookTitle');
                                    this.pageContentEl = document.getElementById('pageContent');
                                    this.pageDateEl = document.getElementById('pageDate');
                                    this.pageNumberEl = document.getElementById('pageNumber');
                                    this.favoriteBtn = document.getElementById('favoriteHeart');
                                }

                                attachEventListeners() {
                                    const prevBtn = document.getElementById('prevPage');
                                    const nextBtn = document.getElementById('nextPage');

                                    if (prevBtn) prevBtn.addEventListener('click', () => this.previousPage());
                                    if (nextBtn) nextBtn.addEventListener('click', () => this.nextPage());

                                    document.addEventListener('keydown', (e) => {
                                        if (e.key === 'ArrowLeft') this.previousPage();
                                        if (e.key === 'ArrowRight') this.nextPage();
                                    });

                                    if (this.favoriteBtn) {
                                        this.favoriteBtn.addEventListener('click', () => this.toggleFavorite());
                                    }
                                }

                                loadPage(index) {
                                    if (index < 0 || index >= this.entries.length) return;
                                    this.currentPageIndex = index;
                                    const entry = this.entries[index];

                                    // Parse content (format: Author: Message |DECORATIONS|JSON)
                                    let author = "Anonymous";
                                    let message = entry.content;
                                    let decorationsHtml = "";

                                    if (message.includes(': ')) {
                                        const parts = message.split(': ');
                                        author = parts[0];
                                        message = parts.slice(1).join(': ');
                                    }

                                    if (message.includes(' |DECORATIONS|')) {
                                        const parts = message.split(' |DECORATIONS|');
                                        message = parts[0];
                                        try {
                                            const decons = JSON.parse(parts[1]);
                                            decons.forEach(dec => {
                                                decorationsHtml += `<span class="${dec.className}" style="position: absolute; top: ${dec.top}; left: ${dec.left};">${dec.content}</span>`;
                                            });
                                        } catch (e) { }
                                    }

                                    this.pageContentEl.style.opacity = '0';
                                    setTimeout(() => {
                                        this.pageContentEl.innerHTML = `
                                            <div class="message-text">
                                                <p class="main-message">${message}</p>
                                                <div class="decorations">
                                                    ${decorationsHtml}
                                                </div>
                                                <div class="author-name">- ${author}</div>
                                            </div>
                                        `;
                                        this.pageDateEl.textContent = `Written on ${entry.submittedAt}`;
                                        this.pageNumberEl.textContent = `Page ${index + 1} of ${this.entries.length}`;
                                        this.pageContentEl.style.opacity = '1';
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
                                    const bookId = this.currentAutographId;
                                    if (this.favorites.has(bookId)) {
                                        this.favorites.delete(bookId);
                                        this.favoriteBtn.classList.remove('favorited');
                                    } else {
                                        this.favorites.add(bookId);
                                        this.favoriteBtn.classList.add('favorited');
                                    }
                                }
                            }

                            // Initialize when DOM is ready
                            document.addEventListener('DOMContentLoaded', () => {
                                new AutographViewer();

                                // Delete button functionality
                                const deleteBtn = document.getElementById('deleteBtn');
                                const deleteForm = document.getElementById('deleteAutographForm');
                                const autographIdInput = document.getElementById('autographIdInput');

                                if (deleteBtn && deleteForm && autographIdInput) {
                                    deleteBtn.addEventListener('click', function (event) {
                                        event.preventDefault(); // Prevent default button action
                                        const confirmDelete = confirm('Are you sure you want to delete this autograph book? This action cannot be undone.');
                                        if (confirmDelete) {
                                            // Submit the hidden form
                                            deleteForm.submit();
                                        }
                                    });
                                }
                            });
                        </script>
                    </body>

                    </html>