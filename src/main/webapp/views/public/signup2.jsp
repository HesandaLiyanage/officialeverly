<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profile Setup - Everly</title>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/base.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/signup.css">
    </head>

    <body>

        <jsp:include page="header.jsp" />

        <main class="profile-container">
            <h1 class="profile-title">Tell us about Yourself</h1>

            <% String errorMessage=(String) request.getAttribute("errorMessage"); %>
                <% if (errorMessage !=null) { %>
                    <div class="error">
                        <%= errorMessage %>
                    </div>
                    <% } %>

                        <form class="profile-form" action="/signupservlet" method="post" id="profileForm">
                            <input type="hidden" name="step" value="2">

                            <div class="form-group">
                                <label for="name" class="profile-label">Name(This will be your username)</label>
                                <input type="text" id="name" name="name" class="profile-input"
                                    placeholder="Enter your full name" required>
                            </div>

                            <div class="form-group">
                                <label for="bio" class="profile-label">Bio (Optional)</label>
                                <textarea id="bio" name="bio" class="profile-textarea"
                                    placeholder="Tell us a bit about yourself..." rows="4"></textarea>
                            </div>

                            <div class="profile-actions">
                                <button type="button"
                                    onclick="window.location.href='${pageContext.request.contextPath}/signup'"
                                    class="btn btn-secondary">Back</button>
                                <button type="submit" class="btn btn-primary">Finish Signup</button>
                            </div>
                        </form>
        </main>

        <jsp:include page="footer.jsp" />

    </body>

    </html>