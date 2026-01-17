<%@ page contentType="text/html;charset=UTF-8" language="java" %>

  <jsp:include page="../public/header2.jsp" />
  <html>

  <head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
  </head>
  <script>
    // Handle floating buttons position on scroll
    document.addEventListener('DOMContentLoaded', function () {
      function handleFloatingButtons() {
        const footer = document.querySelector('footer');
        const floatingButtons = document.getElementById('floatingButtons');

        if (!footer || !floatingButtons) return;

        const footerRect = footer.getBoundingClientRect();
        const windowHeight = window.innerHeight;
        const buttonHeight = floatingButtons.offsetHeight;

        if (footerRect.top < windowHeight - buttonHeight - 40) {
          const stopPosition = footer.offsetTop - buttonHeight - 40;
          floatingButtons.style.position = 'absolute';
          floatingButtons.style.bottom = 'auto';
          floatingButtons.style.top = stopPosition + 'px';
        } else {
          floatingButtons.style.position = 'fixed';
          floatingButtons.style.bottom = '40px';
          floatingButtons.style.top = 'auto';
          floatingButtons.style.right = '40px';
        }
      }

      window.addEventListener('scroll', handleFloatingButtons);
      window.addEventListener('resize', handleFloatingButtons);
      handleFloatingButtons();
    });
  </script>

  <body>

    <% Group group=(Group) request.getAttribute("group"); List<GroupAnnouncement> announcements = (List
      <GroupAnnouncement>) request.getAttribute("announcements");
        String groupName = group != null ? group.getName() : "Group";
        int groupId = group != null ? group.getGroupId() : 0;
        %>

        <!-- Page Wrapper -->
        <div class="page-wrapper">
          <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
              <h1 class="group-name">
                <%= groupName %>
              </h1>
              <p class="group-creator">
                <% if (group !=null && group.getDescription() !=null && !group.getDescription().isEmpty()) { %>
                  <%= group.getDescription() %>
                    <% } else { %>
                      Created by You
                      <% } %>
              </p>
            </div>

            <!-- Tab Navigation -->
            <div class="tab-nav">
              <a href="${pageContext.request.contextPath}/groupmemories?groupId=<%= groupId %>"
                class="tab-link">Memories</a>
              <a href="${pageContext.request.contextPath}/groupannouncement?groupId=<%= groupId %>"
                class="tab-link active">Announcements</a>
              <a href="${pageContext.request.contextPath}/groupmembers?groupId=<%= groupId %>"
                class="tab-link">Members</a>
            </div>

            <!-- Announcements Grid -->
            <div class="announcements-grid">
              <% if (announcements !=null && !announcements.isEmpty()) { for (GroupAnnouncement announcement :
                announcements) { String content=announcement.getContent(); if (content.length()> 120) {
                content = content.substring(0, 117) + "...";
                }
                %>
                <div class="announcement-card"
                  onclick="location.href='${pageContext.request.contextPath}/viewannouncement?id=<%= announcement.getAnnouncementId() %>'">
                  <div class="announcement-header">
                    <h3>
                      <%= announcement.getTitle() %>
                    </h3>
                    <span class="announcement-time">
                      <%= announcement.getCreatedAt().toString() %>
                    </span>
                  </div>
                  <p class="announcement-text">
                    <%= content %>
                      <a href="${pageContext.request.contextPath}/viewannouncement?id=<%= announcement.getAnnouncementId() %>"
                        class="inline-link">More Info →</a>
                  </p>
                  <div class="announcement-footer">
                    <span class="announcement-author">
                      <%= announcement.getPostedBy() !=null ? announcement.getPostedBy().getUsername() : "Unknown" %>
                    </span>
                  </div>
                </div>
                <% } } else { %>
                  <p style="text-align: center; color: #888; grid-column: 1/-1; padding: 40px;">No announcements yet. Be
                    the first to post!</p>
                  <% } %>
            </div>

            <!-- Floating Create Announcement Button -->
            <div class="floating-buttons" id="floatingButtons">
              <a href="${pageContext.request.contextPath}/createannouncement?groupId=<%= groupId %>"
                class="floating-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                  stroke-linecap="round" stroke-linejoin="round">
                  <line x1="12" y1="5" x2="12" y2="19"></line>
                  <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                New Post
              </a>
            </div>
          </main>
        </div>

        <jsp:include page="../public/footer.jsp" />

        <script src="${pageContext.request.contextPath}/resources/js/groupfloating.js"></script>

  </body>

  </html>