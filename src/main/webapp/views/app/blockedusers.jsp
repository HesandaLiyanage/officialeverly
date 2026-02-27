<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="java.util.List" %>
    <%@ page import="com.demo.web.model.FeedProfile" %>
      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Blocked Users - Everly</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/blockedusers.css">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
          rel="stylesheet">
      </head>

      <body>

        <jsp:include page="../public/header2.jsp" />

        <main class="blocked-container">
          <h1>Blocked Users</h1>
          <p>Manage the users you've blocked from your feed</p>

          <% String successMessage=(String) request.getAttribute("successMessage"); %>
            <% if (successMessage !=null) { %>
              <div class="success">
                ✓ <%= successMessage %>
              </div>
              <% } %>

                <% String errorMessage=(String) request.getAttribute("errorMessage"); %>
                  <% if (errorMessage !=null) { %>
                    <div class="error">
                      ⚠ <%= errorMessage %>
                    </div>
                    <% } %>

                      <% @SuppressWarnings("unchecked") List<FeedProfile> blockedUsers = (List<FeedProfile>)
                          request.getAttribute("blockedUsers");
                          if (blockedUsers != null && !blockedUsers.isEmpty()) {
                          %>

                          <div class="user-list">
                            <% for (FeedProfile blockedUser : blockedUsers) { String
                              displayName=blockedUser.getFeedUsername(); String username=blockedUser.getFeedUsername();
                              String profilePicture=blockedUser.getFeedProfilePictureUrl(); String
                              initials=blockedUser.getInitials(); int profileId=blockedUser.getFeedProfileId(); %>

                              <div class="user-item">
                                <div class="user-info">
                                  <% if (profilePicture !=null && !profilePicture.isEmpty() &&
                                    !profilePicture.contains("default")) { %>
                                    <img src="<%= profilePicture %>" alt="<%= displayName %>" class="user-avatar">
                                    <% } else { %>
                                      <div class="user-avatar placeholder"
                                        style="background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 14px;">
                                        <%= initials %>
                                      </div>
                                      <% } %>

                                        <div class="user-details">
                                          <div class="user-name">
                                            <%= displayName !=null ? displayName : "Unknown User" %>
                                          </div>
                                          <div class="user-username">@<%= username !=null ? username : "user" %>
                                          </div>
                                        </div>
                                </div>

                                <form action="${pageContext.request.contextPath}/unblockuser" method="POST"
                                  style="display: inline;">
                                  <input type="hidden" name="profileId" value="<%= profileId %>">
                                  <button type="submit" class="btn-unblock"
                                    onclick="return confirm('Are you sure you want to unblock @<%= username %>?');">
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
                              <p>You haven't blocked anyone yet. You can block users from the feed by clicking the •••
                                menu on their posts.</p>
                            </div>

                            <% } %>

                              <div class="extra-links">
                                <a href="${pageContext.request.contextPath}/feed">← Back to Feed</a>
                                <a href="${pageContext.request.contextPath}/settingsprivacy">Account Settings</a>
                              </div>
        </main>

        <jsp:include page="../public/footer.jsp" />

      </body>

      </html>