<%-- Public Header Component - included via jsp:include, no HTML wrapper --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://fonts.googleapis.com/css2?family=Playwrite+US+Trad&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header2.css">
<script src="${pageContext.request.contextPath}/resources/js/ui-alerts.js"></script>

<header class="main-header">
  <div class="logo">
    <a href="/" target="_blank" style="text-decoration:none;">
      <img src="${pageContext.request.contextPath}/resources/assets/everlylogo.png" alt="Everly">
    </a>
  </div>

  <nav class="nav-bar">
    <a href="${pageContext.request.contextPath}/whyeverly">Why Everly?</a>
    <a href="${pageContext.request.contextPath}/plans">Plans</a>
    <a href="${pageContext.request.contextPath}/aboutus">About Us</a>
    <a href="${pageContext.request.contextPath}/privacy">Privacy</a>
  </nav>

  <div class="header-right">
    <a href="${pageContext.request.contextPath}/login" class="header-btn login-btn">Login</a>
    <a href="${pageContext.request.contextPath}/signup" class="header-btn signup-btn">Sign Up</a>
  </div>
</header>
