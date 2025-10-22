<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // Simulated Journal Entries
  class Journal {
    String title, date, tag, image;
    Journal(String title, String date, String tag, String image) {
      this.title = title;
      this.date = date;
      this.tag = tag;
      this.image = image;
    }
  }

  List<Journal> journals = new ArrayList<>();
  journals.add(new Journal("July 21st - Birthday party", "July 15, 2024", "#vacation", "https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800"));
  journals.add(new Journal("July 31st", "June 22, 2024", "#travel", "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800"));
  journals.add(new Journal("June 30", "May 10, 2024", "#family", "https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800"));
  journals.add(new Journal("March 20", "April 5, 2024", "#adventure", "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"));
  journals.add(new Journal("March 21st", "March 18, 2024", "#city", "https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800"));
  journals.add(new Journal("Art Exhibition", "February 2, 2024", "#art", "https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=800"));

  List<Journal> allJournals = new ArrayList<>();
  allJournals.add(new Journal("Sunset Beach Walk", "January 20, 2024", "#nature", "https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800"));
  allJournals.add(new Journal("Coffee Morning", "January 15, 2024", "#daily", "https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800"));
  allJournals.add(new Journal("Mountain Peak", "January 10, 2024", "#adventure", "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800"));
  allJournals.add(new Journal("Evening in the City", "January 5, 2024", "#urban", "https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800"));
  allJournals.add(new Journal("Gallery Visit", "December 28, 2023", "#culture", "https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=800"));
  allJournals.add(new Journal("Winter Hike", "December 20, 2023", "#outdoor", "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"));
  allJournals.add(new Journal("Holiday Dinner", "December 15, 2023", "#celebration", "https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800"));
  allJournals.add(new Journal("New Year Eve", "December 31, 2023", "#celebration", "https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800"));

  request.setAttribute("journals", journals);
  request.setAttribute("allJournals", allJournals);
%>

<jsp:include page="../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/journal.css">

<!-- Wrap everything after header -->
<div class="page-wrapper">
  <main class="main-content">
    <!-- Page Title -->
    <h1 class="page-title">Journals</h1>

    <!-- Search and Filters -->
    <div class="search-filters" style="margin-top: 10px; margin-bottom: 15px;">
      <div class="journals-search-container">
        <button class="journals-search-btn" id="journalsSearchBtn">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <path d="m21 21-4.35-4.35"></path>
          </svg>
        </button>
      </div>
      <button class="filter-btn" id="dateSort">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <polyline points="19 12 12 19 5 12"></polyline>
        </svg>
        Sort: Date
      </button>
      <button class="filter-btn" id="tagFilter">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
          <line x1="7" y1="7" x2="7.01" y2="7"></line>
        </svg>
        Filter: Tags
      </button>
    </div>

    <!-- All Journals Grid -->
    <div class="journals-grid" id="allJournalsGrid" style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
      <%
        List<Journal> journalList = (List<Journal>) request.getAttribute("journals");
        if (journalList != null) {
          for (Journal journal : journalList) {
      %>
      <div class="journal-card" data-title="<%= journal.title %>" data-tag="<%= journal.tag %>">
        <div class="journal-image" style="background-image: url('<%= journal.image %>')"></div>
        <div class="journal-content">
          <h3 class="journal-title"><%= journal.title %></h3>
          <div class="journal-meta">
            <span class="journal-date"><%= journal.date %></span>
            <span class="journal-tag"><%= journal.tag %></span>
          </div>
        </div>
      </div>
      <%
          }
        }
      %>
      <%
        List<Journal> allJournalsList = (List<Journal>) request.getAttribute("allJournals");
        if (allJournalsList != null) {
          for (Journal journal : allJournalsList) {
      %>
      <div class="journal-card" data-title="<%= journal.title %>" data-tag="<%= journal.tag %>">
        <div class="journal-image" style="background-image: url('<%= journal.image %>')"></div>
        <div class="journal-content">
          <h3 class="journal-title"><%= journal.title %></h3>
          <div class="journal-meta">
            <span class="journal-date"><%= journal.date %></span>
            <span class="journal-tag"><%= journal.tag %></span>
          </div>
        </div>
      </div>
      <%
          }
        }
      %>
    </div>
  </main>

  <aside class="sidebar">
    <!-- Streak Section -->
    <div class="sidebar-section streak-section">
      <h3 class="sidebar-title">Streak 🔥</h3>
      <div class="streak-container">
        <div class="streak-icon">🔥</div>
        <div class="streak-info">
          <p class="streak-label">Journal</p>
          <p class="streak-days">36 days</p>
        </div>
      </div>
    </div>

    <!-- Milestones Section -->
