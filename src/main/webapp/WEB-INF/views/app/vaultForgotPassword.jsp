<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Vault Password</title>
    <link rel="stylesheet" type="text/css" href="resources/css/vault.css">
</head>
<body>
<div class="vault-container">
    <div class="vault-box">
        <div class="vault-icon">
            🔑
        </div>
        <h1>Forgot your Vault password?</h1>
        <p>
            Enter the email address associated with your account and we'll send you a verification code to reset your Vault password.
        </p>
        <form action="SendResetLink" method="post">
            <div class="form-group">
                <input type="email" name="email" placeholder="Email" required>
            </div>
            <button type="submit" class="btn-save">Send Reset Link</button>
        </form>
    </div>
</div>
</body>
</html>
