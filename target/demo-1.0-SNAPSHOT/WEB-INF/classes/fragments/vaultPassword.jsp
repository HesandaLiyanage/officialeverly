<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Enter Passcode</title>
    <link rel="stylesheet" type="text/css" href="resources/css/vault.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="vault-container">
    <div class="vault-box">
        <div class="vault-icon">
            🔐
        </div>
        <h1>Enter passcode</h1>
        <form action="UnlockVault" method="post">
            <div class="form-group">
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn-save">Unlock</button>
        </form>
        <small><a href="forgotPasscode.jsp" class="link-secondary">Forgot passcode?</a></small>
        <p>This is a private space. Your entries are encrypted and only accessible with your passcode.</p>
    </div>
</div>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
