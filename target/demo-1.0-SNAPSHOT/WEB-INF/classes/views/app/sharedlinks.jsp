<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
  // Define a basic class for link data
  class SharedLink {
    String title, description, createdDate;
    int views;
    SharedLink(String title, String description, String createdDate, int views) {
      this.title = title;
      this.description = description;
      this.createdDate = createdDate;
      this.views = views;
    }
  }

  // Retrieve shared links list from session
  List<SharedLink> links = (List<SharedLink>) session.getAttribute("sharedLinks");

  // Initialize the list if not already created
  if (links == null) {
    links = new ArrayList<>();
    links.add(new SharedLink("Family Vacation Album", "Family Vacation Album", "2024-01-10", 150));
    links.add(new SharedLink("Link to a specific memory", "Link to a specific memory", "2024-01-15", 75));
    links.add(new SharedLink("Event Announcement", "Event Announcement", "2024-01-10", 200));
    session.setAttribute("sharedLinks", links);
  }

  // --- HANDLE REMOVE FUNCTIONALITY ---
  String titleToRemove = request.getParameter("titleToRemove");
  if (titleToRemove != null && !titleToRemove.isEmpty()) {
    Iterator<SharedLink> iterator = links.iterator();
    while (iterator.hasNext()) {
      SharedLink link = iterator.next();
      if (link.title.equals(titleToRemove)) {
        iterator.remove();
        break;
      }
    }
    session.setAttribute("sharedLinks", links);
    // Redirect to prevent resubmission issue on refresh
    response.sendRedirect("sharedLinks.jsp");
    return;
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Shared Links | Everly</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="../public/header2.jsp" />
<div class="settings-container">
  <h2>Settings</h2>

  <div class="settings-tabs">
    <button class="tab" onclick="navigateTo('settingsaccount')">Account</button>
    <button class="tab active">Privacy & Security</button>
    <button class="tab" onclick="navigateTo('storagesense')">Storage Sense</button>
    <button class="tab" onclick="navigateTo('settingsnotifications')">Notifications</button>
    <button class="tab" onclick="navigateTo('settingsappearance')">Appearance</button>
  </div>

  <div class="back-option">
    <a href="${pageContext.request.contextPath}/fragments/settingsprivacy.jsp" class="back-link">&#8592; Back</a>
  </div>

  <h2>Shared Links</h2>

  <div class="shared-links">
    <%
      if (links.isEmpty()) {
    %>
    <p style="color:#777;">No shared links available.</p>
    <%
    } else {
      for (SharedLink link : links) {
    %>
    <div class="shared-item">
      <div class="shared-info">
        <p class="shared-title"><%= link.title %></p>
        <p class="shared-desc"><%= link.description %></p>
        <p class="shared-meta">Created: <%= link.createdDate %> | Views: <%= link.views %></p>
      </div>
      <form method="post" action="sharedLinks.jsp">
        <input type="hidden" name="titleToRemove" value="<%= link.title %>">
        <button type="submit" class="remove-btn">✕</button>
      </form>
    </div>
    <%
        }
      }
    %>
  </div>
</div>

<script>
  function navigateTo(tab) {
    window.location.href = tab + ".jsp";
  }
</script>

<jsp:include page="../public/footer.jsp" />
</body>
</html>
