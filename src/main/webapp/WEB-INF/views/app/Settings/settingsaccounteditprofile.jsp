<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Edit Profile - Settings</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
        rel="stylesheet">
</head>

<body>
    <jsp:include page="/WEB-INF/views/public/header2.jsp" />
    <div class="settings-container">
        <h2>Settings</h2>
        <div class="settings-tabs">
            <a href="${pageContext.request.contextPath}/settingsaccount" class="tab active">Account</a>
            <a href="${pageContext.request.contextPath}/settingssubscription" class="tab">Subscription</a>
            <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy & Security</a>
            <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
        </div>

        <div class="back-option">
            <a href="${pageContext.request.contextPath}/settingsaccount" class="back-link">← Back to Account</a>
        </div>

        <div class="edit-profile-section">
            <h3>Edit Profile</h3>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <c:out value="${success}" />
                </div>
            </c:if>

            <form id="settingsEditProfileForm" action="${pageContext.request.contextPath}/editprofileservlet" method="post"
                enctype="multipart/form-data">
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-input" placeholder="Enter your username"
                        value="${fn:escapeXml(sessionScope.user.username)}">
                </div>

                

                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input" placeholder="Enter your email"
                        value="${fn:escapeXml(sessionScope.user.email)}" readonly
                        style="background-color: #f5f5f5;">
                    <p style="font-size: 12px; color: #777; margin-top: 5px;">Email cannot be changed</p>
                </div>

                <div class="form-group">
                    <label class="form-label">Bio</label>
                    <textarea name="bio" class="form-textarea"
                        placeholder="Tell us about yourself">${fn:escapeXml(sessionScope.user.bio)}</textarea>
                    <input type="text" name="username" class="form-input" placeholder="Enter your username"
                           value="${fn:escapeXml(sessionScope.user.joined_at)}">
                </div>

                <div class="form-group">
                    <label class="form-label-section">Password</label>

                    <div class="password-field">
                        <label class="form-sublabel">Current Password</label>
                        <div class="input-wrapper">
                            <input type="password" name="currentPassword" class="form-input-password"
                                placeholder="Enter current password">
                            <button type="button" class="toggle-password" data-target="currentPassword">
                                <svg class="eye-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                                <svg class="eye-off-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
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

                    <div class="password-field">
                        <label class="form-sublabel">New Password</label>
                        <div class="input-wrapper">
                            <input type="password" name="newPassword" id="newPassword" class="form-input-password"
                                placeholder="Enter new password">
                            <button type="button" class="toggle-password" data-target="newPassword">
                                <svg class="eye-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                                <svg class="eye-off-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
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

                    <div class="password-field">
                        <label class="form-sublabel">Confirm New Password</label>
                        <div class="input-wrapper">
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-input-password"
                                placeholder="Confirm new password">
                            <button type="button" class="toggle-password" data-target="confirmPassword">
                                <svg class="eye-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                                <svg class="eye-off-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
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

                    <!-- Password Constraints Message -->
                    <div id="password-constraints" class="password-constraints">
                        <p>Password must contain:</p>
                        <ul>
                            <li id="length">At least 8 characters</li>
                            <li id="uppercase">At least one uppercase letter (A-Z)</li>
                            <li id="lowercase">At least one lowercase letter (a-z)</li>
                            <li id="number">At least one number (0-9)</li>
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
    <jsp:include page="/WEB-INF/views/public/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const passwordInputs = ['newPassword', 'currentPassword', 'confirmPassword'];

            // Password visibility toggle
            function setupPasswordToggle(toggleBtn, passwordField) {
                toggleBtn.addEventListener('click', function () {
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
            const editProfileForm = document.getElementById('settingsEditProfileForm');
            const usernameField = document.querySelector('input[name="username"]');
            const bioField = document.querySelector('textarea[name="bio"]');
            const passwordConstraints = document.getElementById('password-constraints');
            const lengthConstraint = document.getElementById('length');
            const uppercaseConstraint = document.getElementById('uppercase');
            const lowercaseConstraint = document.getElementById('lowercase');
            const numberConstraint = document.getElementById('number');
            const specialConstraint = document.getElementById('special');

            function checkPasswordConstraints() {
                if (!newPasswordField) return;
                const password = newPasswordField.value;

                lengthConstraint.style.color = password.length >= 8 ? '#10b981' : '#ef4444';
                lengthConstraint.style.textDecoration = password.length >= 8 ? 'line-through' : 'none';

                const hasUppercase = /[A-Z]/.test(password);
                uppercaseConstraint.style.color = hasUppercase ? '#10b981' : '#ef4444';
                uppercaseConstraint.style.textDecoration = hasUppercase ? 'line-through' : 'none';

                const hasLowercase = /[a-z]/.test(password);
                lowercaseConstraint.style.color = hasLowercase ? '#10b981' : '#ef4444';
                lowercaseConstraint.style.textDecoration = hasLowercase ? 'line-through' : 'none';

                const hasNumber = /\d/.test(password);
                numberConstraint.style.color = hasNumber ? '#10b981' : '#ef4444';
                numberConstraint.style.textDecoration = hasNumber ? 'line-through' : 'none';

                passwordConstraints.style.display = password ? 'block' : 'none';
            }

            function checkPasswordMatch() {
                if (!newPasswordField || !confirmPasswordField) return;
                const password = newPasswordField.value;
                const confirmPassword = confirmPasswordField.value;

                if (confirmPassword) {
                    if (password === confirmPassword) {
                        confirmPasswordField.style.borderColor = '#10b981';
                    } else {
                        confirmPasswordField.style.borderColor = '#ef4444';
                    }
                } else {
                    confirmPasswordField.style.borderColor = '';
                }
            }

            if (newPasswordField) {
                newPasswordField.addEventListener('input', checkPasswordConstraints);
            }
            if (newPasswordField && confirmPasswordField) {
                confirmPasswordField.addEventListener('input', checkPasswordMatch);
            }

            if (newPasswordField && !newPasswordField.value) {
                passwordConstraints.style.display = 'none';
            }

            if (editProfileForm) {
                editProfileForm.addEventListener('submit', function (e) {
                    const username = usernameField ? (usernameField.value || '').trim() : '';
                    const bio = bioField ? (bioField.value || '').trim() : '';
                    const newPassword = newPasswordField ? (newPasswordField.value || '') : '';
                    const confirmPassword = confirmPasswordField ? (confirmPasswordField.value || '') : '';
                    const currentPassword = document.querySelector('input[name="currentPassword"]');
                    const currentPasswordValue = currentPassword ? (currentPassword.value || '') : '';

                    if (usernameField) usernameField.value = username;
                    if (bioField) bioField.value = bio;

                    if (usernameField && username.length > 0 && (username.length < 2 || username.length > 60)) {
                        e.preventDefault();
                        alert('Username must be between 2 and 60 characters.');
                        usernameField.focus();
                        return;
                    }

                    if (bioField && bio.length > 500) {
                        e.preventDefault();
                        alert('Bio must be 500 characters or less.');
                        bioField.focus();
                        return;
                    }

                    if (newPassword.trim().length > 0) {
                        if (!/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/.test(newPassword)) {
                            e.preventDefault();
                            alert('New password must be at least 8 characters and include uppercase, lowercase, and a number.');
                            newPasswordField.focus();
                            return;
                        }
                        if (newPassword !== confirmPassword) {
                            e.preventDefault();
                            alert('New password and confirm password do not match.');
                            confirmPasswordField.focus();
                            return;
                        }
                        if (!currentPasswordValue.trim()) {
                            e.preventDefault();
                            alert('Please enter your current password to change your password.');
                            currentPassword.focus();
                        }
                    }
                });
            }

        });
    </script>

</body>

</html>
