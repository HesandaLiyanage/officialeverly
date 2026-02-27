<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="com.demo.web.model.FeedProfile" %>
    <%@ page import="com.demo.web.model.FeedPost" %>
      <%@ page import="java.util.List" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
          <% FeedProfile profileToView=(FeedProfile) request.getAttribute("profileToView"); FeedProfile
            currentUserProfile=(FeedProfile) request.getAttribute("currentUserProfile"); Boolean isOwnProfile=(Boolean)
            request.getAttribute("isOwnProfile"); Boolean isFollowing=(Boolean) request.getAttribute("isFollowing");
            Integer followerCount=(Integer) request.getAttribute("followerCount"); Integer followingCount=(Integer)
            request.getAttribute("followingCount"); Integer postCount=(Integer) request.getAttribute("postCount");
            List<FeedPost> userPosts = (List<FeedPost>) request.getAttribute("userPosts");
              List<FeedPost> savedPosts = (List<FeedPost>) request.getAttribute("savedPosts");
                  List<FeedProfile> recommendedUsers = (List<FeedProfile>) request.getAttribute("recommendedUsers");

                      // Fallback values
                      if (profileToView == null && currentUserProfile != null) {
                      profileToView = currentUserProfile;
                      isOwnProfile = true;
                      }
                      if (followerCount == null) followerCount = 0;
                      if (followingCount == null) followingCount = 0;
                      if (postCount == null) postCount = 0;
                      if (isOwnProfile == null) isOwnProfile = true;
                      if (isFollowing == null) isFollowing = false;

                      Boolean isBlocked = (Boolean) request.getAttribute("isBlocked");
                      if (isBlocked == null) isBlocked = false;

                      String profileUsername = (profileToView != null) ? profileToView.getFeedUsername() : "user";
                      String profilePic = (profileToView != null && profileToView.getFeedProfilePictureUrl() != null)
                      ? profileToView.getFeedProfilePictureUrl() : null;
                      String profileBio = (profileToView != null && profileToView.getFeedBio() != null)
                      ? profileToView.getFeedBio() : "No bio yet";
                      String profileInitials = (profileToView != null) ? profileToView.getInitials() : "U";
                      int profileId = (profileToView != null) ? profileToView.getFeedProfileId() : 0;
                      %>

                      <jsp:include page="../public/header2.jsp" />
                      <!DOCTYPE html>
                      <html lang="en">

                      <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>@<%= profileUsername %> - Everly</title>
                        <link rel="stylesheet" type="text/css"
                          href="${pageContext.request.contextPath}/resources/css/publicfeed.css">
                        <style>
                          /* Profile page styles */
                          .follow-btn {
                            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
                            color: white;
                            border: none;
                            padding: 10px 28px;
                            border-radius: 10px;
                            font-size: 14px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.3s ease;
                            text-decoration: none;
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                          }

                          .follow-btn:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 8px 24px rgba(99, 102, 241, 0.4);
                          }

                          .follow-btn.following {
                            background: transparent;
                            color: #333;
                            border: 2px solid #dbdbdb;
                          }

                          .follow-btn.following:hover {
                            border-color: #ed4956;
                            color: #ed4956;
                            background: rgba(237, 73, 86, 0.05);
                          }

                          .profile-avatar-large {
                            width: 120px;
                            height: 120px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 36px;
                            font-weight: 700;
                            color: white;
                            background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%);
                            box-shadow: 0 4px 20px rgba(154, 116, 216, 0.3);
                          }

                          .profile-avatar-large img {
                            width: 100%;
                            height: 100%;
                            border-radius: 50%;
                            object-fit: cover;
                          }

                          .empty-posts {
                            text-align: center;
                            padding: 60px 20px;
                            color: #6c757d;
                          }

                          .empty-posts svg {
                            width: 80px;
                            height: 80px;
                            stroke: #d1d5db;
                            margin-bottom: 20px;
                          }

                          .empty-posts h3 {
                            color: #374151;
                            margin-bottom: 8px;
                          }

                          .profile-post-overlay {
                            position: absolute;
                            top: 0;
                            left: 0;
                            right: 0;
                            bottom: 0;
                            background: rgba(0, 0, 0, 0.3);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            opacity: 0;
                            transition: opacity 0.3s ease;
                          }

                          .profile-post-item:hover .profile-post-overlay {
                            opacity: 1;
                          }

                          .profile-post-overlay svg {
                            width: 24px;
                            height: 24px;
                            color: white;
                          }

                          .posts-container {
                            display: block;
                          }

                          .posts-container.hidden {
                            display: none;
                          }

                          .profile-tabs button.active {
                            border-bottom: 2px solid #262626;
                            color: #262626;
                          }

                          .block-btn {
                            background: transparent;
                            color: #6c757d;
                            border: 2px solid #e5e7eb;
                            padding: 10px 28px;
                            border-radius: 10px;
                            font-size: 14px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.3s ease;
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                          }

                          .block-btn:hover {
                            border-color: #ed4956;
                            color: #ed4956;
                            background: rgba(237, 73, 86, 0.05);
                          }

                          .block-btn.blocked {
                            background: rgba(237, 73, 86, 0.1);
                            color: #ed4956;
                            border-color: #ed4956;
                          }

                          .block-btn.blocked:hover {
                            background: transparent;
                            color: #6c757d;
                            border-color: #e5e7eb;
                          }

                          .profile-action-buttons {
                            display: flex;
                            gap: 10px;
                            align-items: center;
                            flex-wrap: wrap;
                          }

                          .toast-notification {
                            position: fixed;
                            bottom: 30px;
                            left: 50%;
                            transform: translateX(-50%) translateY(20px);
                            background: #1e1e2e;
                            color: white;
                            padding: 14px 28px;
                            border-radius: 12px;
                            font-size: 14px;
                            font-weight: 500;
                            z-index: 9999;
                            pointer-events: none;
                            opacity: 0;
                            transition: all 0.3s ease;
                            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
                          }

                          .toast-notification.show {
                            opacity: 1;
                            transform: translateX(-50%) translateY(0);
                          }
                        </style>
                      </head>

                      <body>

                        <div class="page-wrapper">
                          <main class="main-content">
                            <!-- Fixed Top Section -->
                            <div class="fixed-top-section">
                              <div class="tab-nav">
                                <div class="tab-buttons">
                                  <a href="${pageContext.request.contextPath}/feed" style="text-decoration: none;">
                                    <button>← Feed</button>
                                  </a>
                                </div>
                              </div>
                            </div>

                            <!-- Scrollable Profile Content -->
                            <div class="scrollable-feed" id="feedContainer">
                              <!-- Profile Header -->
                              <div class="profile-header">
                                <div class="profile-avatar">
                                  <% if (profilePic !=null && !profilePic.contains("default")) { %>
                                    <div class="profile-avatar-large">
                                      <img src="<%= profilePic %>" alt="@<%= profileUsername %>">
                                    </div>
                                    <% } else { %>
                                      <div class="profile-avatar-large">
                                        <%= profileInitials %>
                                      </div>
                                      <% } %>
                                </div>
                                <div class="profile-info">
                                  <div class="profile-name">
                                    <h1>@<%= profileUsername %>
                                    </h1>
                                    <% if (isOwnProfile) { %>
                                      <a href="${pageContext.request.contextPath}/feededitprofile"
                                        class="edit-profile-btn">Edit profile</a>
                                      <% } else { %>
                                        <div class="profile-action-buttons">
                                          <button class="follow-btn <%= isFollowing ? " following" : "" %>"
                                            id="followBtn" data-profile-id="<%= profileId %>" data-is-following="<%=
                                                isFollowing %>">
                                                <% if (isFollowing) { %>
                                                  Following
                                                  <% } else { %>
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                      stroke="currentColor" stroke-width="2">
                                                      <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                      <circle cx="8.5" cy="7" r="4" />
                                                      <line x1="20" y1="8" x2="20" y2="14" />
                                                      <line x1="23" y1="11" x2="17" y2="11" />
                                                    </svg>
                                                    Follow
                                                    <% } %>
                                          </button>
                                          <button class="block-btn <%= isBlocked ? " blocked" : "" %>" id="blockBtn"
                                            data-profile-id="<%= profileId %>" data-username="<%= profileUsername %>"
                                                data-is-blocked="<%= isBlocked %>" onclick="toggleBlockUser()">
                                                  <% if (isBlocked) { %>
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                      stroke="currentColor" stroke-width="2">
                                                      <circle cx="12" cy="12" r="10"></circle>
                                                    </svg>
                                                    Blocked
                                                    <% } else { %>
                                                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10"></circle>
                                                      </svg>
                                                      Block
                                                      <% } %>
                                          </button>
                                        </div>
                                        <% } %>
                                  </div>
                                  <div class="profile-stats">
                                    <span><strong id="postCount">
                                        <%= postCount %>
                                      </strong> posts</span>
                                    <a href="${pageContext.request.contextPath}/followers?profileId=<%= profileId %>">
                                      <strong id="followerCount">
                                        <%= followerCount %>
                                      </strong> followers
                                    </a>
                                    <a href="${pageContext.request.contextPath}/following?profileId=<%= profileId %>">
                                      <strong id="followingCount">
                                        <%= followingCount %>
                                      </strong> following
                                    </a>
                                  </div>
                                  <div class="profile-bio">
                                    <%= profileBio %>
                                  </div>
                                </div>
                              </div>

                              <!-- Posts/Saved Tabs -->
                              <div class="profile-tabs">
                                <button class="active" data-tab="posts" onclick="showTab('posts')">Posts</button>
                                <% if (isOwnProfile) { %>
                                  <button data-tab="saved" onclick="showTab('saved')">Saved</button>
                                  <% } %>
                              </div>

                              <!-- Posts Section -->
                              <div id="postsSection" class="posts-container">
                                <% if (userPosts==null || userPosts.isEmpty()) { %>
                                  <div class="empty-posts">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                      <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                      <circle cx="8.5" cy="8.5" r="1.5" />
                                      <polyline points="21 15 16 10 5 21" />
                                    </svg>
                                    <h3>
                                      <%= isOwnProfile ? "No posts yet" : "No posts yet" %>
                                    </h3>
                                    <p>
                                      <%= isOwnProfile ? "Share your first memory to the feed!"
                                        : "This user hasn't shared any posts yet." %>
                                    </p>
                                    <% if (isOwnProfile) { %>
                                      <a href="${pageContext.request.contextPath}/createPost" class="empty-feed-btn"
                                        style="margin-top: 16px; display: inline-flex;">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                          stroke="currentColor" stroke-width="2">
                                          <circle cx="12" cy="12" r="10" />
                                          <line x1="12" y1="8" x2="12" y2="16" />
                                          <line x1="8" y1="12" x2="16" y2="12" />
                                        </svg>
                                        Create Post
                                      </a>
                                      <% } %>
                                  </div>
                                  <% } else { %>
                                    <div class="profile-posts-grid">
                                      <% for (FeedPost post : userPosts) { String coverUrl=post.getCoverMediaUrl(); %>
                                        <div class="profile-post-item"
                                          onclick="window.location.href='${pageContext.request.contextPath}/comments?postId=<%= post.getPostId() %>'">
                                          <% if (coverUrl !=null && !coverUrl.isEmpty()) { %>
                                            <img src="<%= coverUrl %>" alt="Post">
                                            <% } else { %>
                                              <div
                                                style="width: 100%; aspect-ratio: 1; background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e1 100%); display: flex; align-items: center; justify-content: center;">
                                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                                                  stroke="#94a3b8" stroke-width="1.5">
                                                  <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                  <circle cx="8.5" cy="8.5" r="1.5" />
                                                  <polyline points="21 15 16 10 5 21" />
                                                </svg>
                                              </div>
                                              <% } %>
                                                <div class="profile-post-overlay">
                                                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                                    <circle cx="12" cy="12" r="3" />
                                                  </svg>
                                                </div>
                                        </div>
                                        <% } %>
                                    </div>
                                    <% } %>
                              </div>

                              <!-- Saved Section (only for own profile) -->
                              <% if (isOwnProfile) { %>
                                <div id="savedSection" class="posts-container hidden">
                                  <% if (savedPosts==null || savedPosts.isEmpty()) { %>
                                    <div class="empty-posts">
                                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                        <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z" />
                                      </svg>
                                      <h3>No saved posts yet</h3>
                                      <p>Save posts to view them later. Only you can see what you've saved.</p>
                                    </div>
                                    <% } else { %>
                                      <div class="profile-posts-grid">
                                        <% for (FeedPost post : savedPosts) { String coverUrl=post.getCoverMediaUrl();
                                          %>
                                          <div class="profile-post-item"
                                            onclick="window.location.href='${pageContext.request.contextPath}/comments?postId=<%= post.getPostId() %>'">
                                            <% if (coverUrl !=null && !coverUrl.isEmpty()) { %>
                                              <img src="<%= coverUrl %>" alt="Saved Post">
                                              <% } else { %>
                                                <div
                                                  style="width: 100%; aspect-ratio: 1; background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e1 100%); display: flex; align-items: center; justify-content: center;">
                                                  <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                                                    stroke="#94a3b8" stroke-width="1.5">
                                                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                                    <polyline points="21 15 16 10 5 21" />
                                                  </svg>
                                                </div>
                                                <% } %>
                                                  <div class="profile-post-overlay">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                      stroke-width="2">
                                                      <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z" />
                                                    </svg>
                                                  </div>
                                          </div>
                                          <% } %>
                                      </div>
                                      <% } %>
                                </div>
                                <% } %>
                            </div>
                          </main>

                          <aside class="sidebar">
                            <!-- Suggested Section -->
                            <div class="sidebar-section">
                              <h3 class="sidebar-title">Suggested For You</h3>
                              <ul class="favorites-list">
                                <% String[] gradients={ "linear-gradient(135deg, #fa709a 0%, #fee140 100%)"
                                  , "linear-gradient(135deg, #30cfd0 0%, #330867 100%)"
                                  , "linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)"
                                  , "linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%)"
                                  , "linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)" }; int gradientIndex=0; if
                                  (recommendedUsers !=null && !recommendedUsers.isEmpty()) { for (FeedProfile user :
                                  recommendedUsers) { String gradient=gradients[gradientIndex % gradients.length];
                                  gradientIndex++; %>
                                  <li class="favorite-item">
                                    <% if (user.getFeedProfilePictureUrl() !=null &&
                                      !user.getFeedProfilePictureUrl().contains("default")) { %>
                                      <img src="<%= user.getFeedProfilePictureUrl() %>"
                                        alt="@<%= user.getFeedUsername() %>"
                                        style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; flex-shrink: 0;">
                                      <% } else { %>
                                        <div class="favorite-icon" style="background: <%= gradient %>;">
                                          <%= user.getInitials() %>
                                        </div>
                                        <% } %>
                                          <div class="favorite-content">
                                            <a href="${pageContext.request.contextPath}/publicprofile?username=<%= user.getFeedUsername() %>"
                                              style="text-decoration: none;">
                                              <span class="favorite-name">
                                                <%= user.getFeedUsername() %>
                                              </span>
                                            </a>
                                            <span class="follower-info">Suggested for you</span>
                                          </div>
                                          <button class="follow-btn-small"
                                            data-profile-id="<%= user.getFeedProfileId() %>"
                                            onclick="handleFollow(this, <%= user.getFeedProfileId() %>)">Follow</button>
                                  </li>
                                  <% } } else { %>
                                    <li style="text-align: center; color: #6c757d; padding: 20px 0;">
                                      No suggestions available
                                    </li>
                                    <% } %>
                              </ul>
                            </div>
                          </aside>
                        </div>

                        <jsp:include page="../public/footer.jsp" />

                        <script>
                          // Tab switching for posts/saved
                          function showTab(tab) {
                            const tabs = document.querySelectorAll('.profile-tabs button');
                            const postsSection = document.getElementById('postsSection');
                            const savedSection = document.getElementById('savedSection');

                            tabs.forEach(t => t.classList.remove('active'));
                            document.querySelector('[data-tab="' + tab + '"]').classList.add('active');

                            if (tab === 'posts') {
                              postsSection.classList.remove('hidden');
                              if (savedSection) savedSection.classList.add('hidden');
                            } else if (tab === 'saved') {
                              postsSection.classList.add('hidden');
                              if (savedSection) savedSection.classList.remove('hidden');
                            }
                          }

                          document.addEventListener('DOMContentLoaded', function () {
                            // Follow button functionality for main profile
                            const followBtn = document.getElementById('followBtn');
                            if (followBtn) {
                              followBtn.addEventListener('click', function () {
                                const profileId = this.dataset.profileId;
                                const isFollowing = this.dataset.isFollowing === 'true';
                                const action = isFollowing ? 'unfollow' : 'follow';

                                fetch('${pageContext.request.contextPath}/followUser?action=' + action + '&targetProfileId=' + profileId, {
                                  method: 'POST',
                                  headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                  }
                                })
                                  .then(response => response.json())
                                  .then(data => {
                                    if (data.success) {
                                      this.dataset.isFollowing = data.isFollowing.toString();
                                      if (data.isFollowing) {
                                        this.classList.add('following');
                                        this.innerHTML = 'Following';
                                      } else {
                                        this.classList.remove('following');
                                        this.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="23" y1="11" x2="17" y2="11"/></svg> Follow';
                                      }
                                      // Update follower count
                                      document.getElementById('followerCount').textContent = data.followerCount;
                                    }
                                  })
                                  .catch(error => console.error('Error:', error));
                              });
                            }
                          });

                          // Handle follow for recommended users
                          function handleFollow(btn, profileId) {
                            const isFollowing = btn.textContent.trim() === 'Following';
                            const action = isFollowing ? 'unfollow' : 'follow';

                            fetch('${pageContext.request.contextPath}/followUser?action=' + action + '&targetProfileId=' + profileId, {
                              method: 'POST',
                              headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                              }
                            })
                              .then(response => response.json())
                              .then(data => {
                                if (data.success) {
                                  if (data.isFollowing) {
                                    btn.textContent = 'Following';
                                    btn.style.background = 'transparent';
                                    btn.style.color = '#333';
                                    btn.style.border = '1px solid #dbdbdb';
                                  } else {
                                    btn.textContent = 'Follow';
                                    btn.style.background = '#6366f1';
                                    btn.style.color = 'white';
                                    btn.style.border = 'none';
                                  }
                                }
                              })
                              .catch(error => console.error('Error:', error));
                          }

                          // Block/Unblock user toggle
                          function toggleBlockUser() {
                            const blockBtn = document.getElementById('blockBtn');
                            const profileId = blockBtn.dataset.profileId;
                            const username = blockBtn.dataset.username;
                            const isBlocked = blockBtn.dataset.isBlocked === 'true';

                            if (isBlocked) {
                              // Unblock
                              if (!confirm('Unblock @' + username + '? Their posts will appear in your feed again.')) return;

                              fetch('${pageContext.request.contextPath}/unblockuser', {
                                method: 'POST',
                                headers: {
                                  'Content-Type': 'application/x-www-form-urlencoded',
                                  'X-Requested-With': 'XMLHttpRequest'
                                },
                                body: 'profileId=' + profileId
                              })
                                .then(response => response.json())
                                .then(data => {
                                  if (data.success) {
                                    blockBtn.dataset.isBlocked = 'false';
                                    blockBtn.classList.remove('blocked');
                                    blockBtn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle></svg> Block';
                                    showToast('✅ @' + username + ' has been unblocked');
                                  } else {
                                    showToast('⚠️ ' + (data.message || 'Could not unblock user'));
                                  }
                                })
                                .catch(error => {
                                  console.error('Error:', error);
                                  showToast('⚠️ Error unblocking user');
                                });
                            } else {
                              // Block
                              if (!confirm('Block @' + username + '? Their posts will no longer appear in your feed.')) return;

                              fetch('${pageContext.request.contextPath}/blockUser?targetProfileId=' + profileId, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                              })
                                .then(response => response.json())
                                .then(data => {
                                  if (data.success) {
                                    blockBtn.dataset.isBlocked = 'true';
                                    blockBtn.classList.add('blocked');
                                    blockBtn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle></svg> Blocked';
                                    showToast('🚫 @' + username + ' has been blocked');
                                  } else {
                                    showToast('⚠️ ' + (data.message || 'Could not block user'));
                                  }
                                })
                                .catch(error => {
                                  console.error('Error:', error);
                                  showToast('⚠️ Error blocking user');
                                });
                            }
                          }

                          // Toast notification
                          function showToast(message) {
                            var existing = document.querySelector('.toast-notification');
                            if (existing) existing.remove();

                            var toast = document.createElement('div');
                            toast.className = 'toast-notification';
                            toast.textContent = message;
                            document.body.appendChild(toast);

                            setTimeout(function () { toast.classList.add('show'); }, 10);
                            setTimeout(function () {
                              toast.classList.remove('show');
                              setTimeout(function () { toast.remove(); }, 300);
                            }, 3000);
                          }
                        </script>
                      </body>

                      </html>