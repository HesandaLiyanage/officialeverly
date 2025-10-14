<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Password Reset Successful</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/login.css">
</head>
<body>
<jsp:include page="/fragments/header.jsp" />
<div class="container">
    <div class="icon">✉️</div>
    <h2>Password Reset Successful</h2>
    <p class="message">
        Your password has been successfully reset.<br>
        A confirmation email has been sent to your registered email address.<br>
        You can now login with your new password</p>

    <form action="${pageContext.request.contextPath}/view?page=login">
        <button type="submit" class="btn">Go Back To Login</button>
    </form>
</div>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
