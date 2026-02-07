<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="com.demo.web.model.FeedPost" %>
    <%@ page import="com.demo.web.model.FeedComment" %>
      <%@ page import="com.demo.web.model.FeedProfile" %>
        <%@ page import="com.demo.web.model.MediaItem" %>
          <%@ page import="java.util.List" %>
            <% FeedPost post=(FeedPost) request.getAttribute("post"); List<FeedComment> comments = (List<FeedComment>)
                request.getAttribute("comments");
                FeedProfile currentProfile = (FeedProfile) request.getAttribute("currentProfile");
                Integer likeCount = (Integer) request.getAttribute("likeCount");
                Boolean isLikedByUser = (Boolean) request.getAttribute("isLikedByUser");
                Integer commentCount = (Integer) request.getAttribute("commentCount");
                Boolean isPostOwner = (Boolean) request.getAttribute("isPostOwner");
                List<MediaItem> mediaItems = (List<MediaItem>) request.getAttribute("mediaItems");

                    if (post == null) {
                    response.sendRedirect(request.getContextPath() + "/feed");
                    return;
                    }

                    FeedProfile postOwner = post.getFeedProfile();
                    if (likeCount == null) likeCount = 0;
                    if (isLikedByUser == null) isLikedByUser = false;
                    if (commentCount == null) commentCount = 0;
                    if (isPostOwner == null) isPostOwner = false;

                    String[] gradients = {
                    "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
                    "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)",
                    "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)",
                    "linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)",
                    "linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%)",
                    "linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)"
                    };
                    %>
                    <jsp:include page="../public/header2.jsp" />
                    <html>

                    <head>
                      <link rel="stylesheet" type="text/css"
                        href="${pageContext.request.contextPath}/resources/css/postcomments.css">
                      <style>
                        .delete-comment-btn {
                          background: none;
                          border: none;
                          color: #6b7280;
                          cursor: pointer;
                          font-size: 12px;
                          padding: 4px 8px;
                          margin-left: 8px;
                          border-radius: 4px;
                          transition: all 0.2s;
                        }

                        .delete-comment-btn:hover {
                          color: #dc2626;
                          background: rgba(220, 38, 38, 0.1);
                        }

                        .comment-like-btn.liked svg {
                          fill: #ed4956;
                          stroke: #ed4956;
                        }

                        .liked .svg-heart {
                          fill: #ed4956;
                          stroke: #ed4956;
                        }
                      </style>
                    </head>

                    <body>

                      <div class="comments-page-container">
                        <a href="${pageContext.request.contextPath}/feed" class="close-post-btn">
                          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                          </svg>
                        </a>

                        <div class="post-comments-wrapper">
                          <div class="post-image-section">
                            <% if (mediaItems !=null && !mediaItems.isEmpty()) { %>
                              <% MediaItem firstMedia=mediaItems.get(0); %>
                                <% if (firstMedia.getMediaType() !=null &&
                                  firstMedia.getMediaType().startsWith("video")) { %>
                                  <video src="<%= firstMedia.getMediaUrl() %>" controls
                                    style="width: 100%; height: 100%; object-fit: cover;"></video>
                                  <% } else { %>
                                    <img src="<%= firstMedia.getMediaUrl() %>" alt="Post image" id="postImage">
                                    <% } %>
                                      <% } else if (post.getCoverMediaUrl() !=null) { %>
                                        <img src="<%= post.getCoverMediaUrl() %>" alt="Post image" id="postImage">
                                        <% } else { %>
                                          <div
                                            style="width: 100%; height: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 48px;">
                                            <svg width="64" height="64" viewBox="0 0 24 24" fill="none"
                                              stroke="currentColor" stroke-width="2">
                                              <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                              <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                              <polyline points="21 15 16 10 5 21"></polyline>
                                            </svg>
                                          </div>
                                          <% } %>
                          </div>

                          <div class="post-details-section">
                            <div class="post-detail-header">
                              <div class="user-info">
                                <% if (postOwner.getFeedProfilePictureUrl() !=null &&
                                  !postOwner.getFeedProfilePictureUrl().contains("default")) { %>
                                  <img src="<%= postOwner.getFeedProfilePictureUrl() %>"
                                    alt="<%= postOwner.getFeedUsername() %>" class="user-avatar"
                                    style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                                  <% } else { %>
                                    <div class="user-avatar" style="background: <%= gradients[0] %>;">
                                      <span>
                                        <%= postOwner.getInitials() %>
                                      </span>
                                    </div>
                                    <% } %>
                                      <div class="user-details">
                                        <h4 class="username">
                                          <%= postOwner.getFeedUsername() %>
                                        </h4>
                                        <% if (post.getMemory() !=null && post.getMemory().getMemoryTitle() !=null) { %>
                                          <p class="post-location">
                                            <%= post.getMemory().getMemoryTitle() %>
                                          </p>
                                          <% } %>
                                      </div>
                              </div>
                            </div>

                            <div class="comments-list-container" id="commentsContainer">
                              <% if (post.getCaption() !=null && !post.getCaption().isEmpty()) { %>
                                <div class="comment-item original-caption">
                                  <% if (postOwner.getFeedProfilePictureUrl() !=null &&
                                    !postOwner.getFeedProfilePictureUrl().contains("default")) { %>
                                    <img src="<%= postOwner.getFeedProfilePictureUrl() %>"
                                      alt="<%= postOwner.getFeedUsername() %>" class="comment-avatar"
                                      style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover;">
                                    <% } else { %>
                                      <div class="comment-avatar" style="background: <%= gradients[0] %>;">
                                        <span>
                                          <%= postOwner.getInitials() %>
                                        </span>
                                      </div>
                                      <% } %>
                                        <div class="comment-content">
                                          <div class="comment-header">
                                            <span class="comment-username">
                                              <%= postOwner.getFeedUsername() %>
                                            </span>
                                            <span class="comment-time">
                                              <%= post.getRelativeTime() %>
                                            </span>
                                          </div>
                                          <p class="comment-text">
                                            <%= post.getCaption() %>
                                          </p>
                                        </div>
                                </div>
                                <% } %>

                                  <% int gradientIndex=1; if (comments !=null) { for (FeedComment comment : comments) {
                                    FeedProfile commenter=comment.getFeedProfile(); String
                                    gradient=gradients[gradientIndex % gradients.length]; gradientIndex++; boolean
                                    canDelete=isPostOwner ||
                                    (comment.getFeedProfileId()==currentProfile.getFeedProfileId()); %>
                                    <div class="comment-item" data-comment-id="<%= comment.getCommentId() %>">
                                      <% if (commenter.getFeedProfilePictureUrl() !=null &&
                                        !commenter.getFeedProfilePictureUrl().contains("default")) { %>
                                        <img src="<%= commenter.getFeedProfilePictureUrl() %>"
                                          alt="<%= commenter.getFeedUsername() %>" class="comment-avatar"
                                          style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover;">
                                        <% } else { %>
                                          <div class="comment-avatar" style="background: <%= gradient %>;">
                                            <span>
                                              <%= commenter.getInitials() %>
                                            </span>
                                          </div>
                                          <% } %>
                                            <div class="comment-content">
                                              <div class="comment-header">
                                                <span class="comment-username">
                                                  <%= commenter.getFeedUsername() %>
                                                </span>
                                                <span class="comment-time">
                                                  <%= comment.getRelativeTime() %>
                                                </span>
                                              </div>
                                              <p class="comment-text">
                                                <%= comment.getCommentText() %>
                                              </p>
                                              <div class="comment-actions">
                                                <button class="comment-like-btn <%= comment.isLikedByCurrentUser() ? "
                                                  liked" : "" %>"
                                                  data-comment-id="<%= comment.getCommentId() %>">
                                                    <svg class="svg-heart" width="12" height="12" viewBox="0 0 24 24"
                                                      fill="<%= comment.isLikedByCurrentUser() ? " #ed4956" : "none" %>"
                                                      stroke="<%= comment.isLikedByCurrentUser() ? "#ed4956"
                                                        : "currentColor" %>"
                                                        stroke-width="2">
                                                        <path
                                                          d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                        </path>
                                                    </svg>
                                                </button>
                                                <span class="comment-likes">
                                                  <%= comment.getLikeCount()> 0 ? comment.getLikeCount() + " likes" : ""
                                                    %>
                                                </span>
                                                <% if (canDelete) { %>
                                                  <button class="delete-comment-btn"
                                                    data-comment-id="<%= comment.getCommentId() %>">Delete</button>
                                                  <% } %>
                                              </div>
                                            </div>
                                    </div>
                                    <% } } %>
                            </div>

                            <div class="post-actions-bar">
                              <div class="post-actions">
                                <div class="action-buttons">
                                  <button class="action-btn like-btn <%= isLikedByUser ? " liked" : "" %>"
                                    data-post-id="<%= post.getPostId() %>">
                                      <svg class="svg-heart" width="24" height="24" viewBox="0 0 24 24"
                                        fill="<%= isLikedByUser ? " #ed4956" : "none" %>"
                                        stroke="<%= isLikedByUser ? "#ed4956" : "currentColor" %>"
                                          stroke-width="2">
                                          <path
                                            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                          </path>
                                      </svg>
                                  </button>
                                  <button class="action-btn">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                      stroke-width="2">
                                      <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                                    </svg>
                                  </button>
                                </div>
                              </div>
                              <div class="post-stats">
                                <p class="likes-count" id="likesCount">
                                  <%= likeCount %> likes
                                </p>
                                <p class="post-time-stamp">
                                  <%= post.getRelativeTime().toUpperCase() %>
                                </p>
                              </div>
                            </div>

                            <div class="add-comment-section">
                              <button class="emoji-btn">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2">
                                  <circle cx="12" cy="12" r="10"></circle>
                                  <path d="M8 14s1.5 2 4 2 4-2 4-2"></path>
                                  <line x1="9" y1="9" x2="9.01" y2="9"></line>
                                  <line x1="15" y1="9" x2="15.01" y2="9"></line>
                                </svg>
                              </button>
                              <input type="text" placeholder="Add a comment..." id="commentInput">
                              <button class="post-comment-btn" id="postCommentBtn"
                                data-post-id="<%= post.getPostId() %>">Post</button>
                            </div>
                          </div>
                        </div>
                      </div>

                      <script>
                        const contextPath = '${pageContext.request.contextPath}';
                        const currentUserInitials = '<%= currentProfile.getInitials() %>';
                        const currentUsername = '<%= currentProfile.getFeedUsername() %>';
                        const currentProfilePicUrl = '<%= currentProfile.getFeedProfilePictureUrl() != null ? currentProfile.getFeedProfilePictureUrl() : "" %>';

                        document.addEventListener('DOMContentLoaded', function () {
                          // Like post button
                          const likeBtn = document.querySelector('.like-btn');
                          likeBtn.addEventListener('click', function () {
                            const postId = this.dataset.postId;
                            const isLiked = this.classList.contains('liked');
                            const action = isLiked ? 'unlike' : 'like';

                            fetch(contextPath + '/postLike?postId=' + postId + '&action=' + action, {
                              method: 'POST',
                              headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                            })
                              .then(response => response.json())
                              .then(data => {
                                if (data.success) {
                                  const svg = this.querySelector('svg');
                                  if (data.isLiked) {
                                    this.classList.add('liked');
                                    svg.style.fill = '#ed4956';
                                    svg.style.stroke = '#ed4956';
                                  } else {
                                    this.classList.remove('liked');
                                    svg.style.fill = 'none';
                                    svg.style.stroke = 'currentColor';
                                  }
                                  document.getElementById('likesCount').textContent = data.likeCount + ' likes';
                                }
                              })
                              .catch(error => console.error('Error:', error));
                          });

                          // Comment like buttons
                          document.querySelectorAll('.comment-like-btn').forEach(btn => {
                            btn.addEventListener('click', handleCommentLike);
                          });

                          // Delete comment buttons
                          document.querySelectorAll('.delete-comment-btn').forEach(btn => {
                            btn.addEventListener('click', handleDeleteComment);
                          });

                          // Post comment functionality
                          const commentInput = document.getElementById('commentInput');
                          const postCommentBtn = document.getElementById('postCommentBtn');

                          commentInput.addEventListener('input', function () {
                            if (this.value.trim().length > 0) {
                              postCommentBtn.style.opacity = '1';
                              postCommentBtn.style.cursor = 'pointer';
                            } else {
                              postCommentBtn.style.opacity = '0.3';
                              postCommentBtn.style.cursor = 'default';
                            }
                          });

                          postCommentBtn.addEventListener('click', function () {
                            const commentText = commentInput.value.trim();
                            if (commentText.length === 0) return;

                            const postId = this.dataset.postId;

                            fetch(contextPath + '/commentAction?action=add&postId=' + postId + '&commentText=' + encodeURIComponent(commentText), {
                              method: 'POST',
                              headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                            })
                              .then(response => response.json())
                              .then(data => {
                                if (data.success) {
                                  const commentsContainer = document.getElementById('commentsContainer');
                                  const newComment = document.createElement('div');
                                  newComment.className = 'comment-item';
                                  newComment.dataset.commentId = data.comment.commentId;

                                  const avatarHtml = currentProfilePicUrl && !currentProfilePicUrl.includes('default')
                                    ? `<img src="${currentProfilePicUrl}" alt="${currentUsername}" class="comment-avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover;">`
                                    : `<div class="comment-avatar" style="background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);"><span>${currentUserInitials}</span></div>`;

                                  newComment.innerHTML = `
                        ${avatarHtml}
                        <div class="comment-content">
                            <div class="comment-header">
                                <span class="comment-username">${currentUsername}</span>
                                <span class="comment-time">Just now</span>
                            </div>
                            <p class="comment-text">${data.comment.commentText}</p>
                            <div class="comment-actions">
                                <button class="comment-like-btn" data-comment-id="${data.comment.commentId}">
                                    <svg class="svg-heart" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                                    </svg>
                                </button>
                                <span class="comment-likes"></span>
                                <button class="delete-comment-btn" data-comment-id="${data.comment.commentId}">Delete</button>
                            </div>
                        </div>
                    `;

                                  commentsContainer.appendChild(newComment);
                                  commentInput.value = '';
                                  postCommentBtn.style.opacity = '0.3';
                                  postCommentBtn.style.cursor = 'default';

                                  // Add event listeners to new buttons
                                  newComment.querySelector('.comment-like-btn').addEventListener('click', handleCommentLike);
                                  newComment.querySelector('.delete-comment-btn').addEventListener('click', handleDeleteComment);

                                  // Scroll to bottom
                                  commentsContainer.scrollTop = commentsContainer.scrollHeight;
                                }
                              })
                              .catch(error => console.error('Error:', error));
                          });

                          // Enter key to post comment
                          commentInput.addEventListener('keypress', function (e) {
                            if (e.key === 'Enter' && this.value.trim().length > 0) {
                              postCommentBtn.click();
                            }
                          });
                        });

                        function handleCommentLike() {
                          const commentId = this.dataset.commentId;
                          const isLiked = this.classList.contains('liked');
                          const action = isLiked ? 'unlike' : 'like';

                          fetch(contextPath + '/commentAction?action=' + action + '&commentId=' + commentId, {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                          })
                            .then(response => response.json())
                            .then(data => {
                              if (data.success) {
                                const svg = this.querySelector('svg');
                                const likesSpan = this.nextElementSibling;

                                if (data.isLiked) {
                                  this.classList.add('liked');
                                  svg.style.fill = '#ed4956';
                                  svg.style.stroke = '#ed4956';
                                } else {
                                  this.classList.remove('liked');
                                  svg.style.fill = 'none';
                                  svg.style.stroke = 'currentColor';
                                }

                                likesSpan.textContent = data.likeCount > 0 ? data.likeCount + ' likes' : '';
                              }
                            })
                            .catch(error => console.error('Error:', error));
                        }

                        function handleDeleteComment() {
                          const commentId = this.dataset.commentId;

                          if (!confirm('Are you sure you want to delete this comment?')) {
                            return;
                          }

                          fetch(contextPath + '/commentAction?action=delete&commentId=' + commentId, {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                          })
                            .then(response => response.json())
                            .then(data => {
                              if (data.success) {
                                const commentItem = document.querySelector(`.comment-item[data-comment-id="${commentId}"]`);
                                if (commentItem) {
                                  commentItem.remove();
                                }
                              } else {
                                alert('Failed to delete comment: ' + (data.error || 'Unknown error'));
                              }
                            })
                            .catch(error => console.error('Error:', error));
                        }
                      </script>

                    </body>

                    </html>