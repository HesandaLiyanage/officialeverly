<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.demo.web.model.user" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Profile - Settings</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
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
    <div style="background-color: #fee; border: 1px solid #fcc; padding: 10px; border-radius: 6px; margin-bottom: 20px; color: #c00;">
      <%= errorMsg %>
    </div>
    <% } %>

    <% if (successMsg != null) { %>
    <div style="background-color: #efe; border: 1px solid #cfc; padding: 10px; border-radius: 6px; margin-bottom: 20px; color: #060;">
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
          <input type="password" name="currentPassword" class="form-input-password" placeholder="Enter current password">
        </div>

        <div class="password-field">
          <label class="form-sublabel">New Password</label>
          <input type="password" name="newPassword" class="form-input-password" placeholder="Enter new password">
        </div>

        <div class="password-field">
          <label class="form-sublabel">Confirm New Password</label>
          <input type="password" name="confirmPassword" class="form-input-password" placeholder="Confirm new password">
        </div>
      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/settingsaccount" class="cancel-btn">Cancel</a>
        <button type="submit" class="save-changes-btn">Save Changes</button>
      </div>
    </form>
  </div>
</div>
<jsp:include page="../public/footer.jsp" />
</body>
</html>