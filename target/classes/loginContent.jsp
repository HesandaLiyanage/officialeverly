<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- No need to load CSS here - it's loaded in layout.jsp -->
<main class="login-container">
  <h1>Log in to Everly</h1>
  <p>Don't have an account? <a href="${pageContext.request.contextPath}/view/signup">Create one.</a></p>

  <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">
    <label for="email">Email address</label>
    <input type="email" id="email" name="email" required>

    <label for="password">Password</label>
    <input type="password" id="password" name="password" required>

    <button type="submit" class="btn login-btn">Log In</button>
  </form>

  <div class="divider"><span>OR</span></div>

  <form action="${pageContext.request.contextPath}/google-login" method="post">
    <button type="submit" class="google-login-btn">
      <img src="${pageContext.request.contextPath}/resources/icons/google-icon.svg" alt="Google" />
      Continue with Google
    </button>
  </form>

  <div class="extra-links">
    <a href="${pageContext.request.contextPath}/view/signup">Create a new account</a>
    <a href="${pageContext.request.contextPath}/forgot-password">Forgot password?</a>
    <a href="${pageContext.request.contextPath}/view/landing">← Back to Everly.com</a>
  </div>
</main>