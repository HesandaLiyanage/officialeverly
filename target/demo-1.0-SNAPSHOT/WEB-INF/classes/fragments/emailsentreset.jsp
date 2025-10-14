<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Password Reset Successful</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/login.css">
    <script>
        let countdown = 30;
        let intervalId;

        function startCountdown() {
            intervalId = setInterval(function() {
                if (countdown > 0) {
                    document.getElementById("resendText").innerText = "Resend in " + countdown + "s";
                    countdown--;
                } else {
                    clearInterval(intervalId);
                    document.getElementById("resendLink").innerHTML = '<a href="ResendMailServlet" class="resend">Resend email</a>';
                }
            }, 1000);
        }

        window.onload = function() {
            startCountdown();
        };
    </script>
</head>
<body>
<jsp:include page="/fragments/header.jsp" />
<div class="container">
    <div class="icon">✉️</div>
    <h2>Check your inbox</h2>
    <p class="message">
        We've sent a password reset link to your email address.<br>
        Please check your inbox and follow the instructions to reset your password.
    </p>

    <div id="resendLink">
        <p class="resend-text">
            Didn't get the mail? <span id="resendText"></span>
        </p>
    </div>

    <form action="${pageContext.request.contextPath}/view?page=login">
        <button type="submit" class="btn">Go Back To Login</button>
    </form>
</div>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