<%--    <div class="sidebar-section">--%>
<%--      <h3 class="sidebar-title">Milestones</h3>--%>
<%--      <ul class="milestones-list">--%>
<%--        <li class="milestone-item">--%>
<%--          <div class="milestone-icon">📅</div>--%>
<%--          <span class="milestone-name">Two Weeks</span>--%>
<%--        </li>--%>
<%--        <li class="milestone-item">--%>
<%--          <div class="milestone-icon">📅</div>--%>
<%--          <span class="milestone-name">One Month</span>--%>
<%--        </li>--%>
<%--        <li class="milestone-item">--%>
<%--          <div class="milestone-icon">📅</div>--%>
<%--          <span class="milestone-name">Three Months</span>--%>
<%--        </li>--%>
<%--        <li class="milestone-item">--%>
<%--          <div class="milestone-icon">📅</div>--%>
<%--          <span class="milestone-name">Six Months</span>--%>
<%--        </li>--%>
<%--        <li class="milestone-item">--%>
<%--          <div class="milestone-icon">📅</div>--%>
<%--          <span class="milestone-name">One Year</span>--%>
<%--        </li>--%>
<%--      </ul>--%>
<%--    </div>--%>

    <!-- Favourites Section -->
    <div class="sidebar-section">
      <h3 class="sidebar-title">Favourites</h3>
      <ul class="favourites-list">
<%--        <li class="favourite-item">--%>
<%--          <div class="favourite-icon">📘</div>--%>
<%--          <div class="favourite-info">--%>
<%--            <span class="favourite-name">July 6th</span>--%>
<%--            <span class="favourite-days">36 days</span>--%>
<%--          </div>--%>
<%--        </li>--%>
<%--        <li class="favourite-item">--%>
<%--          <div class="favourite-icon">📘</div>--%>
<%--          <div class="favourite-info">--%>
<%--            <span class="favourite-name">Two Weeks</span>--%>
<%--          </div>--%>
<%--        </li>--%>
        <li class="favourite-item">
          <div class="favourite-icon">📘</div>
          <div class="favourite-info">
            <span class="favourite-name">One Month</span>
          </div>
        </li>
        <li class="favourite-item">
          <div class="favourite-icon">📘</div>
          <div class="favourite-info">
            <span class="favourite-name">Three Months</span>
          </div>
        </li>
      </ul>
    </div>

    <!-- Floating Action Buttons - Now static below sidebar -->
    <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
      <a href="/writejournal" class="floating-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        Add Journal
      </a>
      <a href="/vaultmemories" class="floating-btn vault-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
          <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
        </svg>
        Vault
      </a>
    </div>
  </aside>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
  // Modern Search Functionality for Journals Page
  document.addEventListener('DOMContentLoaded', function() {
    const journalsSearchBtn = document.getElementById('journalsSearchBtn');

    if (journalsSearchBtn) {
      journalsSearchBtn.addEventListener('click', function(event) {
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

        input.addEventListener('blur', function() {
          setTimeout(() => {
            if (!document.activeElement.closest('.journals-search-expanded')) {
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
          const journalCards = document.querySelectorAll('.journal-card');
          journalCards.forEach(card => {
            const title = card.getAttribute('data-title')?.toLowerCase() || '';
            const tag = card.getAttribute('data-tag')?.toLowerCase() || '';
            const matches = title.includes(query) || tag.includes(query);
            card.style.display = matches ? 'block' : 'none';
          });
        });
      });
    }

    // Filter button handlers
    const dateSort = document.getElementById('dateSort');
    const tagFilter = document.getElementById('tagFilter');

    if (dateSort) {
      dateSort.addEventListener('click', function() {
        console.log('Sort by date clicked');
        // Implement sorting logic here
      });
    }

    if (tagFilter) {
      tagFilter.addEventListener('click', function() {
        console.log('Filter tags clicked');
        // Implement tag filtering logic here
      });
    }

    // Journal card click handlers
    const journalCards = document.querySelectorAll('.journal-card');
    journalCards.forEach(card => {
      card.addEventListener('click', function() {
        console.log('Journal clicked:', this.querySelector('.journal-title').textContent);
        // Redirect to journal detail page
        // window.location.href = '/journalview';
      });
    });

    // Milestone and favourite item interactions
    // const milestoneItems = document.querySelectorAll('.milestone-item');
    // milestoneItems.forEach(item => {
    //   item.addEventListener('click', function() {
    //     milestoneItems.forEach(i => i.classList.remove('selected'));
    //     this.classList.add('selected');
    //   });
    // });

    const favouriteItems = document.querySelectorAll('.favourite-item');
    favouriteItems.forEach(item => {
      item.addEventListener('click', function() {
        favouriteItems.forEach(i => i.classList.remove('selected'));
        this.classList.add('selected');
      });
    });
  });
</script>
</body>
</html>