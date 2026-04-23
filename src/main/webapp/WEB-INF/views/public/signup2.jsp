<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

        <jsp:include page="/WEB-INF/views/public/header.jsp" />

        <main class="profile-container">
            <h1 class="profile-title">Tell us about Yourself</h1>

            <c:if test="${not empty errorMessage}">
                <div class="error">
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>

                        <form class="profile-form" action="${pageContext.request.contextPath}/signupservlet"
                            method="post" id="profileForm">
                            <input type="hidden" name="step" value="2">

                            <div class="form-group">
                                <label for="name" class="profile-label">Name</label>
                                <input type="text" id="name" name="name" class="profile-input"
                                    placeholder="Enter your full name" required>
                            </div>

                            <div class="form-group">
                                <label for="password" class="profile-label">Password</label>
                                <input type="password" id="password" name="password" class="profile-input"
                                    placeholder="Re-enter your password" required autocomplete="new-password">
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword" class="profile-label">Confirm Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="profile-input"
                                    placeholder="Confirm your password" required autocomplete="new-password">
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

        <jsp:include page="/WEB-INF/views/public/footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const profileForm = document.getElementById('profileForm');
                if (!profileForm) return;

                const nameInput = document.getElementById('name');
                const passwordInput = document.getElementById('password');
                const confirmPasswordInput = document.getElementById('confirmPassword');
                const bioInput = document.getElementById('bio');

                profileForm.addEventListener('submit', function (e) {
                    const name = (nameInput.value || '').trim();
                    const bio = (bioInput.value || '').trim();

                    nameInput.value = name;
                    bioInput.value = bio;

                    if (name.length < 2 || name.length > 60) {
                        e.preventDefault();
                        alert('Name must be between 2 and 60 characters.');
                        nameInput.focus();
                        return;
                    }

                    if (passwordInput.value.length < 8) {
                        e.preventDefault();
                        alert('Password must be at least 8 characters long.');
                        passwordInput.focus();
                        return;
                    }

                    if (passwordInput.value !== confirmPasswordInput.value) {
                        e.preventDefault();
                        alert('Passwords do not match.');
                        confirmPasswordInput.focus();
                        return;
                    }

                    if (bio.length > 500) {
                        e.preventDefault();
                        alert('Bio must be 500 characters or less.');
                        bioInput.focus();
                    }
                });
            });
        </script>

    </body>

    </html>
