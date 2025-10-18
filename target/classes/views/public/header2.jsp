<%--
  Created by IntelliJ IDEA.
  User: nethm
  Date: 8/18/2025
  Time: 11:50 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Header Layout</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header2.css">
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Playwrite+US+Trad&family=Plus+Jakarta+Sans:wght@400;500&display=swap" rel="stylesheet">
</head>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    console.log("DOM fully loaded and parsed");

    const profilePhoto = document.getElementById('profilePhoto');
    const profileDropdown = document.getElementById('profileDropdown');

    if (profilePhoto && profileDropdown) {
      console.log("Profile elements found");

      profilePhoto.addEventListener('click', function(event) {
        event.stopPropagation(); // Prevent event from bubbling up immediately
        profileDropdown.classList.toggle('active');
        console.log("Profile photo clicked, toggled dropdown");
      });

      // Close dropdown if clicked outside
      document.addEventListener('click', function(event) {
        // Check if the click is outside the dropdown container
        if (!profileDropdown.contains(event.target) && event.target !== profilePhoto) {
          profileDropdown.classList.remove('active');
          console.log("Clicked outside, closed dropdown");
        }
      });
    } else {
      console.error("Profile photo or dropdown element not found in the DOM.");
    }

    // Search Button Expand/Contract Functionality
    const searchBtn = document.getElementById('searchBtn');
    if (searchBtn) {
      console.log("Search button found");

      searchBtn.addEventListener('click', function(event) {
        event.stopPropagation(); // Prevent event from bubbling up immediately

        const searchBtnElement = this;
        const searchBox = document.createElement('div');
        searchBox.className = 'search-box-expanded';
        searchBox.innerHTML = `
          <div class="search-icon"><img src="${pageContext.request.contextPath}/resources/assets/search.png" alt="Search"></div>
          <input type="text" placeholder="Search..." autofocus>
          <button class="search-close">×</button>
        `;

        // Replace the button with the search box
        searchBtnElement.parentNode.replaceChild(searchBox, searchBtnElement);

        // Focus the input
        const input = searchBox.querySelector('input');
        input.focus();

        // Handle closing the search box
        const closeSearch = () => {
          const newSearchBtn = document.createElement('button');
          newSearchBtn.className = 'search-btn';
          newSearchBtn.id = 'searchBtn';
          newSearchBtn.innerHTML = '<img src="${pageContext.request.contextPath}/resources/assets/search.png" alt="Search">';
          searchBox.parentNode.replaceChild(newSearchBtn, searchBox);
          // Re-add the click listener to the new button
          newSearchBtn.addEventListener('click', arguments.callee);
        };

        // Close on 'X' click
        searchBox.querySelector('.search-close').addEventListener('click', closeSearch);

        // Close on blur (if user clicks elsewhere)
        input.addEventListener('blur', function() {
          // Use a timeout to allow click handlers on other elements to fire first
          setTimeout(() => {
            if (!document.activeElement.closest('.search-box-expanded')) {
              closeSearch();
            }
          }, 100);
        });

        // Prevent blur from closing immediately if clicking inside the new search box
        searchBox.addEventListener('mousedown', function(e) {
          e.preventDefault(); // Prevent blur from firing if clicking inside
          input.focus();
        });
      });
    } else {
      console.error("Search button element not found in the DOM.");
    }

    // Mobile Menu Toggle
    const navToggle = document.getElementById('navToggle');
    const navBar = document.getElementById('navBar');
    if (navToggle && navBar) {
      console.log("Mobile menu elements found");

      navToggle.addEventListener('click', function() {
        navBar.classList.toggle('active');
      });

      // Close menu when clicking outside
      document.addEventListener('click', function(event) {
        if (!navBar.contains(event.target) && !navToggle.contains(event.target) && navBar.classList.contains('active')) {
          navBar.classList.remove('active');
        }
      });
    } else {
      console.error("Mobile menu toggle or nav bar element not found in the DOM.");
    }
  });
</script>
<body>

<header class="main-header">
  <!-- Logo -->
  <div class="logo">
    <img src="${pageContext.request.contextPath}/resources/assets/everlylogo.png" alt="Everly">
  </div>

  <!-- Navigation Bar -->
  <nav class="nav-bar" id="navBar">
    <a href="${pageContext.request.contextPath}/memories">Memories</a>
    <a href="${pageContext.request.contextPath}/journals">Journals</a>
    <a href="${pageContext.request.contextPath}/autographs">Autographs</a>
    <a href="${pageContext.request.contextPath}/groups">Groups</a>
    <a href="${pageContext.request.contextPath}/events">Events</a>
    <a href="${pageContext.request.contextPath}/feed">Feed</a>
  </nav>

  <!-- Right Section -->
  <div class="header-right">
    <!-- Search Button (Small Icon) -->
    <button class="search-btn" id="searchBtn">
      <img src="${pageContext.request.contextPath}/resources/assets/search.png" alt="Search">
    </button>

    <!-- Notification Icon -->
    <div class="notification-icon"><img src="${pageContext.request.contextPath}/resources/assets/notification.png"></div>

    <!-- Profile Photo with Dropdown -->
    <div class="profile-dropdown-container">
      <div class="profile-photo" id="profilePhoto"></div>
      <!-- Dropdown Menu -->
      <div class="profile-dropdown" id="profileDropdown">
        <a href="${pageContext.request.contextPath}/settingsaccounteditprofile">Profile</a>
        <a href="${pageContext.request.contextPath}/settingsaccount">Settings</a>
        <a href="${pageContext.request.contextPath}/logoutservlet">Logout</a>
      </div>
    </div>
  </div>

  <!-- Hamburger Menu Toggle Button -->
  <button class="nav-toggle" id="navToggle">
    <span></span>
    <span></span>
    <span></span>
  </button>
</header>
</body>
</html>