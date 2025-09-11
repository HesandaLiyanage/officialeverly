<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Everly</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>
<!--hehe -->
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

    <h1>Forgot password?</h1>
    <p>Enter the email address associated with your account<br>and we'll send you a link to reset your password.</p>

    <form action="forgotPassword" method="POST" class="login-form">
        <input type="email"
               name="email"
               placeholder="Email address"
               required
               autocomplete="email"
               value="${param.email != null ? param.email : ''}">

        <button type="submit" class="btn login-btn">Send Reset Link</button>
    </form>

    <div class="extra-links">
        <a href="login.jsp">Remember your password? Sign in</a>
    </div>

    <div class="back-link">
        <a href="login.jsp">← Back</a>
    </div>
</div>

</body>
</html>