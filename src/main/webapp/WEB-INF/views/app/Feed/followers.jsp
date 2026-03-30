<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty pageTitle}">
    <c:set var="pageTitle" value="Followers" />
</c:if>
<c:if test="${empty isOwnProfile}">
    <c:set var="isOwnProfile" value="${true}" />
</c:if>

<jsp:include page="/WEB-INF/views/public/header2.jsp" />
<!DOCTYPE html>
<html>

<head>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/follow.css">
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
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: white;
            font-size: 16px;
            font-family: "Plus Jakarta Sans", sans-serif;
        }

        .follower-info {
            flex: 1;
            min-width: 0;
        }

        .follower-name {
            font-weight: 600;
            color: #1f2937;
            font-size: 15px;
            margin: 0;
            font-family: "Plus Jakarta Sans", sans-serif;
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
            margin: 4px 0 0 0;
        }

        .follow-btn-list {
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: "Plus Jakarta Sans", sans-serif;
        }

        .follow-btn-list:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        .follow-btn-list.following {
            background: transparent;
            color: #374151;
            border: 1.5px solid #d1d5db;
        }

        .follow-btn-list.following:hover {
            border-color: #ed4956;
            color: #ed4956;
        }

        .empty-list {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }

        .empty-list svg {
            width: 64px;
            height: 64px;
            stroke: #d1d5db;
            margin-bottom: 16px;
        }

        .empty-list h3 {
            color: #374151;
            margin: 0 0 8px 0;
            font-family: "Plus Jakarta Sans", sans-serif;
        }

        .empty-list p {
            margin: 0;
            font-family: "Plus Jakarta Sans", sans-serif;
        }
    </style>
</head>

<body>

    <div class="followers-wrapper">
        <div class="followers-header">
            <button class="back-btn" onclick="history.back()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                    stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12" />
                    <polyline points="12 19 5 12 12 5" />
                </svg>
            </button>
            <div>
                <h1 class="followers-title">${fn:escapeXml(pageTitle)}</h1>
                <c:if test="${!isOwnProfile}">
                    <p class="followers-subtitle">@${fn:escapeXml(profileUsername)}</p>
                </c:if>
            </div>
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
                                        <img src="${fn:escapeXml(user.feedProfilePictureUrl)}"
                                            alt="@${fn:escapeXml(user.feedUsername)}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="follower-avatar-initials"
                                            style="background: var(--gradient-${gradientIndex});">
                                            ${fn:escapeXml(user.initials)}
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
                                    <c:choose>
                                        <c:when test="${pageTitle == 'Followers'}">Follows you</c:when>
                                        <c:otherwise>Following</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <c:if test="${!isCurrentUser}">
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
                        <h3>No ${fn:toLowerCase(pageTitle)} yet</h3>
                        <p>
                            <c:choose>
                                <c:when test="${pageTitle == 'Followers'}">
                                    When people follow ${isOwnProfile ? 'you' : 'this user'}, they'll show up here.
                                </c:when>
                                <c:otherwise>
                                    ${isOwnProfile ? "You're" : "This user is"} not following anyone yet.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/public/footer.jsp" />

    <style>
        :root {
            --gradient-0: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --gradient-1: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
            --gradient-2: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            --gradient-3: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%);
            --gradient-4: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            --gradient-5: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>

    <script>
        function handleFollow(btn) {
            const profileId = btn.dataset.profileId;
            const isFollowing = btn.dataset.isFollowing === 'true';
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
    </script>
</body>

</html>