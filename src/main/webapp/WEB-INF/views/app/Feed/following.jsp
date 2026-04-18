<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty pageTitle}">
    <c:set var="pageTitle" value="Following" />
</c:if>
<c:if test="${empty isOwnProfile}">
    <c:set var="isOwnProfile" value="${true}" />
</c:if>

<!DOCTYPE html>
<html>

<head>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/publicfeed.css">
    <style>
        .followers-wrapper {
            max-width: 450px;
            margin: 0 auto;
            padding: 20px;
        }

        .followers-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid #e5e7eb;
        }

        .back-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 8px;
            border-radius: 50%;
            transition: background 0.2s;
        }

        .back-btn:hover {
            background: #f3f4f6;
        }

        .back-btn svg {
            width: 24px;
            height: 24px;
            stroke: #333;
        }

        .followers-title {
            font-size: 24px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            font-family: "Plus Jakarta Sans", sans-serif;
        }

        .followers-subtitle {
            font-size: 14px;
            color: #6b7280;
            margin: 0;
        }

        .follower-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 16px;
            border-radius: 12px;
            transition: all 0.2s ease;
            margin-bottom: 8px;
        }

        .follower-item:hover {
            background: #f9fafb;
        }

        .follower-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            overflow: hidden;
            flex-shrink: 0;
        }

        .follower-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .follower-avatar-initials {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 18px;
            text-transform: uppercase;
        }

        .follower-info {
            flex: 1;
            min-width: 0;
        }

        .follower-name {
            font-size: 15px;
            font-weight: 600;
            color: #1f2937;
            margin: 0 0 3px 0;
        }

        .follower-name a {
            color: inherit;
            text-decoration: none;
        }

        .follower-name a:hover {
            text-decoration: underline;
        }

        .follower-status {
            font-size: 13px;
            color: #6b7280;
            margin: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .follow-btn-list {
            padding: 8px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white;
        }

        .follow-btn-list:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        .follow-btn-list.following {
            background: #f3f4f6;
            color: #374151;
        }

        .follow-btn-list.following:hover {
            background: #fee2e2;
            color: #dc2626;
            box-shadow: none;
        }

        .empty-list {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }

        .empty-list svg {
            width: 64px;
            height: 64px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        .empty-list h3 {
            font-size: 18px;
            color: #1f2937;
            margin: 0 0 8px 0;
        }

        .empty-list p {
            font-size: 14px;
            margin: 0;
        }

        .find-users-btn {
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white;
            padding: 10px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 16px;
        }

        .find-users-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(99, 102, 241, 0.4);
        }

        :root {
            --gradient-0: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --gradient-1: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
            --gradient-2: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            --gradient-3: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%);
            --gradient-4: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            --gradient-5: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
</head>

<body class="feed-shell-page">
    <jsp:include page="/WEB-INF/views/public/header2.jsp" />
    <c:set var="currentUserHasPic" value="${not empty currentUserProfile && not empty currentUserProfile.feedProfilePictureUrl && !fn:contains(currentUserProfile.feedProfilePictureUrl, 'default')}" />

    <div class="feed-shell follow-shell">
        <aside class="feed-rail">
            <div class="feed-rail-top">
                <a href="${pageContext.request.contextPath}/feed" class="feed-rail-brand">
                    <span class="feed-rail-brand-mark">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="6"></rect>
                            <circle cx="12" cy="12" r="3.2"></circle>
                            <circle cx="17.5" cy="6.5" r="1"></circle>
                        </svg>
                    </span>
                    <span class="feed-rail-brand-text">
                        <span class="feed-rail-brand-title">Everly Feed</span>
                        <span class="feed-rail-brand-subtitle">Community moments</span>
                    </span>
                </a>

                <a href="${pageContext.request.contextPath}/feed" class="feed-rail-link">
                    <span class="feed-rail-link-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M3 11.5 12 4l9 7.5"></path>
                            <path d="M5 10.5V20h14v-9.5"></path>
                        </svg>
                    </span>
                    <span class="feed-rail-label feed-rail-link-text">
                        <span class="feed-rail-link-title">Home</span>
                        <span class="feed-rail-link-meta">Fresh posts</span>
                    </span>
                </a>

                <a href="${pageContext.request.contextPath}/createPost" class="feed-rail-link">
                    <span class="feed-rail-link-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 5v14"></path>
                            <path d="M5 12h14"></path>
                        </svg>
                    </span>
                    <span class="feed-rail-label feed-rail-link-text">
                        <span class="feed-rail-link-title">Create</span>
                        <span class="feed-rail-link-meta">Share a memory</span>
                    </span>
                </a>

                <a href="${pageContext.request.contextPath}/notifications" class="feed-rail-link">
                    <span class="feed-rail-link-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                        </svg>
                    </span>
                    <span class="feed-rail-label feed-rail-link-text">
                        <span class="feed-rail-link-title">Notifications</span>
                        <span class="feed-rail-link-meta">Comments and likes</span>
                    </span>
                </a>

                <a href="${pageContext.request.contextPath}/publicprofile?username=${fn:escapeXml(profileUsername)}" class="feed-rail-link active">
                    <span class="feed-rail-link-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </span>
                    <span class="feed-rail-label feed-rail-link-text">
                        <span class="feed-rail-link-title">Profile</span>
                        <span class="feed-rail-link-meta">@${fn:escapeXml(profileUsername)}</span>
                    </span>
                </a>
            </div>

            <div class="feed-rail-bottom">
                <a href="${pageContext.request.contextPath}/publicprofile" class="feed-rail-link">
                    <span class="feed-rail-link-icon">
                        <c:choose>
                            <c:when test="${currentUserHasPic}">
                                <span class="feed-rail-avatar avatar-shell">
                                    <img src="${fn:escapeXml(currentUserProfile.feedProfilePictureUrl)}"
                                         alt="@${fn:escapeXml(currentUserProfile.feedUsername)}"
                                         class="feed-rail-avatar avatar-image"
                                         onerror="this.closest('.avatar-shell').classList.add('is-fallback');">
                                    <span class="feed-rail-avatar-fallback avatar-fallback">${fn:escapeXml(currentUserProfile.initials)}</span>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="feed-rail-avatar avatar-shell is-fallback">
                                    <span class="feed-rail-avatar-fallback avatar-fallback">${fn:escapeXml(currentUserProfile.initials)}</span>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span class="feed-rail-label feed-rail-link-text">
                        <span class="feed-rail-link-title">Profile</span>
                        <span class="feed-rail-link-meta">@${fn:escapeXml(currentUserProfile.feedUsername)}</span>
                    </span>
                </a>
            </div>
        </aside>

        <main class="main-content follow-page-main">
            <div class="follow-card">
                <div class="followers-header">
                    <div style="display:flex; align-items:center; gap:16px;">
                        <button class="back-btn" onclick="history.back()">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <line x1="19" y1="12" x2="5" y2="12" />
                                <polyline points="12 19 5 12 12 5" />
                            </svg>
                        </button>
                        <div class="followers-heading">
                            <h1 class="followers-title">${fn:escapeXml(pageTitle)}</h1>
                            <c:if test="${!isOwnProfile}">
                                <p class="followers-subtitle">@${fn:escapeXml(profileUsername)}</p>
                            </c:if>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/followers?profileId=${profileToView.feedProfileId}" class="sidebar-link">Followers</a>
                </div>

                <div class="follow-search">
                    <input type="text" id="followSearchInput" placeholder="Search following by username">
                </div>

                <div class="followers-list">
            <c:choose>
                <c:when test="${not empty userList}">
                    <c:forEach items="${userList}" var="user" varStatus="status">
                        <c:set var="gradientIndex" value="${status.index mod 6}" />
                        <c:set var="hasPic" value="${not empty user.feedProfilePictureUrl && !fn:contains(user.feedProfilePictureUrl, 'default')}" />
                        <c:set var="isCurrentUser" value="${user.feedProfileId == currentProfileId}" />
                        <c:set var="followKey" value="isFollowing_${user.feedProfileId}" />
                        <c:set var="isFollowingUser" value="${requestScope[followKey] == true}" />

                        <div class="follower-item">
                            <div class="follower-avatar">
                                <c:choose>
                                    <c:when test="${hasPic}">
                                        <div class="follower-avatar avatar-shell">
                                            <img src="${fn:escapeXml(user.feedProfilePictureUrl)}"
                                                alt="@${fn:escapeXml(user.feedUsername)}"
                                                class="avatar-image"
                                                onerror="this.closest('.avatar-shell').classList.add('is-fallback');">
                                            <span class="follower-avatar-initials avatar-fallback">${fn:escapeXml(user.initials)}</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="follower-avatar avatar-shell is-fallback">
                                            <span class="follower-avatar-initials avatar-fallback">${fn:escapeXml(user.initials)}</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="follower-info">
                                <h3 class="follower-name">
                                    <a href="${pageContext.request.contextPath}/publicprofile?username=${fn:escapeXml(user.feedUsername)}">
                                        ${fn:escapeXml(user.feedUsername)}
                                    </a>
                                </h3>
                                <p class="follower-status">
                                    ${not empty user.feedBio ? fn:escapeXml(user.feedBio) : 'Everly user'}
                                </p>
                            </div>
                            <c:if test="${!isCurrentUser && isOwnProfile}">
                                <button class="follow-btn-list following"
                                    data-profile-id="${user.feedProfileId}"
                                    data-is-following="true"
                                    onclick="handleFollow(this)">Following</button>
                            </c:if>
                            <c:if test="${!isCurrentUser && !isOwnProfile}">
                                <button class="follow-btn-list${isFollowingUser ? ' following' : ''}"
                                    data-profile-id="${user.feedProfileId}"
                                    data-is-following="${isFollowingUser}"
                                    onclick="handleFollow(this)">
                                    ${isFollowingUser ? 'Following' : 'Follow'}
                                </button>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-list">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                            <circle cx="9" cy="7" r="4" />
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                            <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                        </svg>
                        <h3>Not following anyone yet</h3>
                        <p>
                            <c:choose>
                                <c:when test="${isOwnProfile}">
                                    Start following people to see their posts in your feed!
                                </c:when>
                                <c:otherwise>
                                    @${fn:escapeXml(profileUsername)} isn't following anyone yet.
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${isOwnProfile}">
                            <a href="${pageContext.request.contextPath}/feed" class="find-users-btn">Find People</a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
                </div>
            </div>
        </main>
        <div></div>
    </div>
    <script>
        function handleFollow(btn) {
            const profileId = btn.dataset.profileId;
            const isFollowing = btn.dataset.isFollowing === 'true';
            const action = isFollowing ? 'unfollow' : 'follow';
            fetch('${pageContext.request.contextPath}/followUser?action=' + action + '&targetProfileId=' + profileId, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        btn.dataset.isFollowing = data.isFollowing.toString();
                        if (data.isFollowing) {
                            btn.classList.add('following');
                            btn.textContent = 'Following';
                        } else {
                            btn.classList.remove('following');
                            btn.textContent = 'Follow';
                        }
                    }
                })
                .catch(error => console.error('Error:', error));
        }

        document.addEventListener('DOMContentLoaded', function () {
            const searchInput = document.getElementById('followSearchInput');
            if (!searchInput) return;

            searchInput.addEventListener('input', function () {
                const query = this.value.trim().toLowerCase();
                document.querySelectorAll('.follower-item').forEach(function (item) {
                    const username = item.querySelector('.follower-name')?.textContent?.toLowerCase() || '';
                    const status = item.querySelector('.follower-status')?.textContent?.toLowerCase() || '';
                    item.style.display = (username.includes(query) || status.includes(query)) ? 'flex' : 'none';
                });
            });
        });
    </script>
</body>

</html>
