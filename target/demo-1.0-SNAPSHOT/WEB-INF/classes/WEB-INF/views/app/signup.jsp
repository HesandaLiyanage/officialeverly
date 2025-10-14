<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/signup.css">

<main class="signup-container">
    <h1>Create your account</h1>

    <form action="${pageContext.request.contextPath}/view?page=signup2.jsp" method="GET" class="signup-form">
        <label for="email">Email</label>
        <input type="email" id="email" name="email" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <label for="confirm-password">Confirm password</label>
        <input type="password" id="confirm-password" name="confirmPassword" required>

        <div class="terms">
            <input type="checkbox" id="terms" name="terms" required>
            <label for="terms">
                I agree to the <a href="${pageContext.request.contextPath}/terms-of-service">Terms of Service</a>
                and <a href="${pageContext.request.contextPath}/privacy-policy">Privacy Policy</a>
            </label>
        </div>

        <button type="submit" class="btn signup-btn">Next</button>
    </form>

    <div class="extra-links">
        <a href="${pageContext.request.contextPath}/view?page=login.jsp">Already have an account? Log in</a>
    </div>
</main>
