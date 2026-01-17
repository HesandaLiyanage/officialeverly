<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.AutographEntry" %>
        <%@ page import="java.util.List" %>
            <jsp:include page="../../public/header2.jsp" />
            <% List<AutographEntry> entries = (List<AutographEntry>) request.getAttribute("entries");
                    %>
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
                                        <div class="autograph-page">
                                            <button class="favorite-heart" id="favoriteHeart">
                                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <path
                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                    </path>
                                                </svg>
                                            </button>
                                            <div class="page-content" id="pageContent">
                                                <!-- Content will be dynamically loaded -->
                                            </div>
                                            <div class="page-number" id="pageNumber">Page 1 of 1</div>
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
                                <div class="page-info" style="display: none;">
                                    <p class="page-date" id="pageDate">Written on October 5, 2025</p>
                                </div>
                            </div>
                        </div>

                        <form id="deleteAutographForm" action="${pageContext.request.contextPath}/deleteautograph"
                            method="post" style="display: none;">
                            <input type="hidden" name="autographId" id="autographIdInput"
                                value="${autograph.autographId}">
                        </form>

                        <div class="floating-buttons">
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
                            class AutographViewer {
                                constructor() {
                                    this.currentAutographId = ${ autograph.autographId };
                                    this.currentAutographTitle = '${autograph.title}';

                                    this.books = this.getBooks();
                                    this.currentBookIndex = 0;
                                    this.currentPageIndex = 0;
                                    this.favorites = new Set();
                                    this.initializeElements();
                                    this.attachEventListeners();
                                    this.loadBook(this.currentBookIndex);
                                }

                                initializeElements() {
                                    this.titleEl = document.getElementById('bookTitle');
                                    this.pageContentEl = document.getElementById('pageContent');
                                    this.pageDateEl = document.getElementById('pageDate');
                                    this.pageNumberEl = document.getElementById('pageNumber');
                                    this.favoriteBtn = document.getElementById('favoriteHeart');
                                }

                                attachEventListeners() {
                                    document.getElementById('prevBook').addEventListener('click', () => this.previousBook());
                                    document.getElementById('nextBook').addEventListener('click', () => this.nextBook());
                                    document.getElementById('prevPage').addEventListener('click', () => this.previousPage());
                                    document.getElementById('nextPage').addEventListener('click', () => this.nextPage());
                                    document.addEventListener('keydown', (e) => {
                                        if (e.key === 'ArrowLeft') this.previousPage();
                                        if (e.key === 'ArrowRight') this.nextPage();
                                    });
                                    this.favoriteBtn.addEventListener('click', () => this.toggleFavorite());
                                }

                                getBooks() {
                                    const pages = [];
            <% 
            if (entries != null) {
                                        for (AutographEntry entry : entries) {
                    String content = entry.getContent();
                    String author = "Anonymous";
                    String message = content;
                                            if (content != null && content.contains(": ")) {
                        int index = content.indexOf(": ");
                                                author = content.substring(0, index);
                                                message = content.substring(index + 2);
                                            }
            %>
                                                pages.push({
                                                    author: "<%= author.replace("\"", "\\\"").replace("\n", " ") %> ",
                                            date: "<%= entry.getSubmittedAt() != null ? entry.getSubmittedAt().toString().substring(0, 10) : "Unknown Date" %>",
                                                message: `<%= message.replace("`", "\\`").replace("$", "\\$") %>`,
                                                    decorations: <%= entry.getDecorations() != null && !entry.getDecorations().isEmpty() ? entry.getDecorations() : "[]" %>
            });
            <% 
                }
                                } 
            %>

            if (pages.length === 0) {
                                pages.push({
                                    author: "System",
                                    date: "",
                                    message: "No entries yet. Share your link to get some!",
                                    decorations: []
                                });
                            }

                            return [
                                {
                                    id: this.currentAutographId,
                                    title: this.currentAutographTitle,
                                    pages: pages
                                }
                            ];
        }

                            loadBook(index) {
                                if (index < 0 || index >= this.books.length) return;
                                this.currentBookIndex = index;
                                this.currentPageIndex = 0;
                                const book = this.books[index];
                                this.titleEl.textContent = book.title;
                                this.updateFavoriteButton();
                                this.loadPage(0);
                            }

                            loadPage(index) {
                                const book = this.books[this.currentBookIndex];
                                if (index < 0 || index >= book.pages.length) return;
                                this.currentPageIndex = index;
                                const page = book.pages[index];

                                this.pageContentEl.style.opacity = '0';
                                setTimeout(() => {
                                    let html = `
                    <div class="message-text">
                        <div class="main-message">${page.message}</div>
                    </div>
                    <div class="decorations-container" style="position: absolute; top:0; left:0; width:100%; height:100%; pointer-events: none;">
                `;

                                    if (page.decorations && Array.isArray(page.decorations)) {
                                        page.decorations.forEach(dec => {
                                            html += `<span class="${dec.className}" style="position: absolute; top: ${dec.top}; left: ${dec.left};">${dec.content}</span>`;
                                        });
                                    }

                                    html += `</div><div class="author-name">- ${page.author}</div>`;

                                    this.pageContentEl.innerHTML = html;
                                    this.pageDateEl.textContent = page.date ? `Written on ${page.date}` : "";
                                    this.pageNumberEl.textContent = `Page ${index + 1} of ${book.pages.length}`;
                                    this.pageContentEl.style.opacity = '1';
                                }, 300);
                            }

                            previousBook() {
                                if (this.currentBookIndex > 0) this.loadBook(this.currentBookIndex - 1);
                            }

                            nextBook() {
                                if (this.currentBookIndex < this.books.length - 1) this.loadBook(this.currentBookIndex + 1);
                            }

                            previousPage() {
                                if (this.currentPageIndex > 0) this.loadPage(this.currentPageIndex - 1);
                            }

                            nextPage() {
                                const book = this.books[this.currentBookIndex];
                                if (this.currentPageIndex < book.pages.length - 1) this.loadPage(this.currentPageIndex + 1);
                            }

                            toggleFavorite() {
                                const bookId = this.books[this.currentBookIndex].id;
                                if (this.favorites.has(bookId)) this.favorites.delete(bookId);
                                else this.favorites.add(bookId);
                                this.updateFavoriteButton();
                            }

                            updateFavoriteButton() {
                                const bookId = this.books[this.currentBookIndex].id;
                                if (this.favorites.has(bookId)) this.favoriteBtn.classList.add('favorited');
                                else this.favoriteBtn.classList.remove('favorited');
                            }
    }

                            document.addEventListener('DOMContentLoaded', () => {
                                new AutographViewer();

                                const deleteBtn = document.getElementById('deleteBtn');
                                const deleteForm = document.getElementById('deleteAutographForm');

                                if (deleteBtn && deleteForm) {
                                    deleteBtn.addEventListener('click', function (event) {
                                        event.preventDefault();
                                        const confirmDelete = confirm('Are you sure you want to delete this autograph book? This action cannot be undone.');
                                        if (confirmDelete) {
                                            deleteForm.submit();
                                        }
                                    });
                                }
                            });
                        </script>
                    </body>

                    </html>