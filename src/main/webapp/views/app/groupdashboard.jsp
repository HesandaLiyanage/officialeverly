<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.demo.web.model.Group" %>
<%@ page import="com.demo.web.dao.GroupDAO" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groups.css">
</head>
<body>

<!-- Page Wrapper -->
<div class="page-wrapper">
  <main class="main-content">
    <!-- Page Title -->
      <div class="tab-nav">
    <div class="page-title">Groups
        <p class="page-subtitle">Stay connected through shared groups and conversations.</p></div>
      </div>

    <!-- Search and Filters -->
    <div class="search-filters">
      <div class="groups-search-container">
        <button class="groups-search-btn" id="groupsSearchBtn">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <path d="m21 21-4.35-4.35"></path>
          </svg>
        </button>
      </div>
      <button class="filter-btn" id="memberFilter">Members</button>
      <button class="filter-btn" id="activityFilter">Activity</button>
    </div>

    <!-- Groups List with Scrolling -->
    <div class="groups-list" id="groupsList" style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
      <%
        List<Group> groups = (List<Group>) request.getAttribute("groups");
        GroupDAO groupDAO = (GroupDAO) request.getAttribute("groupDAO");

        if (groups == null || groups.isEmpty()) {
      %>
        <div style="text-align: center; padding: 40px; color: #6b7280;">
            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin: 0 auto 20px; opacity: 0.5;">
                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
            </svg>
            <h3 style="margin: 0 0 10px; color: #374151;">No groups yet.</h3>
            <p style="margin: 0;">Create your first group to get started!</p>
        </div>
      <%
      } else {
        for (Group group : groups) {
          // Calculate time ago
          java.sql.Timestamp createdAt = group.getCreatedAt();
          long diffInMillies = Math.abs(new Date().getTime() - createdAt.getTime());
          long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

          String timeAgo;
          if (diffInDays == 0) {
            long diffInHours = TimeUnit.HOURS.convert(diffInMillies, TimeUnit.MILLISECONDS);
            if (diffInHours == 0) {
              long diffInMinutes = TimeUnit.MINUTES.convert(diffInMillies, TimeUnit.MILLISECONDS);
              timeAgo = diffInMinutes + " minutes ago";
            } else {
              timeAgo = diffInHours + " hours ago";
            }
          } else if (diffInDays == 1) {
            timeAgo = "Yesterday";
          } else if (diffInDays < 7) {
            timeAgo = diffInDays + " days ago";
          } else if (diffInDays < 30) {
            long weeks = diffInDays / 7;
            timeAgo = weeks + " week" + (weeks > 1 ? "s" : "") + " ago";
          } else if (diffInDays < 365) {
            long months = diffInDays / 30;
            timeAgo = months + " month" + (months > 1 ? "s" : "") + " ago";
          } else {
            long years = diffInDays / 365;
            timeAgo = years + " year" + (years > 1 ? "s" : "") + " ago";
          }

          // Get member count
          int memberCount = groupDAO.getMemberCount(group.getGroupId());
      %>

      <a href="<%= request.getContextPath() %>/groupmemories?groupId=<%= group.getGroupId() %>" class="group-card" data-group-title="<%= group.getName().toLowerCase() %>">
        <div class="group-images single">
          <% if (group.getGroupPicUrl() != null && !group.getGroupPicUrl().isEmpty()) { %>
          <div class="image-card" style="background-image: url('<%= group.getGroupPicUrl() %>'); background-size: cover; background-position: center;"></div>
          <% } else { %>
          <div class="image-placeholder beige"></div>
          <% } %>
        </div>
        <div class="group-info">
          <h3 class="group-title"><%= group.getName() %></h3>
          <p class="group-meta">
            <span class="members-count"><%= memberCount %> member<%= memberCount != 1 ? "s" : "" %></span>
            <span class="separator">•</span>
            <span class="last-activity"><%= timeAgo %></span>
          </p>
        </div>
      </a>

      <%
          }
        }
      %>
    </div>
  </main>

  <aside class="sidebar">
    <!-- Announcements Section -->
    <div class="sidebar-section">
      <h3 class="sidebar-title">Group Announcements</h3>
      <div class="announcements-list">
        <%
          // Display recent groups as announcements
          if (groups != null && !groups.isEmpty()) {
            int announcementCount = 0;
            for (Group group : groups) {
              if (announcementCount >= 5) break; // Show max 5 announcements

              // Calculate time ago for announcement
              java.sql.Timestamp createdAt = group.getCreatedAt();
              long diffInMillies = Math.abs(new Date().getTime() - createdAt.getTime());
              long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

              String timeAgo;
              if (diffInDays == 0) {
                long diffInHours = TimeUnit.HOURS.convert(diffInMillies, TimeUnit.MILLISECONDS);
                if (diffInHours == 0) {
                  timeAgo = "Just now";
                } else {
                  timeAgo = diffInHours + " hours ago";
                }
              } else if (diffInDays == 1) {
                timeAgo = "1 day ago";
              } else if (diffInDays < 7) {
                timeAgo = diffInDays + " days ago";
              } else {
                long weeks = diffInDays / 7;
                timeAgo = weeks + " week" + (weeks > 1 ? "s" : "") + " ago";
              }
        %>

        <!-- Announcement <%= announcementCount + 1 %> -->
        <div class="announcement-item">
          <div class="announcement-icon family">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
              <circle cx="9" cy="7" r="4"></circle>
              <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
              <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
            </svg>
          </div>
          <div class="announcement-content">
            <h4 class="announcement-title"><%= group.getName() %></h4>
            <p class="announcement-text"><%= group.getDescription() != null && !group.getDescription().isEmpty() ? group.getDescription() : "New group created!" %></p>
            <span class="announcement-time"><%= timeAgo %></span>
          </div>
        </div>

        <%
            announcementCount++;
          }
        } else {
        %>
        <div style="text-align: center; padding: 20px; color: #6b7280;">
          <p>No announcements yet</p>
        </div>
        <%
          }
        %>
      </div>
    </div>

    <!-- Floating Create Button - Now static below sidebar -->
    <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
      <a href="<%= request.getContextPath() %>/creategroup" class="floating-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        Create Group
      </a>
    </div>
  </aside>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
  // Modern Search Functionality
  document.addEventListener('DOMContentLoaded', function() {
    const groupsSearchBtn = document.getElementById('groupsSearchBtn');

    if (groupsSearchBtn) {
      groupsSearchBtn.addEventListener('click', function(event) {
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

        input.addEventListener('blur', function() {
          setTimeout(() => {
            if (!document.activeElement.closest('.groups-search-expanded')) {
              closeSearch();
            }
          }, 150);
        });

        searchBox.addEventListener('mousedown', function(e) {
          e.preventDefault();
          input.focus();
        });

        // Search functionality
        input.addEventListener('input', function(e) {
          const query = e.target.value.toLowerCase();
          const groupCards = document.querySelectorAll('.group-card');
          groupCards.forEach(card => {
            const title = card.getAttribute('data-group-title') || '';
            card.style.display = title.includes(query) ? 'flex' : 'none';
          });
        });
      });
    }

    // Filter button handlers
    const memberFilter = document.getElementById('memberFilter');
    const activityFilter = document.getElementById('activityFilter');

    if (memberFilter) {
      memberFilter.addEventListener('click', function() {
        console.log('Filter by members clicked');
        // Implement member filtering logic here
      });
    }

    if (activityFilter) {
      activityFilter.addEventListener('click', function() {
        console.log('Filter by activity clicked');
        // Implement activity filtering logic here
      });
    }

    // Announcement item interactions
    const announcementItems = document.querySelectorAll('.announcement-item');
    announcementItems.forEach(item => {
      item.addEventListener('click', function() {
        announcementItems.forEach(i => i.classList.remove('selected'));
        this.classList.add('selected');
      });
    });
  });
</script>

</body>
</html>