<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Everly</title>
    <link rel="stylesheet" href="resources/login.css">
</head>
<body>
<!-- Include your header here -->
<%@ include file="fragments/header.jsp" %>

<div class="login-container">
    <!-- Lock icon with refresh arrow -->
    <div class="forgot-icon">

    </div>

    <h1>Password Reset</h1>
    <p>Your Password has been successfully Reset !!!!
        You can now login with your new password</p>

    <div class="login-form">
        <button type="submit" class="btn login-btn">Go Back to Login</button>
    </div>
</div>

<!-- Include your footer here -->
<%@ include file="fragments/footer.jsp" %>


</body>
</html>