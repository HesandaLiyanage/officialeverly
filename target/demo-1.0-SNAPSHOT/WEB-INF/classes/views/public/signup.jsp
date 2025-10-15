<%--
  Created by IntelliJ IDEA.
  User: Hesanda Liyanage
  Date: 09/09/2025
  Time: 14:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signup Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        textarea {
            height: 80px;
            resize: vertical;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .success {
            color: green;
            margin-top: 10px;
        }
        .error {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<jsp:include page="header.jsp" />
<body>
<h2>Sign Up</h2>
<form id="signupForm">
    <div class="form-group">
        <label for="username">Name:</label>
        <input type="text" id="username" name="username" required>
    </div>

    <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
    </div>

    <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
    </div>

    <div class="form-group">
        <label for="bio">Bio:</label>
        <textarea id="bio" name="bio" placeholder="Tell us about yourself..."></textarea>
    </div>

    <button type="submit">Sign Up</button>
    <div id="message"></div>
</form>

<script>
    const form = document.getElementById('signupForm');
    const messageDiv = document.getElementById('message');

    form.addEventListener('submit', function(e) {
        e.preventDefault();

        // Get form data
        const formData = new FormData(form);
        const userData = {
            username: formData.get('username'),
            email: formData.get('email'),
            password: formData.get('password'),
            bio: formData.get('bio')
        };

        // Simple validation
        if (!userData.username || !userData.email || !userData.password) {
            showMessage('Please fill in all required fields.', 'error');
            return;
        }

        // Email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(userData.email)) {
            showMessage('Please enter a valid email address.', 'error');
            return;
        }

        // Password length validation
        if (userData.password.length < 6) {
            showMessage('Password must be at least 6 characters long.', 'error');
            return;
        }

        // Store data (in a real app, this would be sent to a server)
        console.log('User Data:', userData);

        showMessage('Account created successfully!', 'success');
        form.reset();
    });

    function showMessage(text, type) {
        messageDiv.textContent = text;
        messageDiv.className = type;
    }
</script>
</body>
<jsp:include page="footer.jsp" />
</html>
