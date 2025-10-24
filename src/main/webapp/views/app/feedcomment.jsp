<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
  <link rel="stylesheet" type="text/css" href="/resources/css/postcomments.css">
</head>
<body>

<!-- Main Container -->
<div class="comments-page-container">
  <!-- Close Button -->
  <a href="publicfeed.jsp" class="close-post-btn">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <line x1="18" y1="6" x2="6" y2="18"></line>
      <line x1="6" y1="6" x2="18" y2="18"></line>
    </svg>
  </a>

  <!-- Two Column Layout -->
  <div class="post-comments-wrapper">

    <!-- Left Side - Post Image -->
    <div class="post-image-section">
      <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200" alt="Post image" id="postImage">
    </div>

    <!-- Right Side - Post Details & Comments -->
    <div class="post-details-section">

      <!-- Post Header -->
      <div class="post-detail-header">
        <div class="user-info">
          <div class="user-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <span>DW</span>
          </div>
          <div class="user-details">
            <h4 class="username">dave_wanderer</h4>
            <p class="post-location">Miami Beach, Florida</p>
          </div>
        </div>
        <button class="post-options">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="1"></circle>
            <circle cx="12" cy="5" r="1"></circle>
            <circle cx="12" cy="19" r="1"></circle>
          </svg>
        </button>
      </div>

      <!-- Comments Section (Scrollable) -->
      <div class="comments-list-container" id="commentsContainer">

        <!-- Original Post Caption -->
        <div class="comment-item original-caption">
          <div class="comment-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <span>DW</span>
          </div>
          <div class="comment-content">
            <div class="comment-header">
              <span class="comment-username">dave_wanderer</span>
              <span class="comment-time">6h</span>
            </div>
            <p class="comment-text">
              Enjoying the sun, sand, and sea with friends. Perfect day at the beach!
              <span class="hashtag">#beachlife</span> <span class="hashtag">#summer</span>
            </p>
            <div class="comment-actions">
              <button class="comment-action-btn">Reply</button>
            </div>
          </div>
        </div>

        <!-- Comment 1 -->
        <div class="comment-item">
          <div class="comment-avatar" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <span>JD</span>
          </div>
          <div class="comment-content">
            <div class="comment-header">
              <span class="comment-username">jessica_doe</span>
              <span class="comment-time">5h</span>
            </div>
            <p class="comment-text">Looks amazing! Wish I was there 🌊</p>
            <div class="comment-actions">
              <button class="comment-action-btn">Reply</button>
              <button class="comment-like-btn">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
              </button>
              <span class="comment-likes">24 likes</span>
            </div>
          </div>
        </div>

        <!-- Comment 2 -->
        <div class="comment-item">
          <div class="comment-avatar" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
            <span>MS</span>
          </div>
          <div class="comment-content">
            <div class="comment-header">
              <span class="comment-username">mike_smith</span>
              <span class="comment-time">4h</span>
            </div>
            <p class="comment-text">Beautiful sunset! 🌅</p>
            <div class="comment-actions">
              <button class="comment-action-btn">Reply</button>
              <button class="comment-like-btn">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
              </button>
              <span class="comment-likes">12 likes</span>
            </div>
          </div>
        </div>

        <!-- Comment 3 -->
        <div class="comment-item">
          <div class="comment-avatar" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
            <span>EW</span>
          </div>
          <div class="comment-content">
            <div class="comment-header">
              <span class="comment-username">emma_wilson</span>
              <span class="comment-time">3h</span>
            </div>
            <p class="comment-text">This is goals! 😍 Can't wait for summer vacation</p>
            <div class="comment-actions">
              <button class="comment-action-btn">Reply</button>
              <button class="comment-like-btn">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
              </button>
              <span class="comment-likes">8 likes</span>
            </div>
          </div>
        </div>

        <!-- Comment 4 -->
        <div class="comment-item">
          <div class="comment-avatar" style="background: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%);">
            <span>AB</span>
          </div>
          <div class="comment-content">
            <div class="comment-header">
              <span class="comment-username">alex_brown</span>
              <span class="comment-time">2h</span>
            </div>
            <p class="comment-text">
              <span class="mention">@dave_wanderer</span> Where exactly is this? Planning a trip soon!
            </p>
            <div class="comment-actions">
              <button class="comment-action-btn">Reply</button>
              <button class="comment-like-btn">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
              </button>
              <span class="comment-likes">5 likes</span>
            </div>

            <!-- Nested Reply -->
            <div class="comment-reply">
              <div class="comment-item">
                <div class="comment-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                  <span>DW</span>
                </div>
                <div class="comment-content">
                  <div class="comment-header">
                    <span class="comment-username">dave_wanderer</span>
                    <span class="comment-time">1h</span>
                  </div>
                  <p class="comment-text">
                    <span class="mention">@alex_brown</span> This is Miami Beach! Highly recommend it 🏖️
                  </p>
                  <div class="comment-actions">
                    <button class="comment-action-btn">Reply</button>
                    <button class="comment-like-btn">
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                      </svg>
                    </button>
                    <span class="comment-likes">3 likes</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Comment 5 -->
        <div class="comment-item">
          <div class="comment-avatar" style="background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);">
            <span>ST</span>
          </div>
          <div class="comment-content">
            <div class="comment-header">
              <span class="comment-username">sarah_taylor</span>
              <span class="comment-time">30m</span>
            </div>
            <p class="comment-text">Perfect vibes! 🌴☀️</p>
            <div class="comment-actions">
              <button class="comment-action-btn">Reply</button>
              <button class="comment-like-btn">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
              </button>
              <span class="comment-likes">2 likes</span>
            </div>
          </div>
        </div>

      </div>

      <!-- Post Actions Bar -->
      <div class="post-actions-bar">
        <div class="post-actions">
          <div class="action-buttons">
            <button class="action-btn like-btn">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
              </svg>
            </button>
            <button class="action-btn">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
              </svg>
            </button>
            <button class="action-btn repost-btn">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="17 1 21 5 17 9"></polyline>
                <path d="M3 11V9a4 4 0 0 1 4-4h14"></path>
                <polyline points="7 23 3 19 7 15"></polyline>
                <path d="M21 13v2a4 4 0 0 1-4 4H3"></path>
              </svg>
            </button>
          </div>
        </div>
        <div class="post-stats">
          <p class="likes-count">120 likes</p>
          <p class="post-time-stamp">6 HOURS AGO</p>
        </div>
      </div>

      <!-- Add Comment Section -->
      <div class="add-comment-section">
        <button class="emoji-btn">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M8 14s1.5 2 4 2 4-2 4-2"></path>
            <line x1="9" y1="9" x2="9.01" y2="9"></line>
            <line x1="15" y1="9" x2="15.01" y2="9"></line>
          </svg>
        </button>
        <input type="text" placeholder="Add a comment..." id="commentInput">
        <button class="post-comment-btn" id="postCommentBtn">Post</button>
      </div>

    </div>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {

    // Like button functionality
    const likeBtn = document.querySelector('.like-btn');
    likeBtn.addEventListener('click', function() {
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

    // Bookmark button functionality
    const bookmarkBtn = document.querySelector('.bookmark-btn');
    bookmarkBtn.addEventListener('click', function() {
      this.classList.toggle('bookmarked');
      const svg = this.querySelector('svg');
      if (this.classList.contains('bookmarked')) {
        svg.style.fill = '#262626';
      } else {
        svg.style.fill = 'none';
      }
    });

    // Comment like buttons
    const commentLikeBtns = document.querySelectorAll('.comment-like-btn');
    commentLikeBtns.forEach(btn => {
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

    // Post comment functionality
    const commentInput = document.getElementById('commentInput');
    const postCommentBtn = document.getElementById('postCommentBtn');

    commentInput.addEventListener('input', function() {
      if (this.value.trim().length > 0) {
        postCommentBtn.style.opacity = '1';
        postCommentBtn.style.cursor = 'pointer';
      } else {
        postCommentBtn.style.opacity = '0.3';
        postCommentBtn.style.cursor = 'default';
      }
    });

    postCommentBtn.addEventListener('click', function() {
      const commentText = commentInput.value.trim();
      if (commentText.length > 0) {
        // Add new comment to the list
        const commentsContainer = document.getElementById('commentsContainer');
        const newComment = document.createElement('div');
        newComment.className = 'comment-item';
        newComment.innerHTML = `
          <div class="comment-avatar" style="background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);">
            <span>ME</span>
          </div>
          <div class="comment-content">
            <div class="comment-header">
              <span class="comment-username">you</span>
              <span class="comment-time">Just now</span>
            </div>
            <p class="comment-text">${commentText}</p>
            <div class="comment-actions">
              <button class="comment-action-btn">Reply</button>
              <button class="comment-like-btn">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
              </button>
            </div>
          </div>
        `;
        commentsContainer.appendChild(newComment);
        commentInput.value = '';
        postCommentBtn.style.opacity = '0.3';
        postCommentBtn.style.cursor = 'default';

        // Scroll to bottom
        commentsContainer.scrollTop = commentsContainer.scrollHeight;
      }
    });

    // Enter key to post comment
    commentInput.addEventListener('keypress', function(e) {
      if (e.key === 'Enter' && this.value.trim().length > 0) {
        postCommentBtn.click();
      }
    });
  });
</script>

</body>
</html>