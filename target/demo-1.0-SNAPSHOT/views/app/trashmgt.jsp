<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web.model.RecycleBinItem" %>
<%@ page import="java.util.List" %>

<jsp:include page="../public/header2.jsp" />

<div class="settings-container">
  <h2>Settings</h2>

  <div class="settings-tabs">
    <a href="${pageContext.request.contextPath}/settingsaccount" class="tab">Account</a>
    <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy & Security</a>
    <a href="#" class="tab active">Storage Sense</a>
    <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
    <a href="${pageContext.request.contextPath}/settingsappearance" class="tab">Appearance</a>
  </div>

  <button class="filter-btn">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
      <polyline points="15 18 9 12 15 6"></polyline>
    </svg>
    <a href="${pageContext.request.contextPath}/storagesense" style="text-decoration:none; color:inherit;">Back</a>
  </button>

  <h2>Trash Management</h2>

  <%
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
    if (msg != null) {
  %>
  <div style="color:green; background:#d4edda; padding:10px; margin:10px 0; border-radius:4px;"><%= msg %></div>
  <%
  } else if (error != null) {
  %>
  <div style="color:red; background:#f8d7da; padding:10px; margin:10px 0; border-radius:4px;"><%= error %></div>
  <%
    }
  %>

  <div class="trash-list">
    <%
      List<RecycleBinItem> trashItems = (List<RecycleBinItem>) request.getAttribute("trashItems");
      if (trashItems == null || trashItems.isEmpty()) {
    %>
    <p class="empty-trash-message">Trash is empty.</p>
    <%
    } else {
      for (RecycleBinItem item : trashItems) {
        String title = (item.getTitle() != null && !item.getTitle().trim().isEmpty())
                ? item.getTitle()
                : "Untitled Journal";
        String deletedDate = (item.getDeletedAt() != null)
                ? item.getDeletedAt().toString()
                : "Unknown";
    %>
    <div class="trash-item">
      <div class="trash-item-left">
        <div style="width:60px; height:60px; background:#e0e0e0; border-radius:8px; display:flex; align-items:center; justify-content:center; color:#777; font-weight:bold;">
          📝
        </div>
        <div class="trash-details">
          <p class="trash-title"><%= title %></p>
          <p class="trash-meta">
            Original ID: <%= item.getOriginalId() %><br>
            Deleted: <%= deletedDate %>
          </p>
        </div>
      </div>
      <div style="display:flex; gap:8px;">
        <form method="post" action="${pageContext.request.contextPath}/journal/restore">
          <input type="hidden" name="recycleBinId" value="<%= item.getId() %>">
          <button type="submit" class="trash-delete-btn" style="background:#28a745;">Restore</button>
        </form>
        <form method="post" action="${pageContext.request.contextPath}/journal/permanent-delete">
          <input type="hidden" name="recycleBinId" value="<%= item.getId() %>">
          <button type="submit" class="trash-delete-btn"
                  onclick="return confirm('Permanently delete this journal? This cannot be undone.');">
            Delete
          </button>
        </form>
      </div>
    </div>
    <%
        }
      }
    %>
  </div>
</div>

<jsp:include page="../public/footer.jsp" />