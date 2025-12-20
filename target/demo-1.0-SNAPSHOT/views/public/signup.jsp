<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign Up - Everly</title>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/base.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/signup.css">
    </head>

    <body>

        <jsp:include page="header.jsp" />

        <main class="signup-container">
            <h1>Create Account</h1>
            <p>Join Everly and start preserving your memories</p>

            <% String errorMessage=(String) request.getAttribute("errorMessage"); %>
                <% if (errorMessage !=null) { %>
                    <div class="error">
                        <%= errorMessage %>
                    </div>
                    <% } %>

                        <form class="signup-form" action="/signupservlet" method="post" id="signupForm">
                            <input type="hidden" name="step" value="1">

                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" placeholder="your@email.com" required>
                            </div>

                            <div class="form-group">
                                <label for="password">Password</label>
                                <div class="input-wrapper">
                                    <input type="password" id="password" name="password"
                                        placeholder="Create a strong password" required>
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
                                <div class="password-constraints">
                                    <div class="constraint" id="lengthCheck">
                                        <span class="constraint-icon"></span>
                                        <span>At least 8 characters</span>
                                    </div>
                                    <div class="constraint" id="uppercaseCheck">
                                        <span class="constraint-icon"></span>
                                        <span>One uppercase letter</span>
                                    </div>
                                    <div class="constraint" id="numberCheck">
                                        <span class="constraint-icon"></span>
                                        <span>One number</span>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <div class="input-wrapper">
                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                        placeholder="Re-enter your password" required>
                                    <button type="button" class="toggle-password" id="toggleConfirmPassword">
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

                            <div class="terms">
                                <input type="checkbox" id="terms" name="terms" required>
                                <label for="terms">
                                    I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
                                </label>
                            </div>

                            <button type="submit" class="btn btn-primary">Next</button>
                        </form>

                        <div class="extra-links">
                            <a href="${pageContext.request.contextPath}/login">Already have an account? Log in</a>
                        </div>
        </main>

        <jsp:include page="footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');
                const togglePassword = document.getElementById('togglePassword');
                const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');

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

                setupPasswordToggle(togglePassword, password);
                setupPasswordToggle(toggleConfirmPassword, confirmPassword);

                // Password validation
                const lengthCheck = document.getElementById('lengthCheck');
                const uppercaseCheck = document.getElementById('uppercaseCheck');
                const numberCheck = document.getElementById('numberCheck');

                password.addEventListener('input', function () {
                    const value = password.value;

                    // Length check
                    if (value.length >= 8) {
                        lengthCheck.classList.add('valid');
                    } else {
                        lengthCheck.classList.remove('valid');
                    }

                    // Uppercase check
                    if (/[A-Z]/.test(value)) {
                        uppercaseCheck.classList.add('valid');
                    } else {
                        uppercaseCheck.classList.remove('valid');
                    }

                    // Number check
                    if (/[0-9]/.test(value)) {
                        numberCheck.classList.add('valid');
                    } else {
                        numberCheck.classList.remove('valid');
                    }
                });
            });
        </script>

    </body>

    </html>