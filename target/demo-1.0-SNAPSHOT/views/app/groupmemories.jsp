<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
</head>
<script>
    // Group Search Functionality
    document.addEventListener('DOMContentLoaded', function() {
        const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');

        if (memoriesSearchBtn) {
            memoriesSearchBtn.addEventListener('click', function(event) {
                event.stopPropagation();

                const searchBtnElement = this;
                const searchContainer = searchBtnElement.parentElement;

                const searchBox = document.createElement('div');
                searchBox.className = 'memories-search-expanded';
                searchBox.innerHTML = `
                <div class="memories-search-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                </div>
                <input type="text" id="searchInput" placeholder="Search memories..." autofocus>
                <button class="memories-search-close">
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
                    newSearchBtn.className = 'memories-search-btn';
                    newSearchBtn.id = 'memoriesSearchBtn';
                    newSearchBtn.innerHTML = `
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                `;
                    searchContainer.replaceChild(newSearchBtn, searchBox);
                    newSearchBtn.addEventListener('click', arguments.callee);
                };

                searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

                input.addEventListener('blur', function() {
                    setTimeout(() => {
                        if (!document.activeElement.closest('.memories-search-expanded')) {
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
                    const memoryCards = document.querySelectorAll('.memory-card');
                    memoryCards.forEach(card => {
                        const title = card.querySelector('.memory-title')?.textContent?.toLowerCase() || '';
                        card.style.display = title.includes(query) ? 'block' : 'none';
                    });
                });
            });
        }
    });

    // Handle floating buttons position on scroll
    document.addEventListener('DOMContentLoaded', function() {
        function handleFloatingButtons() {
            const footer = document.querySelector('footer');
            const floatingButtons = document.getElementById('floatingButtons');

            if (!footer || !floatingButtons) return;

            const footerRect = footer.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            const buttonHeight = floatingButtons.offsetHeight;

            if (footerRect.top < windowHeight - buttonHeight - 40) {
                const stopPosition = footer.offsetTop - buttonHeight - 40;
                floatingButtons.style.position = 'absolute';
                floatingButtons.style.bottom = 'auto';
                floatingButtons.style.top = stopPosition + 'px';
            } else {
                floatingButtons.style.position = 'fixed';
                floatingButtons.style.bottom = '40px';
                floatingButtons.style.top = 'auto';
                floatingButtons.style.right = '40px';
            }
        }

        window.addEventListener('scroll', handleFloatingButtons);
        window.addEventListener('resize', handleFloatingButtons);
        handleFloatingButtons();
    });
</script>
<body>

<!-- Page Wrapper -->
<div class="page-wrapper">
    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="group-name">Family Memories</h1>
            <p class="group-creator">Created by You</p>
        </div>

        <!-- Tab Navigation -->
        <div class="tab-nav">
            <a href="${pageContext.request.contextPath}/groupmemories?groupId=1" class="tab-link active">Memories</a>
            <a href="${pageContext.request.contextPath}/groupannouncement?groupId=1" class="tab-link">Announcements</a>
            <a href="${pageContext.request.contextPath}/groupmembers?groupId=1" class="tab-link">Members</a>
        </div>

        <!-- Search and Filters -->
        <div class="search-filters">
            <div class="memories-search-container">
                <button class="memories-search-btn" id="memoriesSearchBtn">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                </button>
            </div>
            <button class="filter-btn" id="dateFilter">Date</button>
            <button class="filter-btn" id="locationFilter">Location</button>
        </div>

        <!-- Memories Grid -->
        <div class="memories-grid" id="memoriesGrid">
            <a href="${pageContext.request.contextPath}/memoryview?memoryId=1" class="memory-card">
                <div class="memory-image summer-beach"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Summer Beach Trip</h3>
                    <p class="memory-date">June 15, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=2" class="memory-card">
                <div class="memory-image holiday-dinner"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Holiday Dinner</h3>
                    <p class="memory-date">December 24, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=3" class="memory-card">
                <div class="memory-image safe-vacation"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Safe Vacation</h3>
                    <p class="memory-date">August 5, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=4" class="memory-card">
                <div class="memory-image beach-walk"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Beach Walk</h3>
                    <p class="memory-date">July 22, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=5" class="memory-card">
                <div class="memory-image photo-shoot"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Photo Shoot Day</h3>
                    <p class="memory-date">May 10, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=6" class="memory-card">
                <div class="memory-image picnic"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Picnic in Park</h3>
                    <p class="memory-date">September 3, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=7" class="memory-card">
                <div class="memory-image mountain-hike"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Mountain Hike</h3>
                    <p class="memory-date">October 12, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=8" class="memory-card">
                <div class="memory-image reunion"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Grand Reunion</h3>
                    <p class="memory-date">November 1, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=9" class="memory-card">
                <div class="memory-image wedding"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Cousin's Wedding</h3>
                    <p class="memory-date">April 20, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=10" class="memory-card">
                <div class="memory-image road-trip"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Road Trip Adventure</h3>
                    <p class="memory-date">March 8, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=11" class="memory-card">
                <div class="memory-image camping"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Camping Weekend</h3>
                    <p class="memory-date">February 14, 2023</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/memoryview?memoryId=12" class="memory-card">
                <div class="memory-image birthday"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Birthday Celebration</h3>
                    <p class="memory-date">January 18, 2023</p>
                </div>
            </a>
        </div>

        <!-- Floating Add Memory Button -->
        <div class="floating-buttons" id="floatingButtons">
            <a href="${pageContext.request.contextPath}/creatememory?groupId=1" class="floating-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Add Memory
            </a>
        </div>
    </main>
</div>

<jsp:include page="../public/footer.jsp" />

<script src="${pageContext.request.contextPath}/resources/js/groupsearch.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/groupfloating.js"></script>

</body>
</html>