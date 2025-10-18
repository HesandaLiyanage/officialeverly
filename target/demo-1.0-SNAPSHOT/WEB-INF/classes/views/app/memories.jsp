<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
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
      <div class="search-box">
        <input type="text" placeholder="Search memories" id="searchInput">
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
              <%--              <li class="favorite-item">--%>
              <%--                <div class="favorite-icon ${favorite.iconClass}">${favorite.icon}</div>--%>
              <%--                <span class="favorite-name">${favorite.name}</span>--%>
              <%--              </li>--%>
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

    <!-- Storage Section -->

    <!-- Recycle Bin Section -->



  </aside>
</div> <!-- End of .page-wrapper -->

<!-- Floating Action Buttons (Moved outside .page-wrapper, before footer) -->
<div class="floating-buttons">
  <a href="/memoryview" class="floating-btn" id="addMemoryBtn">Add a Memory</a>
  <a href="/vaultmemories" class="floating-btn" id="vaultBtn">Vault</a>
</div>

<jsp:include page="../public/footer.jsp" />
<script>
  // TypeScript-compatible JavaScript for JSP
  class MemoriesApp {
    constructor() {
      // Get server-side data if available
      this.serverMemories = ${not empty memoriesJson ? memoriesJson : 'null'};
      this.memories = this.serverMemories || this.getDefaultMemories();

      this.currentTab = 'memories';
      this.searchQuery = '';
      this.dateFilter = '';
      this.locationFilter = '';

      this.initializeEventListeners();

      // Only render if using client-side data
      if (!this.serverMemories) {
        this.renderMemories();
      } else {
        this.attachEventListeners();
      }
    }

    getDefaultMemories() {
      return [
        {
          id: 1,
          title: "Family Vacation 2023",
          date: "July 15, 2023",
          type: "family-vacation",
          isFavorite: false
        },
        {
          id: 2,
          title: "Sarah's Birthday Party",
          date: "May 20, 2023",
          type: "birthday-party",
          isFavorite: false
        },
        {
          id: 3,
          title: "Weekend Getaway",
          date: "April 8, 2023",
          type: "getaway",
          isFavorite: false
        },
        {
          id: 4,
          title: "Graduation Ceremony",
          date: "June 10, 2023",
          type: "graduation",
          isFavorite: true
        },
        {
          id: 5,
          title: "Summer BBQ",
          date: "August 5, 2023",
          type: "bbq",
          isFavorite: true
        },
        {
          id: 6,
          title: "Hiking Trip",
          date: "September 22, 2023",
          type: "hiking",
          isFavorite: false
        },
        {
          id: 7,
          title: "Concert Night",
          date: "October 14, 2023",
          type: "concert",
          isFavorite: false
        },
        {
          id: 8,
          title: "Art Exhibition",
          date: "November 3, 2023",
          type: "art-exhibition",
          isFavorite: true
        },
        {
          id: 9,
          title: "Beach Day",
          date: "December 25, 2023",
          type: "beach",
          isFavorite: false
        },
        {
          id: 10,
          title: "City Exploration",
          date: "January 12, 2024",
          type: "city",
          isFavorite: true
        },
        {
          id: 11,
          title: "Holiday Celebration",
          date: "February 18, 2024",
          type: "holiday",
          isFavorite: false
        },
        {
          id: 12,
          title: "Road Trip",
          date: "March 7, 2024",
          type: "road-trip",
          isFavorite: true
        }
      ];
    }

    initializeEventListeners() {
      // Tab navigation
      const tabButtons = document.querySelectorAll('.tab-nav button');
      tabButtons.forEach(button => {
        button.addEventListener('click', (e) => {
          const target = e.target;
          const tab = target.getAttribute('data-tab');
          this.switchTab(tab);
        });
      });

      // Search functionality
      const searchInput = document.getElementById('searchInput');
      if (searchInput) {
        searchInput.addEventListener('input', (e) => {
          const target = e.target;
          this.searchQuery = target.value.toLowerCase();
          if (!this.serverMemories) {
            this.renderMemories();
          } else {
            this.filterServerMemories();
          }
        });
      }

      // Filter buttons
      const dateFilter = document.getElementById('dateFilter');
      const locationFilter = document.getElementById('locationFilter');

      if (dateFilter) {
        dateFilter.addEventListener('click', () => this.toggleDateFilter());
      }

      if (locationFilter) {
        locationFilter.addEventListener('click', () => this.toggleLocationFilter());
      }

      // Expandable sections
      const expandableSections = document.querySelectorAll('.expandable-section');
      expandableSections.forEach(section => {
        section.addEventListener('click', (e) => {
          const target = e.currentTarget;
          target.classList.toggle('expanded');
        });
      });

      // Favorite items
      const favoriteItems = document.querySelectorAll('.favorite-item');
      favoriteItems.forEach(item => {
        item.addEventListener('click', (e) => {
          const target = e.currentTarget;
          this.selectFavorite(target);
        });
      });
    }

    attachEventListeners() {
      // Attach event listeners to server-rendered memory cards
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

      // Update active tab button
      const tabButtons = document.querySelectorAll('.tab-nav button');
      tabButtons.forEach(button => {
        button.classList.remove('active');
        if (button.getAttribute('data-tab') === tab) {
          button.classList.add('active');
        }
      });

      if (!this.serverMemories) {
        this.renderMemories();
      } else {
        this.filterServerMemories();
      }
    }

    toggleDateFilter() {
      console.log('Date filter clicked');
      // Send request to server for date filtering if needed
      // window.location.href = '/memories?dateFilter=' + dateValue;
    }

    toggleLocationFilter() {
      console.log('Location filter clicked');
      // Send request to server for location filtering if needed
      // window.location.href = '/memories?locationFilter=' + locationValue;
    }

    selectFavorite(element) {
      const favoriteItems = document.querySelectorAll('.favorite-item');
      favoriteItems.forEach(item => item.classList.remove('selected'));
      element.classList.add('selected');

      const favoriteName = element.querySelector('.favorite-name')?.textContent;
      console.log('Selected favorite:', favoriteName);
    }

    filterServerMemories() {
      const memoryCards = document.querySelectorAll('.memory-card');
      memoryCards.forEach(card => {
        const title = card.querySelector('.memory-title')?.textContent?.toLowerCase() || '';
        const matchesSearch = !this.searchQuery || title.includes(this.searchQuery);

        if (matchesSearch) {
          card.style.display = 'block';
        } else {
          card.style.display = 'none';
        }
      });
    }

    filterMemories() {
      return this.memories.filter(memory => {
        const matchesSearch = !this.searchQuery ||
                memory.title.toLowerCase().includes(this.searchQuery);

        const matchesTab = this.currentTab === 'memories' ||
                (this.currentTab === 'collab' && memory.isCollab);

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

      grid.innerHTML = filteredMemories
              .map(memory => this.createMemoryCard(memory))
              .join('');

      this.attachEventListeners();
    }

    openMemory(memoryId) {
      console.log('Opening memory with ID:', memoryId);
      // Redirect to memory detail page or open modal
      // window.location.href = '/memory/' + memoryId;
    }
  }

  // Initialize the app when DOM is loaded
  document.addEventListener('DOMContentLoaded', () => {
    new MemoriesApp();
  });
</script>
</body>
</html>