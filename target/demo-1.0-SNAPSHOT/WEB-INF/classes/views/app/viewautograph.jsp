<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/autographviewer.css">
</head>
<body>

<div class="autograph-viewer-wrapper">
    <div class="autograph-viewer-container">
        <!-- Navigation Header -->
        <div class="viewer-header">
            <button class="nav-btn prev-book" id="prevBook">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Previous
            </button>
            <h1 class="book-title" id="bookTitle">University 2025</h1>
            <button class="nav-btn next-book" id="nextBook">
                Next
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
        </div>

        <!-- Page Viewer -->
        <div class="page-viewer">
            <button class="arrow-btn left-arrow" id="prevPage">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
            </button>

            <div class="page-container" id="pageContainer">
                <!-- Autograph Page Content -->
                <div class="autograph-page">
                    <!-- Favorite Heart -->
                    <button class="favorite-heart" id="favoriteHeart">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
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
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
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

<jsp:include page="../public/footer.jsp" />

<script>
    // Autograph Viewer Application
    class AutographViewer {
        constructor() {
            this.books = this.getBooks();
            this.currentBookIndex = 0;
            this.currentPageIndex = 0;
            this.favorites = new Set();

            this.initializeElements();
            this.attachEventListeners();
            this.loadBook(this.currentBookIndex);
        }

        getBooks() {
            return [
                {
                    id: 1,
                    title: "University 2025",
                    date: "October 2025",
                    pages: [
                        {
                            author: "Sarah",
                            date: "October 5, 2025",
                            content: `
                                <div class="message-text">
                                    <p class="main-message">Hey bestie! 💜</p>
                                    <p>I can't believe we're graduating! These past four years have been absolutely incredible. From late-night study sessions to spontaneous road trips, every moment with you has been special.</p>
                                    <p>Thank you for being my partner in crime and always having my back. Here's to our amazing future! 🎓✨</p>
                                </div>
                                <div class="decorations">
                                    <span class="emoji" style="top: 20%; left: 10%;">🌟</span>
                                    <span class="emoji" style="top: 40%; right: 15%;">💫</span>
                                    <span class="doodle heart" style="bottom: 25%; left: 15%;">♡</span>
                                </div>
                                <div class="author-name">- Sarah</div>
                            `
                        },
                        {
                            author: "Michael",
                            date: "October 6, 2025",
                            content: `
                                <div class="message-text">
                                    <p class="main-message">To my favorite study buddy! 📚</p>
                                    <p>Remember that time we pulled an all-nighter before finals and survived on coffee and determination? Those memories will stay with me forever!</p>
                                    <p>You're going to do amazing things. Keep being awesome! 🚀</p>
                                </div>
                                <div class="decorations">
                                    <span class="emoji" style="top: 15%; right: 10%;">☕</span>
                                    <span class="emoji" style="bottom: 30%; left: 12%;">📖</span>
                                    <span class="doodle star" style="top: 35%; right: 20%;">★</span>
                                    <span class="doodle star" style="bottom: 20%; right: 15%;">★</span>
                                </div>
                                <div class="small-photo" style="bottom: 80px; right: 40px;">
                                    <div style="width: 80px; height: 80px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">US</div>
                                </div>
                                <div class="author-name">- Michael</div>
                            `
                        },
                        {
                            author: "Emma",
                            date: "October 8, 2025",
                            content: `
                                <div class="message-text">
                                    <p class="main-message">You're simply the best! 🌈</p>
                                    <p>Thank you for being such an amazing friend and making university life so much fun. From our coffee runs to our late-night talks, every moment has been precious.</p>
                                    <p>Stay awesome and keep shining! ✨ Can't wait to see where life takes you!</p>
                                </div>
                                <div class="decorations">
                                    <span class="emoji" style="top: 25%; left: 8%;">🎨</span>
                                    <span class="emoji" style="top: 50%; right: 10%;">🌸</span>
                                    <span class="doodle heart" style="bottom: 35%; right: 18%;">♡</span>
                                    <span class="doodle heart" style="top: 40%; left: 12%;">♡</span>
                                </div>
                                <div class="author-name">- Emma</div>
                            `
                        },
                        {
                            author: "David",
                            date: "October 10, 2025",
                            content: `
                                <div class="message-text">
                                    <p class="main-message">What a journey! 🎉</p>
                                    <p>From confused freshmen to graduating seniors - we made it! Your friendship has meant the world to me. Thanks for all the laughs, support, and unforgettable memories.</p>
                                    <p>Here's to staying friends forever! Cheers to new beginnings! 🥂</p>
                                </div>
                                <div class="decorations">
                                    <span class="emoji" style="top: 18%; right: 12%;">🎓</span>
                                    <span class="emoji" style="bottom: 25%; left: 10%;">🎊</span>
                                    <span class="doodle star" style="top: 45%; left: 15%;">★</span>
                                </div>
                                <div class="small-photo" style="top: 120px; left: 40px;">
                                    <div style="width: 70px; height: 70px; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">👥</div>
                                </div>
                                <div class="author-name">- David</div>
                            `
                        }
                    ]
                },
                {
                    id: 2,
                    title: "High School 2020",
                    date: "July 2020",
                    pages: [
                        {
                            author: "Jessica",
                            date: "July 1, 2020",
                            content: `
                                <div class="message-text">
                                    <p class="main-message">Never forget our crazy adventures! 🌟</p>
                                    <p>From science projects to lunch breaks, you made high school bearable! Thanks for being there through thick and thin. You're truly one of a kind!</p>
                                    <p>Stay wild, stay wonderful! 💕</p>
                                </div>
                                <div class="decorations">
                                    <span class="emoji" style="top: 20%; right: 15%;">🎒</span>
                                    <span class="emoji" style="bottom: 30%; left: 10%;">🌈</span>
                                    <span class="doodle heart" style="top: 45%; right: 12%;">♡</span>
                                </div>
                                <div class="author-name">- Jessica</div>
                            `
                        },
                        {
                            author: "Ryan",
                            date: "July 3, 2020",
                            content: `
                                <div class="message-text">
                                    <p class="main-message">BFF Forever! 🤝</p>
                                    <p>Man, we've been through so much together! From failing math quizzes to winning the basketball championship - what a ride!</p>
                                    <p>Keep being awesome dude! Let's stay in touch! 🏀</p>
                                </div>
                                <div class="decorations">
                                    <span class="emoji" style="top: 25%; left: 12%;">⚡</span>
                                    <span class="emoji" style="bottom: 35%; right: 15%;">🎯</span>
                                    <span class="doodle star" style="top: 50%; right: 10%;">★</span>
                                </div>
                                <div class="author-name">- Ryan</div>
                            `
                        },
                        {
                            author: "Mia",
                            date: "July 5, 2020",
                            content: `
                                <div class="message-text">
                                    <p class="main-message">You're my sunshine! ☀️</p>
                                    <p>Thanks for making every day brighter with your smile. Our friendship means everything to me. I'll miss our daily chats and lunch table gossips!</p>
                                    <p>Promise we'll stay friends forever! 💛✨</p>
                                </div>
                                <div class="decorations">
                                    <span class="emoji" style="top: 18%; right: 10%;">🌻</span>
                                    <span class="emoji" style="bottom: 25%; left: 8%;">🦋</span>
                                    <span class="doodle heart" style="top: 40%; left: 15%;">♡</span>
                                    <span class="doodle heart" style="bottom: 30%; right: 18%;">♡</span>
                                </div>
                                <div class="small-photo" style="bottom: 90px; right: 35px;">
                                    <div style="width: 75px; height: 75px; background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-size: 24px;">💕</div>
                                </div>
                                <div class="author-name">- Mia</div>
                            `
                        },
                        {
                            author: "Alex",
                            date: "July 8, 2020",
                            content: `
                                <div class="message-text">
                                    <p class="main-message">Thanks for everything! 🙏</p>
                                    <p>You've been an amazing friend through all these years. From group projects to school events, you always had my back. High school wouldn't have been the same without you!</p>
                                    <p>Good luck with everything! 🍀</p>
                                </div>
                                <div class="decorations">
                                    <span class="emoji" style="top: 22%; left: 10%;">🎵</span>
                                    <span class="emoji" style="bottom: 28%; right: 12%;">🎸</span>
                                    <span class="doodle star" style="top: 48%; right: 15%;">★</span>
                                </div>
                                <div class="author-name">- Alex</div>
                            `
                        }
                    ]
                }
            ];
        }

        initializeElements() {
            this.titleEl = document.getElementById('bookTitle');
            this.pageContentEl = document.getElementById('pageContent');
            this.pageDateEl = document.getElementById('pageDate');
            this.pageNumberEl = document.getElementById('pageNumber');
            this.favoriteBtn = document.getElementById('favoriteHeart');
        }

        attachEventListeners() {
            // Book navigation
            document.getElementById('prevBook').addEventListener('click', () => this.previousBook());
            document.getElementById('nextBook').addEventListener('click', () => this.nextBook());

            // Page navigation
            document.getElementById('prevPage').addEventListener('click', () => this.previousPage());
            document.getElementById('nextPage').addEventListener('click', () => this.nextPage());

            // Keyboard navigation
            document.addEventListener('keydown', (e) => {
                if (e.key === 'ArrowLeft') this.previousPage();
                if (e.key === 'ArrowRight') this.nextPage();
            });

            // Favorite button
            this.favoriteBtn.addEventListener('click', () => this.toggleFavorite());
        }

        loadBook(index) {
            if (index < 0 || index >= this.books.length) return;

            this.currentBookIndex = index;
            this.currentPageIndex = 0;
            const book = this.books[index];

            this.titleEl.textContent = book.title;
            this.titleEl.style.animation = 'fadeInUp 0.5s ease';

            this.updateFavoriteButton();
            this.loadPage(0);
        }

        loadPage(index) {
            const book = this.books[this.currentBookIndex];
            if (index < 0 || index >= book.pages.length) return;

            this.currentPageIndex = index;
            const page = book.pages[index];

            // Add fade effect
            this.pageContentEl.style.opacity = '0';

            setTimeout(() => {
                this.pageContentEl.innerHTML = page.content;
                this.pageDateEl.textContent = `Written on ${page.date}`;
                this.pageNumberEl.textContent = `Page ${index + 1} of ${book.pages.length}`;

                // Fade in
                this.pageContentEl.style.opacity = '1';
            }, 300);
        }

        previousBook() {
            if (this.currentBookIndex > 0) {
                this.loadBook(this.currentBookIndex - 1);
            }
        }

        nextBook() {
            if (this.currentBookIndex < this.books.length - 1) {
                this.loadBook(this.currentBookIndex + 1);
            }
        }

        previousPage() {
            const book = this.books[this.currentBookIndex];
            if (this.currentPageIndex > 0) {
                this.loadPage(this.currentPageIndex - 1);
            }
        }

        nextPage() {
            const book = this.books[this.currentBookIndex];
            if (this.currentPageIndex < book.pages.length - 1) {
                this.loadPage(this.currentPageIndex + 1);
            }
        }

        toggleFavorite() {
            const bookId = this.books[this.currentBookIndex].id;

            if (this.favorites.has(bookId)) {
                this.favorites.delete(bookId);
            } else {
                this.favorites.add(bookId);
            }

            this.updateFavoriteButton();
        }

        updateFavoriteButton() {
            const bookId = this.books[this.currentBookIndex].id;

            if (this.favorites.has(bookId)) {
                this.favoriteBtn.classList.add('favorited');
            } else {
                this.favoriteBtn.classList.remove('favorited');
            }
        }
    }

    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', () => {
        new AutographViewer();
    });
</script>

</body>
</html>