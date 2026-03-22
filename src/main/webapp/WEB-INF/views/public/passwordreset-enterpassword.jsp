<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Everly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/login.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/public/header.jsp" />

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
    <c:if test="${not empty successMessage}">
    alert('${fn:escapeXml(successMessage)}');
    // Redirect to login page after successful password reset
    setTimeout(function() {
        window.location.href = '${pageContext.request.contextPath}/login';
    }, 2000);
    </c:if>

    <c:if test="${not empty errorMessage}">
    alert('${fn:escapeXml(errorMessage)}');
    </c:if>

    // Check if token is expired or invalid
    <c:if test="${not empty tokenError}">
    alert('This password reset link has expired or is invalid. Please request a new one.');
    window.location.href = '${pageContext.request.contextPath}/forgotpassword';
    </c:if>
</script>
<jsp:include page="/WEB-INF/views/public/footer.jsp" />
</body>
</html>