<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="UTF-8">
      <title>Shared Links - Settings</title>
      <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
      <style>
        .shared-links-content {
          padding: 20px 0;
        }

        .section-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          margin-bottom: 25px;
          margin-top: 20px;
          padding-bottom: 15px;
          border-bottom: 1px solid #eee;
        }

        .section-title {
          font-size: 18px;
          font-weight: 700;
          color: #333;
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .section-badge {
          background-color: #f0efff;
          color: #6b5bff;
          font-size: 12px;
          padding: 4px 10px;
          border-radius: 12px;
          font-weight: 600;
        }

        .links-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
          gap: 20px;
          margin-bottom: 40px;
        }

        .link-card {
          background: #fff;
          border: 1px solid #eef0f2;
          border-radius: 16px;
          padding: 20px;
          box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
          transition: all 0.3s ease;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          height: 100%;
          position: relative;
          overflow: hidden;
        }

        .link-card:hover {
          transform: translateY(-3px);
          box-shadow: 0 8px 25px rgba(107, 91, 255, 0.1);
          border-color: #dcd9ff;
        }

        .link-card::before {
          content: "";
          position: absolute;
          top: 0;
          left: 0;
          width: 4px;
          height: 100%;
          background: #6b5bff;
          opacity: 0;
          transition: opacity 0.3s;
        }

        .link-card:hover::before {
          opacity: 1;
        }

        .link-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: 15px;
        }

        .link-icon-wrapper {
          width: 42px;
          height: 42px;
          border-radius: 12px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 20px;
        }

        .bg-purple {
          background-color: #f0efff;
          color: #6b5bff;
        }

        .bg-blue {
          background-color: #e3f2fd;
          color: #2196f3;
        }

        .bg-orange {
          background-color: #fff3e0;
          color: #ff9800;
        }

        .link-content h4 {
          font-size: 16px;
          font-weight: 600;
          margin: 0 0 5px 0;
          color: #1a1a1a;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          max-width: 200px;
        }

        .link-url-container {
          background: #f8f9fa;
          padding: 10px;
          border-radius: 8px;
          margin-bottom: 15px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          border: 1px dashed #ced4da;
        }

        .link-url {
          font-size: 13px;
          color: #666;
          text-decoration: none;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          margin-right: 10px;
          max-width: 220px;
        }

        .link-url:hover {
          color: #6b5bff;
          text-decoration: underline;
        }

        .link-meta {
          font-size: 12px;
          color: #999;
          margin-top: auto;
          display: flex;
          align-items: center;
          gap: 5px;
        }

        .revoke-form {
          margin-top: 15px;
        }

        .revoke-btn {
          width: 100%;
          padding: 10px;
          border: none;
          background-color: #fff0f0;
          color: #d32f2f;
          font-weight: 600;
          font-size: 13px;
          border-radius: 8px;
          cursor: pointer;
          transition: background 0.2s;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }

        .revoke-btn:hover {
          background-color: #ffe0e0;
        }

        .back-nav {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 20px;
          color: #666;
          text-decoration: none;
          font-size: 14px;
          font-weight: 500;
          width: fit-content;
          transition: color 0.2s;
        }

        .back-nav:hover {
          color: #6b5bff;
        }

        .empty-state {
          grid-column: 1 / -1;
          text-align: center;
          padding: 40px;
          background: #fbfbfb;
          border-radius: 16px;
          border: 1px dashed #ddd;
          color: #888;
        }
      </style>
    </head>

    <body>
      <jsp:include page="../public/header2.jsp" />

      <div class="settings-container">
        <h2>Settings</h2>

        <div class="settings-tabs">
          <a href="${pageContext.request.contextPath}/settingsaccount" class="tab">Account</a>
          <a href="${pageContext.request.contextPath}/settingssubscription" class="tab">Subscription</a>
          <a href="#" class="tab active">Privacy & Security</a>
          <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
          <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
          <a href="${pageContext.request.contextPath}/settingsappearance" class="tab">Appearance</a>
        </div>

        <a href="${pageContext.request.contextPath}/settingsprivacy" class="back-nav">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
            stroke-linecap="round" stroke-linejoin="round">
            <path d="M19 12H5M12 19l-7-7 7-7" />
          </svg>
          Back to Privacy
        </a>

        <div class="shared-links-content">
          <h3 style="font-size: 22px; margin-bottom: 5px;">Shared Links</h3>
          <p style="color: #666; margin-bottom: 30px;">Manage access to your autographs, memories, and group invites.
          </p>

          <!-- Autographs Section -->
          <div class="section-header">
            <div class="section-title">
              ✍️ Autograph Links
            </div>
            <c:if test="${not empty sharedAutographs}">
              <span class="section-badge">${sharedAutographs.size()} Active</span>
            </c:if>
          </div>

          <div class="links-grid">
            <c:choose>
              <c:when test="${not empty sharedAutographs}">
                <c:forEach var="ag" items="${sharedAutographs}">
                  <div class="link-card">
                    <div class="link-header">
                      <div class="link-content">
                        <h4>${ag.title}</h4>
                        <div class="link-meta">Created ${ag.createdAt}</div>
                      </div>
                      <div class="link-icon-wrapper bg-purple">
                        🔖
                      </div>
                    </div>
                    <div class="link-url-container">
                      <a href="${pageContext.request.contextPath}/autograph/${ag.shareToken}" target="_blank"
                        class="link-url">.../autograph/${ag.shareToken}</a>
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#999" stroke-width="2">
                        <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                        <polyline points="15 3 21 3 21 9"></polyline>
                        <line x1="10" y1="14" x2="21" y2="3"></line>
                      </svg>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/sharedlinks" class="revoke-form">
                      <input type="hidden" name="action" value="revokeAutograph">
                      <input type="hidden" name="id" value="${ag.autographId}">
                      <button type="submit" class="revoke-btn">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                          stroke-width="2">
                          <circle cx="12" cy="12" r="10"></circle>
                          <line x1="15" y1="9" x2="9" y2="15"></line>
                          <line x1="9" y1="9" x2="15" y2="15"></line>
                        </svg>
                        Revoke Link
                      </button>
                    </form>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <div class="empty-state">
                  No active autograph links found.
                </div>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- Collaborative Memories Section -->
          <div class="section-header">
            <div class="section-title">
              🤝 Collaborations
            </div>
            <c:if test="${not empty sharedMemories}">
              <span class="section-badge">${sharedMemories.size()} Active</span>
            </c:if>
          </div>

          <div class="links-grid">
            <c:choose>
              <c:when test="${not empty sharedMemories}">
                <c:forEach var="mem" items="${sharedMemories}">
                  <div class="link-card">
                    <div class="link-header">
                      <div class="link-content">
                        <h4>${mem.title}</h4>
                        <div class="link-meta">Updated ${mem.updatedAt}</div>
                      </div>
                      <div class="link-icon-wrapper bg-blue">
                        🖼️
                      </div>
                    </div>
                    <div class="link-url-container">
                      <a href="${pageContext.request.contextPath}/memoryinvite?key=${mem.collabShareKey}"
                        target="_blank" class="link-url">.../memoryinvite?key=${mem.collabShareKey}</a>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/sharedlinks" class="revoke-form">
                      <input type="hidden" name="action" value="revokeCollab">
                      <input type="hidden" name="id" value="${mem.memoryId}">
                      <button type="submit" class="revoke-btn">
                        Remove Access
                      </button>
                    </form>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <div class="empty-state">
                  No active shared memories.
                </div>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- Group Invites Section -->
          <div class="section-header">
            <div class="section-title">
              🎟️ Group Invites
            </div>
            <c:if test="${not empty sharedInvites}">
              <span class="section-badge">${sharedInvites.size()} Active</span>
            </c:if>
          </div>

          <div class="links-grid">
            <c:choose>
              <c:when test="${not empty sharedInvites}">
                <c:forEach var="inv" items="${sharedInvites}">
                  <div class="link-card">
                    <div class="link-header">
                      <div class="link-content">
                        <h4>Group Invite #${inv.groupId}</h4>
                        <div class="link-meta">Created ${inv.createdAt}</div>
                      </div>
                      <div class="link-icon-wrapper bg-orange">
                        👥
                      </div>
                    </div>
                    <div class="link-url-container">
                      <a href="${pageContext.request.contextPath}/invite/${inv.inviteToken}" target="_blank"
                        class="link-url">.../invite/${inv.inviteToken}</a>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/sharedlinks" class="revoke-form">
                      <input type="hidden" name="action" value="revokeGroup">
                      <input type="hidden" name="id" value="${inv.inviteId}">
                      <button type="submit" class="revoke-btn">
                        Delete Invite
                      </button>
                    </form>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <div class="empty-state">
                  No active group invites.
                </div>
              </c:otherwise>
            </c:choose>
          </div>

        </div>
      </div>
      <jsp:include page="../public/footer.jsp" />
      margin: 30px auto;
      justify-content: space-between;
      }

      .links-column {
      flex: 1;
      min-width: 300px;
      }

      /* Card style for each link */
      .link-card {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px;
      margin-bottom: 16px;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
      background-color: #fff;
      transition: transform 0.2s, box-shadow 0.2s;
      }

      .link-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }

      .link-info {
      max-width: 75%;
      }

      .link-title {
      font-weight: 600;
      margin: 0 0 4px 0;
      }

      .link-url a {
      color: #6366f1;
      text-decoration: none;
      word-break: break-all;
      font-size: 14px;
      }

      .link-url a:hover {
      text-decoration: underline;
      }

      .link-date {
      font-size: 12px;
      color: #777;
      margin-top: 4px;
      }

      /* Buttons inside card */
      .card-btn {
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 13px;
      cursor: pointer;
      border: none;
      white-space: nowrap;
      }

      .revoke-btn {
      background-color: #d00000;
      color: #fff;
      }

      .revoke-btn:hover {
      background-color: #b80000;
      }

      .remove-btn {
      background-color: #ff9800;
      color: #fff;
      }

      .remove-btn:hover {
      background-color: #e68900;
      }

      /* Back link wrapper */
      .back-wrapper {
      text-align: center;
      margin-top: 30px;
      }

      .back-link {
      text-decoration: none;
      font-size: 14px;
      color: #444;
      font-weight: 500;
      transition: color 0.3s;
      }

      .back-link:hover {
      color: #000;
      }

      /* Responsive for mobile */
      @media (max-width: 768px) {
      .shared-links-container {
      flex-direction: column;
      gap: 20px;
      }

      .link-info {
      max-width: 70%;
      }
      }
      </style>