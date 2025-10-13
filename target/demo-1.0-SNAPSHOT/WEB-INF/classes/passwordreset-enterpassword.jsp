<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Everly</title>
    <link rel="stylesheet" href="login2.css">
</head>
<body>
<!-- Include your header here -->
<%@ include file="fragments/header.jsp" %>

<div class="reset-password-container">
    <h1>Reset your password</h1>

    <form action="resetPassword" method="POST" class="login-form">
        <!-- Hidden token field for security -->
        <input type="hidden" name="token" value="${param.token}">

        <input type="password"
               name="newPassword"
               placeholder="New password"
               required
               minlength="8"
               id="newPassword">

        <input type="password"
               name="confirmPassword"
               placeholder="Confirm new password"
               required
               minlength="8"
               id="confirmPassword">

        <button type="submit" class="btn login-btn">Go Back To Login</button>
    </form>
</div>

<!-- Include your footer here -->
<%@ include file="fragments/footer.jsp" %>

<script>
    // Password validation
    document.querySelector('.login-form').addEventListener('submit', function(e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        // Check if passwords match
        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert('Passwords do not match. Please try again.');
            return;
        }

        // Check password strength (minimum requirements)
        if (newPassword.length < 8) {
            e.preventDefault();
            alert('Password must be at least 8 characters long.');
            return;
        }

        // Optional: Add more password strength requirements
        const hasUpperCase = /[A-Z]/.test(newPassword);
        const hasLowerCase = /[a-z]/.test(newPassword);
        const hasNumbers = /\d/.test(newPassword);

        if (!hasUpperCase || !hasLowerCase || !hasNumbers) {
            const confirmed = confirm('Your password should contain uppercase letters, lowercase letters, and numbers for better security. Continue anyway?');
            if (!confirmed) {
                e.preventDefault();
                return;
            }
        }
    });

    // Real-time password match validation
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = this.value;

        if (confirmPassword && newPassword !== confirmPassword) {
            this.style.borderColor = '#ff6b6b';
            this.style.backgroundColor = '#ffe6e6';
        } else {
            this.style.borderColor = '';
            this.style.backgroundColor = '#E8EDF5';
        }
    });

    // Display success/error messages if they exist
    <% if (request.getAttribute("successMessage") != null) { %>
    alert('<%= request.getAttribute("successMessage") %>');
    // Redirect to login page after successful password reset
    setTimeout(function() {
        window.location.href = 'login.jsp';
    }, 2000);
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
    alert('<%= request.getAttribute("errorMessage") %>');
    <% } %>

    // Check if token is expired or invalid
    <% if (request.getAttribute("tokenError") != null) { %>
    alert('This password reset link has expired or is invalid. Please request a new one.');
    window.location.href = 'forgot-password.jsp';
    <% } %>
</script>
</body>
</html>