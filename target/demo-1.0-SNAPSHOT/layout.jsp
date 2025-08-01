<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String layoutType = (String) request.getAttribute("layoutType");
  String contentPage = (String) request.getAttribute("contentPage");
%>

<!DOCTYPE html>
<html>
<head>
  <title>My Web App</title>
  <!-- You can dynamically load different CSS based on layoutType -->
  <c:if test="${layoutType == 'auth'}">
    <link rel="stylesheet" href="resources/login.css">
  </c:if>
  <c:if test="${layoutType == 'dashboard'}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/login.css">

  </c:if>
  c:if test="${layoutType == 'login'}">
  <link rel="stylesheet" href="resources/login.css">
  </c:if>
</head>
<body>

<jsp:include page="/fragments/header.jsp"/>

<!-- Dynamically include content -->
<jsp:include page="${contentPage}" />

<jsp:include page="/fragments/footer.jsp"/>

</body>
</html>
