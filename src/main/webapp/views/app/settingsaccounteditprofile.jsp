<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.demo.web.model.user" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Profile - Settings</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<jsp:include page="../public/header2.jsp" />
<div class="settings-container">
  <h2>Settings</h2>
  <div class="settings-tabs">
    <a href="${pageContext.request.contextPath}/settingsaccount" class="tab active">Account</a>
    <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy & Security</a>
    <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
    <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
    <a href="${pageContext.request.contextPath}/settingsappearance" class="tab">Appearance</a>
  </div>

  <div class="back-option">
    <a href="${pageContext.request.contextPath}/settingsaccount" class="back-link">← Back to Account</a>
  </div>

  <div class="edit-profile-section">
    <h3>Edit Profile</h3>

    <%
      user currentUser = (user) session.getAttribute("user");
      if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
      }

      String errorMsg = (String) request.getAttribute("error");
      String successMsg = (String) request.getAttribute("success");
    %>

    <% if (errorMsg != null) { %>
    <div class="alert alert-error">
      <%= errorMsg %>
    </div>
    <% } %>

    <% if (successMsg != null) { %>
    <div class="alert alert-success">
      <%= successMsg %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/editprofileservlet" method="post" enctype="multipart/form-data">
      <div class="form-group">
        <label class="form-label">Username</label>
        <input type="text" name="username" class="form-input" placeholder="Enter your username"
               value="<%= currentUser.getUsername() != null ? currentUser.getUsername() : "" %>">
      </div>

      <div class="form-group">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="form-input" placeholder="Enter your email"
               value="<%= currentUser.getEmail() != null ? currentUser.getEmail() : "" %>" readonly style="background-color: #f5f5f5;">
        <p style="font-size: 12px; color: #777; margin-top: 5px;">Email cannot be changed</p>
      </div>

      <div class="form-group">
        <label class="form-label">Bio</label>
        <textarea name="bio" class="form-textarea" placeholder="Tell us about yourself"><%= currentUser.getBio() != null ? currentUser.getBio() : "" %></textarea>
      </div>

      <div class="form-group">
        <label class="form-label">Profile Picture</label>
        <div class="profile-picture-preview">
          <%
            String profilePic = currentUser.getProfilePictureUrl();
            if (profilePic != null && !profilePic.isEmpty()) {
          %>
          <img src="${pageContext.request.contextPath}/uploads/<%= profilePic %>"
               alt="Profile" style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
          <% } else { %>
          <div class="profile-avatar"></div>
          <% } %>
        </div>
        <label for="profilePic" class="upload-picture-btn">Upload New Picture</label>
        <input type="file" id="profilePic" name="profilePicture" accept="image/*" style="display: none;">
      </div>

      <div class="form-group">
        <label class="form-label-section">Password</label>

        <div class="password-field">
          <label class="form-sublabel">Current Password</label>
          <div class="input-wrapper">
            <input type="password" name="currentPassword" class="form-input-password" placeholder="Enter current password">
            <button type="button" class="toggle-password" data-target="currentPassword">
              <svg class="eye-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
              <svg class="eye-off-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
              </svg>
            </button>
          </div>
        </div>

        <div class="password-field">
          <label class="form-sublabel">New Password</label>
          <div class="input-wrapper">
            <input type="password" name="newPassword" id="newPassword" class="form-input-password" placeholder="Enter new password">
            <button type="button" class="toggle-password" data-target="newPassword">
              <svg class="eye-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
              <svg class="eye-off-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
              </svg>
            </button>
          </div>
        </div>

        <div class="password-field">
          <label class="form-sublabel">Confirm New Password</label>
          <div class="input-wrapper">
            <input type="password" name="confirmPassword" id="confirmPassword" class="form-input-password" placeholder="Confirm new password">
            <button type="button" class="toggle-password" data-target="confirmPassword">
              <svg class="eye-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
              <svg class="eye-off-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
              </svg>
            </button>
          </div>
        </div>

        <!-- Password Constraints Message -->
        <div id="password-constraints" class="password-constraints">
          <p>Password must contain:</p>
          <ul>
            <li id="length">At least 8 characters</li>
            <li id="uppercase">At least one uppercase letter (A-Z)</li>
            <li id="lowercase">At least one lowercase letter (a-z)</li>
            <li id="number">At least one number (0-9)</li>
            <li id="special">At least one special character (!@#$%^&*(),.?":{}|<>)</li>
          </ul>
        </div>

      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/settingsaccount" class="cancel-btn">Cancel</a>
        <button type="submit" class="save-changes-btn btn btn-primary">Save Changes</button>
      </div>
    </form>
  </div>
</div>
<jsp:include page="../public/footer.jsp" />

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const passwordInputs = ['newPassword', 'currentPassword', 'confirmPassword'];

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

    // Initialize toggles for each password field
    passwordInputs.forEach(inputId => {
      const inputField = document.getElementById(inputId);
      if (inputField) {
        const toggleBtn = document.querySelector(`button[data-target="${inputId}"]`);
        if (toggleBtn) {
          setupPasswordToggle(toggleBtn, inputField);
        }
      }
    });

    // Password constraints validation
    const newPasswordField = document.getElementById('newPassword');
    const confirmPasswordField = document.getElementById('confirmPassword');
    const passwordConstraints = document.getElementById('password-constraints');
    const lengthConstraint = document.getElementById('length');
    const uppercaseConstraint = document.getElementById('uppercase');
    const lowercaseConstraint = document.getElementById('lowercase');
    const numberConstraint = document.getElementById('number');
    const specialConstraint = document.getElementById('special');

    function checkPasswordConstraints() {
      if (!newPasswordField) return; // Exit if new password field doesn't exist
      const password = newPasswordField.value;

      // Check length
      lengthConstraint.style.color = password.length >= 8 ? '#10b981' : '#ef4444';
      lengthConstraint.style.textDecoration = password.length >= 8 ? 'line-through' : 'none';

      // Check for uppercase
      const hasUppercase = /[A-Z]/.test(password);
      uppercaseConstraint.style.color = hasUppercase ? '#10b981' : '#ef4444';
      uppercaseConstraint.style.textDecoration = hasUppercase ? 'line-through' : 'none';

      // Check for lowercase
      const hasLowercase = /[a-z]/.test(password);
      lowercaseConstraint.style.color = hasLowercase ? '#10b981' : '#ef4444';
      lowercaseConstraint.style.textDecoration = hasLowercase ? 'line-through' : 'none';

      // Check for number
      const hasNumber = /\d/.test(password);
      numberConstraint.style.color = hasNumber ? '#10b981' : '#ef4444';
      numberConstraint.style.textDecoration = hasNumber ? 'line-through' : 'none';

      // Check for special character
      const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
      specialConstraint.style.color = hasSpecial ? '#10b981' : '#ef4444';
      specialConstraint.style.textDecoration = hasSpecial ? 'line-through' : 'none';

      // Show/hide constraints div based on if new password field has content
      passwordConstraints.style.display = password ? 'block' : 'none';
    }

    function checkPasswordMatch() {
      if (!newPasswordField || !confirmPasswordField) return;
      const password = newPasswordField.value;
      const confirmPassword = confirmPasswordField.value;

      if (confirmPassword) {
        if (password === confirmPassword) {
          confirmPasswordField.style.borderColor = '#10b981'; // Green border
        } else {
          confirmPasswordField.style.borderColor = '#ef4444'; // Red border
        }
      } else {
        confirmPasswordField.style.borderColor = ''; // Reset border
      }
    }

    if (newPasswordField) {
      newPasswordField.addEventListener('input', checkPasswordConstraints);
    }
    if (newPasswordField && confirmPasswordField) {
      confirmPasswordField.addEventListener('input', checkPasswordMatch);
    }

    // Initially hide the constraints if the password field is empty
    if (newPasswordField && !newPasswordField.value) {
      passwordConstraints.style.display = 'none';
    }

  });
</script>

</body>
</html>