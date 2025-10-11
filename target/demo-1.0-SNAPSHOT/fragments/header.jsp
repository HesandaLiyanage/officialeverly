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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/landing.css">
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
    <a href="${pageContext.request.contextPath}/view?page=whyeverly">Why Everly?</a>
    <a href="${pageContext.request.contextPath}/view?page=plans">Plans</a>
    <a href="${pageContext.request.contextPath}/view?page=aboutus">About Us</a>
    <a href="${pageContext.request.contextPath}/view?page=privacy">Privacy</a>
  </nav>

  <!-- Right Section -->
  <div class="header-right">
    <button class="header-btn login-btn">Login</button>
    <button class="header-btn signup-btn">Sign Up</button>
  </div>
</header>

</body>
</html>

