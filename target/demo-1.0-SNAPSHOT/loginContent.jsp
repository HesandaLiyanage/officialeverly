<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

<html>
<header>
  <jsp:include page="/header.jsp" />
</header>
<body>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}resources/login.css">
<main class="login-container">
  <h1>Log in to Everly</h1>
  <p>Don't have an account? <a href="${pageContext.request.contextPath}/view?page=signup">Create one.</a></p>

  <form action="${pageContext.request.contextPath}/login" method="POST" class="login-form">
    <label for="email">Email address</label>
    <input id="email" name="username" required>

    <label for="password">Password</label>
    <input type="password" id="password" name="password" required>

    <button type="submit" class="btn login-btn">Log In</button>
  </form>

  <div class="divider"><span>OR</span></div>

  <form action="/google-login" method="post">
    <button type="submit" class="google-login-btn">
      <img src="${pageContext.request.contextPath}/resources/assets/googleicon.png" alt="Google" />
      Continue with Google
    </button>
  </form>

  <div class="extra-links">
    <a href="${pageContext.request.contextPath}/signup">Create a new account</a>
    <a href="${pageContext.request.contextPath}/forgotpassword">Forgot password?</a>
    <a href="/">Back to Everly.com</a>
  </div>
</main>
</body>
<footer>
  <jsp:include page="/footer.jsp" />
</footer>
</html>