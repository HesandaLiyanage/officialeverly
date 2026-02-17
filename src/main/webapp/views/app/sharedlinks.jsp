<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
      <h2>Shared Links</h2>

      <div class="settings-tabs">
        <a href="${pageContext.request.contextPath}/settingsaccount" class="tab">Account</a>
        <a href="${pageContext.request.contextPath}/settingssubscription" class="tab">Subscription</a>
        <a href="#" class="tab active">Privacy & Security</a>
        <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
        <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
        <a href="${pageContext.request.contextPath}/settingsappearance" class="tab">Appearance</a>
      </div>
      <button class="filter-btn">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
        <a href="${pageContext.request.contextPath}/settingsprivacy" class="back-link">Back</a>
      </button>

      <div class="shared-links-container">
        <!-- Autograph Links Column -->
        <div class="links-column">
          <h3 style="margin-bottom: 15px;">Autograph Links</h3>

          <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <c:choose>
              <c:when test="${not empty sharedAutographs}">
                <c:forEach var="ag" items="${sharedAutographs}">
                  <div class="link-card">
                    <div class="link-info">
                      <p class="link-title">Autograph - ${ag.title}</p>
                      <p class="link-url"><a href="${pageContext.request.contextPath}/autograph/${ag.shareToken}"
                          target="_blank">.../autograph/${ag.shareToken}</a></p>
                      <p class="link-date">Created on: ${ag.createdAt}</p>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/sharedlinks">
                      <input type="hidden" name="action" value="revokeAutograph">
                      <input type="hidden" name="id" value="${ag.autographId}">
                      <button type="submit" class="card-btn revoke-btn">Revoke</button>
                    </form>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <p style="color: #777; font-size: 14px;">No active autograph links.</p>
              </c:otherwise>
            </c:choose>
        </div>

        <!-- Collaborative Links Column -->
        <div class="links-column">
          <h3 style="margin-bottom: 15px;">Collaborated Memory Links</h3>

          <c:choose>
            <c:when test="${not empty sharedMemories}">
              <c:forEach var="mem" items="${sharedMemories}">
                <div class="link-card">
                  <div class="link-info">
                    <p class="link-title">Collab - ${mem.title}</p>
                    <p class="link-url"><a
                        href="${pageContext.request.contextPath}/memoryinvite?key=${mem.collabShareKey}"
                        target="_blank">.../memoryinvite?key=${mem.collabShareKey}</a></p>
                    <p class="link-date">Updated: ${mem.updatedAt}</p>
                  </div>
                  <form method="post" action="${pageContext.request.contextPath}/sharedlinks">
                    <input type="hidden" name="action" value="revokeCollab">
                    <input type="hidden" name="id" value="${mem.memoryId}">
                    <button type="submit" class="card-btn remove-btn">Remove Access</button>
                  </form>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <p style="color: #777; font-size: 14px;">No active collaboration links.</p>
            </c:otherwise>
          </c:choose>
        </div>

        <!-- Group Invite Links Column -->
        <div class="links-column">
          <h3 style="margin-bottom: 15px;">Group Invite Links</h3>

          <c:choose>
            <c:when test="${not empty sharedInvites}">
              <c:forEach var="inv" items="${sharedInvites}">
                <div class="link-card">
                  <div class="link-info">
                    <p class="link-title">Group Invite (ID: ${inv.groupId})</p>
                    <p class="link-url"><a href="${pageContext.request.contextPath}/invite/${inv.inviteToken}"
                        target="_blank">.../invite/${inv.inviteToken}</a></p>
                    <p class="link-date">Created: ${inv.createdAt}</p>
                  </div>
                  <form method="post" action="${pageContext.request.contextPath}/sharedlinks">
                    <input type="hidden" name="action" value="revokeGroup">
                    <input type="hidden" name="id" value="${inv.inviteId}">
                    <button type="submit" class="card-btn revoke-btn">Revoke</button>
                  </form>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <p style="color: #777; font-size: 14px;">No active group invites.</p>
            </c:otherwise>
          </c:choose>
        </div>

      </div>

    </div>

    <jsp:include page="../public/footer.jsp" />

    <!-- NEW CSS SNIPPETS FOR LINK CARDS -->
    <style>
      /* Shared Links container */
      .shared-links-container {
        display: flex;
        gap: 30px;
        width: 80%;
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