<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Everly</title>
    <!-- Component CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
      rel="stylesheet">
  </head>
  <script>
    document.addEventListener('DOMContentLoaded', function () {
      const profilePhoto = document.getElementById('profilePhoto');
      const profileDropdown = document.getElementById('profileDropdown');

      if (profilePhoto && profileDropdown) {
        profilePhoto.addEventListener('click', function (event) {
          event.stopPropagation();
          profileDropdown.classList.toggle('active');
        });

        document.addEventListener('click', function (event) {
          if (!profileDropdown.contains(event.target) && event.target !== profilePhoto) {
            profileDropdown.classList.remove('active');
          }
        });
      }

      // NEW MODERN SEARCH FUNCTIONALITY
      const searchBtn = document.getElementById('searchBtn');
      if (searchBtn) {
        searchBtn.addEventListener('click', function (event) {
          event.stopPropagation();

          const searchBtnElement = this;
          const searchBox = document.createElement('div');
          searchBox.className = 'search-box-expanded';
          searchBox.innerHTML = `
          <div class="search-icon-expanded">
            <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          </div>
          <input type="text" placeholder="Search anything..." autofocus>
          <button class="search-close">
            <svg viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        `;

          searchBtnElement.parentNode.replaceChild(searchBox, searchBtnElement);

          const input = searchBox.querySelector('input');
          input.focus();

          const closeSearch = () => {
            const newSearchBtn = document.createElement('button');
            newSearchBtn.className = 'search-btn';
            newSearchBtn.id = 'searchBtn';
            newSearchBtn.innerHTML = '<img src="${pageContext.request.contextPath}/resources/assets/search.png" alt="Search">';
            searchBox.parentNode.replaceChild(newSearchBtn, searchBox);
            newSearchBtn.addEventListener('click', arguments.callee);
          };

          searchBox.querySelector('.search-close').addEventListener('click', closeSearch);

          input.addEventListener('blur', function () {
            setTimeout(() => {
              if (!document.activeElement.closest('.search-box-expanded')) {
                closeSearch();
              }
            }, 150);
          });

          searchBox.addEventListener('mousedown', function (e) {
            e.preventDefault();
            input.focus();
          });
        });
      }

      // Notification click
      const notificationIcon = document.getElementById('notificationIcon');
      if (notificationIcon) {
        notificationIcon.addEventListener('click', function () {
          window.location.href = '${pageContext.request.contextPath}/notifications';
        });
      }


      // Mobile Menu
      const navToggle = document.getElementById('navToggle');
      const navBar = document.getElementById('navBar');
      if (navToggle && navBar) {
        navToggle.addEventListener('click', function () {
          navBar.classList.toggle('active');
        });

        document.addEventListener('click', function (event) {
          if (!navBar.contains(event.target) && !navToggle.contains(event.target) && navBar.classList.contains('active')) {
            navBar.classList.remove('active');
          }
        });
      }
    });
  </script>

  <body>

    <header class="main-header">
      <div class="logo">
        <a href="/" target="_blank" style="text-decoration:none;">
          <img src="${pageContext.request.contextPath}/resources/assets/everlylogo.png" alt="Everly">
        </a>
      </div>

      <nav class="nav-bar" id="navBar">
        <a href="${pageContext.request.contextPath}/memories">Memories</a>
        <a href="${pageContext.request.contextPath}/journals">Journals</a>
        <a href="${pageContext.request.contextPath}/autographs">Autographs</a>
        <a href="${pageContext.request.contextPath}/groups">Groups</a>
        <a href="${pageContext.request.contextPath}/events">Events</a>
        <a href="${pageContext.request.contextPath}/feed">Feed</a>
      </nav>

      <div class="header-right">
        <button class="search-btn" id="searchBtn">
          <img src="${pageContext.request.contextPath}/resources/assets/search.png" alt="Search">
        </button>

        <div class="notification-icon" id="notificationIcon">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
            stroke-linejoin="round">
            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
          </svg>
        </div>

        <div class="profile-dropdown-container">
          <div class="profile-photo" id="profilePhoto">
            <div class="profile-initials">JD</div>
          </div>
          <div class="profile-dropdown" id="profileDropdown">
            <a href="${pageContext.request.contextPath}/editprofile">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
              Profile
            </a>
            <a href="${pageContext.request.contextPath}/settingsaccount">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="3"></circle>
                <path d="M12 1v6m0 6v6m9.22-9.22l-4.24 4.24m-5.96 0L6.78 9.78m12.44 0l-4.24 4.24m-5.96 0L6.78 14.22">
                </path>
              </svg>
              Settings
            </a>
            <a href="${pageContext.request.contextPath}/logoutservlet">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                <polyline points="16 17 21 12 16 7"></polyline>
                <line x1="21" y1="12" x2="9" y2="12"></line>
              </svg>
              Logout
            </a>
          </div>
        </div>
      </div>

      <button class="nav-toggle" id="navToggle">
        <span></span>
        <span></span>
        <span></span>
      </button>
    </header>
  </body>

  </html>