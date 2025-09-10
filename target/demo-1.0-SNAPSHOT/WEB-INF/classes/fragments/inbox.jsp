<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Everly</title>
    <link rel="stylesheet" href="login2.css">
</head>
<body>
<!-- Include your header here -->
<%@ include file="header.jsp" %>

<div class="login-container">
    <!-- Lock icon with refresh arrow -->
    <div class="forgot-icon">
        <svg width="80" height="80" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
            <!-- Circular arrow -->
            <path d="M75 50C75 63.8071 63.8071 75 50 75C36.1929 75 25 63.8071 25 50C25 36.1929 36.1929 25 50 25C58.2843 25 65.6569 28.9289 70.7107 35"
                  stroke="#4A5568" stroke-width="3" fill="none" stroke-linecap="round"/>
            <!-- Arrow head -->
            <path d="M65 30L70.7107 35L75 30" stroke="#4A5568" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
            <!-- Lock body -->
            <rect x="40" y="45" width="20" height="15" rx="2" fill="#9CA3AF"/>
            <!-- Lock shackle -->
            <path d="M45 45V40C45 37.2386 47.2386 35 50 35C52.7614 35 55 37.2386 55 40V45"
                  stroke="#9CA3AF" stroke-width="2" fill="none" stroke-linecap="round"/>
        </svg>
    </div>

    <h1>Check your inbox</h1>
    <p>We've sent a password reset link to your email address. Please check your inbox and follow the instructions to reset your
        password.</p>


    <div class="extra-links">
        <a href="login.jsp"> Didn't got the mail? Resend in 30s</a>
    </div>

    <div class="login-form">
        <button type="submit" class="btn login-btn">Go back to login</button>
    </div>
</div>

<!-- Include your footer here -->
<%@ include file="footer.jsp" %>


</body>
</html>