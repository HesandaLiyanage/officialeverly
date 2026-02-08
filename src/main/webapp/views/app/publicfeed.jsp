<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.FeedProfile" %>
        <%@ page import="com.demo.web.model.FeedPost" %>
            <%@ page import="java.util.List" %>
                <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                    <% FeedProfile feedProfile=(FeedProfile) request.getAttribute("feedProfile"); if (feedProfile==null)
                        { feedProfile=(FeedProfile) session.getAttribute("feedProfile"); } String
                        feedUsername=(feedProfile !=null) ? feedProfile.getFeedUsername() : "user" ; String
                        feedProfilePic=(feedProfile !=null && feedProfile.getFeedProfilePictureUrl() !=null) ?
                        feedProfile.getFeedProfilePictureUrl() : "/resources/assets/default-feed-avatar.png" ; String
                        feedInitials=(feedProfile !=null) ? feedProfile.getInitials() : "U" ; List<FeedPost> posts =
                        (List<FeedPost>) request.getAttribute("posts");
                            List<FeedProfile> recommendedUsers = (List<FeedProfile>)
                                    request.getAttribute("recommendedUsers");
                                    %>
                                    <jsp:include page="../public/header2.jsp" />
                                    <html>

                                    <head>
                                        <link rel="stylesheet" type="text/css" href="/resources/css/publicfeed.css">
                                        <style>
                                            /* Floating Create Button */
                                            .fab-create {
                                                position: fixed;
                                                bottom: 24px;
                                                right: 24px;
                                                width: 60px;
                                                height: 60px;
                                                border-radius: 50%;
                                                background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%);
                                                border: none;
                                                cursor: pointer;
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                                box-shadow: 0 6px 24px rgba(154, 116, 216, 0.4);
                                                transition: transform 0.3s, box-shadow 0.3s;
                                                z-index: 1000;
                                            }

                                            .fab-create:hover {
                                                transform: scale(1.1);
                                                box-shadow: 0 8px 32px rgba(154, 116, 216, 0.5);
                                            }

                                            .fab-create svg {
                                                width: 28px;
                                                height: 28px;
                                                color: white;
                                            }

                                            /* Empty State */
                                            .empty-feed {
                                                text-align: center;
                                                padding: 80px 20px;
                                            }

                                            .empty-feed-icon {
                                                width: 100px;
                                                height: 100px;
                                                background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
                                                border-radius: 50%;
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                                margin: 0 auto 24px;
                                            }

                                            .empty-feed-icon svg {
                                                width: 48px;
                                                height: 48px;
                                                color: #94a3b8;
                                            }

                                            .empty-feed h2 {
                                                font-size: 22px;
                                                color: #334155;
                                                margin-bottom: 8px;
                                            }

                                            .empty-feed p {
                                                font-size: 15px;
                                                color: #64748b;
                                                margin-bottom: 24px;
                                            }

                                            .empty-feed-btn {
                                                display: inline-flex;
                                                align-items: center;
                                                gap: 8px;
                                                background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%);
                                                color: white;
                                                padding: 14px 28px;
                                                border-radius: 14px;
                                                text-decoration: none;
                                                font-weight: 600;
                                                font-size: 15px;
                                                transition: transform 0.2s, box-shadow 0.2s;
                                            }

                                            .empty-feed-btn:hover {
                                                transform: translateY(-2px);
                                                box-shadow: 0 8px 24px rgba(154, 116, 216, 0.4);
                                            }

                                            /* Post placeholder image */
                                            .post-image-placeholder {
                                                width: 100%;
                                                height: 300px;
                                                background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e1 100%);
                                                display: flex;
                                                align-items: center;
                                                justify-content: center;
                                            }

                                            .post-image-placeholder svg {
                                                width: 64px;
                                                height: 64px;
                                                color: #94a3b8;
                                            }
                                        </style>
                                    </head>

                                    <body>
                                        <div class="page-wrapper">
                                            <main class="main-content">
                                                <!-- Fixed Top Section: Tabs + Search -->
                                                <div class="fixed-top-section">
                                                    <!-- Tab Navigation -->
                                                    <div class="tab-nav">
                                                        <div class="tab-buttons">
                                                            <div>
                                                                <button class="active" data-tab="home">Home</button>
                                                                <button data-tab="explore">Explore</button>
                                                            </div>
                                                        </div>
                                                        <a href="${pageContext.request.contextPath}/publicprofile"
                                                            class="profile-link" title="@<%= feedUsername %>">
                                                            <% if
                                                                (feedProfilePic.startsWith("/resources/assets/default")
                                                                || feedProfilePic.contains("default")) { %>
                                                                <div class="profile-pic profile-pic-initials"
                                                                    style="background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 14px;">
                                                                    <%= feedInitials %>
                                                                </div>
                                                                <% } else { %>
                                                                    <img src="<%= feedProfilePic %>"
                                                                        alt="@<%= feedUsername %>" class="profile-pic">
                                                                    <% } %>
                                                        </a>
                                                    </div>

                                                    <!-- Search Bar -->
                                                    <div class="search-filters"
                                                        style="margin-top: 10px; margin-bottom: 15px;">
                                                        <div class="memories-search-container">
                                                            <button class="memories-search-btn" id="memoriesSearchBtn">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <circle cx="11" cy="11" r="8"></circle>
                                                                    <path d="m21 21-4.35-4.35"></path>
                                                                </svg>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Scrollable Feed -->
                                                <div class="scrollable-feed" id="feedContainer">
                                                    <% if (posts==null || posts.isEmpty()) { %>
                                                        <!-- Empty State -->
                                                        <div class="empty-feed">
                                                            <div class="empty-feed-icon">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="1.5">
                                                                    <rect x="3" y="3" width="18" height="18" rx="2"
                                                                        ry="2" />
                                                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                                                    <polyline points="21 15 16 10 5 21" />
                                                                </svg>
                                                            </div>
                                                            <h2>No posts yet</h2>
                                                            <p>Be the first to share a memory with the community!</p>
                                                            <a href="${pageContext.request.contextPath}/createPost"
                                                                class="empty-feed-btn">
                                                                <svg width="20" height="20" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10" />
                                                                    <line x1="12" y1="8" x2="12" y2="16" />
                                                                    <line x1="8" y1="12" x2="16" y2="12" />
                                                                </svg>
                                                                Create First Post
                                                            </a>
                                                        </div>
                                                        <% } else { for (FeedPost post : posts) { FeedProfile
                                                            poster=post.getFeedProfile(); String posterUsername=(poster
                                                            !=null) ? poster.getFeedUsername() : "unknown" ; String
                                                            posterPic=(poster !=null &&
                                                            poster.getFeedProfilePictureUrl() !=null) ?
                                                            poster.getFeedProfilePictureUrl() : null; String
                                                            posterInitials=(poster !=null) ? poster.getInitials() : "??"
                                                            ; String postCaption=(post.getCaption() !=null) ?
                                                            post.getCaption() : (post.getMemory() !=null ?
                                                            post.getMemory().getTitle() : "" ); String
                                                            coverMedia=post.getCoverMediaUrl(); %>
                                                            <!-- Dynamic Post -->
                                                            <div class="feed-post"
                                                                data-post-id="<%= post.getPostId() %>">
                                                                <div class="post-header">
                                                                    <div class="user-info">
                                                                        <% if (posterPic !=null &&
                                                                            !posterPic.contains("default")) { %>
                                                                            <img src="<%= posterPic %>"
                                                                                alt="@<%= posterUsername %>"
                                                                                class="user-avatar"
                                                                                style="width: 42px; height: 42px; border-radius: 50%; object-fit: cover;">
                                                                            <% } else { %>
                                                                                <div class="user-avatar"
                                                                                    style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); width: 42px; height: 42px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 14px;">
                                                                                    <span>
                                                                                        <%= posterInitials %>
                                                                                    </span>
                                                                                </div>
                                                                                <% } %>
                                                                                    <div class="user-details">
                                                                                        <h4 class="username">
                                                                                            <%= posterUsername %>
                                                                                        </h4>
                                                                                        <p class="post-time">
                                                                                            <%= post.getRelativeTime()
                                                                                                %>
                                                                                        </p>
                                                                                    </div>
                                                                    </div>
                                                                    <button class="post-options">
                                                                        <svg width="20" height="20" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="12" cy="12" r="1"></circle>
                                                                            <circle cx="12" cy="5" r="1"></circle>
                                                                            <circle cx="12" cy="19" r="1"></circle>
                                                                        </svg>
                                                                    </button>
                                                                </div>

                                                                <div class="post-image">
                                                                    <% if (coverMedia !=null && !coverMedia.isEmpty()) {
                                                                        %>
                                                                        <img src="<%= coverMedia %>" alt="Post">
                                                                        <% } else { %>
                                                                            <div class="post-image-placeholder">
                                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="1.5">
                                                                                    <rect x="3" y="3" width="18"
                                                                                        height="18" rx="2" ry="2" />
                                                                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                                                                    <polyline
                                                                                        points="21 15 16 10 5 21" />
                                                                                </svg>
                                                                            </div>
                                                                            <% } %>
                                                                </div>

                                                                <div class="post-actions">
                                                                    <div class="action-buttons">
                                                                        <button class="action-btn like-btn">
                                                                            <svg width="24" height="24"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path
                                                                                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                                                </path>
                                                                            </svg>
                                                                        </button>
                                                                        <button class="action-btn comment-btn"
                                                                            onclick="window.location.href='${pageContext.request.contextPath}/comments?postId=<%= post.getPostId() %>'">
                                                                            <svg width="24" height="24"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path
                                                                                    d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z">
                                                                                </path>
                                                                            </svg>
                                                                        </button>
                                                                        <button class="action-btn">
                                                                            <svg width="24" height="24"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <circle cx="18" cy="5" r="3"></circle>
                                                                                <circle cx="6" cy="12" r="3"></circle>
                                                                                <circle cx="18" cy="19" r="3"></circle>
                                                                                <line x1="8.59" y1="13.51" x2="15.42"
                                                                                    y2="17.49"></line>
                                                                                <line x1="15.41" y1="6.51" x2="8.59"
                                                                                    y2="10.49">
                                                                                </line>
                                                                            </svg>
                                                                        </button>
                                                                    </div>
                                                                    <button class="action-btn bookmark-btn"
                                                                        data-post-id="<%= post.getPostId() %>">
                                                                        <svg width="24" height="24" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path
                                                                                d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z">
                                                                            </path>
                                                                        </svg>
                                                                    </button>
                                                                </div>

                                                                <div class="post-info">
                                                                    <p class="likes-count">0 likes</p>
                                                                    <p class="post-caption">
                                                                        <span class="username">
                                                                            <%= posterUsername %>
                                                                        </span>
                                                                        <%= postCaption %>
                                                                    </p>
                                                                    <button class="view-comments"
                                                                        onclick="window.location.href='${pageContext.request.contextPath}/comments?postId=<%= post.getPostId() %>'">View
                                                                        comments</button>
                                                                </div>
                                                            </div>
                                                            <% }} %>
                                                </div>
                                            </main>

                                            <!-- Sidebar with Recommended Users -->
                                            <aside class="sidebar" style="width: 280px; flex-shrink: 0; display: none;">
                                                <div class="sidebar-section"
                                                    style="background: #fff; border-radius: 16px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.06);">
                                                    <h3
                                                        style="font-size: 14px; font-weight: 600; color: #8e8e8e; margin: 0 0 16px 0; font-family: 'Plus Jakarta Sans', sans-serif;">
                                                        Suggested for you</h3>
                                                    <ul style="list-style: none; padding: 0; margin: 0;">
                                                        <% String[]
                                                            gradients={ "linear-gradient(135deg, #fa709a 0%, #fee140 100%)"
                                                            , "linear-gradient(135deg, #30cfd0 0%, #330867 100%)"
                                                            , "linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)"
                                                            , "linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%)"
                                                            , "linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)" }; int
                                                            gradientIndex=0; if (recommendedUsers !=null &&
                                                            !recommendedUsers.isEmpty()) { for (FeedProfile user :
                                                            recommendedUsers) { String gradient=gradients[gradientIndex
                                                            % gradients.length]; gradientIndex++; %>
                                                            <li
                                                                style="display: flex; align-items: center; gap: 12px; margin-bottom: 14px;">
                                                                <% if (user.getFeedProfilePictureUrl() !=null &&
                                                                    !user.getFeedProfilePictureUrl().contains("default"))
                                                                    { %>
                                                                    <img src="<%= user.getFeedProfilePictureUrl() %>"
                                                                        alt="@<%= user.getFeedUsername() %>"
                                                                        style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; flex-shrink: 0;">
                                                                    <% } else { %>
                                                                        <div
                                                                            style="width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; background: <%= gradient %>; color: white; font-weight: 600; font-size: 14px; flex-shrink: 0;">
                                                                            <%= user.getInitials() %>
                                                                        </div>
                                                                        <% } %>
                                                                            <div style="flex: 1; min-width: 0;">
                                                                                <a href="${pageContext.request.contextPath}/publicprofile?username=<%= user.getFeedUsername() %>"
                                                                                    style="text-decoration: none; display: block;">
                                                                                    <span
                                                                                        style="font-weight: 600; font-size: 14px; color: #262626; font-family: 'Plus Jakarta Sans', sans-serif;">
                                                                                        <%= user.getFeedUsername() %>
                                                                                    </span>
                                                                                </a>
                                                                                <span
                                                                                    style="font-size: 12px; color: #8e8e8e;">Suggested
                                                                                    for you</span>
                                                                            </div>
                                                                            <button class="follow-btn-small"
                                                                                style="background: transparent; color: #0095f6; border: none; font-weight: 600; font-size: 12px; cursor: pointer; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif;"
                                                                                data-profile-id="<%= user.getFeedProfileId() %>"
                                                                                onclick="handleFollowSidebar(this, <%= user.getFeedProfileId() %>)">Follow</button>
                                                            </li>
                                                            <% } } else { %>
                                                                <li
                                                                    style="text-align: center; color: #8e8e8e; padding: 20px 0; font-size: 14px;">
                                                                    No suggestions available
                                                                </li>
                                                                <% } %>
                                                    </ul>
                                                </div>
                                            </aside>
                                        </div>

                                        <!-- Floating Action Button -->
                                        <a href="${pageContext.request.contextPath}/createPost" class="fab-create"
                                            title="Create Post">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2.5">
                                                <line x1="12" y1="5" x2="12" y2="19" />
                                                <line x1="5" y1="12" x2="19" y2="12" />
                                            </svg>
                                        </a>

                                        <jsp:include page="../public/footer.jsp" />

                                        <script>
                                            document.addEventListener('DOMContentLoaded', function () {
                                                // Search functionality
                                                const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');
                                                if (memoriesSearchBtn) {
                                                    memoriesSearchBtn.addEventListener('click', function () {
                                                        const searchContainer = this.parentElement;
                                                        const searchBox = document.createElement('div');
                                                        searchBox.className = 'memories-search-expanded';
                                                        searchBox.innerHTML = `
                        <input type="text" class="memories-search-input" placeholder="Search posts...">
                        <button class="memories-search-close">
                            <svg viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2.5">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    `;
                                                        searchContainer.replaceChild(searchBox, this);
                                                        const input = searchBox.querySelector('input');
                                                        input.focus();

                                                        const closeSearch = () => {
                                                            const newBtn = document.createElement('button');
                                                            newBtn.className = 'memories-search-btn';
                                                            newBtn.id = 'memoriesSearchBtn';
                                                            newBtn.innerHTML = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.35-4.35"></path></svg>`;
                                                            searchContainer.replaceChild(newBtn, searchBox);
                                                            location.reload();
                                                        };

                                                        searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

                                                        input.addEventListener('input', function (e) {
                                                            const query = e.target.value.toLowerCase();
                                                            document.querySelectorAll('.feed-post').forEach(post => {
                                                                const text = post.textContent.toLowerCase();
                                                                post.style.display = text.includes(query) ? 'block' : 'none';
                                                            });
                                                        });
                                                    });
                                                }

                                                // Tab switching
                                                document.querySelectorAll('.tab-nav button').forEach(btn => {
                                                    btn.addEventListener('click', function () {
                                                        const tab = this.dataset.tab;
                                                        document.querySelectorAll('.tab-nav button').forEach(b => b.classList.remove('active'));
                                                        this.classList.add('active');
                                                        if (tab === 'home') location.reload();
                                                    });
                                                });

                                                // Like button
                                                document.querySelectorAll('.like-btn').forEach(btn => {
                                                    btn.addEventListener('click', function () {
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

                                                // Bookmark button - save post functionality
                                                document.querySelectorAll('.bookmark-btn').forEach(btn => {
                                                    btn.addEventListener('click', function () {
                                                        const postId = this.dataset.postId;
                                                        const isSaved = this.classList.contains('bookmarked');
                                                        const action = isSaved ? 'unsave' : 'save';

                                                        fetch('${pageContext.request.contextPath}/savePost?action=' + action + '&postId=' + postId, {
                                                            method: 'POST',
                                                            headers: {
                                                                'Content-Type': 'application/x-www-form-urlencoded'
                                                            }
                                                        })
                                                            .then(response => response.json())
                                                            .then(data => {
                                                                if (data.success) {
                                                                    const svg = this.querySelector('svg');
                                                                    if (data.isSaved) {
                                                                        this.classList.add('bookmarked');
                                                                        svg.style.fill = '#262626';
                                                                    } else {
                                                                        this.classList.remove('bookmarked');
                                                                        svg.style.fill = 'none';
                                                                    }
                                                                }
                                                            })
                                                            .catch(error => console.error('Error saving post:', error));
                                                    });
                                                });
                                            });

                                            // Handle follow for recommended users in sidebar
                                            function handleFollowSidebar(btn, profileId) {
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
                                                                btn.style.color = '#262626';
                                                            } else {
                                                                btn.textContent = 'Follow';
                                                                btn.style.color = '#0095f6';
                                                            }
                                                        }
                                                    })
                                                    .catch(error => console.error('Error:', error));
                                            }
                                        </script>
                                    </body>

                                    </html>