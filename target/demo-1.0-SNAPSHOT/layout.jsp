<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  String layoutType = (String) request.getAttribute("layoutType");
  String contentPage = (String) request.getAttribute("contentPage");
%>

<!DOCTYPE html>
<html>
<head>
  <title>My Web App</title>

  <!-- Base CSS that's always loaded -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/base.css">

  <!-- Conditionally load CSS based on layoutType -->
  <c:if test="${layoutType == 'auth'}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/login.css">
  </c:if>

  <c:if test="${layoutType == 'dashboard'}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/dashboard.css">
  </c:if>

  <c:if test="${layoutType == 'public'}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/public.css">
  </c:if>

  <c:if test="${layoutType == 'feed'}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/feed.css">
  </c:if>

</head>
<body class="${layoutType}-layout">

<jsp:include page="/fragments/header.jsp"/>

<!-- Dynamically include content -->
<jsp:include page="${contentPage}" />

<jsp:include page="/fragments/footer.jsp"/>

</body>
</html>