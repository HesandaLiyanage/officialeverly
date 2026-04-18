<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="/WEB-INF/views/public/header2.jsp" />
<html>

<head>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/publicfeed.css">
    <style>
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

        .carousel-container {
            position: relative;
            width: 100%;
            overflow: hidden;
        }

        .carousel-track {
            display: flex;
            transition: transform 0.3s ease;
        }

        .carousel-slide {
            min-width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #000;
        }

        .carousel-slide img,
        .carousel-slide video {
            width: 100%;
            height: 400px;
            object-fit: contain;
        }

        .carousel-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.9);
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            z-index: 10;
            opacity: 0;
            transition: opacity 0.2s;
        }

        .carousel-container:hover .carousel-btn {
            opacity: 1;
        }

        .carousel-btn:hover {
            background: white;
        }

        .carousel-btn.prev {
            left: 12px;
        }

        .carousel-btn.next {
            right: 12px;
        }

        .carousel-btn svg {
            width: 16px;
            height: 16px;
            color: #262626;
        }

        .carousel-dots {
            position: absolute;
            bottom: 12px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 4px;
        }

        .carousel-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            transition: background 0.2s;
        }

        .carousel-dot.active {
            background: white;
        }

        .add-comment-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border-top: 1px solid #efefef;
        }

        .add-comment-bar input {
            flex: 1;
            border: none;
            outline: none;
            font-size: 14px;
            font-family: "Plus Jakarta Sans", sans-serif;
            background: transparent;
        }

        .add-comment-bar input::placeholder {
            color: #8e8e8e;
        }

        .add-comment-bar .post-btn {
            background: none;
            border: none;
            color: #6366f1;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            opacity: 0.3;
            transition: opacity 0.2s;
        }

        .add-comment-bar .post-btn.active {
            opacity: 1;
        }

        /* Post Options Dropdown */
        .post-header {
            position: relative;
        }

        .post-options {
            background: none;
            border: none;
            cursor: pointer;
            padding: 8px;
            border-radius: 50%;
            transition: background 0.2s;
        }

        .post-options:hover {
            background: #f3f4f6;
        }

        .post-options-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.15);
            min-width: 200px;
            z-index: 100;
            overflow: hidden;
            display: none;
            animation: menuSlideDown 0.2s ease;
        }

        .post-options-menu.active {
            display: block;
        }

        @keyframes menuSlideDown {
            from {
                opacity: 0;
                transform: translateY(-8px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .menu-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            cursor: pointer;
            transition: background 0.15s;
            font-size: 14px;
            font-family: "Plus Jakarta Sans", sans-serif;
            color: #262626;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
        }

        .menu-item:hover {
            background: #f9fafb;
        }

        .menu-item.danger {
            color: #dc2626;
        }

        .menu-item.danger:hover {
            background: #fef2f2;
        }

        .menu-item svg {
            flex-shrink: 0;
        }

        .menu-divider {
            height: 1px;
            background: #f3f4f6;
            margin: 4px 0;
        }

        /* Toast Notification */
        .toast-notification {
            position: fixed;
            bottom: 100px;
            left: 50%;
            transform: translateX(-50%) translateY(20px);
            background: #1a1a1a;
            color: white;
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            font-family: "Plus Jakarta Sans", sans-serif;
            z-index: 9999;
            opacity: 0;
            transition: opacity 0.3s, transform 0.3s;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .toast-notification.show {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }

        :root {
            --gradient-0: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --gradient-1: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
            --gradient-2: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            --gradient-3: linear-gradient(135deg, #fbc2eb 0%, #a6c1ee 100%);
            --gradient-4: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
        }
    </style>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/publicfeed.css">
</head>

<body class="feed-shell-page">
    <c:set var="currentHasPic" value="${not empty feedProfile && not empty feedProfile.feedProfilePictureUrl && !fn:contains(feedProfile.feedProfilePictureUrl, 'default')}" />
    <c:set var="currentBio" value="${empty feedProfile.feedBio ? 'Your next story starts here.' : feedProfile.feedBio}" />

    <div class="feed-shell">
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

                <a href="${pageContext.request.contextPath}/feed" class="feed-rail-link active">
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
            </div>

            <div class="feed-rail-bottom">
                <a href="${pageContext.request.contextPath}/publicprofile" class="feed-rail-link">
                    <span class="feed-rail-link-icon">
                        <c:choose>
                            <c:when test="${currentHasPic}">
                                <img src="${fn:escapeXml(feedProfile.feedProfilePictureUrl)}" alt="@${fn:escapeXml(feedUsername)}"
                                     class="feed-rail-avatar">
                            </c:when>
                            <c:otherwise>
                                <span class="feed-rail-avatar-fallback">${fn:escapeXml(feedInitials)}</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span class="feed-rail-label feed-rail-link-text">
                        <span class="feed-rail-link-title">Profile</span>
                        <span class="feed-rail-link-meta">@${fn:escapeXml(feedUsername)}</span>
                    </span>
                </a>
            </div>
        </aside>

        <div class="page-wrapper">
            <main class="main-content feed-main-column">
                <div class="fixed-top-section">
                    <div class="feed-panel feed-topbar">
                        <div class="feed-heading">
                            <span class="feed-eyebrow">Feed</span>
                            <h1>Discover memories from your circle</h1>
                            <p>Scroll through shared moments, jump into conversations, and keep your own profile close by while the main Everly header stays on top.</p>
                        </div>

                        <a href="${pageContext.request.contextPath}/publicprofile" class="profile-link compact"
                           title="@${fn:escapeXml(feedUsername)}">
                            <div class="feed-identity-chip">
                                <c:choose>
                                    <c:when test="${hasDefaultPic}">
                                        <div class="profile-pic profile-pic-initials">${fn:escapeXml(feedInitials)}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${fn:escapeXml(feedProfilePic)}" alt="@${fn:escapeXml(feedUsername)}"
                                             class="profile-pic">
                                    </c:otherwise>
                                </c:choose>
                                <div class="feed-identity-copy">
                                    <strong>@${fn:escapeXml(feedUsername)}</strong>
                                    <span>Open your profile</span>
                                </div>
                            </div>
                        </a>
                    </div>

                    <div class="feed-panel stories-bar">
                        <div class="stories-track">
                            <a href="${pageContext.request.contextPath}/publicprofile" class="story-card">
                                <div class="story-ring story-ring-self">
                                    <div class="story-inner">
                                        <c:choose>
                                            <c:when test="${currentHasPic}">
                                                <img src="${fn:escapeXml(feedProfile.feedProfilePictureUrl)}"
                                                     alt="@${fn:escapeXml(feedUsername)}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="story-initials">${fn:escapeXml(feedInitials)}</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <span class="story-name">You</span>
                            </a>

                            <c:forEach items="${recommendedUsers}" var="user" varStatus="status">
                                <c:if test="${status.index lt 6}">
                                    <c:set var="storyHasPic" value="${not empty user.feedProfilePictureUrl && !fn:contains(user.feedProfilePictureUrl, 'default')}" />
                                    <a href="${pageContext.request.contextPath}/publicprofile?username=${fn:escapeXml(user.feedUsername)}"
                                       class="story-card">
                                        <div class="story-ring">
                                            <div class="story-inner">
                                                <c:choose>
                                                    <c:when test="${storyHasPic}">
                                                        <img src="${fn:escapeXml(user.feedProfilePictureUrl)}"
                                                             alt="@${fn:escapeXml(user.feedUsername)}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="story-initials">${fn:escapeXml(user.initials)}</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <span class="story-name">${fn:escapeXml(user.feedUsername)}</span>
                                    </a>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="search-filters">
                        <div class="memories-search-container">
                            <button class="memories-search-btn" id="memoriesSearchBtn">
                                <svg viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <path d="m21 21-4.35-4.35"></path>
                                </svg>
                                <span>Search posts, captions, and people</span>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="scrollable-feed" id="feedContainer">
                <c:choose>
                    <c:when test="${empty posts}">
                        <div class="feed-panel empty-feed">
                            <div class="empty-feed-icon">
                                <svg viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="1.5">
                                    <rect x="3" y="3" width="18" height="18"
                                        rx="2" ry="2" />
                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                    <polyline points="21 15 16 10 5 21" />
                                </svg>
                            </div>
                            <h2>No posts yet</h2>
                            <p>Be the first to share a memory with the
                                community!</p>
                            <a href="${pageContext.request.contextPath}/createPost"
                                class="empty-feed-btn">
                                <svg width="20" height="20" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <circle cx="12" cy="12" r="10" />
                                    <line x1="12" y1="8" x2="12" y2="16" />
                                    <line x1="8" y1="12" x2="16" y2="12" />
                                </svg>
                                Create First Post
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="feed-container">
                        <c:forEach items="${posts}" var="post">
                            <c:set var="poster" value="${post.feedProfile}" />
                            <c:set var="posterUsername" value="${not empty poster ? poster.feedUsername : 'unknown'}" />
                            <c:set var="posterPic" value="${not empty poster && not empty poster.feedProfilePictureUrl ? poster.feedProfilePictureUrl : ''}" />
                            <c:set var="posterInitials" value="${not empty poster ? poster.initials : '??'}" />
                            <c:set var="postCaption" value="${not empty post.caption ? post.caption : (not empty post.memory ? post.memory.title : '')}" />
                            <c:set var="hasPosterPic" value="${not empty posterPic && !fn:contains(posterPic, 'default')}" />
                            <c:set var="mediaItems" value="${post.mediaItems}" />
                            <c:set var="hasMultipleMedia" value="${not empty mediaItems && fn:length(mediaItems) > 1}" />
                            <c:set var="mediaCount" value="${not empty mediaItems ? fn:length(mediaItems) : 0}" />
                            <c:set var="isNotOwnPost" value="${not empty poster && poster.feedProfileId != currentProfileId}" />

                            <div class="feed-post"
                                data-post-id="${post.postId}">
                                <div class="post-header">
                                    <div class="user-info">
                                        <c:choose>
                                            <c:when test="${hasPosterPic}">
                                                <img src="${fn:escapeXml(posterPic)}"
                                                    alt="@${fn:escapeXml(posterUsername)}"
                                                    class="user-avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="user-avatar">
                                                    <span>${fn:escapeXml(posterInitials)}</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="user-details">
                                            <h4 class="username">${fn:escapeXml(posterUsername)}</h4>
                                            <p class="post-time">${fn:escapeXml(post.relativeTime)}</p>
                                        </div>
                                    </div>
                                    <button class="post-options"
                                        onclick="toggleOptionsMenu(this, event)">
                                        <svg width="20" height="20"
                                            viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor"
                                            stroke-width="2">
                                            <circle cx="12" cy="12" r="1"></circle>
                                            <circle cx="12" cy="5" r="1"></circle>
                                            <circle cx="12" cy="19" r="1"></circle>
                                        </svg>
                                    </button>
                                    <div class="post-options-menu">
                                        <c:if test="${isNotOwnPost}">
                                            <button class="menu-item danger"
                                                onclick="blockUser(${poster.feedProfileId}, '${fn:escapeXml(posterUsername)}', this)">
                                                <svg width="16" height="16"
                                                    viewBox="0 0 24 24"
                                                    fill="none"
                                                    stroke="currentColor"
                                                    stroke-width="2">
                                                    <circle cx="12" cy="12"
                                                        r="10"></circle>
                                                </svg>
                                                Block @${fn:escapeXml(posterUsername)}
                                            </button>
                                            <div class="menu-divider"></div>
                                        </c:if>
                                        <button class="menu-item"
                                            onclick="showReportModal(${post.postId})">
                                            <svg width="16" height="16"
                                                viewBox="0 0 24 24"
                                                fill="none"
                                                stroke="currentColor"
                                                stroke-width="2">
                                                <path
                                                    d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z">
                                                </path>
                                            </svg>
                                            Report Post
                                        </button>
                                    </div>
                                </div>

                                <div class="carousel-container"
                                    data-current-slide="0">
                                    <div class="carousel-track">
                                        <c:choose>
                                            <c:when test="${not empty mediaItems}">
                                                <c:forEach items="${mediaItems}" var="media">
                                                    <c:set var="mediaUrl" value="${pageContext.request.contextPath}/viewmedia?id=${media.mediaId}" />
                                                    <c:set var="isVideo" value="${media.mediaType == 'video' || (not empty media.mimeType && fn:startsWith(media.mimeType, 'video/'))}" />
                                                    <div class="carousel-slide">
                                                        <c:choose>
                                                            <c:when test="${isVideo}">
                                                                <video src="${mediaUrl}" controls></video>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${mediaUrl}" alt="Post media">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="carousel-slide">
                                                    <div class="post-image-placeholder">
                                                        <svg viewBox="0 0 24 24"
                                                            fill="none"
                                                            stroke="currentColor"
                                                            stroke-width="1.5">
                                                            <rect x="3" y="3"
                                                                width="18"
                                                                height="18" rx="2"
                                                                ry="2" />
                                                            <circle cx="8.5"
                                                                cy="8.5" r="1.5" />
                                                            <polyline
                                                                points="21 15 16 10 5 21" />
                                                        </svg>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <c:if test="${hasMultipleMedia}">
                                        <button class="carousel-btn prev"
                                            onclick="moveCarousel(this, -1)">
                                            <svg viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor"
                                                stroke-width="2">
                                                <polyline points="15 18 9 12 15 6">
                                                </polyline>
                                            </svg>
                                        </button>
                                        <button class="carousel-btn next"
                                            onclick="moveCarousel(this, 1)">
                                            <svg viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor"
                                                stroke-width="2">
                                                <polyline points="9 18 15 12 9 6">
                                                </polyline>
                                            </svg>
                                        </button>
                                        <div class="carousel-dots">
                                            <c:forEach begin="0" end="${mediaCount - 1}" var="i">
                                                <div class="carousel-dot${i == 0 ? ' active' : ''}"></div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="post-actions">
                                    <div class="action-buttons">
                                        <button
                                            class="action-btn like-btn${post.likedByCurrentUser ? ' liked' : ''}" data-post-id="${post.postId}">
                                            <svg width="24" height="24"
                                                viewBox="0 0 24 24"
                                                fill="${post.likedByCurrentUser ? '#ed4956' : 'none'}"
                                                stroke="${post.likedByCurrentUser ? '#ed4956' : 'currentColor'}"
                                                stroke-width="2">
                                                <path
                                                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                </path>
                                            </svg>
                                        </button>
                                        <button class="action-btn comment-btn"
                                            onclick="window.location.href='${pageContext.request.contextPath}/comments?postId=${post.postId}'">
                                            <svg width="24" height="24"
                                                viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor"
                                                stroke-width="2">
                                                <path
                                                    d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z">
                                                </path>
                                            </svg>
                                        </button>
                                        <button class="action-btn">
                                            <svg width="24" height="24"
                                                viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor"
                                                stroke-width="2">
                                                <circle cx="18" cy="5" r="3"></circle>
                                                <circle cx="6" cy="12" r="3"></circle>
                                                <circle cx="18" cy="19" r="3"></circle>
                                                <line x1="8.59" y1="13.51"
                                                    x2="15.42" y2="17.49"></line>
                                                <line x1="15.41" y1="6.51" x2="8.59"
                                                    y2="10.49"></line>
                                            </svg>
                                        </button>
                                    </div>
                                    <button class="action-btn bookmark-btn"
                                        data-post-id="${post.postId}">
                                        <svg width="24" height="24"
                                            viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path
                                                d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z">
                                            </path>
                                        </svg>
                                    </button>
                                </div>

                                <div class="post-info">
                                    <p class="likes-count">
                                        ${post.likeCount} likes
                                    </p>
                                    <p class="post-caption">
                                        <span class="username">${fn:escapeXml(posterUsername)}</span>
                                        ${fn:escapeXml(postCaption)}
                                    </p>
                                    <button class="view-comments"
                                        onclick="window.location.href='${pageContext.request.contextPath}/comments?postId=${post.postId}'">View
                                        comments</button>
                                </div>

                                <div class="add-comment-bar">
                                    <input type="text"
                                        placeholder="Add a comment..."
                                        class="comment-input"
                                        data-post-id="${post.postId}">
                                    <button class="post-btn"
                                        data-post-id="${post.postId}">Post</button>
                                </div>
                            </div>
                        </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
                </div>
            </main>

            <aside class="sidebar">
                <div class="sidebar-section">
                    <div class="sidebar-profile-card">
                        <c:choose>
                            <c:when test="${currentHasPic}">
                                <img src="${fn:escapeXml(feedProfile.feedProfilePictureUrl)}" alt="@${fn:escapeXml(feedUsername)}"
                                     class="favorite-icon">
                            </c:when>
                            <c:otherwise>
                                <div class="favorite-icon" style="background: var(--avatar-fallback);">${fn:escapeXml(feedInitials)}</div>
                            </c:otherwise>
                        </c:choose>
                        <div class="sidebar-profile-copy">
                            <strong>@${fn:escapeXml(feedUsername)}</strong>
                            <span>${fn:escapeXml(currentBio)}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/publicprofile" class="sidebar-link">Profile</a>
                    </div>
                </div>

                <div class="sidebar-section">
                    <div class="sidebar-title-row">
                        <h3 class="sidebar-title">Suggested for you</h3>
                        <a href="${pageContext.request.contextPath}/following?profileId=${currentProfileId}" class="sidebar-link">Following</a>
                    </div>

                    <ul class="favorites-list">
                        <c:choose>
                            <c:when test="${not empty recommendedUsers}">
                                <c:forEach items="${recommendedUsers}" var="user" varStatus="status">
                                    <c:set var="gradientIdx" value="${status.index mod 5}" />
                                    <c:set var="hasUserPic" value="${not empty user.feedProfilePictureUrl && !fn:contains(user.feedProfilePictureUrl, 'default')}" />
                                    <li class="favorite-item">
                                        <c:choose>
                                            <c:when test="${hasUserPic}">
                                                <img src="${fn:escapeXml(user.feedProfilePictureUrl)}"
                                                     alt="@${fn:escapeXml(user.feedUsername)}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="favorite-icon" style="background: var(--gradient-${gradientIdx});">
                                                    ${fn:escapeXml(user.initials)}
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="favorite-content">
                                            <a href="${pageContext.request.contextPath}/publicprofile?username=${fn:escapeXml(user.feedUsername)}"
                                               style="text-decoration: none;">
                                                <span class="favorite-name">${fn:escapeXml(user.feedUsername)}</span>
                                            </a>
                                            <span class="follower-info">${empty user.feedBio ? 'Suggested for you' : fn:escapeXml(user.feedBio)}</span>
                                        </div>
                                        <button class="follow-btn-small"
                                                data-profile-id="${user.feedProfileId}"
                                                onclick="handleFollowSidebar(this, ${user.feedProfileId})">Follow</button>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li class="sidebar-note">No suggestions available right now. Start following a few people and this panel will fill in automatically.</li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </aside>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/createPost"
        class="fab-create" title="Create Post">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2.5">
            <line x1="12" y1="5" x2="12" y2="19" />
            <line x1="5" y1="12" x2="19" y2="12" />
        </svg>
    </a>

    <script>
        var contextPath = '${pageContext.request.contextPath}';

        function moveCarousel(btn, direction) {
            var container = btn.closest('.carousel-container');
            var track = container.querySelector('.carousel-track');
            var slides = container.querySelectorAll('.carousel-slide');
            var dots = container.querySelectorAll('.carousel-dot');
            var currentSlide = parseInt(container.dataset.currentSlide);

            var newSlide = currentSlide + direction;
            if (newSlide < 0) newSlide = slides.length - 1;
            if (newSlide >= slides.length) newSlide = 0;

            track.style.transform = 'translateX(-' + (newSlide * 100) + '%)';
            container.dataset.currentSlide = newSlide;

            dots.forEach(function (dot, index) {
                dot.classList.toggle('active', index === newSlide);
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            var memoriesSearchBtn = document.getElementById('memoriesSearchBtn');
            if (memoriesSearchBtn) {
                memoriesSearchBtn.addEventListener('click', function () {
                    var searchContainer = this.parentElement;
                    var searchBox = document.createElement('div');
                    searchBox.className = 'memories-search-expanded';
                    searchBox.innerHTML = '<input type="text" class="memories-search-input" placeholder="Search posts..."><button class="memories-search-close"><svg viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg></button>';
                    searchContainer.replaceChild(searchBox, this);
                    var input = searchBox.querySelector('input');
                    input.focus();
                    var closeSearch = function () {
                        var newBtn = document.createElement('button');
                        newBtn.className = 'memories-search-btn';
                        newBtn.id = 'memoriesSearchBtn';
                        newBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.35-4.35"></path></svg>';
                        searchContainer.replaceChild(newBtn, searchBox);
                        location.reload();
                    };
                    searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);
                    input.addEventListener('input', function (e) {
                        var query = e.target.value.toLowerCase();
                        document.querySelectorAll('.feed-post').forEach(function (post) {
                            var text = post.textContent.toLowerCase();
                            post.style.display = text.includes(query) ? 'block' : 'none';
                        });
                    });
                });
            }

            document.querySelectorAll('.tab-nav button').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var tab = this.dataset.tab;
                    document.querySelectorAll('.tab-nav button').forEach(function (b) { b.classList.remove('active'); });
                    this.classList.add('active');
                    if (tab === 'home') location.reload();
                });
            });

            document.querySelectorAll('.like-btn').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var postId = this.dataset.postId;
                    var isLiked = this.classList.contains('liked');
                    var action = isLiked ? 'unlike' : 'like';
                    var likeBtn = this;
                    fetch(contextPath + '/postLike?postId=' + postId + '&action=' + action, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                    })
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            if (data.success) {
                                var svg = likeBtn.querySelector('svg');
                                if (data.isLiked) {
                                    likeBtn.classList.add('liked');
                                    svg.style.fill = '#ed4956';
                                    svg.style.stroke = '#ed4956';
                                } else {
                                    likeBtn.classList.remove('liked');
                                    svg.style.fill = 'none';
                                    svg.style.stroke = 'currentColor';
                                }
                                var likesCount = likeBtn.closest('.feed-post').querySelector('.likes-count');
                                if (likesCount) likesCount.textContent = data.likeCount + ' likes';
                            }
                        })
                        .catch(function (error) { console.error('Error:', error); });
                });
            });

            document.querySelectorAll('.bookmark-btn').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var postId = this.dataset.postId;
                    var isSaved = this.classList.contains('bookmarked');
                    var action = isSaved ? 'unsave' : 'save';
                    var bookmarkBtn = this;
                    fetch(contextPath + '/savePost?action=' + action + '&postId=' + postId, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                    })
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            if (data.success) {
                                var svg = bookmarkBtn.querySelector('svg');
                                if (data.isSaved) {
                                    bookmarkBtn.classList.add('bookmarked');
                                    svg.style.fill = '#262626';
                                } else {
                                    bookmarkBtn.classList.remove('bookmarked');
                                    svg.style.fill = 'none';
                                }
                            }
                        })
                        .catch(function (error) { console.error('Error saving post:', error); });
                });
            });

            document.querySelectorAll('.comment-input').forEach(function (input) {
                var postBtn = input.nextElementSibling;
                input.addEventListener('input', function () {
                    postBtn.classList.toggle('active', this.value.trim().length > 0);
                });
                input.addEventListener('keypress', function (e) {
                    if (e.key === 'Enter' && this.value.trim().length > 0) {
                        postBtn.click();
                    }
                });
            });

            document.querySelectorAll('.add-comment-bar .post-btn').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var postId = this.dataset.postId;
                    var input = this.previousElementSibling;
                    var commentText = input.value.trim();
                    if (commentText.length === 0) return;
                    fetch(contextPath + '/commentAction?action=add&postId=' + postId + '&commentText=' + encodeURIComponent(commentText), {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                    })
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            if (data.success) {
                                input.value = '';
                                btn.classList.remove('active');
                                window.location.href = contextPath + '/comments?postId=' + postId;
                            }
                        })
                        .catch(function (error) { console.error('Error:', error); });
                });
            });
        });

        function handleFollowSidebar(btn, profileId) {
            var isFollowing = btn.textContent.trim() === 'Following';
            var action = isFollowing ? 'unfollow' : 'follow';
            fetch(contextPath + '/followUser?action=' + action + '&targetProfileId=' + profileId, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            })
                .then(function (response) { return response.json(); })
                .then(function (data) {
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
                .catch(function (error) { console.error('Error:', error); });
        }

        // Toggle post options menu
        function toggleOptionsMenu(btn, event) {
            event.stopPropagation();
            var menu = btn.parentElement.querySelector('.post-options-menu');
            var isActive = menu.classList.contains('active');

            // Close all other menus first
            closeAllMenus();

            if (!isActive) {
                menu.classList.add('active');
            }
        }

        // Close all open menus
        function closeAllMenus() {
            document.querySelectorAll('.post-options-menu.active').forEach(function (menu) {
                menu.classList.remove('active');
            });
        }

        // Close menus when clicking elsewhere
        document.addEventListener('click', function (e) {
            if (!e.target.closest('.post-options') && !e.target.closest('.post-options-menu')) {
                closeAllMenus();
            }
        });

        // Block a user
        function blockUser(targetProfileId, username, btn) {
            if (!confirm('Are you sure you want to block @' + username + '? Their posts will no longer appear in your feed.')) {
                closeAllMenus();
                return;
            }

            closeAllMenus();

            fetch(contextPath + '/blockUser?targetProfileId=' + targetProfileId, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            })
                .then(function (response) { return response.json(); })
                .then(function (data) {
                    if (data.success) {
                        // Hide all posts by this user with animation
                        document.querySelectorAll('.feed-post').forEach(function (post) {
                            var postHeader = post.querySelector('.post-header');
                            if (postHeader) {
                                var blockBtn = postHeader.querySelector('.menu-item.danger');
                                if (blockBtn && blockBtn.getAttribute('onclick') &&
                                    blockBtn.getAttribute('onclick').indexOf(targetProfileId) !== -1) {
                                    post.style.transition = 'opacity 0.4s, transform 0.4s, max-height 0.4s';
                                    post.style.opacity = '0';
                                    post.style.transform = 'scale(0.95)';
                                    setTimeout(function () {
                                        post.style.maxHeight = '0';
                                        post.style.overflow = 'hidden';
                                        post.style.padding = '0';
                                        post.style.margin = '0';
                                        setTimeout(function () {
                                            post.remove();
                                        }, 300);
                                    }, 400);
                                }
                            }
                        });

                        showToast('🚫 @' + username + ' has been blocked');
                    } else {
                        showToast('⚠️ ' + (data.message || 'Could not block user'));
                    }
                })
                .catch(function (error) {
                    console.error('Error blocking user:', error);
                    showToast('⚠️ Error blocking user');
                });
        }

        // Show toast notification
        function showToast(message) {
            var existing = document.querySelector('.toast-notification');
            if (existing) existing.remove();

            var toast = document.createElement('div');
            toast.className = 'toast-notification';
            toast.textContent = message;
            document.body.appendChild(toast);

            setTimeout(function () {
                toast.classList.add('show');
            }, 10);

            setTimeout(function () {
                toast.classList.remove('show');
                setTimeout(function () {
                    toast.remove();
                }, 300);
            }, 3000);
        }

        // ===== REPORT POST FUNCTIONALITY =====
        var reportPostId = null;

        function showReportModal(postId) {
            closeAllMenus();
            reportPostId = postId;
            document.getElementById('reportModal').style.display = 'flex';
            // Reset selection
            var radios = document.getElementsByName('reportReason');
            for (var i = 0; i < radios.length; i++) {
                radios[i].checked = false;
            }
            document.getElementById('reportSubmitBtn').disabled = true;
        }

        function closeReportModal() {
            document.getElementById('reportModal').style.display = 'none';
            reportPostId = null;
        }

        function enableReportSubmit() {
            document.getElementById('reportSubmitBtn').disabled = false;
        }

        function submitReport() {
            if (!reportPostId) return;

            var radios = document.getElementsByName('reportReason');
            var reason = '';
            for (var i = 0; i < radios.length; i++) {
                if (radios[i].checked) {
                    reason = radios[i].value;
                    break;
                }
            }

            if (!reason) {
                showToast('⚠️ Please select a reason');
                return;
            }

            document.getElementById('reportSubmitBtn').disabled = true;
            document.getElementById('reportSubmitBtn').textContent = 'Submitting...';

            fetch(contextPath + '/reportpost', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'postId=' + reportPostId + '&reason=' + encodeURIComponent(reason)
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                closeReportModal();
                if (data.success) {
                    showToast('✅ ' + data.message);
                } else {
                    showToast('ℹ️ ' + data.message);
                }
            })
            .catch(function(error) {
                closeReportModal();
                console.error('Error reporting post:', error);
                showToast('⚠️ Error reporting post. Please try again.');
            })
            .finally(function() {
                var btn = document.getElementById('reportSubmitBtn');
                if (btn) {
                    btn.disabled = false;
                    btn.textContent = 'Submit Report';
                }
            });
        }

        // Close report modal on overlay click
        document.getElementById('reportModal').addEventListener('click', function(e) {
            if (e.target === this) closeReportModal();
        });
    </script>

    <!-- Report Post Modal -->
    <div id="reportModal" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.6); z-index:10000; align-items:center; justify-content:center;">
        <div style="background:white; border-radius:16px; padding:2rem; max-width:400px; width:90%; box-shadow:0 20px 60px rgba(0,0,0,0.3);">
            <h3 style="margin:0 0 0.5rem 0; font-size:1.2rem; color:#1a202c;">Report Post</h3>
            <p style="color:#718096; font-size:0.9rem; margin:0 0 1.2rem 0;">Why are you reporting this post?</p>

            <div style="display:flex; flex-direction:column; gap:0.6rem; margin-bottom:1.5rem;">
                <label style="display:flex; align-items:center; gap:0.6rem; padding:0.7rem; border:1px solid #e2e8f0; border-radius:8px; cursor:pointer; transition:all 0.2s;" onmouseover="this.style.borderColor='#5b4cdb'" onmouseout="this.style.borderColor='#e2e8f0'">
                    <input type="radio" name="reportReason" value="spam" onchange="enableReportSubmit()" style="accent-color:#5b4cdb;">
                    <span style="font-size:0.9rem; color:#2d3748;">Spam</span>
                </label>
                <label style="display:flex; align-items:center; gap:0.6rem; padding:0.7rem; border:1px solid #e2e8f0; border-radius:8px; cursor:pointer; transition:all 0.2s;" onmouseover="this.style.borderColor='#5b4cdb'" onmouseout="this.style.borderColor='#e2e8f0'">
                    <input type="radio" name="reportReason" value="harassment" onchange="enableReportSubmit()" style="accent-color:#5b4cdb;">
                    <span style="font-size:0.9rem; color:#2d3748;">Harassment</span>
                </label>
                <label style="display:flex; align-items:center; gap:0.6rem; padding:0.7rem; border:1px solid #e2e8f0; border-radius:8px; cursor:pointer; transition:all 0.2s;" onmouseover="this.style.borderColor='#5b4cdb'" onmouseout="this.style.borderColor='#e2e8f0'">
                    <input type="radio" name="reportReason" value="inappropriate" onchange="enableReportSubmit()" style="accent-color:#5b4cdb;">
                    <span style="font-size:0.9rem; color:#2d3748;">Inappropriate content</span>
                </label>
                <label style="display:flex; align-items:center; gap:0.6rem; padding:0.7rem; border:1px solid #e2e8f0; border-radius:8px; cursor:pointer; transition:all 0.2s;" onmouseover="this.style.borderColor='#5b4cdb'" onmouseout="this.style.borderColor='#e2e8f0'">
                    <input type="radio" name="reportReason" value="hate_speech" onchange="enableReportSubmit()" style="accent-color:#5b4cdb;">
                    <span style="font-size:0.9rem; color:#2d3748;">Hate speech</span>
                </label>
                <label style="display:flex; align-items:center; gap:0.6rem; padding:0.7rem; border:1px solid #e2e8f0; border-radius:8px; cursor:pointer; transition:all 0.2s;" onmouseover="this.style.borderColor='#5b4cdb'" onmouseout="this.style.borderColor='#e2e8f0'">
                    <input type="radio" name="reportReason" value="other" onchange="enableReportSubmit()" style="accent-color:#5b4cdb;">
                    <span style="font-size:0.9rem; color:#2d3748;">Other</span>
                </label>
            </div>

            <div style="display:flex; gap:0.8rem; justify-content:flex-end;">
                <button onclick="closeReportModal()" style="padding:0.6rem 1.5rem; border-radius:8px; border:none; background:#e2e8f0; color:#4a5568; font-weight:500; cursor:pointer; font-size:0.9rem;">Cancel</button>
                <button id="reportSubmitBtn" onclick="submitReport()" disabled style="padding:0.6rem 1.5rem; border-radius:8px; border:none; background:#e53e3e; color:white; font-weight:500; cursor:pointer; font-size:0.9rem; opacity:0.5; transition:opacity 0.3s;">Submit Report</button>
            </div>
        </div>
    </div>

    <style>
        #reportSubmitBtn:not(:disabled) { opacity: 1 !important; }
        #reportSubmitBtn:not(:disabled):hover { background: #c53030 !important; }
    </style>

</body>

</html>
