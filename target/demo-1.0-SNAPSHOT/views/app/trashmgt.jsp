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
      // Get deleted journals from request (set by servlet)
      java.util.List<com.demo.web.model.Journal> deletedJournals =
              (java.util.List<com.demo.web.model.Journal>) request.getAttribute("deletedJournals");

      if (deletedJournals == null || deletedJournals.isEmpty()) {
    %>
    <p class="empty-trash-message">Trash is empty.</p>
    <%
    } else {
      for (com.demo.web.model.Journal journal : deletedJournals) {
        // Use title as display name; fallback to "Untitled"
        String title = (journal.getTitle() != null && !journal.getTitle().trim().isEmpty())
                ? journal.getTitle()
                : "Untitled Journal";
        String deletedDate = (journal.getDeletedAt() != null)
                ? journal.getDeletedAt().toString()
                : "Unknown";
    %>
    <div class="trash-item">
      <div class="trash-item-left">
        <!-- Journal icon (you can replace with default image later) -->
        <div style="width:60px; height:60px; background:#e0e0e0; border-radius:8px; display:flex; align-items:center; justify-content:center; color:#777; font-weight:bold;">
          📝
        </div>
        <div class="trash-details">
          <p class="trash-title"><%= title %></p>
          <p class="trash-meta">
            Journal ID: <%= journal.getJournalId() %><br>
            Deleted: <%= deletedDate %>
          </p>
        </div>
      </div>
      <div style="display:flex; gap:8px;">
        <!-- Restore Button -->
        <form method="post" action="${pageContext.request.contextPath}/trashmgt" style="display:inline;">
          <input type="hidden" name="action" value="restore">
          <input type="hidden" name="journalId" value="<%= journal.getJournalId() %>">
          <button type="submit" class="trash-delete-btn" style="background:#28a745;">Restore</button>
        </form>

        <!-- Permanent Delete Button -->
        <form method="post" action="${pageContext.request.contextPath}/trashmgt" style="display:inline;">
          <input type="hidden" name="action" value="permanentDelete">
          <input type="hidden" name="journalId" value="<%= journal.getJournalId() %>">
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

  <!-- Optional: Restore All / Empty Trash (for all journals) -->
  <%
    if (deletedJournals != null && !deletedJournals.isEmpty()) {
  %>
  <div class="trash-actions">
    <!-- You can add "Restore All" later if needed -->
    <form method="post" action="${pageContext.request.contextPath}/trashmgt">
      <input type="hidden" name="action" value="emptyAll"> <!-- Not implemented yet -->
      <button type="button" class="restore-all-btn" disabled>Restore All</button>
    </form>

    <!-- Empty Trash: You'd need to implement batch delete -->
    <button type="button" class="empty-trash-btn" disabled>Empty Trash</button>
  </div>
  <%
    }
  %>
</div>

<jsp:include page="../public/footer.jsp" />