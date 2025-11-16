<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vault - Everly</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/vault1.css">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<jsp:include page="../public/header2.jsp" />

<main class="vault-container">
  <div class="vault-icon">
    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
      <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
    </svg>
  </div>

  <h1>Enter Vault</h1>
  <p>Enter your password to access protected content</p>

  <!-- Password Entry Section -->
  <div id="passwordSection" class="password-section">
    <div class="error" id="errorMessage" style="display: none;"></div>

    <form id="vaultForm" class="vault-form">
      <div class="form-group">
        <label for="vaultPassword">Vault Password</label>
        <div class="input-wrapper">
          <input type="password" id="vaultPassword" placeholder="Enter vault password" required>
          <button type="button" class="toggle-password" id="togglePassword">
            <svg class="eye-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
              <circle cx="12" cy="12" r="3"></circle>
            </svg>
            <svg class="eye-off-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
              <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
              <line x1="1" y1="1" x2="23" y2="23"></line>
            </svg>
          </button>
        </div>
      </div>

      <button type="submit" class="btn btn-primary">Unlock Vault</button>
    </form>
  </div>

  <!-- Navigation Section (Hidden by default) -->
  <div id="navigationSection" class="navigation-section" style="display: none;">
    <div class="success-message">
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <polyline points="20 6 9 17 4 12"></polyline>
      </svg>
      <p>Vault Unlocked Successfully!</p>
    </div>

    <div class="vault-options">
      <a href="${pageContext.request.contextPath}/vaultmemories" class="vault-option-card">
        <div class="option-icon">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
            <circle cx="8.5" cy="8.5" r="1.5"></circle>
            <polyline points="21 15 16 10 5 21"></polyline>
          </svg>
        </div>
        <h3>Memories</h3>
        <p>View your protected photos and videos</p>
      </a>

      <a href="${pageContext.request.contextPath}/vaultjournals" class="vault-option-card">
        <div class="option-icon">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
          </svg>
        </div>
        <h3>Journals</h3>
        <p>Read your private journal entries</p>
      </a>
    </div>
  </div>
</main>

<jsp:include page="../public/footer.jsp" />

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const vaultForm = document.getElementById('vaultForm');
    const vaultPassword = document.getElementById('vaultPassword');
    const togglePassword = document.getElementById('togglePassword');
    const errorMessage = document.getElementById('errorMessage');
    const passwordSection = document.getElementById('passwordSection');
    const navigationSection = document.getElementById('navigationSection');

    const CORRECT_PASSWORD = 'Admin1234';

    // Password visibility toggle
    function setupPasswordToggle(toggleBtn, passwordField) {
      toggleBtn.addEventListener('click', function() {
        const eyeIcon = toggleBtn.querySelector('.eye-icon');
        const eyeOffIcon = toggleBtn.querySelector('.eye-off-icon');

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

    setupPasswordToggle(togglePassword, vaultPassword);

    // Handle form submission
    vaultForm.addEventListener('submit', function(e) {
      e.preventDefault();

      const enteredPassword = vaultPassword.value;

      // Hide any previous error messages
      errorMessage.style.display = 'none';

      // Check if password is correct
      if (enteredPassword === CORRECT_PASSWORD) {
        // Success! Show navigation section
        passwordSection.style.display = 'none';
        navigationSection.style.display = 'block';
      } else {
        // Wrong password - show error
        errorMessage.textContent = 'Incorrect password. Please try again.';
        errorMessage.style.display = 'block';

        // Clear the password field
        vaultPassword.value = '';

        // Shake animation is handled by CSS
        // Focus back on password field
        vaultPassword.focus();
      }
    });

    // Clear error message when user starts typing
    vaultPassword.addEventListener('input', function() {
      if (errorMessage.style.display === 'block') {
        errorMessage.style.display = 'none';
      }
    });
  });
</script>

</body>
</html>