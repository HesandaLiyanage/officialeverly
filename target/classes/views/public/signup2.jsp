<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Setup - Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/signup.css">
</head>
<jsp:include page="header.jsp" />
<body>

<main class="profile-container">
    <h1 class="profile-title">Tell us about Yourself</h1>

    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
    <div class="error"><%= errorMessage %></div>
    <% } %>

    <form class="profile-form" action="${pageContext.request.contextPath}/signup" method="post">
        <input type="hidden" name="step" value="2">

        <label for="name" class="profile-label">Name</label>
        <input type="text" id="name" name="name" class="profile-input" placeholder="Enter your name" required>

        <label for="bio" class="profile-label">Bio</label>
        <textarea id="bio" name="bio" class="profile-textarea" placeholder="Write a short bio..." rows="4"></textarea>

        <div class="profile-actions">
            <button type="submit" class="btn btn-primary">Finish Signup</button>
            <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/signup'" class="btn btn-secondary">Back</button>
        </div>
    </form>
</main>

<jsp:include page="footer.jsp" />
</body>
</html>
