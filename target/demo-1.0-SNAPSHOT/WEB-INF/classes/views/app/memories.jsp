<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>--%>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>--%>

<!-- Memories Page Content -->
<jsp:include page="../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/memories.css">

<!-- Wrap everything after header -->
<div class="page-wrapper">
  <main class="main-content">
    <!-- Tab Navigation -->
    <div class="tab-nav">
      <button class="active" data-tab="memories">Memories</button>
      <button data-tab="collab">Collab Memories</button>
      <button data-tab="recap">Memory Recap</button>
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
      <!-- JSP Memory cards - can be populated from server-side data -->
      <c:choose>
        <c:when test="${not empty memories}">
          <c:forEach var="memory" items="${memories}">
            <div class="memory-card ${memory.type}" data-id="${memory.id}">
              <div class="memory-image"
                      <c:if test="${not empty memory.imageUrl}">
                        style="background-image: url('${memory.imageUrl}')"
                      </c:if>>
              </div>
              <div class="memory-content">
                <h3 class="memory-title">${memory.title}</h3>
                <p class="memory-date">
                  <fmt:formatDate value="${memory.date}" pattern="MMMM d, yyyy"/>
                </p>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <!-- Fallback static content if no server data available -->
          <div class="memory-card family-vacation" data-id="1">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Family Vacation 2023</h3>
              <p class="memory-date">July 15, 2023</p>
            </div>
          </div>

          <div class="memory-card birthday-party" data-id="2">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Sarah's Birthday Party</h3>
              <p class="memory-date">May 20, 2023</p>
            </div>
          </div>

          <div class="memory-card getaway" data-id="3">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Weekend Getaway</h3>
              <p class="memory-date">April 8, 2023</p>
            </div>
          </div>

          <div class="memory-card graduation" data-id="4">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Graduation Ceremony</h3>
              <p class="memory-date">June 10, 2023</p>
            </div>
          </div>

          <div class="memory-card bbq" data-id="5">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Summer BBQ</h3>
              <p class="memory-date">August 5, 2023</p>
            </div>
          </div>

          <div class="memory-card hiking" data-id="6">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Hiking Trip</h3>
              <p class="memory-date">September 22, 2023</p>
            </div>
          </div>

          <div class="memory-card concert" data-id="7">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Concert Night</h3>
              <p class="memory-date">October 14, 2023</p>
            </div>
          </div>

          <div class="memory-card art-exhibition" data-id="8">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Art Exhibition</h3>
              <p class="memory-date">November 3, 2023</p>
            </div>
          </div>

          <div class="memory-card beach" data-id="9">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Beach Day</h3>
              <p class="memory-date">December 25, 2023</p>
            </div>
          </div>

          <div class="memory-card city" data-id="10">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">City Exploration</h3>
              <p class="memory-date">January 12, 2024</p>
            </div>
          </div>

          <div class="memory-card holiday" data-id="11">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Holiday Celebration</h3>
              <p class="memory-date">February 18, 2024</p>
            </div>
          </div>

          <div class="memory-card road-trip" data-id="12">
            <div class="memory-image"></div>
            <div class="memory-content">
              <h3 class="memory-title">Road Trip</h3>
              <p class="memory-date">March 7, 2024</p>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>

  <aside class="sidebar">
    <!-- Favourites Section -->
    <div class="sidebar-section">
      <h3 class="sidebar-title">Favourites</h3>
      <ul class="favorites-list">
        <c:choose>
          <c:when test="${not empty favorites}">
            <c:forEach var="favorite" items="${favorites}">
            </c:forEach>
          </c:when>
          <c:otherwise>
            <!-- Default favorites -->
            <li class="favorite-item">
              <div class="favorite-icon graduation">  </div>
              <span class="favorite-name">Graduation Ceremony</span>
            </li>
            <li class="favorite-item">
              <div class="favorite-icon bbq"> </div>
              <span class="favorite-name">Summer BBQ</span>
            </li>
            <li class="favorite-item">
              <div class="favorite-icon city"> </div>
              <span class="favorite-name">City Exploration</span>
            </li>
            <li class="favorite-item">
              <div class="favorite-icon art">  </div>
              <span class="favorite-name">Art Exhibition</span>
            </li>
            <li class="favorite-item">
              <div class="favorite-icon road">  </div>
              <span class="favorite-name">Road Trip</span>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>

    <!-- Floating Action Buttons - Now in sidebar -->
    <div class="floating-buttons" id="floatingButtons">
      <a href="/memoryview" class="floating-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        Add Memory
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
  // Modern Search Functionality for Memories Page
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
  });

  // TypeScript-compatible JavaScript for JSP
  class MemoriesApp {
    constructor() {
      this.serverMemories = ${not empty memoriesJson ? memoriesJson : 'null'};
      this.memories = this.serverMemories || this.getDefaultMemories();
      this.currentTab = 'memories';
      this.searchQuery = '';
      this.dateFilter = '';
      this.locationFilter = '';

      this.initializeEventListeners();

      if (!this.serverMemories) {
        this.renderMemories();
      } else {
        this.attachEventListeners();
      }
    }

    getDefaultMemories() {
      return [
        { id: 1, title: "Family Vacation 2023", date: "July 15, 2023", type: "family-vacation", isFavorite: false },
        { id: 2, title: "Sarah's Birthday Party", date: "May 20, 2023", type: "birthday-party", isFavorite: false },
        { id: 3, title: "Weekend Getaway", date: "April 8, 2023", type: "getaway", isFavorite: false },
        { id: 4, title: "Graduation Ceremony", date: "June 10, 2023", type: "graduation", isFavorite: true },
        { id: 5, title: "Summer BBQ", date: "August 5, 2023", type: "bbq", isFavorite: true },
        { id: 6, title: "Hiking Trip", date: "September 22, 2023", type: "hiking", isFavorite: false },
        { id: 7, title: "Concert Night", date: "October 14, 2023", type: "concert", isFavorite: false },
        { id: 8, title: "Art Exhibition", date: "November 3, 2023", type: "art-exhibition", isFavorite: true },
        { id: 9, title: "Beach Day", date: "December 25, 2023", type: "beach", isFavorite: false },
        { id: 10, title: "City Exploration", date: "January 12, 2024", type: "city", isFavorite: true },
        { id: 11, title: "Holiday Celebration", date: "February 18, 2024", type: "holiday", isFavorite: false },
        { id: 12, title: "Road Trip", date: "March 7, 2024", type: "road-trip", isFavorite: true }
      ];
    }

    initializeEventListeners() {
      const tabButtons = document.querySelectorAll('.tab-nav button');
      tabButtons.forEach(button => {
        button.addEventListener('click', (e) => {
          const target = e.target;
          const tab = target.getAttribute('data-tab');
          this.switchTab(tab);
        });
      });

      const dateFilter = document.getElementById('dateFilter');
      const locationFilter = document.getElementById('locationFilter');

      if (dateFilter) {
        dateFilter.addEventListener('click', () => this.toggleDateFilter());
      }

      if (locationFilter) {
        locationFilter.addEventListener('click', () => this.toggleLocationFilter());
      }

      const favoriteItems = document.querySelectorAll('.favorite-item');
      favoriteItems.forEach(item => {
        item.addEventListener('click', (e) => {
          const target = e.currentTarget;
          this.selectFavorite(target);
        });
      });
    }

    attachEventListeners() {
      const memoryCards = document.querySelectorAll('.memory-card');
      memoryCards.forEach(card => {
        card.addEventListener('click', (e) => {
          const target = e.currentTarget;
          const memoryId = parseInt(target.getAttribute('data-id') || '0');
          this.openMemory(memoryId);
        });
      });
    }

    switchTab(tab) {
      this.currentTab = tab;
      const tabButtons = document.querySelectorAll('.tab-nav button');
      tabButtons.forEach(button => {
        button.classList.remove('active');
        if (button.getAttribute('data-tab') === tab) {
          button.classList.add('active');
        }
      });

      if (!this.serverMemories) {
        this.renderMemories();
      }
    }

    toggleDateFilter() {
      console.log('Date filter clicked');
    }

    toggleLocationFilter() {
      console.log('Location filter clicked');
    }

    selectFavorite(element) {
      const favoriteItems = document.querySelectorAll('.favorite-item');
      favoriteItems.forEach(item => item.classList.remove('selected'));
      element.classList.add('selected');
    }

    filterMemories() {
      return this.memories.filter(memory => {
        const matchesSearch = !this.searchQuery || memory.title.toLowerCase().includes(this.searchQuery);
        const matchesTab = this.currentTab === 'memories' || (this.currentTab === 'collab' && memory.isCollab);
        return matchesSearch && matchesTab;
      });
    }

    createMemoryCard(memory) {
      return `
        <div class="memory-card ${memory.type}" data-id="${memory.id}">
          <div class="memory-image"></div>
          <div class="memory-content">
            <h3 class="memory-title">${memory.title}</h3>
            <p class="memory-date">${memory.date}</p>
          </div>
        </div>
      `;
    }

    renderMemories() {
      const grid = document.getElementById('memoriesGrid');
      if (!grid) return;

      const filteredMemories = this.filterMemories();

      if (filteredMemories.length === 0) {
        grid.innerHTML = '<p style="text-align: center; color: #6c757d; grid-column: 1 / -1; margin: 40px 0;">No memories found</p>';
        return;
      }

      grid.innerHTML = filteredMemories.map(memory => this.createMemoryCard(memory)).join('');
      this.attachEventListeners();
    }

    openMemory(memoryId) {
      console.log('Opening memory with ID:', memoryId);
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    new MemoriesApp();
  });
</script>
</body>
</html>