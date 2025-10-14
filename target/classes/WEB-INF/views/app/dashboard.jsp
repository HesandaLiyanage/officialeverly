<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Check if user is logged in
    String username = (String) session.getAttribute("username");
    if (username == null) {
        // Not logged in → redirect to login page
        response.sendRedirect("view?page=login");
        return;
    }
%>
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
    <h1>Welcome, <%= username %>!</h1>
    <p>This is your dashboard.</p>
    <a href="logout">Logout</a>
</div>
</body>
</html>
