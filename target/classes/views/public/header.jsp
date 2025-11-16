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
    <a href="/" target="_blank" style="text-decoration:none;">

    <img src="${pageContext.request.contextPath}/resources/assets/everlylogo.png" alt="Everly">
    </a>
  </div>

  <!-- Navigation Bar -->
  <nav class="nav-bar">
    <a href="${pageContext.request.contextPath}/whyeverly">Why Everly?</a>
    <a href="${pageContext.request.contextPath}/plans">Plans</a>
    <a href="${pageContext.request.contextPath}/aboutus">About Us</a>
    <a href="${pageContext.request.contextPath}/privacy">Privacy</a>
  </nav>

  <!-- Right Section -->
  <div class="header-right">
    <a href="${pageContext.request.contextPath}/login" class="header-btn login-btn">Login</a>
    <a href="${pageContext.request.contextPath}/signup" class="header-btn signup-btn">Sign Up</a>
  </div>
</header>

</body>
</html>

