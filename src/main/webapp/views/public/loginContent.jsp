<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Everly</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
      rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/base.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/login.css">
  </head>

  <body>

    <jsp:include page="header.jsp" />

    <main class="login-container">
      <h1>Log in to Everly</h1>
      <p>Sign in to continue preserving your memories</p>

      <% String infoMessage=(String) request.getAttribute("infoMessage"); %>
        <% String deactivatedParam=request.getParameter("deactivated"); %>
          <% if (infoMessage !=null || "true" .equals(deactivatedParam)) { %>
            <div class="error" style="background-color: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb;">
              <%= infoMessage !=null ? infoMessage
                : "Your account has been deactivated. You can reactivate it by logging in again." %>
            </div>
            <% } %>

              <% String errorMessage=(String) request.getAttribute("errorMessage"); %>
                <% if (errorMessage !=null) { %>
                  <div class="error">
                    <%= errorMessage %>
                  </div>
                  <% } %>

                    <form action="${pageContext.request.contextPath}/loginservlet" method="POST" class="login-form">
                      <!-- Preserve redirect URL if present -->
                      <% String redirectUrl=request.getParameter("redirect"); %>
                        <% if (redirectUrl !=null && !redirectUrl.isEmpty()) { %>
                          <input type="hidden" name="redirect" value="<%= redirectUrl %>">
                          <% } %>

                            <div class="form-group">
                              <label for="email">Username</label>
                              <input type="text" id="email" name="username" placeholder="your@email.com" required>
                            </div>

                            <div class="form-group">
                              <label for="password">Password</label>
                              <div class="input-wrapper">
                                <input type="password" id="password" name="password" placeholder="Enter your password"
                                  required>
                                <button type="button" class="toggle-password" id="togglePassword">
                                  <svg class="eye-icon" width="20" height="20" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                  </svg>
                                  <svg class="eye-off-icon" width="20" height="20" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round" style="display: none;">
                                    <path
                                      d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                                    </path>
                                    <line x1="1" y1="1" x2="23" y2="23"></line>
                                  </svg>
                                </button>
                              </div>
                            </div>

                            <label for="rememberme">
                              <input type="checkbox" id="rememberme" name="rememberme">
                              Remember me
                            </label>
                            <button type="submit" class="btn btn-primary">Log In</button>
                    </form>

                    <div class="divider"><span>OR</span></div>

                    <%-- <form action="/googlelogin" method="post">--%>
                      <%-- <button type="submit" class="google-login-btn">--%>
                        <%-- <img src="${pageContext.request.contextPath}/resources/assets/googleicon.png"
                          alt="Google" />--%>
                        <%-- Continue with Google--%>
                          <%-- </button>--%>
                            <%-- </form>--%>

                              <div class="extra-links">
                                <a href="${pageContext.request.contextPath}/signup">Create a new account</a>
                                <a href="${pageContext.request.contextPath}/forgotpassword">Forgot password?</a>
                                <a href="/">Back to Everly.com</a>
                              </div>
    </main>

    <jsp:include page="footer.jsp" />

    <script>
      document.addEventListener('DOMContentLoaded', function () {
        const password = document.getElementById('password');
        const togglePassword = document.getElementById('togglePassword');

        // Password visibility toggle
        function setupPasswordToggle(toggleBtn, passwordField) {
          toggleBtn.addEventListener('click', function () {
            const eyeOffIcon = toggleBtn.querySelector('.eye-icon');
            const eyeIcon = toggleBtn.querySelector('.eye-off-icon');


            if (passwordField.type === 'password') {
              passwordField.type = 'text';
              eyeIcon.style.display = 'none';
              eyeOffIcon.style.display = 'block';
            } else {
              passwordField.type = 'password';
              eyeIcon.style.display = 'block';
              eyeOffIcon.style.display = 'none';
            }
          });
        }

        setupPasswordToggle(togglePassword, password);
      });
    </script>

  </body>

  </html>