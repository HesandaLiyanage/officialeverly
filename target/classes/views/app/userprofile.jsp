<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/publicfeed.css">
</head>
<body>

<!-- Wrap everything after header -->
<div class="page-wrapper">
  <main class="main-content">
    <!-- Fixed Top Section: Tabs + Search -->
    <div class="fixed-top-section">
      <!-- Tab Navigation -->
      <div class="tab-nav">
        </a>
      </div>

      <!-- Search Bar -->
      <div class="search-filters" style="margin-top: 10px; margin-bottom: 15px;">
        <div class="memories-search-container">
          </button>
        </div>
      </div>
    </div>

    <!-- Scrollable Profile Content -->
    <div class="scrollable-feed" id="feedContainer">

      <!-- Profile Header -->
      <div class="profile-header">
        <div class="profile-avatar">
          <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop" alt="Sophia Bennett">
        </div>
        <div class="profile-info">
          <div class="profile-name">
            <h1>Sophia Bennett</h1>
            <a href="/feededitprofile" class="edit-profile-btn">Edit profile</a>
          </div>
          <div class="profile-stats">
            <span><strong>1,234</strong> posts</span>
            <a href="/followers"><strong>5,678</strong> followers</a>
            <a href="/following"><strong>1,234</strong> following</a>
          </div>
          <div class="profile-bio">
            Travel enthusiast | Photographer | Sharing my adventures around the globe
          </div>
        </div>
      </div>

      <!-- Posts/Saved Tabs -->
      <div class="profile-tabs">
        <button class="active" data-tab="posts">Posts</button>
        <button data-tab="saved">Saved</button>
      </div>

      <!-- Posts Grid -->
      <div class="profile-posts-grid">
        <!-- Post 1 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800" alt="Beach sunset">
        </div>
        <!-- Post 2 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800" alt="City skyline">
        </div>
        <!-- Post 3 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800" alt="Coffee cup">
        </div>
        <!-- Post 4 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800" alt="Mountain landscape">
        </div>
        <!-- Post 5 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800" alt="Beach sunset">
        </div>
        <!-- Post 6 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800" alt="City skyline">
        </div>
        <!-- Post 7 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800" alt="Coffee cup">
        </div>
        <!-- Post 8 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800" alt="Mountain landscape">
        </div>
        <!-- Post 9 -->
        <div class="profile-post-item">
          <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800" alt="Beach sunset">
        </div>
      </div>

    </div>
  </main>

  <aside class="sidebar">
    <!-- Suggested Section -->
    <div class="sidebar-section">
      <h3 class="sidebar-title">Suggested For You</h3>
      <ul class="favorites-list">
        <li class="favorite-item">
          <div class="favorite-icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">JD</div>
          <div class="favorite-content">
            <span class="favorite-name">jessica_doe</span>
            <span class="follower-info">Followed by 3 friends</span>
          </div>
          <button class="follow-btn-small">Follow</button>
        </li>
        <li class="favorite-item">
          <div class="favorite-icon" style="background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);">MS</div>
          <div class="favorite-content">
            <span class="favorite-name">mike_smith</span>
            <span class="follower-info">Followed by 5 friends</span>
          </div>
          <button class="follow-btn-small">Follow</button>
        </li>
        <li class="favorite-item">
          <div class="favorite-icon" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">EW</div>
          <div class="favorite-content">
            <span class="favorite-name">emma_wilson</span>
            <span class="follower-info">Followed by 2 friends</span>
          </div>
          <button class="follow-btn-small">Follow</button>
        </li>
        <li class="favorite-item">
          <div class="favorite-icon" style="background: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%);">AB</div>
          <div class="favorite-content">
            <span class="favorite-name">alex_brown</span>
            <span class="follower-info">Followed by 4 friends</span>
          </div>
          <button class="follow-btn-small">Follow</button>
        </li>
        <li class="favorite-item">
          <div class="favorite-icon" style="background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);">ST</div>
          <div class="favorite-content">
            <span class="favorite-name">sarah_taylor</span>
            <span class="follower-info">Followed by 6 friends</span>
          </div>
          <button class="follow-btn-small">Follow</button>
        </li>
      </ul>
    </div>
  </aside>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
  // Modern Search Functionality (same as before)
  document.addEventListener('DOMContentLoaded', function() {
    const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');

    if (memoriesSearchBtn) {
      memoriesSearchBtn.addEventListener('click', function(event) {
        event.stopPropagation();

        const searchBtnElement = this;
        const searchContainer = searchBtnElement.parentElement;

        const searchBox = document.createElement('div');
        searchBox.className = 'memories-search-expanded';
        searchBox.innerHTML = `
          <div class="memories-search-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          </div>
          <input type="text" id="searchInput" placeholder="Search posts..." autofocus>
          <button class="memories-search-close">
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
          newSearchBtn.className = 'memories-search-btn';
          newSearchBtn.id = 'memoriesSearchBtn';
          newSearchBtn.innerHTML = `
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <path d="m21 21-4.35-4.35"></path>
            </svg>
          `;
          searchContainer.replaceChild(newSearchBtn, searchBox);
          newSearchBtn.addEventListener('click', arguments.callee);
        };

        searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

        input.addEventListener('blur', function() {
          setTimeout(() => {
            if (!document.activeElement.closest('.memories-search-expanded')) {
              closeSearch();
            }
          }, 150);
        });

        searchBox.addEventListener('mousedown', function(e) {
          e.preventDefault();
          input.focus();
        });

        input.addEventListener('input', function(e) {
          const query = e.target.value.toLowerCase();
          const feedPosts = document.querySelectorAll('.feed-post');
          feedPosts.forEach(post => {
            const username = post.querySelector('.username').textContent.toLowerCase();
            const caption = post.querySelector('.post-caption').textContent.toLowerCase();
            post.style.display = (username.includes(query) || caption.includes(query)) ? 'block' : 'none';
          });
        });
      });
    }

    // Tab switching functionality
    const tabButtons = document.querySelectorAll('.tab-nav button');
    const feedContainer = document.getElementById('feedContainer');

    tabButtons.forEach(button => {
      button.addEventListener('click', function() {
        const tab = this.getAttribute('data-tab');

        tabButtons.forEach(btn => btn.classList.remove('active'));
        this.classList.add('active');

        if (tab === 'home') {
          location.reload();
        } else if (tab === 'explore') {
          feedContainer.innerHTML = '<p style="text-align: center; color: #6c757d; margin: 40px 0; font-size: 16px;">Discover new content and explore amazing posts!</p>';
        }
      });
    });

    // Profile Tabs (Posts / Saved)
    const profileTabButtons = document.querySelectorAll('.profile-tabs button');
    profileTabButtons.forEach(button => {
      button.addEventListener('click', function() {
        profileTabButtons.forEach(btn => btn.classList.remove('active'));
        this.classList.add('active');
      });
    });

    // Like button functionality
    const likeButtons = document.querySelectorAll('.like-btn');
    likeButtons.forEach(btn => {
      btn.addEventListener('click', function() {
        this.classList.toggle('liked');
        const svg = this.querySelector('svg');
        if (this.classList.contains('liked')) {
          svg.style.fill = '#ed4956';
          svg.style.stroke = '#ed4956';
        } else {
          svg.style.fill = 'none';
          svg.style.stroke = 'currentColor';
        }
      });
    });

    // Bookmark button functionality
    const bookmarkButtons = document.querySelectorAll('.bookmark-btn');
    bookmarkButtons.forEach(btn => {
      btn.addEventListener('click', function() {
        this.classList.toggle('bookmarked');
        const svg = this.querySelector('svg');
        if (this.classList.contains('bookmarked')) {
          svg.style.fill = '#262626';
        } else {
          svg.style.fill = 'none';
        }
      });
    });

    // Follow button functionality
    const followButtons = document.querySelectorAll('.follow-btn-small');
    followButtons.forEach(btn => {
      btn.addEventListener('click', function() {
        if (this.textContent === 'Follow') {
          this.textContent = 'Following';
          this.style.background = 'transparent';
          this.style.color = '#333';
          this.style.border = '1px solid #dbdbdb';
        } else {
          this.textContent = 'Follow';
          this.style.background = '#6366f1';
          this.style.color = 'white';
          this.style.border = 'none';
        }
      });
    });
  });
</script>
</body>
</html>