<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Footer Component</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400&display=swap" rel="stylesheet">
</head>
<body>
<!-- Demo content to show footer positioning -->
<%--<div style="flex: 1; padding: 40px; text-align: center; color: #333;">--%>
<%--  <h1>Website Content</h1>--%>
<%--  <p>This is demo content to show the footer positioning. The footer will appear at the bottom.</p>--%>
<%--</div>--%>

<!-- Footer Component -->
<footer class="footer">
  <div class="footer-inner">
    <nav class="footer-links">
      <div class="footer-link-wrapper left">
        <a href="#" class="footer-link">Terms of Service</a>
      </div>
      <div class="footer-link-wrapper center">
        <a href="#" class="footer-link">Privacy Policy</a>
      </div>
      <div class="footer-link-wrapper right">
        <a href="#" class="footer-link">Contact Us</a>
      </div>
    </nav>
  </div>
  <div class="footer-copyright">
    Everly. All rights reserved.
  </div>
</footer>
</body>
</html>