<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="/WEB-INF/views/public/header2.jsp" />
<html>

<head>
  <link rel="stylesheet" type="text/css"
    href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
  <link rel="stylesheet" type="text/css"
    href="${pageContext.request.contextPath}/resources/css/memories.css">
</head>

<body>

  <!-- Page Wrapper -->
  <div class="page-wrapper">
    <main class="main-content">
      <!-- Page Header -->
      <div class="page-header">
        <h1 class="group-name">
          <c:out value="${groupName}" default="Group" />
        </h1>
        <p class="group-creator">
          <c:out value="${groupDescription}" default="Created by You" />
        </p>
      </div>

      <!-- Tab Navigation -->
      <div class="tab-nav">
        <a href="${pageContext.request.contextPath}/groupmemories?groupId=${groupId}"
          class="tab-link">Memories</a>
        <a href="${pageContext.request.contextPath}/groupannouncement?groupId=${groupId}"
          class="tab-link active">Announcements</a>
        <a href="${pageContext.request.contextPath}/groupmembers?groupId=${groupId}"
          class="tab-link">Members</a>
      </div>

      <!-- Announcements Grid -->
      <div class="announcements-grid"
        style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
        <c:choose>
          <c:when test="${not empty announcementDisplayData}">
            <c:forEach var="ann" items="${announcementDisplayData}">
              <div class="announcement-card"
                onclick="location.href='${pageContext.request.contextPath}/viewannouncement?id=${ann.announcementId}'">
                <div class="announcement-header">
                  <h3>${fn:escapeXml(ann.title)}</h3>
                  <span class="announcement-time">${ann.createdAt}</span>
                </div>
                <p class="announcement-text">
                  ${fn:escapeXml(ann.truncatedContent)}
                  <a href="${pageContext.request.contextPath}/viewannouncement?id=${ann.announcementId}"
                    class="inline-link">More Info →</a>
                </p>
                <div class="announcement-footer">
                  <span class="announcement-author">${fn:escapeXml(ann.authorName)}</span>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <p style="text-align: center; color: #888; grid-column: 1/-1; padding: 40px;">
              No announcements yet. Be the first to post!</p>
          </c:otherwise>
        </c:choose>
      </div>
    </main>

    <aside class="sidebar">
      <!-- Group Info -->
      <div class="sidebar-section">
        <h3 class="sidebar-title">Group Info</h3>
        <ul class="favorites-list">
          <li class="favorite-item">
            <div class="favorite-icon"
              style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 14px;">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 11v2a1 1 0 0 0 1 1h3l5 4V6L7 10H4a1 1 0 0 0-1 1z"></path>
                <path d="M16 9a4 4 0 0 1 0 6"></path>
                <path d="M19 7a7 7 0 0 1 0 10"></path>
              </svg>
            </div>
            <span class="favorite-name">Announcements:
              <c:out value="${fn:length(announcementDisplayData)}" default="0" />
            </span>
          </li>
          <li class="favorite-item">
            <div class="favorite-icon"
              style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 14px;">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M16 21v-2a4 4 0 0 0-8 0v2"></path>
                <circle cx="12" cy="8" r="4"></circle>
                <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
              </svg>
            </div>
            <span class="favorite-name">
              Group: <strong><c:out value="${groupName}" default="Group" /></strong>
            </span>
          </li>
        </ul>
      </div>

      <div class="floating-buttons" id="floatingButtons"
        style="position: static; margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/createannouncement?groupId=${groupId}"
          class="floating-btn">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
          New Post
        </a>
        <a href="${pageContext.request.contextPath}/groupmemories?groupId=${groupId}"
          class="floating-btn" style="background: #6366f1;">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <path
              d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z">
            </path>
            <circle cx="12" cy="13" r="4"></circle>
          </svg>
          Memories
        </a>
      </div>
    </aside>
  </div>

  <jsp:include page="/WEB-INF/views/public/footer.jsp" />

</body>

</html>
