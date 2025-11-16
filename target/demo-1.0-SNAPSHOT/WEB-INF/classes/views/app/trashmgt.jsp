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
    trashFiles.add(new TrashFile("Family Trip Photo", "family_trip_photo.jpg", "2024-02-15", "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e"));
    trashFiles.add(new TrashFile("Group Photo", "group_photo.jpg", "2024-02-05", "https://images.unsplash.com/photo-1494790108377-be9c29b29330"));
    trashFiles.add(new TrashFile("Old Sunset Shot", "sunset_2022.jpg", "2023-12-18", "https://images.unsplash.com/photo-1501973801540-537f08ccae7b"));
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
  <style>
    /* --- Consistent Styling with Duplicate Finder --- */
    .trash-list {
      margin-top: 20px;
    }

    .trash-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid #eee;
      padding: 15px 0;
    }

    .trash-item-left {
      display: flex;
      align-items: center;
      gap: 15px;
    }

    .trash-icon {
      width: 60px;
      height: 60px;
      border-radius: 8px;
      object-fit: cover;
      background-color: #f0f0f0;
    }

    .trash-details {
      display: flex;
      flex-direction: column;
    }

    .trash-title {
      font-weight: 600;
      font-size: 15px;
      color: #222;
      margin: 0 0 4px 0;
    }

    .trash-meta {
      font-size: 13px;
      color: #777;
    }

    .trash-delete-btn {
      background-color: #d00000;
      border: none;
      color: white;
      font-size: 14px;
      font-weight: 600;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
      transition: background-color 0.3s ease;
      border-color: #d00000;
    }

    .trash-delete-btn:hover {
      background-color: #e60000;
    }

    .empty-trash-message {
      text-align: center;
      color: #777;
      font-style: italic;
      margin-top: 25px;
    }

    .trash-actions {
      display: flex;
      gap: 15px;
      margin-top: 25px;
    }

    .restore-all-btn,
    .empty-trash-btn {
      padding: 10px 20px;
      border-radius: 6px;
      border: none;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .restore-all-btn {
      background-color: #f0f0f0;
      color: #333;
    }

    .restore-all-btn:hover {
      background-color: #ddd;
    }

    .empty-trash-btn {
      background-color: #d00000;
      color: white;
    }

    .empty-trash-btn:hover {
      background-color: #b00000;
    }

    /* back button + tab consistency */
    .filter-btn {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 10px 14px;
      border: 2px solid #e9ecef;
      border-radius: 12px;
      background: white;
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
      color: #333;
      transition: all 0.3s ease;
      width: auto;
    }

    .filter-btn:hover {
      border-color: #6366f1;
      color: #6366f1;
      background: #f0f9ff;
    }

    .tab {
      text-decoration: none;
    }
  </style>
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

  <button class="filter-btn">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
      <polyline points="15 18 9 12 15 6"></polyline>
    </svg>
    <a href="${pageContext.request.contextPath}/storagesense" class="back-link">Back</a>
  </button>

  <h2>Trash Management</h2>

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
        <img src="<%= file.imagePath %>?auto=format&fit=crop&w=80&h=80&q=60"
             alt="<%= file.title %>"
             class="trash-icon">
        <div class="trash-details">
          <p class="trash-title"><%= file.title %></p>
          <p class="trash-meta">
            File Name: <%= file.fileName %><br>
            Deleted: <%= file.deletedDate %>
          </p>
        </div>
      </div>
      <form method="post" action="trashManagement.jsp">
        <input type="hidden" name="deleteTitle" value="<%= file.title %>">
        <button type="submit" class="trash-delete-btn">Delete</button>
      </form>
    </div>
    <%
        }
      }
    %>
  </div>

  <div class="trash-actions">
    <form method="post" action="trashManagement.jsp">
      <button type="submit" name="restoreAll" class="restore-all-btn">Restore All</button>
    </form>
    <form method="post" action="trashManagement.jsp">
      <button type="submit" name="emptyTrash" class="empty-trash-btn">Empty Trash</button>
    </form>
  </div>
</div>

<jsp:include page="../public/footer.jsp" />
</body>
</html>
