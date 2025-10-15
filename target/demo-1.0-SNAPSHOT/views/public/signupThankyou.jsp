<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thank You - Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/signup.css">
</head>
<header><jsp:include page="header2.jsp" /></header>
<body>

<main class="thankyou-container">
    <h1 class="thank-you-title">Thank you for signing up!</h1>
    <p class="thank-you-text">
        Please check your email inbox for a verification link.
        We've sent an email to the address you provided. Click the link
        to complete your registration and start preserving your memories with Everly.
    </p>
    <div class="thankyou-actions">
        <button id="resendEmailBtn" class="btn btn-primary">Resend Email</button>
        <a href="${pageContext.request.contextPath}/WEB-INF/views/public/loginContent.jspblic/loginContent.jsp" class="btn btn-secondary">Back to log in</a>
    </div>
</main>


<script>
    document.getElementById('resendEmailBtn').addEventListener('click', function() {
        this.textContent = 'Sending...';
        this.disabled = true;

        setTimeout(() => {
            this.textContent = 'Email Sent!';
            this.classList.add('success');

            setTimeout(() => {
                this.textContent = 'Resend Email';
                this.disabled = false;
                this.classList.remove('success');
            }, 3000);
        }, 1500);
    });
</script>
<footer><jsp:include page="footer.jsp" /></footer>
</body>
</html>
