<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="/WEB-INF/views/public/header2.jsp" />
<html>

<head>
  <link rel="stylesheet" type="text/css"
    href="${pageContext.request.contextPath}/resources/css/groups.css">
</head>

<body>

  <!-- Page Wrapper -->
  <div class="page-wrapper">
    <main class="main-content">
      <!-- Page Title -->
      <div class="tab-nav">
        <div class="page-title">Groups
          <p class="page-subtitle">Stay connected through shared groups and conversations.</p>
        </div>
      </div>

      <!-- Search and Filters -->
      <div class="search-filters">
        <div class="groups-search-container">
          <button class="groups-search-btn" id="groupsSearchBtn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          </button>
        </div>

      </div>

      <!-- Groups List with Scrolling -->
      <div class="groups-list" id="groupsList"
        style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
        <c:choose>
          <c:when test="${empty groupDisplayData}">
            <div style="text-align: center; padding: 40px; color: #6b7280;">
              <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                stroke-width="1.5" style="margin: 0 auto 20px; opacity: 0.5;">
                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
              </svg>
              <h3 style="margin: 0 0 10px; color: #374151;">No groups yet.</h3>
              <p style="margin: 0;">Create your first group to get started!</p>
            </div>
          </c:when>
          <c:otherwise>
            <c:forEach var="g" items="${groupDisplayData}">
              <a href="${pageContext.request.contextPath}/groupmemories?groupId=${g.groupId}"
                class="group-card" data-group-title="${fn:escapeXml(g.nameLower)}">
                <div class="group-images single">
                  <c:choose>
                    <c:when test="${g.hasGroupPic}">
                      <div class="image-card"
                        style="background-image: url('${g.groupPicUrl}'); background-size: cover; background-position: center;">
                      </div>
                    </c:when>
                    <c:otherwise>
                      <div class="image-placeholder beige"></div>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="group-info">
                  <h3 class="group-title">
                    ${fn:escapeXml(g.name)}
                  </h3>
                  <p class="group-meta">
                    <span class="members-count">
                      ${g.memberCount} ${g.memberLabel}
                    </span>
                    <span class="separator">•</span>
                    <span class="last-activity">
                      ${g.timeAgo}
                    </span>
                  </p>
                </div>
              </a>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
    </main>

    <aside class="sidebar">
      <!-- Announcements Section -->
      <div class="sidebar-section">
        <h3 class="sidebar-title">Group Announcements</h3>
        <div class="announcements-list">
          <c:choose>
            <c:when test="${not empty announcementDisplayData}">
              <c:forEach var="ann" items="${announcementDisplayData}">
                <div class="announcement-item">
                  <div class="announcement-icon family">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="2">
                      <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                      <circle cx="9" cy="7" r="4"></circle>
                      <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                      <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                  </div>
                  <div class="announcement-content">
                    <h4 class="announcement-title">
                      ${fn:escapeXml(ann.name)}
                    </h4>
                    <p class="announcement-text">
                      ${fn:escapeXml(ann.description)}
                    </p>
                    <span class="announcement-time">
                      ${ann.timeAgo}
                    </span>
                  </div>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div style="text-align: center; padding: 20px; color: #6b7280;">
                <p>No announcements yet</p>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- Floating Create Button - Now static below sidebar -->
      <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/creategroup" class="floating-btn">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
          Create Group
        </a>
      </div>
    </aside>
  </div>

  <jsp:include page="/WEB-INF/views/public/footer.jsp" />

  <script>
    // Modern Search Functionality
    document.addEventListener('DOMContentLoaded', function () {
      const groupsSearchBtn = document.getElementById('groupsSearchBtn');

      if (groupsSearchBtn) {
        groupsSearchBtn.addEventListener('click', function (event) {
          event.stopPropagation();

          const searchBtnElement = this;
          const searchContainer = searchBtnElement.parentElement;

          const searchBox = document.createElement('div');
          searchBox.className = 'groups-search-expanded';
          searchBox.innerHTML = `
                    <div class="groups-search-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    </div>
                    <input type="text" id="searchInput" placeholder="Search groups..." autofocus>
                    <button class="groups-search-close">
                        <svg viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                `;

          searchContainer.replaceChild(searchBox, searchBtnElement);

          const input = searchBox.querySelector('input');
          input.focus();

          const closeSearch = () => {
            const newSearchBtn = document.createElement('button');
            newSearchBtn.className = 'groups-search-btn';
            newSearchBtn.id = 'groupsSearchBtn';
            newSearchBtn.innerHTML = `
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    `;
            searchContainer.replaceChild(newSearchBtn, searchBox);
            newSearchBtn.addEventListener('click', arguments.callee);
          };

          searchBox.querySelector('.groups-search-close').addEventListener('click', closeSearch);

          input.addEventListener('blur', function () {
            setTimeout(() => {
              if (!document.activeElement.closest('.groups-search-expanded')) {
                closeSearch();
              }
            }, 150);
          });

          searchBox.addEventListener('mousedown', function (e) {
            e.preventDefault();
            input.focus();
          });

          // Search functionality
          input.addEventListener('input', function (e) {
            const query = e.target.value.toLowerCase();
            const groupCards = document.querySelectorAll('.group-card');
            groupCards.forEach(card => {
              const title = card.getAttribute('data-group-title') || '';
              card.style.display = title.includes(query) ? 'flex' : 'none';
            });
          });
        });
      }



      // Announcement item interactions
      const announcementItems = document.querySelectorAll('.announcement-item');
      announcementItems.forEach(item => {
        item.addEventListener('click', function () {
          announcementItems.forEach(i => i.classList.remove('selected'));
          this.classList.add('selected');
        });
      });
    });
  </script>

</body>

</html>
