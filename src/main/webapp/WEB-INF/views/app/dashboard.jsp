<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty sessionScope.username}">
    <c:redirect url="view?page=login" />
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        .container { max-width: 600px; margin: auto; text-align: center; }
        a { text-decoration: none; color: white; background: #007BFF; padding: 10px 20px; border-radius: 5px; }
        a:hover { background: #0056b3; }
    </style>
</head>
<body>
<div class="container">
    <h1>Welcome, ${fn:escapeXml(sessionScope.username)}!</h1>
    <p>This is your dashboard.</p>
    <a href="logout">Logout</a>
</div>
</body>
</html>
