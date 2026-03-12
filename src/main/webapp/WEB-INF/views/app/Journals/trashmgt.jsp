<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="com.demo.web.model.Journals.RecycleBinItem" %>
    <%@ page import="java.util.List" %>
      <%@ page import="java.text.SimpleDateFormat" %>
        <% List<RecycleBinItem> trashItems = (List<RecycleBinItem>) request.getAttribute("trashItems");
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' h:mm a");
            %>
            <!DOCTYPE html>
            <html>

            <head>
              <meta charset="UTF-8">
              <title>Trash Management - Everly</title>
              <link rel="stylesheet" type="text/css"
                href="${pageContext.request.contextPath}/resources/css/settings.css">
              <link
                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                rel="stylesheet">
              <style>
                /* Trash Management specific styles */
                .trash-header-bar {
                  display: flex;
                  align-items: center;
                  justify-content: space-between;
                  margin-bottom: 24px;
                }

                .trash-back-btn {
                  display: inline-flex;
                  align-items: center;
                  gap: 6px;
                  color: #9A74D8;
                  font-weight: 600;
                  font-size: 14px;
                  text-decoration: none;
                  transition: all 0.2s;
                  padding: 8px 14px;
                  border-radius: 8px;
                }

                .trash-back-btn:hover {
                  background: #f3f0ff;
                }

                .trash-page-title {
                  font-size: 20px;
                  font-weight: 700;
                  color: #1f2937;
                  display: flex;
                  align-items: center;
                  gap: 8px;
                }

                .trash-count-badge {
                  font-size: 12px;
                  font-weight: 700;
                  color: #9A74D8;
                  background: #f3f0ff;
                  padding: 3px 10px;
                  border-radius: 12px;
                }

                /* Message banners */
                .trash-msg {
                  padding: 12px 16px;
                  border-radius: 10px;
                  font-size: 13px;
                  font-weight: 600;
                  margin-bottom: 16px;
                }

                .trash-msg.success {
                  background: #f0fdf4;
                  color: #16a34a;
                  border: 1px solid #bbf7d0;
                }

                .trash-msg.error {
                  background: #fef2f2;
                  color: #dc2626;
                  border: 1px solid #fecaca;
                }

                /* Trash items */
                .trash-card {
                  background: white;
                  border: 1px solid #f3f4f6;
                  border-radius: 12px;
                  overflow: hidden;
                }

                .trash-card-item {
                  display: flex;
                  align-items: center;
                  gap: 14px;
                  padding: 16px 20px;
                  border-bottom: 1px solid #f9fafb;
                  transition: background 0.15s;
                }

                .trash-card-item:last-child {
                  border-bottom: none;
                }

                .trash-card-item:hover {
                  background: #faf8ff;
                }

                .trash-item-icon {
                  width: 44px;
                  height: 44px;
                  border-radius: 10px;
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  font-size: 20px;
                  flex-shrink: 0;
                }

                .trash-item-icon.journal {
                  background: #dbeafe;
                }

                .trash-item-icon.autograph {
                  background: #fef3c7;
                }

                .trash-item-icon.memory {
                  background: #f3e8ff;
                }

                .trash-item-info {
                  flex: 1;
                  min-width: 0;
                }

                .trash-item-title {
                  font-size: 14px;
                  font-weight: 600;
                  color: #1f2937;
                  margin-bottom: 2px;
                  white-space: nowrap;
                  overflow: hidden;
                  text-overflow: ellipsis;
                }

                .trash-item-meta {
                  font-size: 12px;
                  color: #9ca3af;
                  display: flex;
                  align-items: center;
                  gap: 8px;
                }

                .trash-item-type {
                  display: inline-flex;
                  align-items: center;
                  gap: 3px;
                  font-size: 10px;
                  font-weight: 700;
                  text-transform: uppercase;
                  letter-spacing: 0.3px;
                  padding: 2px 8px;
                  border-radius: 8px;
                }

                .trash-item-type.journal {
                  background: #dbeafe;
                  color: #2563eb;
                }

                .trash-item-type.autograph {
                  background: #fef3c7;
                  color: #d97706;
                }

                .trash-item-type.memory {
                  background: #f3e8ff;
                  color: #9A74D8;
                }

                .trash-item-actions {
                  display: flex;
                  gap: 6px;
                  flex-shrink: 0;
                }

                .trash-btn {
                  padding: 7px 14px;
                  border-radius: 8px;
                  font-size: 12px;
                  font-weight: 600;
                  cursor: pointer;
                  border: none;
                  transition: all 0.2s;
                  font-family: 'Plus Jakarta Sans', sans-serif;
                }

                .trash-btn.restore {
                  background: #f0fdf4;
                  color: #16a34a;
                  border: 1px solid #bbf7d0;
                }

                .trash-btn.restore:hover {
                  background: #dcfce7;
                }

                .trash-btn.delete {
                  background: #fef2f2;
                  color: #dc2626;
                  border: 1px solid #fecaca;
                }

                .trash-btn.delete:hover {
                  background: #fee2e2;
                }

                /* Empty state */
                .trash-empty {
                  text-align: center;
                  padding: 60px 20px;
                }

                .trash-empty-icon {
                  font-size: 48px;
                  margin-bottom: 12px;
                  opacity: 0.5;
                }

                .trash-empty h3 {
                  font-size: 16px;
                  font-weight: 600;
                  color: #6b7280;
                  margin-bottom: 4px;
                }

                .trash-empty p {
                  font-size: 13px;
                  color: #9ca3af;
                }
              </style>
            </head>

            <body>
              <jsp:include page="/WEB-INF/views/public/header2.jsp" />

              <div class="settings-container">
                <h2>Settings</h2>

                <div class="settings-tabs">
                  <a href="${pageContext.request.contextPath}/settingsaccount" class="tab">Account</a>
                  <a href="${pageContext.request.contextPath}/settingssubscription" class="tab">Subscription</a>
                  <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy & Security</a>
                  <a href="${pageContext.request.contextPath}/storagesense" class="tab active">Storage Sense</a>
                  <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
                </div>

                <!-- Header bar -->
                <div class="trash-header-bar">
                  <a href="${pageContext.request.contextPath}/storagesense" class="trash-back-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="2.5">
                      <polyline points="15 18 9 12 15 6"></polyline>
                    </svg>
                    Back
                  </a>
                  <div class="trash-page-title">
                    🗑️ Trash Management
                    <% if (trashItems !=null && !trashItems.isEmpty()) { %>
                      <span class="trash-count-badge">
                        <%= trashItems.size() %> items
                      </span>
                      <% } %>
                  </div>
                  <div style="width: 60px;"></div> <!-- spacer -->
                </div>

                <!-- Messages -->
                <% String msg=request.getParameter("msg"); String error=request.getParameter("error"); if (msg !=null) {
                  %>
                  <div class="trash-msg success">✅ <%= msg %>
                  </div>
                  <% } else if (error !=null) { %>
                    <div class="trash-msg error">⚠️ <%= error %>
                    </div>
                    <% } %>

                      <!-- Trash Items -->
                      <% if (trashItems==null || trashItems.isEmpty()) { %>
                        <div class="trash-card">
                          <div class="trash-empty">
                            <div class="trash-empty-icon">🗑️</div>
                            <h3>Trash is empty</h3>
                            <p>Deleted journals and autographs will appear here for recovery</p>
                          </div>
                        </div>
                        <% } else { %>
                          <div class="trash-card">
                            <% for (RecycleBinItem item : trashItems) { String itemType=item.getItemType(); boolean
                              isAutograph="autograph" .equals(itemType); boolean isMemory="memory" .equals(itemType);
                              String title=(item.getTitle() !=null && !item.getTitle().trim().isEmpty()) ?
                              item.getTitle() : (isAutograph ? "Untitled Autograph" : isMemory ? "Untitled Memory"
                              : "Untitled Journal" ); String deletedDate=(item.getDeletedAt() !=null) ?
                              dateFormat.format(item.getDeletedAt()) : "Unknown" ; String icon=isAutograph ? "✍️" :
                              isMemory ? "📸" : "📝" ; String restoreUrl=isAutograph ? request.getContextPath()
                              + "/autograph/restore" : request.getContextPath() + "/trashmgt" ; %>
                              <div class="trash-card-item">
                                <div class="trash-item-icon <%= itemType %>">
                                  <%= icon %>
                                </div>
                                <div class="trash-item-info">
                                  <div class="trash-item-title">
                                    <%= title %>
                                  </div>
                                  <div class="trash-item-meta">
                                    <span class="trash-item-type <%= itemType %>">
                                      <%= isAutograph ? "Autograph" : isMemory ? "Memory" : "Journal" %>
                                    </span>
                                    <span>Deleted <%= deletedDate %></span>
                                  </div>
                                </div>
                                <div class="trash-item-actions">
                                  <form method="post" action="${pageContext.request.contextPath}/trashmgt"
                                    style="margin:0;">
                                    <input type="hidden" name="action" value="restore">
                                    <input type="hidden" name="recycleBinId" value="<%= item.getId() %>">
                                    <button type="submit" class="trash-btn restore">Restore</button>
                                  </form>
                                  <form method="post" action="${pageContext.request.contextPath}/trashmgt"
                                    style="margin:0;">
                                    <input type="hidden" name="action" value="permanentDelete">
                                    <input type="hidden" name="recycleBinId" value="<%= item.getId() %>">
                                    <button type="submit" class="trash-btn delete"
                                      onclick="return confirm('Permanently delete this item? This cannot be undone.')">Delete</button>
                                  </form>
                                </div>
                              </div>
                              <% } %>
                          </div>
                          <% } %>
              </div>

              <jsp:include page="/WEB-INF/views/public/footer.jsp" />
            </body>

            </html>