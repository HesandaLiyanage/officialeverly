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
  <link rel="stylesheet" href="../resources/css/header2.css">
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Playwrite+US+Trad&family=Plus+Jakarta+Sans:wght@400;500&display=swap" rel="stylesheet">
</head>
<body>

<header class="main-header">
  <!-- Logo -->
  <div class="logo">
    <img src="Everly.png" alt="Everly">
  </div>

  <!-- Navigation Bar -->
  <nav class="nav-bar">
    <a href="#">Memories</a>
    <a href="#">Journals</a>
    <a href="#">Autographs</a>
    <a href="#">Groups</a>
    <a href="#">Events</a>
    <a href="#">Feed</a>
  </nav>

  <!-- Right Section -->
  <div class="header-right">
    <!-- Search Bar -->
    <div class="search-box">
      <div class="search-icon"><img src="search.png"></div>
      <input type="text" placeholder="Search...">
    </div>

    <!-- Notification Icon -->
    <div class="notification-icon"><img src="noti.png"></div>

    <!-- Profile Photo -->
    <div class="profile-photo"></div>
  </div>
</header>

</body>
</html>

