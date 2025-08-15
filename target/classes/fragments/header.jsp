<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Everly - ${param.pageTitle != null ? param.pageTitle : 'Welcome'}</title>

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      background-color: #f8fafc;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .navbar {
      background: white;
      border-bottom: 1px solid #e2e8f0;
      padding: 0 24px;
      height: 64px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      position: sticky;
      top: 0;
      z-index: 100;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .navbar-left {
      display: flex;
      align-items: center;
      gap: 32px;
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 20px;
      font-weight: 600;
      color: #1a202c;
      text-decoration: none;
      cursor: pointer;
    }

    .logo-icon {
      width: 24px;
      height: 24px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 6px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .logo-icon::before {
      content: "▲";
      color: white;
      font-size: 12px;
      font-weight: bold;
    }

    .nav-links {
      display: flex;
      align-items: center;
      gap: 24px;
      list-style: none;
    }

    .nav-links li {
      position: relative;
    }

    .nav-links a {
      color: #4a5568;
      text-decoration: none;
      font-size: 15px;
      font-weight: 500;
      padding: 8px 16px;
      border-radius: 8px;
      transition: all 0.2s ease;
      cursor: pointer;
    }

    .nav-links a:hover {
      color: #2d3748;
      background-color: #f7fafc;
    }

    .nav-links a.active {
      color: #667eea;
      background-color: #edf2f7;
    }

    .navbar-right {
      display: flex;
      align-items: center;
      gap: 16px;
    }

    .search-container {
      position: relative;
    }

    .search-input {
      background: #f7fafc;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      padding: 8px 12px 8px 36px;
      font-size: 14px;
      width: 240px;
      outline: none;
      transition: all 0.2s ease;
    }

    .search-input:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
      background: white;
    }

    .search-icon {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: #a0aec0;
      width: 16px;
      height: 16px;
    }

    .notification-btn {
      background: none;
      border: none;
      padding: 8px;
      border-radius: 8px;
      cursor: pointer;
      color: #4a5568;
      transition: all 0.2s ease;
      position: relative;
    }

    .notification-btn:hover {
      background-color: #f7fafc;
    }

    .notification-dot {
      position: absolute;
      top: 6px;
      right: 6px;
      width: 8px;
      height: 8px;
      background: #f56565;
      border-radius: 50%;
      border: 2px solid white;
    }

    .profile-btn {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      overflow: hidden;
      cursor: pointer;
      border: 2px solid #e2e8f0;
      transition: all 0.2s ease;
      position: relative;
    }

    .profile-btn:hover {
      border-color: #667eea;
    }

    .profile-btn img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .profile-dropdown {
      position: absolute;
      top: 100%;
      right: 0;
      background: white;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
      min-width: 200px;
      z-index: 1000;
      display: none;
      margin-top: 8px;
    }

    .profile-dropdown.show {
      display: block;
    }

    .profile-dropdown a {
      display: block;
      padding: 12px 16px;
      color: #4a5568;
      text-decoration: none;
      font-size: 14px;
      transition: background-color 0.2s ease;
    }

    .profile-dropdown a:hover {
      background-color: #f7fafc;
    }

    .profile-dropdown .divider {
      height: 1px;
      background: #e2e8f0;
      margin: 8px 0;
    }

    #main {
      flex: 1;
      padding: 20px;
    }

    /* Hide user-only elements by default */
    .user-only {
      display: none;
    }

    /* Mobile responsiveness */
    @media (max-width: 768px) {
      .navbar {
        padding: 0 16px;
      }

      .nav-links {
        display: none;
      }

      .search-input {
        width: 180px;
      }

      .navbar-left {
        gap: 16px;
      }
    }
  </style>
</head>
<body>

