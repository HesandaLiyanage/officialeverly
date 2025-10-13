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
<body>

<header class="main-header">
  <!-- Logo -->
  <div class="logo">
    <img src="${pageContext.request.contextPath}/resources/assets/everlylogo.png" alt="Everly">
  </div>

  <!-- Navigation Bar -->
  <nav class="nav-bar">
    <a href="${pageContext.request.contextPath}/view?page=memories">Memories</a>
    <a href="${pageContext.request.contextPath}/view?page=journals">Journals</a>
    <a href="${pageContext.request.contextPath}/view?page=autographs">Autographs</a>
    <a href="${pageContext.request.contextPath}/view?page=groups">Groups</a>
    <a href="${pageContext.request.contextPath}/view?page=events">Events</a>
    <a href="${pageContext.request.contextPath}/view?page=feed">Feed</a>
  </nav>

  <!-- Right Section -->
  <div class="header-right">
    <!-- Search Bar -->
    <div class="search-box">
      <div class="search-icon"><img src="${pageContext.request.contextPath}/resources/assets/search.png"></div>
      <input type="text" placeholder="Search...">
    </div>

    <!-- Notification Icon -->
    <div class="notification-icon"><img src="${pageContext.request.contextPath}/resources/assets/notification.png"></div>

    <!-- Profile Photo -->
    <div class="profile-photo"></div>
  </div>
</header>

</body>
</html>

