<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Autographs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/autographcontent.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<jsp:include page="../public/header2.jsp" />

<div class="page-wrapper">
    <main class="main-content">

        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Autographs</h1>
            <p class="page-subtitle">Share your book with friends and collect heartfelt messages.</p>
        </div>

        <!-- Search Bar -->
        <div class="search-filters">
            <div class="autographs-search-container">
                <button class="autographs-search-btn" id="autographsSearchBtn">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                </button>
            </div>
        </div>

        <!-- Autographs Grid -->
        <div class="autographs-grid" id="autographsGrid">

            <div class="autograph-card" data-title="Junior School 2015">
                <div class="autograph-image" style="background-image: url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800')"></div>
                <div class="autograph-content">
                    <h3 class="autograph-title">Junior School 2015</h3>
                    <p class="autograph-date">July 15, 2015</p>
                    <div class="autograph-meta">
                        <span class="autograph-count">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            24 signatures
                        </span>
                    </div>
                </div>
            </div>

            <div class="autograph-card" data-title="Cool Gang">
                <div class="autograph-image" style="background-image: url('https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800')"></div>
                <div class="autograph-content">
                    <h3 class="autograph-title">Cool Gang</h3>
                    <p class="autograph-date">June 18, 2016</p>
                    <div class="autograph-meta">
                        <span class="autograph-count">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            12 signatures
                        </span>
                    </div>
                </div>
            </div>

            <div class="autograph-card" data-title="High School 2020">
                <div class="autograph-image" style="background-image: url('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=800')"></div>
                <div class="autograph-content">
                    <h3 class="autograph-title">High School 2020</h3>
                    <p class="autograph-date">July 01, 2020</p>
                    <div class="autograph-meta">
                        <span class="autograph-count">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            35 signatures
                        </span>
                    </div>
                </div>
            </div>

            <div class="autograph-card" data-title="Sunday School 2022">
                <div class="autograph-image" style="background-image: url('https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800')"></div>
                <div class="autograph-content">
                    <h3 class="autograph-title">Sunday School 2022</h3>
                    <p class="autograph-date">September 09, 2022</p>
                    <div class="autograph-meta">
                        <span class="autograph-count">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            18 signatures
                        </span>
                    </div>
                </div>
            </div>

            <div class="autograph-card" data-title="US">
                <div class="autograph-image" style="background-image: url('https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800')"></div>
                <div class="autograph-content">
                    <h3 class="autograph-title">US</h3>
                    <p class="autograph-date">July 10, 2023</p>
                    <div class="autograph-meta">
                        <span class="autograph-count">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            8 signatures
                        </span>
                    </div>
                </div>
            </div>

            <div class="autograph-card" data-title="Interact Club">
                <div class="autograph-image" style="background-image: url('https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=800')"></div>
                <div class="autograph-content">
                    <h3 class="autograph-title">Interact Club</h3>
                    <p class="autograph-date">July 15, 2024</p>
                    <div class="autograph-meta">
                        <span class="autograph-count">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            42 signatures
                        </span>
                    </div>
                </div>
            </div>

            <div class="autograph-card" data-title="University 2025">
                <div class="autograph-image" style="background-image: url('https://images.unsplash.com/photo-1523580846011-d3a5bc25702b?w=800')"></div>
                <div class="autograph-content">
                    <h3 class="autograph-title">University 2025</h3>
                    <p class="autograph-date">October 05, 2025</p>
                    <div class="autograph-meta">
                        <span class="autograph-count">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            15 signatures
                        </span>
                    </div>
                </div>
            </div>

        </div>

    </main>

    <aside class="sidebar">

        <!-- Recent Activity Section -->
        <div class="sidebar-section">
            <h3 class="sidebar-title">Recent Activity</h3>
            <div class="activity-list">

                <div class="activity-item">
                    <div class="activity-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <span>SA</span>
                    </div>
                    <div class="activity-info">
                        <p class="activity-text"><strong>Sarah</strong> wrote in University 2025</p>
                        <span class="activity-time">2 hours ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <span>MK</span>
                    </div>
                    <div class="activity-info">
                        <p class="activity-text"><strong>Mark</strong> signed Interact Club</p>
                        <span class="activity-time">5 hours ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
                        <span>EM</span>
                    </div>
                    <div class="activity-info">
                        <p class="activity-text"><strong>Emily</strong> wrote in High School 2020</p>
                        <span class="activity-time">1 day ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar" style="background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);">
                        <span>JD</span>
                    </div>
                    <div class="activity-info">
                        <p class="activity-text"><strong>John</strong> signed Cool Gang</p>
                        <span class="activity-time">2 days ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar" style="background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);">
                        <span>LW</span>
                    </div>
                    <div class="activity-info">
                        <p class="activity-text"><strong>Lisa</strong> wrote in Sunday School 2022</p>
                        <span class="activity-time">3 days ago</span>
                    </div>
                </div>

            </div>
        </div>

        <!-- Floating Action Button -->
        <div class="floating-buttons" id="floatingButtons">
            <a href="/addautograph" class="floating-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Add a Book
            </a>
        </div>

    </aside>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {

        // Handle floating buttons position on scroll
        function handleFloatingButtons() {
            const footer = document.querySelector('footer');
            const floatingButtons = document.getElementById('floatingButtons');

            if (!footer || !floatingButtons) return;

            const footerRect = footer.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            const buttonHeight = floatingButtons.offsetHeight;

            // When footer enters viewport from bottom
            if (footerRect.top < windowHeight - buttonHeight - 40) {
                // Stop buttons above footer
                const stopPosition = footer.offsetTop - buttonHeight - 40;
                floatingButtons.style.position = 'absolute';
                floatingButtons.style.bottom = 'auto';
                floatingButtons.style.top = stopPosition + 'px';
            } else {
                // Keep buttons fixed at bottom
                floatingButtons.style.position = 'fixed';
                floatingButtons.style.bottom = '40px';
                floatingButtons.style.top = 'auto';
            }
        }

        window.addEventListener('scroll', handleFloatingButtons);
        window.addEventListener('resize', handleFloatingButtons);
        handleFloatingButtons();

        // Modern Search Functionality
        const autographsSearchBtn = document.getElementById('autographsSearchBtn');

        if (autographsSearchBtn) {
            autographsSearchBtn.addEventListener('click', function(event) {
                event.stopPropagation();

                const searchBtnElement = this;
                const searchContainer = searchBtnElement.parentElement;

                const searchBox = document.createElement('div');
                searchBox.className = 'autographs-search-expanded';
                searchBox.innerHTML = `
                    <div class="autographs-search-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    </div>
                    <input type="text" id="searchInput" placeholder="Search autograph books..." autofocus>
                    <button class="autographs-search-close">
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
                    newSearchBtn.className = 'autographs-search-btn';
                    newSearchBtn.id = 'autographsSearchBtn';
                    newSearchBtn.innerHTML = `
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    `;
                    searchContainer.replaceChild(newSearchBtn, searchBox);
                    newSearchBtn.addEventListener('click', arguments.callee);
                };

                searchBox.querySelector('.autographs-search-close').addEventListener('click', closeSearch);

                input.addEventListener('blur', function() {
                    setTimeout(() => {
                        if (!document.activeElement.closest('.autographs-search-expanded')) {
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
                    const autographCards = document.querySelectorAll('.autograph-card');
                    autographCards.forEach(card => {
                        const title = card.getAttribute('data-title')?.toLowerCase() || '';
                        card.style.display = title.includes(query) ? 'block' : 'none';
                    });
                });
            });
        }

        // Autograph card click handlers
        const autographCards = document.querySelectorAll('.autograph-card');
        autographCards.forEach(card => {
            card.addEventListener('click', function() {
                console.log('Autograph book clicked:', this.querySelector('.autograph-title').textContent);
                // Redirect to autograph detail page
                window.location.href = '/autographview';
            });
        });

        // Activity item interactions
        const activityItems = document.querySelectorAll('.activity-item');
        activityItems.forEach(item => {
            item.addEventListener('click', function() {
                activityItems.forEach(i => i.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

    });
</script>

</body>
</html>