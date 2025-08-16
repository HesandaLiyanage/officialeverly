<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<div class="login-container">--%>
<%--  <h2>Login</h2>--%>
<%--  <form action="login" method="post">--%>
<%--    <div>--%>
<%--      <label for="username">Username:</label>--%>
<%--      <input type="text" id="username" name="username" required>--%>
<%--    </div>--%>
<%--    <div>--%>
<%--      <label for="password">Password:</label>--%>
<%--      <input type="password" id="password" name="password" required>--%>
<%--    </div>--%>
<%--    <div>--%>
<%--      <button type="submit">Login</button>--%>
<%--    </div>--%>
<%--  </form>--%>
<%--</div>--%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/login.css">
<main class="login-container">
  <h1>Log in to Everly</h1>
  <p>Don't have an account? <a href="/create-account">Create one.</a></p>

  <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">
    <label for="email">Email address</label>
    <input id="email" name="email" required>

    <label for="password">Password</label>
    <input type="password" id="password" name="password" required>

    <button type="submit" class="btn login-btn">Log In</button>
  </form>

  <div class="divider"><span>OR</span></div>

  <form action="/google-login" method="post">
    <button type="submit" class="google-login-btn">
      <img src="/static/icons/google-icon.svg" alt="Google" />
      Continue with Google
    </button>
  </form>

  <div class="extra-links">
    <a href="/create-account">Create a new account</a>
    <a href="/forgot-password">Forgot password?</a>
    <a href="/">← Back to Everly.com</a>
  </div>
</main>
