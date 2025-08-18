<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Add CSS specific to memories page in the head section -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/components.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memories.css">

<main class="main-content">
  <div class="container">
    <!-- Page Header -->
    <div class="page-header">
      <div class="tab-navigation">
        <button class="tab-btn tab-btn--active" data-tab="memories">Memories</button>
        <button class="tab-btn" data-tab="collab">Collab Memories</button>
      </div>
    </div>

    <!-- Content Layout -->
    <div class="content-layout">
      <!-- Main Content -->
      <div class="content-main">
        <!-- Search and Filters -->
        <div class="search-filters">
          <div class="search-input search-input--large">
            <input type="text" placeholder="Search memories" class="search-input__field" id="memoriesSearch">
            <svg class="search-input__icon" width="18" height="18" viewBox="0 0 24 24" fill="none">
              <path d="M21 21L16.514 16.506M19 10.5C19 15.194 15.194 19 10.5 19C5.806 19 2 15.194 2 10.5C2 5.806 5.806 2 10.5 2C15.194 2 19 5.806 19 10.5Z" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
          </div>
          <div class="filter-controls">
            <div class="dropdown" id="dateFilter">
              <button class="dropdown__trigger">
                Date
                <svg class="dropdown__icon" width="16" height="16" viewBox="0 0 24 24" fill="none">
                  <path d="M6 9L12 15L18 9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </button>
              <div class="dropdown__content">
                <a href="#" class="dropdown__item" data-value="recent">Most Recent</a>
                <a href="#" class="dropdown__item" data-value="oldest">Oldest First</a>
                <a href="#" class="dropdown__item" data-value="year">This Year</a>
              </div>
            </div>
            <div class="dropdown" id="locationFilter">
              <button class="dropdown__trigger">
                Location
                <svg class="dropdown__icon" width="16" height="16" viewBox="0 0 24 24" fill="none">
                  <path d="M6 9L12 15L18 9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </button>
              <div class="dropdown__content">
                <a href="#" class="dropdown__item" data-value="all">All Locations</a>
                <a href="#" class="dropdown__item" data-value="local">Local</a>
                <a href="#" class="dropdown__item" data-value="travel">Travel</a>
              </div>
            </div>
          </div>
        </div>

        <!-- Memory Grid -->
        <div class="memory-grid">
          <!-- Memory Card Template -->
          <div class="memory-card" data-memory-id="1">
            <div class="memory-card__image">
              <img src="${pageContext.request.contextPath}/images/family-vacation.jpg" alt="Family Vacation 2023">
              <button class="memory-card__favorite" data-favorited="false">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                  <path d="M20.84 4.61C20.3292 4.099 19.7228 3.69364 19.0554 3.41708C18.3879 3.14052 17.6725 2.99817 16.95 2.99817C16.2275 2.99817 15.5121 3.14052 14.8446 3.41708C14.1772 3.69364 13.5708 4.099 13.06 4.61L12 5.67L10.94 4.61C9.9083 3.5783 8.50903 2.9987 7.05 2.9987C5.59096 2.9987 4.19169 3.5783 3.16 4.61C2.1283 5.6417 1.5487 7.04097 1.5487 8.5C1.5487 9.95903 2.1283 11.3583 3.16 12.39L12 21.23L20.84 12.39C21.351 11.8792 21.7563 11.2728 22.0329 10.6053C22.3095 9.93789 22.4518 9.22248 22.4518 8.5C22.4518 7.77752 22.3095 7.06211 22.0329 6.39465C21.7563 5.7272 21.351 5.1208 20.84 4.61V4.61Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </button>
            </div>
            <div class="memory-card__content">
              <h3 class="memory-card__title">Family Vacation 2023</h3>
              <p class="memory-card__date">July 15, 2023</p>
            </div>
          </div>

          <div class="memory-card" data-memory-id="2">
            <div class="memory-card__image">
              <img src="${pageContext.request.contextPath}/images/birthday-party.jpg" alt="Sarah's Birthday Party">
              <button class="memory-card__favorite" data-favorited="false">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                  <path d="M20.84 4.61C20.3292 4.099 19.7228 3.69364 19.0554 3.41708C18.3879 3.14052 17.6725 2.99817 16.95 2.99817C16.2275 2.99817 15.5121 3.14052 14.8446 3.41708C14.1772 3.69364 13.5708 4.099 13.06 4.61L12 5.67L10.94 4.61C9.9083 3.5783 8.50903 2.9987 7.05 2.9987C5.59096 2.9987 4.19169 3.5783 3.16 4.61C2.1283 5.6417 1.5487 7.04097 1.5487 8.5C1.5487 9.95903 2.1283 11.3583 3.16 12.39L12 21.23L20.84 12.39C21.351 11.8792 21.7563 11.2728 22.0329 10.6053C22.3095 9.93789 22.4518 9.22248 22.4518 8.5C22.4518 7.77752 22.3095 7.06211 22.0329 6.39465C21.7563 5.7272 21.351 5.1208 20.84 4.61V4.61Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </button>
            </div>
            <div class="memory-card__content">
              <h3 class="memory-card__title">Sarah's Birthday Party</h3>
              <p class="memory-card__date">May 20, 2023</p>
            </div>
          </div>

          <div class="memory-card" data-memory-id="3">
            <div class="memory-card__image">
              <img src="${pageContext.request.contextPath}/images/weekend-getaway.jpg" alt="Weekend Getaway">
              <button class="memory-card__favorite" data-favorited="false">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                  <path d="M20.84 4.61C20.3292 4.099 19.7228 3.69364 19.0554 3.41708C18.3879 3.14052 17.6725 2.99817 16.95 2.99817C16.2275 2.99817 15.5121 3.14052 14.8446 3.41708C14.1772 3.69364 13.5708 4.099 13.06 4.61L12 5.67L10.94 4.61C9.9083 3.5783 8.50903 2.9987 7.05 2.9987C5.59096 2.9987 4.19169 3.5783 3.16 4.61C2.1283 5.6417 1.5487 7.04097 1.5487 8.5C1.5487 9.95903 2.1283 11.3583 3.16 12.39L12 21.23L20.84 12.39C21.351 11.8792 21.7563 11.2728 22.0329 10.6053C22.3095 9.93789 22.4518 9.22248 22.4518 8.5C22.4518 7.77752 22.3095 7.06211 22.0329 6.39465C21.7563 5.7272 21.351 5.1208 20.84 4.61V4.61Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </button>
            </div>
            <div class="memory-card__content">
              <h3 class="memory-card__title">Weekend Getaway</h3>
              <p class="memory-card__date">April 8, 2023</p>
            </div>
          </div>

          <div class="memory-card" data-memory-id="4">
            <div class="memory-card__image">
              <img src="${pageContext.request.contextPath}/images/graduation.jpg" alt="Graduation Ceremony">
              <button class="memory-card__favorite" data-favorited="true">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M20.84 4.61C20.3292 4.099 19.7228 3.69364 19.0554 3.41708C18.3879 3.14052 17.6725 2.99817 16.95 2.99817C16.2275 2.99817 15.5121 3.14052 14.8446 3.41708C14.1772 3.69364 13.5708 4.099 13.06 4.61L12 5.67L10.94 4.61C9.9083 3.5783 8.50903 2.9987 7.05 2.9987C5.59096 2.9987 4.19169 3.5783 3.16 4.61C2.1283 5.6417 1.5487 7.04097 1.5487 8.5C1.5487 9.95903 2.1283 11.3583 3.16 12.39L12 21.23L20.84 12.39C21.351 11.8792 21.7563 11.2728 22.0329 10.6053C22.3095 9.93789 22.4518 9.22248 22.4518 8.5C22.4518 7.77752 22.3095 7.06211 22.0329 6.39465C21.7563 5.7272 21.351 5.1208 20.84 4.61V4.61Z"/>
                </svg>
              </button>
            </div>
            <div class="memory-card__content">
              <h3 class="memory-card__title">Graduation Ceremony</h3>
              <p class="memory-card__date">June 10, 2023</p>
            </div>
          </div>

          <div class="memory-card" data-memory-id="5">
            <div class="memory-card__image">
              <img src="${pageContext.request.contextPath}/images/summer-bbq.jpg" alt="Summer BBQ">
              <button class="memory-card__favorite" data-favorited="true">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M20.84 4.61C20.3292 4.099 19.7228 3.69364 19.0554 3.41708C18.3879 3.14052 17.6725 2.99817 16.95 2.99817C16.2275 2.99817 15.5121 3.14052 14.8446 3.41708C14.1772 3.69364 13.5708 4.099 13.06 4.61L12 5.67L10.94 4.61C9.9083 3.5783 8.50903 2.9987 7.05 2.9987C5.59096 2.9987 4.19169 3.5783 3.16 4.61C2.1283 5.6417 1.5487 7.04097 1.5487 8.5C1.5487 9.95903 2.1283 11.3583 3.16 12.39L12 21.23L20.84 12.39C21.351 11.8792 21.7563 11.2728 22.0329 10.6053C22.3095 9.93789 22.4518 9.22248 22.4518 8.5C22.4518 7.77752 22.3095 7.06211 22.0329 6.39465C21.7563 5.7272 21.351 5.1208 20.84 4.61V4.61Z"/>
                </svg>
              </button>
            </div>
            <div class="memory-card__content">
              <h3 class="memory-card__title">Summer BBQ</h3>
              <p class="memory-card__date">August 5, 2023</p>
            </div>
          </div>

          <!-- Additional memory cards would be dynamically generated -->
        </div>
      </div>

      <!-- Sidebar -->
      <aside class="sidebar">
        <!-- Favourites Section -->
        <div class="sidebar-section">
          <h3 class="sidebar-section__title">Favourites</h3>
          <div class="favourite-list">
            <div class="favourite-item">
              <div class="favourite-item__icon">
                <img src="${pageContext.request.contextPath}/images/graduation-icon.jpg" alt="Graduation">
              </div>
              <span class="favourite-item__text">Graduation Ceremony</span>
            </div>
            <div class="favourite-item">
              <div class="favourite-item__icon">
                <img src="${pageContext.request.contextPath}/images/bbq-icon.jpg" alt="BBQ">
              </div>
              <span class="favourite-item__text">Summer BBQ</span>
            </div>
            <div class="favourite-item">
              <div class="favourite-item__icon">
                <img src="${pageContext.request.contextPath}/images/city-icon.jpg" alt="City">
              </div>
              <span class="favourite-item__text">City Exploration</span>
            </div>
            <div class="favourite-item">
              <div class="favourite-item__icon">
                <img src="${pageContext.request.contextPath}/images/art-icon.jpg" alt="Art">
              </div>
              <span class="favourite-item__text">Art Exhibition</span>
            </div>
            <div class="favourite-item">
              <div class="favourite-item__icon">
                <img src="${pageContext.request.contextPath}/images/road-icon.jpg" alt="Road">
              </div>
              <span class="favourite-item__text">Road Trip</span>
            </div>
          </div>
        </div>

        <!-- Storage Section -->
        <div class="sidebar-section">
          <div class="sidebar-section__header">
            <h3 class="sidebar-section__title">Storage</h3>
            <svg class="sidebar-section__icon" width="16" height="16" viewBox="0 0 24 24" fill="none">
              <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="storage-info">
            <div class="storage-info__text">75% used</div>
            <div class="progress-bar">
              <div class="progress-bar__fill" style="width: 75%;"></div>
            </div>
            <div class="storage-info__details">150 GB of 200 GB</div>
          </div>
        </div>

        <!-- Recycle Bin Section -->
        <div class="sidebar-section">
          <div class="sidebar-section__header">
            <h3 class="sidebar-section__title">Recycle Bin</h3>
            <svg class="sidebar-section__icon" width="16" height="16" viewBox="0 0 24 24" fill="none">
              <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
        </div>

        <!-- Vault Section -->
        <div class="sidebar-section">
          <div class="sidebar-section__header">
            <h3 class="sidebar-section__title">Vault</h3>
            <svg class="sidebar-section__icon" width="16" height="16" viewBox="0 0 24 24" fill="none">
              <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
        </div>
      </aside>
    </div>
  </div>
</main>

<!-- Include JavaScript at the bottom -->
<script src="${pageContext.request.contextPath}/resources/ts/memories.js"></script>