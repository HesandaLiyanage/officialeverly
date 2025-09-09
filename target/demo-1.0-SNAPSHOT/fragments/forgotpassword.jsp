<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password | Everly</title>
    <link rel="stylesheet" href="css/login.css"> <!-- adjust path if needed -->
</head>
<body>

<div class="login-container">
    <h1>Forgot password?</h1>
    <p>Enter the email address associated with your account and we'll send you a link to reset your password.</p>

    <form action="sendResetLink" method="post" class="login-form">
        <input type="email" name="email" placeholder="Email address" required>
        <button type="submit" class="btn login-btn">Send Reset Link</button>
    </form>

    <div class="extra-links">
        <a href="login.jsp">Remember your password? Sign in</a>
        <a href="login.jsp">&larr; Back</a>
    </div>
</div>

</body>
</html>
