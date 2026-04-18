<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vault - Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/vault1.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
      rel="stylesheet">
  </head>

  <body>

    <jsp:include page="/WEB-INF/views/public/header2.jsp" />

    <main class="vault-container">
      <div class="vault-icon">
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
          stroke-linecap="round" stroke-linejoin="round">
          <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
          <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
        </svg>
      </div>

      <h1>Enter Vault</h1>
      <p>Enter your password to access protected content</p>

      <!-- Password Entry Section -->
      <div id="passwordSection" class="password-section">
        <c:if test="${not empty errorMessage}">
          <div class="error" style="display: block;">
            ${errorMessage}
          </div>
        </c:if>

                <form id="vaultForm" class="vault-form" action="${pageContext.request.contextPath}/vaultentries"
                  method="POST">
                  <div class="form-group">
                    <label for="vaultPassword">Vault Password</label>
                    <div class="input-wrapper">
                      <input type="password" id="vaultPassword" name="vaultPassword" placeholder="Enter vault password"
                        required>
                      <button type="button" class="toggle-password" id="togglePassword">
                        <svg class="eye-icon" width="20" height="20" viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                          <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                        <svg class="eye-off-icon" width="20" height="20" viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                          style="display: none;">
                          <path
                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                          </path>
                          <line x1="1" y1="1" x2="23" y2="23"></line>
                        </svg>
                      </button>
                    </div>
                  </div>

                  <button type="submit" class="btn btn-primary">Unlock Vault</button>
                </form>
      </div>
    </main>

    <jsp:include page="/WEB-INF/views/public/footer.jsp" />

    <script>
      document.addEventListener('DOMContentLoaded', function () {
        const vaultPassword = document.getElementById('vaultPassword');
        const togglePassword = document.getElementById('togglePassword');

        // Password visibility toggle
        if (togglePassword && vaultPassword) {
          togglePassword.addEventListener('click', function () {
            const eyeIcon = togglePassword.querySelector('.eye-icon');
            const eyeOffIcon = togglePassword.querySelector('.eye-off-icon');

            if (vaultPassword.type === 'password') {
              vaultPassword.type = 'text';
              eyeIcon.style.display = 'none';
              eyeOffIcon.style.display = 'block';
            } else {
              vaultPassword.type = 'password';
              eyeIcon.style.display = 'block';
              eyeOffIcon.style.display = 'none';
            }
          });
        }
      });
    </script>

  </body>

  </html>
