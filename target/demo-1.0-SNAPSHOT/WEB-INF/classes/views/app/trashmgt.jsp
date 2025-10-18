<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
  // --- Model class for Trash Files ---
  class TrashFile {
    String title, fileName, deletedDate, imagePath;
    TrashFile(String title, String fileName, String deletedDate, String imagePath) {
      this.title = title;
      this.fileName = fileName;
      this.deletedDate = deletedDate;
      this.imagePath = imagePath;
    }
  }

  // --- Retrieve or initialize trash files ---
  List<TrashFile> trashFiles = (List<TrashFile>) session.getAttribute("trashFiles");

  if (trashFiles == null) {
    trashFiles = new ArrayList<>();
    trashFiles.add(new TrashFile("Family Trip Photo", "family_trip_photo.jpg", "2024-02-15", "images/trash1.jpg"));
    trashFiles.add(new TrashFile("Group Photo", "group_photo.jpg", "2024-02-05", "images/trash2.jpg"));
    session.setAttribute("trashFiles", trashFiles);
  }

  // --- Remove single file ---
  String deleteTitle = request.getParameter("deleteTitle");
  if (deleteTitle != null && !deleteTitle.isEmpty()) {
    Iterator<TrashFile> iterator = trashFiles.iterator();
    while (iterator.hasNext()) {
      TrashFile file = iterator.next();
      if (file.title.equals(deleteTitle)) {
        iterator.remove();
        break;
      }
    }
    session.setAttribute("trashFiles", trashFiles);
    response.sendRedirect("trashManagement.jsp");
    return;
  }

  // --- Restore all files ---
  if (request.getParameter("restoreAll") != null) {
    trashFiles.clear(); // In actual system, move to active storage
    session.setAttribute("trashFiles", trashFiles);
    response.sendRedirect("trashManagement.jsp");
    return;
  }

  // --- Empty Trash ---
  if (request.getParameter("emptyTrash") != null) {
    trashFiles.clear();
    session.setAttribute("trashFiles", trashFiles);
    response.sendRedirect("trashManagement.jsp");
    return;
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Trash Management | Everly</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="../public/header2.jsp" />
<div class="settings-container">
  <h2>Settings</h2>

  <div class="settings-tabs">
    <a href="/settingsaccount" class="tab">Account</a>
    <a href="/settingsprivacy" class="tab">Privacy & Security</a>
    <a href="#" class="tab active">Storage Sense</a>
    <a href="/settingsnotifications" class="tab">Notifications</a>
    <a href="/settingsappearance" class="tab">Appearance</a>
  </div>

  <!-- Back Option -->
  <div class="back-option">
    <a href="${pageContext.request.contextPath}/storagesense" class="back-link">&#8592; Back</a>
  </div>

  <!-- Trash Management Header -->
  <h3 class="trash-management-header">Trash Management</h3>

  <!-- Trash List -->
  <div class="trash-list">
    <%
      if (trashFiles.isEmpty()) {
    %>
    <p class="empty-trash-message">Trash is empty.</p>
    <%
    } else {
      for (TrashFile file : trashFiles) {
    %>
    <div class="trash-item">
      <div class="trash-item-left">
        <img src="<%= file.imagePath %>" alt="<%= file.title %>" class="trash-icon">
        <div class="trash-details">
          <div class="trash-title"><%= file.title %></div>
          <div class="trash-meta">
            File Name: <%= file.fileName %><br>
            Deleted: <%= file.deletedDate %>
          </div>
        </div>
      </div>
      <form method="post" action="trashManagement.jsp" class="trash-delete-form">
        <input type="hidden" name="deleteTitle" value="<%= file.title %>">
        <button type="submit" class="trash-delete-btn" aria-label="Delete <%= file.title %>">&#128465;</button>
      </form>
    </div>
    <%
        }
      }
    %>
  </div>

  <!-- Action Buttons -->
  <div class="trash-actions">
    <form method="post" action="trashManagement.jsp" style="display:inline;">
      <button type="submit" name="restoreAll" class="restore-all-btn">Restore All</button>
    </form>

    <form method="post" action="trashManagement.jsp" style="display:inline;">
      <button type="submit" name="emptyTrash" class="empty-trash-btn">Empty Trash</button>
    </form>
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