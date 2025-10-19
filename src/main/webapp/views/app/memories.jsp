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
      <button class="filter-btn" id="dateFilter">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <polyline points="19 12 12 19 5 12"></polyline>
        </svg>
        Date
      </button>
      <button class="filter-btn" id="locationFilter">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
          <circle cx="12" cy="10" r="3"></circle>
        </svg>
        Location
      </button>
    </div>
<%--    <a href="/memoryview"/>--%>

    <!-- Memories Grid -->
    <div class="memories-grid" id="memoriesGrid">
      <div class="memory-card" data-title="Beach Sunset Adventure" id="sunset">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Beach Sunset Adventure</h3>
          <p class="memory-date">July 15, 2024</p>
        </div>
      </div>

      <div class="memory-card" data-title="Mountain Hiking Trip">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Mountain Hiking Trip</h3>
          <p class="memory-date">June 22, 2024</p>
        </div>
      </div>

      <div class="memory-card" data-title="Family Reunion Dinner">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Family Reunion Dinner</h3>
          <p class="memory-date">May 10, 2024</p>
        </div>
      </div>

      <div class="memory-card" data-title="Adventure in the Wild">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Adventure in the Wild</h3>
          <p class="memory-date">April 5, 2024</p>
        </div>
      </div>

      <div class="memory-card" data-title="City Lights Exploration">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">City Lights Exploration</h3>
          <p class="memory-date">March 18, 2024</p>
        </div>
      </div>

      <div class="memory-card" data-title="Art Exhibition Visit">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Art Exhibition Visit</h3>
          <p class="memory-date">February 2, 2024</p>
        </div>
      </div>

      <div class="memory-card" data-title="Weekend Getaway">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Weekend Getaway</h3>
          <p class="memory-date">January 20, 2024</p>
        </div>
      </div>

      <div class="memory-card" data-title="Coffee Shop Hangout">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Coffee Shop Hangout</h3>
          <p class="memory-date">December 15, 2023</p>
        </div>
      </div>

      <div class="memory-card" data-title="Birthday Celebration">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Birthday Celebration</h3>
          <p class="memory-date">November 8, 2023</p>
        </div>
      </div>

      <div class="memory-card" data-title="Graduation Day">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Graduation Day</h3>
          <p class="memory-date">October 10, 2023</p>
        </div>
      </div>

      <div class="memory-card" data-title="Summer BBQ Party">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Summer BBQ Party</h3>
          <p class="memory-date">September 5, 2023</p>
        </div>
      </div>

      <div class="memory-card" data-title="Road Trip to Coast">
        <div class="memory-image" style="background-image: url('https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=800')"></div>
        <div class="memory-content">
          <h3 class="memory-title">Road Trip to Coast</h3>
          <p class="memory-date">August 12, 2023</p>
        </div>
      </div>
    </div>

    <!-- Empty state container for minimum height -->
    <div id="emptyStateContainer" style="display: none; min-height: 600px;"></div>
  </main>

  <aside class="sidebar">
    <!-- Favourites Section -->
    <div class="sidebar-section">
      <h3 class="sidebar-title">Favourites</h3>
      <ul class="favorites-list">
        <li class="favorite-item">
          <div class="favorite-icon graduation">  </div>
          <span class="favorite-name">Graduation Day</span>
        </li>
        <li class="favorite-item">
          <div class="favorite-icon bbq"> </div>
          <span class="favorite-name">Summer BBQ Party</span>
        </li>
        <li class="favorite-item">
          <div class="favorite-icon city"> </div>
          <span class="favorite-name">City Lights Exploration</span>
        </li>
        <li class="favorite-item">
          <div class="favorite-icon art">  </div>
          <span class="favorite-name">Art Exhibition Visit</span>
        </li>
        <li class="favorite-item">
          <div class="favorite-icon road">  </div>
          <span class="favorite-name">Road Trip to Coast</span>
        </li>
      </ul>
    </div>

    <!-- Floating Action Buttons - Now in sidebar -->
    <div class="floating-buttons" id="floatingButtons">
      <a href="/creatememory" class="floating-btn">
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

  const card = document.getElementById('sunset');

  car.addEventListener('click', function() {
    window.location.href = '/memoryview';
  })
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

        // Search functionality - FIXED: Now works properly
        input.addEventListener('input', function(e) {
          const query = e.target.value.toLowerCase();
          const memoryCards = document.querySelectorAll('.memory-card');
          memoryCards.forEach(card => {
            const title = card.getAttribute('data-title')?.toLowerCase() || '';
            card.style.display = title.includes(query) ? 'block' : 'none';
          });
        });
      });
    }

    // Tab switching functionality
    const tabButtons = document.querySelectorAll('.tab-nav button');
    const memoriesGrid = document.getElementById('memoriesGrid');

    tabButtons.forEach(button => {
      button.addEventListener('click', function() {
        const tab = this.getAttribute('data-tab');

        // Update active button
        tabButtons.forEach(btn => btn.classList.remove('active'));
        this.classList.add('active');

        // Update content based on tab
        if (tab === 'memories') {
          // Show all memories
          const memoryCards = document.querySelectorAll('.memory-card');
          memoryCards.forEach(card => card.style.display = 'block');
        } else if (tab === 'collab') {
          // Show no collab memories message
          memoriesGrid.innerHTML = '<p style="text-align: center; color: #6c757d; grid-column: 1 / -1; margin: 40px 0; font-size: 16px;">No collab memories yet</p>';
        } else if (tab === 'recap') {
          // Show no memory recap message
          memoriesGrid.innerHTML = '<p style="text-align: center; color: #6c757d; grid-column: 1 / -1; margin: 40px 0; font-size: 16px;">No memory recaps yet</p>';
        }
      });
    });

    // Handle floating buttons position on scroll - FIXED
    function handleFloatingButtons() {
      const footer = document.querySelector('footer');
      const floatingButtons = document.getElementById('floatingButtons');
      const sidebar = document.querySelector('.sidebar');
      const pageWrapper = document.querySelector('.page-wrapper');

      if (!footer || !floatingButtons || !sidebar || !pageWrapper) return;

      const windowHeight = window.innerHeight;
      const buttonHeight = floatingButtons.offsetHeight;
      const scrollY = window.scrollY;
      const sidebarRect = sidebar.getBoundingClientRect();

      // Get positions relative to document
      const footerTop = footer.offsetTop;
      const pageWrapperRect = pageWrapper.getBoundingClientRect();
      const sidebarLeft = sidebar.offsetLeft + pageWrapper.offsetLeft;

      // Calculate stop position (above footer)
      const stopPosition = footerTop - buttonHeight - 40;
      const currentScrollBottom = scrollY + windowHeight;

      // Check if we need to stop before footer
      if (currentScrollBottom >= footerTop + 100) {
        // Stop before footer - use absolute positioning
        floatingButtons.style.position = 'absolute';
        floatingButtons.style.bottom = 'auto';
        floatingButtons.style.top = stopPosition + 'px';
        floatingButtons.style.left = sidebarLeft + 'px';
        floatingButtons.style.width = sidebar.offsetWidth + 'px';
      } else {
        // Float normally - use fixed positioning
        floatingButtons.style.position = 'fixed';
        floatingButtons.style.bottom = '40px';
        floatingButtons.style.top = 'auto';
        floatingButtons.style.left = (sidebarRect.left) + 'px';
        floatingButtons.style.width = sidebarRect.width + 'px';
      }
    }

    // Call immediately and on scroll/resize
    handleFloatingButtons();
    window.addEventListener('scroll', handleFloatingButtons);
    window.addEventListener('resize', handleFloatingButtons);
  });
</script>
</body>
</html>