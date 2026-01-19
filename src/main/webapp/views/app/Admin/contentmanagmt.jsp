<%--
  Created by IntelliJ IDEA.
  User: hesandaliyanage
  Date: 2026-01-19
  Time: 10:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Content Management - Everly</title>
  <link rel="stylesheet" href="dashboard-styles.css">
</head>
<body>
<div class="header">
  <div class="logo" onclick="navigateTo('overview')">Everly</div>
  <div class="header-right">
    <div class="search-box">
      <input type="text" placeholder="Search..." id="searchInput">
      <span class="search-icon">⌕</span>
    </div>
    <button class="logout-btn" onclick="handleLogout()">Logout</button>
  </div>
</div>

<div class="container">
  <div class="sidebar">
    <div class="sidebar-title">Dashboard</div>
    <div class="nav-item" onclick="navigateTo('overview')">
      <span>○</span> Overview
    </div>
    <div class="nav-item" onclick="navigateTo('users')">
      <span>▢</span> User Management
    </div>
    <div class="nav-item active" onclick="navigateTo('content')">
      <span>▢</span> Content Management
    </div>
    <div class="nav-item" onclick="navigateTo('settings')">
      <span>▢</span> Settings
    </div>
  </div>

  <div class="main-content">
    <div class="page-header">
      <h1 class="page-title">Content Management</h1>
      <p class="page-subtitle">ADMIN DASHBOARD</p>
    </div>

    <div class="content-layout">
      <div class="posts-section">
        <h2 class="section-title">View All Posts</h2>
        <table class="posts-table">
          <thead>
          <tr>
            <th>Username</th>
            <th>Post Date</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>user1</td>
            <td>2024-04-20</td>
            <td><span class="status-badge status-approved">Approved</span></td>
            <td><button class="action-btn" onclick="handleAction('approve', 'user1')">Approve</button></td>
          </tr>
          <tr>
            <td>user2</td>
            <td>2024-04-18</td>
            <td><span class="status-badge status-pending">Pending</span></td>
            <td><button class="action-btn" onclick="handleAction('hide', 'user2')">Hide</button></td>
          </tr>
          <tr>
            <td>user3</td>
            <td>2024-04-17</td>
            <td><span class="status-badge status-hidden">Hidden</span></td>
            <td><button class="action-btn danger" onclick="handleAction('delete', 'user3')">Delete</button></td>
          </tr>
          <tr>
            <td>user4</td>
            <td>2024-04-15</td>
            <td><span class="status-badge status-deleted">Deleted</span></td>
            <td><button class="action-btn warning" onclick="handleAction('warn', 'user4')">Warn</button></td>
          </tr>
          </tbody>
        </table>
      </div>

      <div class="right-sidebar">
        <div class="filter-card">
          <h2 class="section-title">Search & Filter</h2>
          <input type="text" class="search-input" placeholder="Search by username" id="usernameSearch">

          <div class="checkbox-group">
            <div class="checkbox-item">
              <input type="checkbox" id="reported" checked>
              <label for="reported">Reported posts</label>
            </div>
            <div class="checkbox-item">
              <input type="checkbox" id="pending" checked>
              <label for="pending">Pending review</label>
            </div>
            <div class="checkbox-item">
              <input type="checkbox" id="deleted" checked>
              <label for="deleted">Deleted/Hidden posts</label>
            </div>
          </div>

          <label class="filter-label">Content type</label>
          <select class="dropdown">
            <option>Image/video/text</option>
            <option>Image only</option>
            <option>Video only</option>
            <option>Text only</option>
          </select>
        </div>

        <div class="logs-card">
          <h2 class="section-title">Logs / Activity History</h2>
          <div class="log-item">Post ID 1234 deleted</div>
          <div class="log-item">Post ID 5678 approved</div>
          <div class="log-item">User7 warned</div>
        </div>
      </div>
    </div>

    <div class="reported-section">
      <h2 class="section-title">Reported Content Review</h2>
      <div class="reported-item">
        <div class="user-avatar">👤</div>
        <div class="reported-content">
          <div class="reported-user">user4</div>
          <div class="reported-reason">Reason: Hate speech</div>
          <div class="reported-text">This content violates our community guidelines</div>
        </div>
        <button class="take-action-btn" onclick="takeAction('user4')">Take Action</button>
      </div>
    </div>
  </div>
</div>

<script>
  function navigateTo(page) {
    console.log(`Navigating to: ${page}`);

    if (page === 'overview') {
      alert('Navigating to Overview page...');
      // window.location.href = 'index.html';
    } else if (page === 'users') {
      alert('Navigating to User Management page...');
      // window.location.href = 'user-management.html';
    } else if (page === 'content') {
      console.log('Already on Content Management page');
    } else if (page === 'settings') {
      alert('Navigating to Settings page...');
      // window.location.href = 'settings.html';
    }
  }

  function handleLogout() {
    if (confirm('Are you sure you want to logout?')) {
      alert('Logging out...');
      // window.location.href = 'login.html';
    }
  }

  function handleAction(action, username) {
    const actions = {
      'approve': `Approving post from ${username}...`,
      'hide': `Hiding post from ${username}...`,
      'delete': `Deleting post from ${username}...`,
      'warn': `Sending warning to ${username}...`
    };
    alert(actions[action] || 'Action performed');
  }

  function takeAction(username) {
    alert(`Opening action panel for ${username}'s reported content...`);
    // Show modal or navigate to detailed review page
  }

  // Search functionality
  document.getElementById('searchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
      const searchTerm = e.target.value;
      if (searchTerm) {
        alert(`Searching for: ${searchTerm}`);
      }
    }
  });

  document.getElementById('usernameSearch').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    console.log(`Filtering by username: ${searchTerm}`);
    // Filter table rows based on search term
  });

  // Filter checkboxes
  document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
    checkbox.addEventListener('change', function() {
      console.log(`Filter ${this.id}: ${this.checked}`);
      // Apply filters to the posts table
    });
  });
</script>
</body>
</html>
