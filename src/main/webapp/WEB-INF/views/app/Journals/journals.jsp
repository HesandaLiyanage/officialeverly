<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty streakDays}"><c:set var="streakDays" value="0" /></c:if>
<c:if test="${empty longestStreak}"><c:set var="longestStreak" value="0" /></c:if>
<c:if test="${empty totalCount}"><c:set var="totalCount" value="0" /></c:if>

<jsp:include page="/WEB-INF/views/public/header2.jsp" />
<html>

<body>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/journal.css">
    <!-- Wrap everything after header -->
    <div class="page-wrapper">
        <main class="main-content">
            <!-- Page Title -->
            <div class="tab-nav">
                <div class="page-title">Journals
                    <p class="page-subtitle">Capture your daily thoughts and special moments.</p>
                </div>
            </div>
            <!-- Search and Filters -->
            <div class="search-filters" style="margin-top: 10px; margin-bottom: 15px;">
                <div class="journals-search-container">
                    <button class="journals-search-btn" id="journalsSearchBtn">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                            stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    </button>
                </div>
                <button class="filter-btn" id="dateSort">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <polyline points="19 12 12 19 5 12"></polyline>
                    </svg>
                    Sort: Date
                </button>
            </div>
            <%-- Display Error Message --%>
            <c:if test="${not empty error}">
                <div class="alert alert-error"
                    style="background: #fee; border: 1px solid #fcc; padding: 12px; border-radius: 8px; margin-bottom: 20px; color: #c00;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    ${fn:escapeXml(error)}
                </div>
            </c:if>
            <!-- All Journals Grid -->
            <div class="journals-grid" id="allJournalsGrid"
                style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
                <c:choose>
                    <c:when test="${empty journals}">
                        <div style="text-align: center; padding: 40px; color: #6b7280;">
                            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="1.5" style="margin: 0 auto 20px; opacity: 0.5;">
                                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                            </svg>
                            <h3 style="margin: 0 0 10px; color: #374151;">No Journal Entries Yet</h3>
                            <p style="margin: 0;">Start documenting your thoughts and experiences!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${journals}" var="journal">
                            <c:set var="wc" value="${wordCounts[journal.journalId]}" />
                            <div class="journal-card" data-title="${fn:escapeXml(journal.title)}"
                                data-journal-id="${journal.journalId}">
                                <!-- Placeholder for image - using a default icon -->
                                <div class="journal-image-placeholder">
                                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF"
                                        stroke-width="1.5">
                                        <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z">
                                        </path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                        <polyline points="10 9 9 9 8 9"></polyline>
                                    </svg>
                                </div>
                                <div class="journal-content">
                                    <h3 class="journal-title">${fn:escapeXml(journal.title)}</h3>
                                    <div class="journal-meta">
                                        <span class="journal-date">Journal entry</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${wc > 0}">
                                            <p style="font-size: 0.8rem; color: #9A74D8; margin-top: 8px; font-weight: 600;">
                                                ${wc} word${wc != 1 ? 's' : ''} &middot; Tap to read
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p style="font-size: 0.8rem; color: #9ca3af; margin-top: 8px; font-style: italic;">
                                                Empty entry &middot; Tap to view
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        <aside class="sidebar">
            <!-- Streak Section -->
            <div class="sidebar-section streak-section">
                <h3 class="sidebar-title">Streak &#x1F525;</h3>
                <div class="streak-container">
                    <div class="streak-icon">&#x1F525;</div>
                    <div class="streak-info">
                        <p class="streak-label">Journal</p>
                        <p class="streak-days">
                            ${streakDays} ${streakDays == 1 ? 'day' : 'days'}
                        </p>
                    </div>
                </div>
            </div>
            <!-- Journal Stats Section -->
            <div class="sidebar-section">
                <h3 class="sidebar-title">Statistics</h3>
                <ul class="favourites-list">
                    <li class="favourite-item">
                        <div class="favourite-icon">&#x1F4DD;</div>
                        <div class="favourite-info">
                            <span class="favourite-name">Total Entries</span>
                            <span class="favourite-days">${totalCount}</span>
                        </div>
                    </li>
                    <li class="favourite-item">
                        <div class="favourite-icon">&#x1F4C5;</div>
                        <div class="favourite-info">
                            <span class="favourite-name">This Month</span>
                            <span class="favourite-days">-</span>
                        </div>
                    </li>
                </ul>
            </div>
            <!-- Floating Action Buttons - Now static below sidebar -->
            <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
                <a href="/writejournal" class="floating-btn">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    Add Journal Entry
                </a>
                <a href="/vaultentries" class="floating-btn vault-btn">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    Vault
                </a>
            </div>
        </aside>
    </div>
    <jsp:include page="/WEB-INF/views/public/footer.jsp" />
    <script>
        // Modern Search Functionality for Journals Page
        document.addEventListener('DOMContentLoaded', function () {
            const journalsSearchBtn = document.getElementById('journalsSearchBtn');
            if (journalsSearchBtn) {
                journalsSearchBtn.addEventListener('click', function (event) {
                    event.stopPropagation();
                    const searchBtnElement = this;
                    const searchContainer = searchBtnElement.parentElement;
                    const searchBox = document.createElement('div');
                    searchBox.className = 'journals-search-expanded';
                    searchBox.innerHTML = `
          <div class="journals-search-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          </div>
          <input type="text" id="searchInput" placeholder="Search journals..." autofocus>
          <button class="journals-search-close">
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
                        newSearchBtn.className = 'journals-search-btn';
                        newSearchBtn.id = 'journalsSearchBtn';
                        newSearchBtn.innerHTML = `
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          `;
                        searchContainer.replaceChild(newSearchBtn, searchBox);
                        newSearchBtn.addEventListener('click', arguments.callee);
                    };
                    searchBox.querySelector('.journals-search-close').addEventListener('click', closeSearch);
                    input.addEventListener('blur', function () {
                        setTimeout(() => {
                            if (!document.activeElement.closest('.journals-search-expanded')) {
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
                        const journalCards = document.querySelectorAll('.journal-card');
                        journalCards.forEach(card => {
                            const title = card.getAttribute('data-title')?.toLowerCase() || '';
                            const matches = title.includes(query);
                            card.style.display = matches ? 'block' : 'none';
                        });
                    });
                });
            }
            // Filter button handlers
            const dateSort = document.getElementById('dateSort');
            if (dateSort) {
                dateSort.addEventListener('click', function () {
                    console.log('Sort by date clicked');
                });
            }
            // Journal card click handlers - redirect to journal view
            const journalCards = document.querySelectorAll('.journal-card');
            journalCards.forEach(card => {
                card.style.cursor = 'pointer';
                card.addEventListener('click', function () {
                    const journalId = this.getAttribute('data-journal-id');
                    if (journalId) {
                        console.log('Navigating to journal:', journalId);
                        window.location.href = '${pageContext.request.contextPath}/journalview?id=' + journalId;
                    }
                });
            });
        });
    </script>
</body>

</html>
