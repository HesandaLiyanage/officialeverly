<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Blocked Users - Everly</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/blockedusers.css">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<jsp:include page="../public/header2.jsp" />

<main class="blocked-container">
  <h1>Blocked Users</h1>
  <p>Manage the users you've blocked from your feed</p>

  <% String successMessage = (String) request.getAttribute("successMessage"); %>
  <% if (successMessage != null) { %>
  <div class="success">
    ✓ <%= successMessage %>
  </div>
  <% } %>

  <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
  <% if (errorMessage != null) { %>
  <div class="error">
    ⚠ <%= errorMessage %>
  </div>
  <% } %>

  <%
    List<?> blockedUsers = (List<?>) request.getAttribute("blockedUsers");
    if (blockedUsers != null && !blockedUsers.isEmpty()) {
  %>

  <div class="user-list">
    <%
      for (Object userObj : blockedUsers) {
        // Assuming you have a User object with getters
        // Adjust property access based on your actual User class
        java.lang.reflect.Method getIdMethod = userObj.getClass().getMethod("getUserId");
        java.lang.reflect.Method getNameMethod = userObj.getClass().getMethod("getDisplayName");
        java.lang.reflect.Method getUsernameMethod = userObj.getClass().getMethod("getUsername");
        java.lang.reflect.Method getPictureMethod = userObj.getClass().getMethod("getProfilePicture");

        Integer userId = (Integer) getIdMethod.invoke(userObj);
        String displayName = (String) getNameMethod.invoke(userObj);
        String username = (String) getUsernameMethod.invoke(userObj);
        String profilePicture = (String) getPictureMethod.invoke(userObj);
    %>

    <div class="user-item">
      <div class="user-info">
        <% if (profilePicture != null && !profilePicture.isEmpty()) { %>
        <img src="${pageContext.request.contextPath}<%= profilePicture %>" alt="<%= displayName %>" class="user-avatar">
        <% } else { %>
        <div class="user-avatar placeholder">👤</div>
        <% } %>

        <div class="user-details">
          <div class="user-name"><%= displayName != null ? displayName : "Unknown User" %></div>
          <div class="user-username">@<%= username != null ? username : "user" %></div>
        </div>
      </div>

      <form action="${pageContext.request.contextPath}/unblockuser" method="POST" style="display: inline;">
        <input type="hidden" name="userId" value="<%= userId %>">
        <button type="submit" class="btn-unblock" onclick="return confirm('Are you sure you want to unblock this user?');">
          Unblock
        </button>
      </form>
    </div>

    <% } %>
  </div>

  <% } else { %>

  <div class="empty-state">
    <div class="empty-state-icon">🚫</div>
    <h3>No Blocked Users</h3>
    <p>You haven't blocked anyone yet. Blocked users won't appear in your feed.</p>
  </div>

  <% } %>

  <div class="extra-links">
    <a href="${pageContext.request.contextPath}/settingsprivacy">Account Settings</a>
  </div>
</main>

<jsp:include page="../public/footer.jsp" />

<script>
  // Optional: Add smooth removal animation when unblocking
  document.addEventListener('DOMContentLoaded', function() {
    const unblockButtons = document.querySelectorAll('.btn-unblock');

    unblockButtons.forEach(button => {
      button.addEventListener('click', function(e) {
        const userItem = this.closest('.user-item');
        if (userItem && confirm('Are you sure you want to unblock this user?')) {
          userItem.style.opacity = '0.5';
          userItem.style.transform = 'scale(0.95)';
        } else if (!confirm('Are you sure you want to unblock this user?')) {
          e.preventDefault();
        }
      });
    });
  });
</script>

</body>
</html>