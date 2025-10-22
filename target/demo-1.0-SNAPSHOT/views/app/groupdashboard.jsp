<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
    <h1 class="page-title">My Groups</h1>

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
      <!-- Group Card 1 -->
      <a href="${pageContext.request.contextPath}/groupmemories?groupId=1" class="group-card">
        <div class="group-images">
          <div class="image-placeholder peach"></div>
          <div class="image-card family-photo"></div>
          <div class="image-placeholder beige"></div>
        </div>
        <div class="group-info">
          <h3 class="group-title">Family Memories</h3>
          <p class="group-meta">
            <span class="members-count">5 members</span>
            <span class="separator">•</span>
            <span class="last-activity">2 weeks ago</span>
          </p>
        </div>
      </a>

      <!-- Group Card 2 -->
      <a href="${pageContext.request.contextPath}/groupmemories?groupId=2" class="group-card">
        <div class="group-images single">
          <div class="image-card beach-photo"></div>
        </div>
        <div class="group-info">
          <h3 class="group-title">Highschool Friends</h3>
          <p class="group-meta">
            <span class="members-count">22 members</span>
            <span class="separator">•</span>
            <span class="last-activity">1 week ago</span>
          </p>
        </div>
      </a>

      <!-- Group Card 3 -->
      <a href="${pageContext.request.contextPath}/groupmemories?groupId=3" class="group-card">
        <div class="group-images single">
          <div class="image-card balloons-photo"></div>
        </div>
        <div class="group-info">
          <h3 class="group-title">Uni Friends</h3>
          <p class="group-meta">
            <span class="members-count">25 members</span>
            <span class="separator">•</span>
            <span class="last-activity">3 days ago</span>
          </p>
        </div>
      </a>

      <!-- Group Card 4 -->
      <a href="${pageContext.request.contextPath}/groupmemories?groupId=4" class="group-card">
        <div class="group-images single">
          <div class="image-card roomies-photo"></div>
        </div>
        <div class="group-info">
          <h3 class="group-title">Roomies</h3>
          <p class="group-meta">
            <span class="members-count">10 members</span>
            <span class="separator">•</span>
            <span class="last-activity">1 month ago</span>
          </p>
        </div>
      </a>

      <!-- Group Card 5 -->
      <a href="${pageContext.request.contextPath}/groupmemories?groupId=5" class="group-card">
        <div class="group-images">
          <div class="image-placeholder mint"></div>
          <div class="image-card travel-photo"></div>
          <div class="image-placeholder lavender"></div>
        </div>
        <div class="group-info">
          <h3 class="group-title">Travel Buddies</h3>
          <p class="group-meta">
            <span class="members-count">8 members</span>
            <span class="separator">•</span>
            <span class="last-activity">5 days ago</span>
          </p>
        </div>
      </a>

      <!-- Group Card 6 -->
      <a href="${pageContext.request.contextPath}/groupmemories?groupId=6" class="group-card">
        <div class="group-images single">
          <div class="image-card gaming-photo"></div>
        </div>
        <div class="group-info">
          <h3 class="group-title">Gaming Squad</h3>
          <p class="group-meta">
            <span class="members-count">15 members</span>
            <span class="separator">•</span>
            <span class="last-activity">Yesterday</span>
          </p>
        </div>
      </a>
    </div>
  </main>

  <aside class="sidebar">
    <!-- Announcements Section -->
    <div class="sidebar-section">
      <h3 class="sidebar-title">Group Announcements</h3>
      <div class="announcements-list">
        <!-- Announcement 1 -->
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
            <h4 class="announcement-title">Family Memories</h4>
            <p class="announcement-text">Reunion planned for next month! 🎉</p>
            <span class="announcement-time">2 hours ago</span>
          </div>
        </div>

        <!-- Announcement 2 -->
        <div class="announcement-item">
          <div class="announcement-icon highschool">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
              <path d="M2 17l10 5 10-5"></path>
              <path d="M2 12l10 5 10-5"></path>
            </svg>
          </div>
          <div class="announcement-content">
            <h4 class="announcement-title">Highschool Friends</h4>
            <p class="announcement-text">10 year reunion this weekend!</p>
            <span class="announcement-time">1 day ago</span>
          </div>
        </div>

        <!-- Announcement 3 -->
        <div class="announcement-item">
          <div class="announcement-icon uni">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
              <line x1="16" y1="2" x2="16" y2="6"></line>
              <line x1="8" y1="2" x2="8" y2="6"></line>
              <line x1="3" y1="10" x2="21" y2="10"></line>
            </svg>
          </div>
          <div class="announcement-content">
            <h4 class="announcement-title">Uni Friends</h4>
            <p class="announcement-text">Game night this Friday at 8 PM</p>
            <span class="announcement-time">2 days ago</span>
          </div>
        </div>

        <!-- Announcement 4 -->
        <div class="announcement-item">
          <div class="announcement-icon roomies">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
              <polyline points="9 22 9 12 15 12 15 22"></polyline>
            </svg>
          </div>
          <div class="announcement-content">
            <h4 class="announcement-title">Roomies</h4>
            <p class="announcement-text">House cleaning day tomorrow!</p>
            <span class="announcement-time">3 days ago</span>
          </div>
        </div>

        <!-- Announcement 5 -->
        <div class="announcement-item">
          <div class="announcement-icon travel">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
              <circle cx="12" cy="10" r="3"></circle>
            </svg>
          </div>
          <div class="announcement-content">
            <h4 class="announcement-title">Travel Buddies</h4>
            <p class="announcement-text">Beach trip confirmed! ☀️🏖️</p>
            <span class="announcement-time">1 week ago</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Floating Create Button - Now static below sidebar -->
    <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
      <a href="/creategroup" class="floating-btn">
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
            const title = card.querySelector('.group-title')?.textContent?.toLowerCase() || '';
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