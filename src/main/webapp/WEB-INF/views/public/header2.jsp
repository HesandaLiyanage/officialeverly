<%-- Authenticated Header Component - included via jsp:include, no HTML wrapper --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String headerUsername = (String) session.getAttribute("username");
  String headerInitials = "EV";
  if (headerUsername != null && !headerUsername.trim().isEmpty()) {
    String[] nameParts = headerUsername.trim().split("\\s+");
    if (nameParts.length >= 2) {
      headerInitials = (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1)).toUpperCase();
    } else {
      headerInitials = headerUsername.substring(0, Math.min(2, headerUsername.length())).toUpperCase();
    }
  }
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/ui-alerts.js"></script>
<style>
  /* Notification bell badge */
  .notification-icon {
    position: relative;
  }
  .notif-badge {
    position: absolute;
    top: -4px;
    right: -4px;
    background: #ef4444;
    color: white;
    font-size: 10px;
    font-weight: 700;
    min-width: 16px;
    height: 16px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 4px;
    border: 2px solid white;
    font-family: "Plus Jakarta Sans", sans-serif;
    animation: badgePulse 2s ease-in-out infinite;
  }
  .notif-badge.hidden {
    display: none;
  }
  @keyframes badgePulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.1); }
  }
</style>

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
    <div class="notification-icon" id="notificationIcon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
      </svg>
      <span class="notif-badge hidden" id="notifBadge">0</span>
    </div>

    <div class="profile-dropdown-container">
      <div class="profile-photo" id="profilePhoto">
        <div class="profile-initials"><%= headerInitials %></div>
      </div>
      <div class="profile-dropdown" id="profileDropdown">
        <a href="${pageContext.request.contextPath}/settingsaccount">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="3"></circle>
            <path d="M12 1v6m0 6v6m9.22-9.22l-4.24 4.24m-5.96 0L6.78 9.78m12.44 0l-4.24 4.24m-5.96 0L6.78 14.22"></path>
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

<script>
  document.addEventListener('DOMContentLoaded', function () {
    var profilePhoto = document.getElementById('profilePhoto');
    var profileDropdown = document.getElementById('profileDropdown');

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

    // Notification click
    var notificationIcon = document.getElementById('notificationIcon');
    if (notificationIcon) {
      notificationIcon.addEventListener('click', function () {
        window.location.href = '${pageContext.request.contextPath}/notifications';
      });
    }

    // Fetch unread count for badge
    function fetchUnreadCount() {
      fetch('${pageContext.request.contextPath}/api/notifications/unreadcount')
        .then(function(r) { return r.json(); })
        .then(function(data) {
          var badge = document.getElementById('notifBadge');
          if (badge) {
            if (data.count > 0) {
              badge.textContent = data.count > 99 ? '99+' : data.count;
              badge.classList.remove('hidden');
            } else {
              badge.classList.add('hidden');
            }
          }
        })
        .catch(function() {});
    }
    fetchUnreadCount();
    setInterval(fetchUnreadCount, 30000);

    // Mobile Menu
    var navToggle = document.getElementById('navToggle');
    var navBar = document.getElementById('navBar');
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