<%-- Navigation Header Component --%>
<nav class="navbar">
  <div class="navbar-left">
    <a href="${pageContext.request.contextPath}/view?page=login" class="logo">
      <div class="logo-icon"></div>
      Everly
    </a>

    <%-- Show navigation links only if user is logged in --%>
    <% if (session.getAttribute("user") != null) { %>
    <ul class="nav-links">
      <li>
        <a href="${pageContext.request.contextPath}/view?page=home"
           class="nav-link <%= "home".equals(request.getParameter("activePage")) ? "active" : "" %>"
           data-page="home">Home</a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/view?page=groups"
           class="nav-link <%= "groups".equals(request.getParameter("activePage")) ? "active" : "" %>"
           data-page="groups">Groups</a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/view?page=events"
           class="nav-link <%= "events".equals(request.getParameter("activePage")) ? "active" : "" %>"
           data-page="events">Events</a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/view?page=announcements"
           class="nav-link <%= "announcements".equals(request.getParameter("activePage")) ? "active" : "" %>"
           data-page="announcements">Announcements</a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/view?page=journal"
           class="nav-link <%= "journal".equals(request.getParameter("activePage")) ? "active" : "" %>"
           data-page="journal">Journal</a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/view?page=autographs"
           class="nav-link <%= "autographs".equals(request.getParameter("activePage")) ? "active" : "" %>"
           data-page="autographs">Autographs</a>
      </li>
    </ul>
    <% } %>
  </div>

  <div class="navbar-right">
    <%-- Show search only if user is logged in --%>
    <% if (session.getAttribute("user") != null) { %>
    <div class="search-container">
      <svg class="search-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
      </svg>
      <form action="${pageContext.request.contextPath}/search" method="GET" style="display: inline;">
        <input type="text" class="search-input" placeholder="Search"
               name="q" value="${param.q}" id="searchInput">
      </form>
    </div>
    <% } %>

    <%-- User authentication section --%>
    <%
      Object user = session.getAttribute("user");
      if (user != null) {
    %>
    <!-- Logged in user -->
    <button class="notification-btn" id="notificationBtn"
            onclick="window.location.href='${pageContext.request.contextPath}/notifications'">
      <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
      </svg>
      <%-- You can add notification dot logic here if needed --%>
    </button>

    <div class="profile-btn" id="profileBtn">
      <img src="${pageContext.request.contextPath}/images/default-avatar.jpg"
           alt="User Profile" />

      <div class="profile-dropdown" id="profileDropdown">
        <a href="${pageContext.request.contextPath}/view?page=profile">
          <strong>User Profile</strong><br>
          <small style="color: #718096;">user@example.com</small>
        </a>
        <div class="divider"></div>
        <a href="${pageContext.request.contextPath}/view?page=profile">Profile Settings</a>
        <a href="${pageContext.request.contextPath}/view?page=preferences">Preferences</a>
        <a href="${pageContext.request.contextPath}/view?page=help">Help & Support</a>
        <div class="divider"></div>
        <a href="${pageContext.request.contextPath}/logout">Sign Out</a>
      </div>
    </div>
    <% } else { %>
    <!-- Not logged in -->
    <a href="${pageContext.request.contextPath}/view?page=login"
       style="color: #9A74D8; text-decoration: none; font-weight: 500; margin-right: 16px;">Login</a>
    <a href="${pageContext.request.contextPath}/view?page=register"
       style="background: #9A74D8; color: white; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-family: Inter; font-weight: 500;">Sign Up</a>
    <% } %>
  </div>
</nav>

<script>
  // Navigation functionality
  document.addEventListener('DOMContentLoaded', function() {
    // Profile dropdown toggle
    const profileBtn = document.getElementById('profileBtn');
    const profileDropdown = document.getElementById('profileDropdown');

    if (profileBtn && profileDropdown) {
      profileBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        profileDropdown.classList.toggle('show');
      });

      // Close dropdown when clicking outside
      document.addEventListener('click', function() {
        profileDropdown.classList.remove('show');
      });

      // Prevent dropdown from closing when clicking inside it
      profileDropdown.addEventListener('click', function(e) {
        e.stopPropagation();
      });
    }

    // Search functionality
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
      searchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
          this.form.submit();
        }
      });
    }

    // Auto-submit search form with debouncing (optional)
    let searchTimeout;
    if (searchInput) {
      searchInput.addEventListener('input', function() {
        clearTimeout(searchTimeout);
        const query = this.value;

        if (query.length > 2) {
          searchTimeout = setTimeout(() => {
            // You can implement live search here if needed
            console.log('Live search for:', query);
          }, 500);
        }
      });
    }
  });
</script>