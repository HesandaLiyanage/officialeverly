<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.FeedPost" %>
        <%@ page import="com.demo.web.model.FeedComment" %>
            <%@ page import="com.demo.web.model.FeedProfile" %>
                <%@ page import="com.demo.web.model.MediaItem" %>
                    <%@ page import="java.util.List" %>
                        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                                <% FeedPost post=(FeedPost) request.getAttribute("post"); List<FeedComment> comments =
                                    (List<FeedComment>) request.getAttribute("comments");
                                        FeedProfile currentProfile = (FeedProfile)
                                        request.getAttribute("currentProfile");
                                        Integer likeCount = (Integer) request.getAttribute("likeCount");
                                        Boolean isLikedByUser = (Boolean) request.getAttribute("isLikedByUser");
                                        Integer commentCount = (Integer) request.getAttribute("commentCount");
                                        Boolean isPostOwner = (Boolean) request.getAttribute("isPostOwner");
                                        List<MediaItem> mediaItems = (List<MediaItem>)
                                                request.getAttribute("mediaItems");

                                                if (post == null) {
                                                response.sendRedirect(request.getContextPath() + "/feed");
                                                return;
                                                }

                                                FeedProfile postOwner = post.getFeedProfile();
                                                if (postOwner == null) {
                                                response.sendRedirect(request.getContextPath() + "/feed");
                                                return;
                                                }

                                                if (likeCount == null) likeCount = 0;
                                                if (isLikedByUser == null) isLikedByUser = false;
                                                if (commentCount == null) commentCount = 0;
                                                if (isPostOwner == null) isPostOwner = false;

                                                String ownerPic = postOwner.getFeedProfilePictureUrl();
                                                boolean hasOwnerPic = ownerPic != null && !ownerPic.isEmpty() &&
                                                !ownerPic.contains("default");
                                                String ownerGradient = "linear-gradient(135deg, #667eea 0%,
                                                #764ba2100%)";
                                                String postLikedClass = isLikedByUser ? "liked" : "";
                                                String postFillColor = isLikedByUser ? "#ed4956" : "none";
                                                String postStrokeColor = isLikedByUser ? "#ed4956" : "currentColor";
                                                String cpUrl = currentProfile != null ?
                                                currentProfile.getFeedProfilePictureUrl() : null;
                                                String cpUrlSafe = (cpUrl != null) ? cpUrl : "";
                                                boolean hasMultipleMedia = mediaItems != null && mediaItems.size() > 1;
                                                int mediaCount = (mediaItems != null) ? mediaItems.size() : 0;
                                                int currentProfileId = (currentProfile != null) ?
                                                currentProfile.getFeedProfileId() : 0;
                                                %>
                                                <!DOCTYPE html>
                                                <html lang="en">

                                                <head>
                                                    <meta charset="UTF-8">
                                                    <meta name="viewport"
                                                        content="width=device-width, initial-scale=1.0">
                                                    <title>Comments - Everly</title>
                                                    <link
                                                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                                                        rel="stylesheet">
                                                    <link rel="stylesheet"
                                                        href="<%= request.getContextPath() %>/resources/css/base.css">
                                                    <style>
                                                        * {
                                                            margin: 0;
                                                            padding: 0;
                                                            box-sizing: border-box;
                                                        }

                                                        body {
                                                            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
                                                            background: rgba(0, 0, 0, 0.65);
                                                            min-height: 100vh;
                                                        }

                                                        .comments-page-container {
                                                            display: flex;
                                                            justify-content: center;
                                                            align-items: center;
                                                            min-height: 100vh;
                                                            padding: 20px;
                                                        }

                                                        .close-post-btn {
                                                            position: fixed;
                                                            top: 20px;
                                                            right: 20px;
                                                            color: white;
                                                            z-index: 100;
                                                            text-decoration: none;
                                                        }

                                                        .post-comments-wrapper {
                                                            display: flex;
                                                            background: white;
                                                            border-radius: 8px;
                                                            overflow: hidden;
                                                            max-width: 1100px;
                                                            width: 100%;
                                                            max-height: 90vh;
                                                        }

                                                        .post-image-section {
                                                            flex: 1;
                                                            background: #000;
                                                            display: flex;
                                                            align-items: center;
                                                            justify-content: center;
                                                            min-width: 0;
                                                            max-width: 600px;
                                                        }

                                                        .post-details-section {
                                                            width: 400px;
                                                            display: flex;
                                                            flex-direction: column;
                                                            border-left: 1px solid #efefef;
                                                        }

                                                        .carousel-container {
                                                            position: relative;
                                                            width: 100%;
                                                            height: 100%;
                                                            overflow: hidden;
                                                        }

                                                        .carousel-track {
                                                            display: flex;
                                                            transition: transform 0.3s ease;
                                                            height: 100%;
                                                        }

                                                        .carousel-slide {
                                                            min-width: 100%;
                                                            height: 500px;
                                                            display: flex;
                                                            align-items: center;
                                                            justify-content: center;
                                                        }

                                                        .carousel-slide img,
                                                        .carousel-slide video {
                                                            max-width: 100%;
                                                            max-height: 100%;
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
                                                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
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

                                                        .post-detail-header {
                                                            padding: 14px 16px;
                                                            border-bottom: 1px solid #efefef;
                                                            display: flex;
                                                            align-items: center;
                                                        }

                                                        .user-info {
                                                            display: flex;
                                                            align-items: center;
                                                            gap: 12px;
                                                        }

                                                        .user-avatar {
                                                            width: 32px;
                                                            height: 32px;
                                                            border-radius: 50%;
                                                            display: flex;
                                                            align-items: center;
                                                            justify-content: center;
                                                            font-size: 12px;
                                                            font-weight: 600;
                                                            color: white;
                                                        }

                                                        .user-details .username {
                                                            font-weight: 600;
                                                            font-size: 14px;
                                                            color: #262626;
                                                            margin: 0;
                                                        }

                                                        .user-details .post-location {
                                                            font-size: 12px;
                                                            color: #8e8e8e;
                                                            margin: 0;
                                                        }

                                                        .comments-list-container {
                                                            flex: 1;
                                                            overflow-y: auto;
                                                            padding: 16px;
                                                        }

                                                        .comment-item {
                                                            display: flex;
                                                            gap: 12px;
                                                            margin-bottom: 16px;
                                                        }

                                                        .comment-avatar {
                                                            width: 32px;
                                                            height: 32px;
                                                            border-radius: 50%;
                                                            flex-shrink: 0;
                                                            display: flex;
                                                            align-items: center;
                                                            justify-content: center;
                                                            font-size: 11px;
                                                            font-weight: 600;
                                                            color: white;
                                                            object-fit: cover;
                                                        }

                                                        .comment-content {
                                                            flex: 1;
                                                        }

                                                        .comment-header {
                                                            display: flex;
                                                            align-items: center;
                                                            gap: 8px;
                                                            margin-bottom: 4px;
                                                        }

                                                        .comment-username {
                                                            font-weight: 600;
                                                            font-size: 13px;
                                                            color: #262626;
                                                        }

                                                        .comment-time {
                                                            font-size: 12px;
                                                            color: #8e8e8e;
                                                        }

                                                        .comment-text {
                                                            font-size: 14px;
                                                            color: #262626;
                                                            line-height: 1.4;
                                                            margin: 0;
                                                            word-break: break-word;
                                                        }

                                                        .comment-actions {
                                                            display: flex;
                                                            align-items: center;
                                                            gap: 12px;
                                                            margin-top: 8px;
                                                        }

                                                        .comment-like-btn {
                                                            background: none;
                                                            border: none;
                                                            cursor: pointer;
                                                            padding: 0;
                                                        }

                                                        .comment-like-btn.liked svg {
                                                            fill: #ed4956;
                                                            stroke: #ed4956;
                                                        }

                                                        .comment-likes {
                                                            font-size: 12px;
                                                            color: #8e8e8e;
                                                            font-weight: 600;
                                                        }

                                                        .reply-btn,
                                                        .delete-comment-btn,
                                                        .view-replies-btn {
                                                            background: none;
                                                            border: none;
                                                            color: #8e8e8e;
                                                            cursor: pointer;
                                                            font-size: 12px;
                                                            font-weight: 600;
                                                            padding: 0;
                                                        }

                                                        .reply-btn:hover,
                                                        .view-replies-btn:hover {
                                                            color: #262626;
                                                        }

                                                        .delete-comment-btn:hover {
                                                            color: #dc2626;
                                                        }

                                                        .no-comments {
                                                            display: flex;
                                                            flex-direction: column;
                                                            align-items: center;
                                                            justify-content: center;
                                                            padding: 60px 20px;
                                                            text-align: center;
                                                            color: #8e8e8e;
                                                        }

                                                        .no-comments svg {
                                                            margin-bottom: 16px;
                                                            opacity: 0.5;
                                                        }

                                                        .no-comments-title {
                                                            font-size: 22px;
                                                            font-weight: 700;
                                                            color: #262626;
                                                            margin: 0 0 8px 0;
                                                        }

                                                        .no-comments-subtitle {
                                                            font-size: 14px;
                                                            color: #8e8e8e;
                                                            margin: 0;
                                                        }

                                                        .post-actions-bar {
                                                            padding: 8px 16px;
                                                            border-top: 1px solid #efefef;
                                                        }

                                                        .post-actions {
                                                            display: flex;
                                                            justify-content: space-between;
                                                            margin-bottom: 8px;
                                                        }

                                                        .action-buttons {
                                                            display: flex;
                                                            gap: 16px;
                                                        }

                                                        .action-btn {
                                                            background: none;
                                                            border: none;
                                                            cursor: pointer;
                                                            padding: 8px 0;
                                                        }

                                                        .action-btn.liked svg {
                                                            fill: #ed4956;
                                                            stroke: #ed4956;
                                                        }

                                                        .post-stats .likes-count {
                                                            font-weight: 600;
                                                            font-size: 14px;
                                                            color: #262626;
                                                            margin: 0 0 4px 0;
                                                        }

                                                        .post-stats .post-time-stamp {
                                                            font-size: 10px;
                                                            color: #8e8e8e;
                                                            text-transform: uppercase;
                                                            letter-spacing: 0.2px;
                                                            margin: 0;
                                                        }

                                                        .add-comment-section {
                                                            display: flex;
                                                            align-items: center;
                                                            gap: 12px;
                                                            padding: 12px 16px;
                                                            border-top: 1px solid #efefef;
                                                        }

                                                        .emoji-btn {
                                                            background: none;
                                                            border: none;
                                                            cursor: pointer;
                                                            padding: 0;
                                                        }

                                                        #commentInput {
                                                            flex: 1;
                                                            border: none;
                                                            outline: none;
                                                            font-size: 14px;
                                                            font-family: inherit;
                                                        }

                                                        #commentInput::placeholder {
                                                            color: #8e8e8e;
                                                        }

                                                        .post-comment-btn {
                                                            background: none;
                                                            border: none;
                                                            color: #0095f6;
                                                            font-weight: 600;
                                                            font-size: 14px;
                                                            cursor: pointer;
                                                            opacity: 0.3;
                                                            transition: opacity 0.2s;
                                                        }

                                                        .post-comment-btn.active {
                                                            opacity: 1;
                                                        }

                                                        .replies-container {
                                                            margin-left: 44px;
                                                            margin-top: 8px;
                                                        }

                                                        .reply-item {
                                                            display: flex;
                                                            gap: 10px;
                                                            margin-bottom: 12px;
                                                        }

                                                        .reply-avatar {
                                                            width: 24px;
                                                            height: 24px;
                                                            border-radius: 50%;
                                                            flex-shrink: 0;
                                                            display: flex;
                                                            align-items: center;
                                                            justify-content: center;
                                                            font-size: 9px;
                                                            font-weight: 600;
                                                            color: white;
                                                            object-fit: cover;
                                                        }
                                                    </style>
                                                </head>

                                                <body>
                                                    <div class="comments-page-container">
                                                        <a href="<%= request.getContextPath() %>/feed"
                                                            class="close-post-btn">
                                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                                                <line x1="6" y1="6" x2="18" y2="18"></line>
                                                            </svg>
                                                        </a>

                                                        <div class="post-comments-wrapper">
                                                            <div class="post-image-section">
                                                                <div class="carousel-container" data-current-slide="0">
                                                                    <div class="carousel-track">
                                                                        <% if (mediaItems !=null &&
                                                                            !mediaItems.isEmpty()) { for (MediaItem
                                                                            media : mediaItems) { String
                                                                            mediaUrl=request.getContextPath()
                                                                            + "/viewmedia?id=" + media.getMediaId();
                                                                            boolean isVideo="video"
                                                                            .equals(media.getMediaType()) ||
                                                                            (media.getMimeType() !=null &&
                                                                            media.getMimeType().startsWith("video/"));
                                                                            %>
                                                                            <div class="carousel-slide">
                                                                                <% if (isVideo) { %>
                                                                                    <video src="<%= mediaUrl %>"
                                                                                        controls></video>
                                                                                    <% } else { %>
                                                                                        <img src="<%= mediaUrl %>"
                                                                                            alt="Post image">
                                                                                        <% } %>
                                                                            </div>
                                                                            <% } } else if (post.getCoverMediaUrl()
                                                                                !=null &&
                                                                                !post.getCoverMediaUrl().isEmpty()) { %>
                                                                                <div class="carousel-slide">
                                                                                    <img src="<%= post.getCoverMediaUrl() %>"
                                                                                        alt="Post image">
                                                                                </div>
                                                                                <% } else { %>
                                                                                    <div class="carousel-slide"
                                                                                        style="background: <%= ownerGradient %>;">
                                                                                        <svg width="64" height="64"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none" stroke="white"
                                                                                            stroke-width="2">
                                                                                            <rect x="3" y="3" width="18"
                                                                                                height="18" rx="2"
                                                                                                ry="2"></rect>
                                                                                            <circle cx="8.5" cy="8.5"
                                                                                                r="1.5"></circle>
                                                                                            <polyline
                                                                                                points="21 15 16 10 5 21">
                                                                                            </polyline>
                                                                                        </svg>
                                                                                    </div>
                                                                                    <% } %>
                                                                    </div>
                                                                    <% if (hasMultipleMedia) { %>
                                                                        <button class="carousel-btn prev" type="button"
                                                                            onclick="moveCarousel(-1)">
                                                                            <svg viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <polyline points="15 18 9 12 15 6">
                                                                                </polyline>
                                                                            </svg>
                                                                        </button>
                                                                        <button class="carousel-btn next" type="button"
                                                                            onclick="moveCarousel(1)">
                                                                            <svg viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <polyline points="9 18 15 12 9 6">
                                                                                </polyline>
                                                                            </svg>
                                                                        </button>
                                                                        <div class="carousel-dots">
                                                                            <% for (int i=0; i < mediaCount; i++) { %>
                                                                                <div class="carousel-dot<%= i == 0 ? "
                                                                                    active" : "" %>"></div>
                                                                                <% } %>
                                                                        </div>
                                                                        <% } %>
                                                                </div>
                                                            </div>

                                                            <div class="post-details-section">
                                                                <div class="post-detail-header">
                                                                    <div class="user-info">
                                                                        <% if (hasOwnerPic) { %>
                                                                            <img src="<%= ownerPic %>"
                                                                                alt="<%= postOwner.getFeedUsername() %>"
                                                                                class="user-avatar"
                                                                                style="width:40px;height:40px;object-fit:cover">
                                                                            <% } else { %>
                                                                                <div class="user-avatar"
                                                                                    style="background:<%= ownerGradient %>;width:40px;height:40px;">
                                                                                    <span>
                                                                                        <%= postOwner.getInitials() %>
                                                                                    </span>
                                                                                </div>
                                                                                <% } %>
                                                                                    <div class="user-details">
                                                                                        <h4 class="username">
                                                                                            <%= postOwner.getFeedUsername()
                                                                                                %>
                                                                                        </h4>
                                                                                        <% if (post.getMemory() !=null
                                                                                            &&
                                                                                            post.getMemory().getTitle()
                                                                                            !=null) { %>
                                                                                            <p class="post-location">
                                                                                                <%= post.getMemory().getTitle()
                                                                                                    %>
                                                                                            </p>
                                                                                            <% } %>
                                                                                    </div>
                                                                    </div>
                                                                </div>

                                                                <div class="comments-list-container"
                                                                    id="commentsContainer">
                                                                    <% if (post.getCaption() !=null &&
                                                                        !post.getCaption().isEmpty()) { %>
                                                                        <div class="comment-item original-caption">
                                                                            <% if (hasOwnerPic) { %>
                                                                                <img src="<%= ownerPic %>"
                                                                                    alt="<%= postOwner.getFeedUsername() %>"
                                                                                    class="comment-avatar">
                                                                                <% } else { %>
                                                                                    <div class="comment-avatar"
                                                                                        style="background:<%= ownerGradient %>">
                                                                                        <span>
                                                                                            <%= postOwner.getInitials()
                                                                                                %>
                                                                                        </span>
                                                                                    </div>
                                                                                    <% } %>
                                                                                        <div class="comment-content">
                                                                                            <div class="comment-header">
                                                                                                <span
                                                                                                    class="comment-username">
                                                                                                    <%= postOwner.getFeedUsername()
                                                                                                        %>
                                                                                                </span>
                                                                                                <span
                                                                                                    class="comment-time">
                                                                                                    <%= post.getRelativeTime()
                                                                                                        %>
                                                                                                </span>
                                                                                            </div>
                                                                                            <p class="comment-text">
                                                                                                <%= post.getCaption() %>
                                                                                            </p>
                                                                                        </div>
                                                                        </div>
                                                                        <% } %>

                                                                            <% if (comments==null || comments.isEmpty())
                                                                                { %>
                                                                                <div class="no-comments">
                                                                                    <svg width="56" height="56"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="1.5">
                                                                                        <path
                                                                                            d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z">
                                                                                        </path>
                                                                                    </svg>
                                                                                    <h3 class="no-comments-title">No
                                                                                        comments yet</h3>
                                                                                    <p class="no-comments-subtitle">
                                                                                        Start the conversation.</p>
                                                                                </div>
                                                                                <% } else { for (FeedComment comment :
                                                                                    comments) { if
                                                                                    (comment.getParentCommentId()
                                                                                    !=null) continue; FeedProfile
                                                                                    commenter=comment.getFeedProfile();
                                                                                    String commenterPic=(commenter
                                                                                    !=null) ?
                                                                                    commenter.getFeedProfilePictureUrl()
                                                                                    : null; boolean
                                                                                    hasCommenterPic=commenterPic !=null
                                                                                    && !commenterPic.isEmpty() &&
                                                                                    !commenterPic.contains("default");
                                                                                    String commenterInitials=(commenter
                                                                                    !=null && commenter.getInitials()
                                                                                    !=null) ? commenter.getInitials()
                                                                                    : "?" ; String
                                                                                    commenterUsername=(commenter !=null
                                                                                    && commenter.getFeedUsername()
                                                                                    !=null) ?
                                                                                    commenter.getFeedUsername()
                                                                                    : "Unknown" ;
                                                                                    commentLiked=comment.isLikedByCurrentUser();
                                                                                    int
                                                                                    cLikeCount=comment.getLikeCount();
                                                                                    boolean canDelete=isPostOwner ||
                                                                                    (currentProfile !=null &&
                                                                                    comment.getFeedProfileId()==currentProfile.getFeedProfileId());
                                                                                    String likedClass=commentLiked
                                                                                    ? " liked" : "" ; String
                                                                                    fillCol=commentLiked ? "#ed4956"
                                                                                    : "none" ; String
                                                                                    strokeCol=commentLiked ? "#ed4956"
                                                                                    : "currentColor" ; %>
                                                                                    <div class="comment-item"
                                                                                        data-comment-id="<%= comment.getCommentId() %>">
                                                                                        <% if (hasCommenterPic) { %>
                                                                                            <img src="<%= commenterPic %>"
                                                                                                alt="<%= commenterUsername %>"
                                                                                                class="comment-avatar">
                                                                                            <% } else { %>
                                                                                                <div class="comment-avatar"
                                                                                                    style="background:<%= ownerGradient %>">
                                                                                                    <span>
                                                                                                        <%= commenterInitials
                                                                                                            %>
                                                                                                    </span>
                                                                                                </div>
                                                                                                <% } %>
                                                                                                    <div
                                                                                                        class="comment-content">
                                                                                                        <div
                                                                                                            class="comment-header">
                                                                                                            <span
                                                                                                                class="comment-username">
                                                                                                                <%= commenterUsername
                                                                                                                    %>
                                                                                                            </span>
                                                                                                            <span
                                                                                                                class="comment-time">
                                                                                                                <%= comment.getRelativeTime()
                                                                                                                    %>
                                                                                                            </span>
                                                                                                        </div>
                                                                                                        <p
                                                                                                            class="comment-text">
                                                                                                            <%= comment.getCommentText()
                                                                                                                %>
                                                                                                        </p>
                                                                                                        <div
                                                                                                            class="comment-actions">
                                                                                                            <button
                                                                                                                class="comment-like-btn<%= likedClass %>"
                                                                                                                data-comment-id="<%= comment.getCommentId() %>">
                                                                                                                <svg width="12"
                                                                                                                    height="12"
                                                                                                                    viewBox="0 0 24 24"
                                                                                                                    fill="<%= fillCol %>"
                                                                                                                    stroke="<%= strokeCol %>"
                                                                                                                    stroke-width="2">
                                                                                                                    <path
                                                                                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                                                                                    </path>
                                                                                                                </svg>
                                                                                                            </button>
                                                                                                            <% if
                                                                                                                (cLikeCount>
                                                                                                                0) {
                                                                                                                %><span
                                                                                                                    class="comment-likes">
                                                                                                                    <%= cLikeCount
                                                                                                                        %>
                                                                                                                        likes
                                                                                                                </span>
                                                                                                                <% } %>
                                                                                                                    <button
                                                                                                                        class="reply-btn"
                                                                                                                        data-username="<%= commenterUsername %>"
                                                                                                                        data-comment-id="<%= comment.getCommentId() %>">Reply</button>
                                                                                                                    <% if
                                                                                                                        (canDelete)
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <button
                                                                                                                            class="delete-comment-btn"
                                                                                                                            data-comment-id="<%= comment.getCommentId() %>">Delete</button>
                                                                                                                        <% }
                                                                                                                            %>
                                                                                                        </div>
                                                                                                        <div class="replies-container"
                                                                                                            id="replies-<%= comment.getCommentId() %>">
                                                                                                        </div>
                                                                                                    </div>
                                                                                    </div>
                                                                                    <% }} %>
                                                                </div>

                                                                <div class="post-actions-bar">
                                                                    <div class="post-actions">
                                                                        <div class="action-buttons">
                                                                            <button
                                                                                class="action-btn like-btn <%= postLikedClass %>"
                                                                                data-post-id="<%= post.getPostId() %>">
                                                                                <svg width="24" height="24"
                                                                                    viewBox="0 0 24 24"
                                                                                    fill="<%= postFillColor %>"
                                                                                    stroke="<%= postStrokeColor %>"
                                                                                    stroke-width="2">
                                                                                    <path
                                                                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                                                    </path>
                                                                                </svg>
                                                                            </button>
                                                                            <button class="action-btn">
                                                                                <svg width="24" height="24"
                                                                                    viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <path
                                                                                        d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z">
                                                                                    </path>
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
                                                                    <button class="emoji-btn" type="button">
                                                                        <svg width="24" height="24" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="12" cy="12" r="10"></circle>
                                                                            <path d="M8 14s1.5 2 4 2 4-2 4-2"></path>
                                                                            <line x1="9" y1="9" x2="9.01" y2="9"></line>
                                                                            <line x1="15" y1="9" x2="15.01" y2="9">
                                                                            </line>
                                                                        </svg>
                                                                    </button>
                                                                    <input type="text" placeholder="Add a comment..."
                                                                        id="commentInput">
                                                                    <input type="hidden" id="parentCommentId" value="">
                                                                    <button class="post-comment-btn" id="postCommentBtn"
                                                                        type="button"
                                                                        data-post-id="<%= post.getPostId() %>">Post</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <script>
                                                        var contextPath = '<%= request.getContextPath() %>';
                                                        var currentUserInitials = '<%= (currentProfile != null) ? currentProfile.getInitials() : "" %>';
                                                        var currentUsername = '<%= (currentProfile != null) ? currentProfile.getFeedUsername() : "" %>';
                                                        var currentProfilePicUrl = '<%= cpUrlSafe %>';
                                                        var currentProfileId = <%= currentProfileId %>;
                                                        var isPostOwner = <%= isPostOwner %>;

                                                        function moveCarousel(direction) {
                                                            var container = document.querySelector('.carousel-container');
                                                            var track = container.querySelector('.carousel-track');
                                                            var slides = container.querySelectorAll('.carousel-slide');
                                                            var dots = container.querySelectorAll('.carousel-dot');
                                                            var currentSlide = parseInt(container.dataset.currentSlide) || 0;
                                                            var newSlide = currentSlide + direction;
                                                            if (newSlide < 0) newSlide = slides.length - 1;
                                                            if (newSlide >= slides.length) newSlide = 0;
                                                            track.style.transform = 'translateX(-' + (newSlide * 100) + '%)';
                                                            container.dataset.currentSlide = newSlide;
                                                            for (var i = 0; i < dots.length; i++) {
                                                                dots[i].classList.toggle('active', i === newSlide);
                                                            }
                                                        }

                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            // Like Post Button
                                                            var likeBtn = document.querySelector('.like-btn');
                                                            if (likeBtn) {
                                                                likeBtn.addEventListener('click', function () {
                                                                    var postId = this.dataset.postId;
                                                                    var isLiked = this.classList.contains('liked');
                                                                    var action = isLiked ? 'unlike' : 'like';
                                                                    var btn = this;
                                                                    fetch(contextPath + '/postLike?postId=' + postId + '&action=' + action, {
                                                                        method: 'POST',
                                                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                                                                    })
                                                                        .then(function (response) { return response.json(); })
                                                                        .then(function (data) {
                                                                            if (data.success) {
                                                                                var svg = btn.querySelector('svg');
                                                                                if (data.isLiked) {
                                                                                    btn.classList.add('liked');
                                                                                    svg.style.fill = '#ed4956';
                                                                                    svg.style.stroke = '#ed4956';
                                                                                } else {
                                                                                    btn.classList.remove('liked');
                                                                                    svg.style.fill = 'none';
                                                                                    svg.style.stroke = 'currentColor';
                                                                                }
                                                                                document.getElementById('likesCount').textContent = data.likeCount + ' likes';
                                                                            }
                                                                        });
                                                                });
                                                            }

                                                            // Comment Like Buttons
                                                            document.querySelectorAll('.comment-like-btn').forEach(function (btn) {
                                                                btn.addEventListener('click', handleCommentLike);
                                                            });

                                                            // Delete Comment Buttons
                                                            document.querySelectorAll('.delete-comment-btn').forEach(function (btn) {
                                                                btn.addEventListener('click', handleDeleteComment);
                                                            });

                                                            // Reply Buttons
                                                            document.querySelectorAll('.reply-btn').forEach(function (btn) {
                                                                btn.addEventListener('click', function () {
                                                                    var username = this.dataset.username;
                                                                    var parentId = this.dataset.commentId;
                                                                    var commentInput = document.getElementById('commentInput');
                                                                    var parentInput = document.getElementById('parentCommentId');
                                                                    commentInput.value = '@' + username + ' ';
                                                                    parentInput.value = parentId;
                                                                    commentInput.focus();
                                                                });
                                                            });

                                                            // Comment Input
                                                            var commentInput = document.getElementById('commentInput');
                                                            var postCommentBtn = document.getElementById('postCommentBtn');

                                                            if (commentInput && postCommentBtn) {
                                                                commentInput.addEventListener('input', function () {
                                                                    postCommentBtn.classList.toggle('active', this.value.trim().length > 0);
                                                                    if (this.value.indexOf('@') !== 0) {
                                                                        document.getElementById('parentCommentId').value = '';
                                                                    }
                                                                });

                                                                commentInput.addEventListener('keypress', function (e) {
                                                                    if (e.key === 'Enter' && this.value.trim().length > 0) {
                                                                        postCommentBtn.click();
                                                                    }
                                                                });

                                                                postCommentBtn.addEventListener('click', function () {
                                                                    var commentText = commentInput.value.trim();
                                                                    if (commentText.length === 0) return;
                                                                    var postId = this.dataset.postId;
                                                                    var parentCommentId = document.getElementById('parentCommentId').value;

                                                                    var url = contextPath + '/commentAction?action=add&postId=' + postId + '&commentText=' + encodeURIComponent(commentText);
                                                                    if (parentCommentId) url += '&parentCommentId=' + parentCommentId;

                                                                    fetch(url, {
                                                                        method: 'POST',
                                                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                                                                    })
                                                                        .then(function (response) { return response.json(); })
                                                                        .then(function (data) {
                                                                            if (data.success) {
                                                                                var noComments = document.querySelector('.no-comments');
                                                                                if (noComments) noComments.remove();

                                                                                var avatarHtml = (currentProfilePicUrl && currentProfilePicUrl.indexOf('default') === -1 && currentProfilePicUrl !== '')
                                                                                    ? '<img src="' + currentProfilePicUrl + '" alt="' + currentUsername + '" class="comment-avatar">'
                                                                                    : '<div class="comment-avatar" style="background:linear-gradient(135deg, #667eea 0%, #764ba2 100%)"><span>' + currentUserInitials + '</span></div>';

                                                                                if (parentCommentId) {
                                                                                    var repliesContainer = document.getElementById('replies-' + parentCommentId);
                                                                                    if (repliesContainer) {
                                                                                        var replyHtml = '<div class="reply-item" data-comment-id="' + data.comment.commentId + '">' +
                                                                                            avatarHtml.replace('comment-avatar', 'reply-avatar') +
                                                                                            '<div class="comment-content">' +
                                                                                            '<div class="comment-header">' +
                                                                                            '<span class="comment-username">' + currentUsername + '</span>' +
                                                                                            '<span class="comment-time">Just now</span>' +
                                                                                            '</div>' +
                                                                                            '<p class="comment-text">' + escapeHtml(data.comment.commentText) + '</p>' +
                                                                                            '<div class="comment-actions">' +
                                                                                            '<button class="comment-like-btn" data-comment-id="' + data.comment.commentId + '">' +
                                                                                            '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>' +
                                                                                            '</button>' +
                                                                                            '<button class="delete-comment-btn" data-comment-id="' + data.comment.commentId + '">Delete</button>' +
                                                                                            '</div>' +
                                                                                            '</div>' +
                                                                                            '</div>';
                                                                                        repliesContainer.insertAdjacentHTML('beforeend', replyHtml);
                                                                                        repliesContainer.querySelector('.reply-item:last-child .comment-like-btn').addEventListener('click', handleCommentLike);
                                                                                        repliesContainer.querySelector('.reply-item:last-child .delete-comment-btn').addEventListener('click', handleDeleteComment);
                                                                                    }
                                                                                } else {
                                                                                    var commentsContainer = document.getElementById('commentsContainer');
                                                                                    var newComment = document.createElement('div');
                                                                                    newComment.className = 'comment-item';
                                                                                    newComment.dataset.commentId = data.comment.commentId;
                                                                                    newComment.innerHTML = avatarHtml +
                                                                                        '<div class="comment-content">' +
                                                                                        '<div class="comment-header">' +
                                                                                        '<span class="comment-username">' + currentUsername + '</span>' +
                                                                                        '<span class="comment-time">Just now</span>' +
                                                                                        '</div>' +
                                                                                        '<p class="comment-text">' + escapeHtml(data.comment.commentText) + '</p>' +
                                                                                        '<div class="comment-actions">' +
                                                                                        '<button class="comment-like-btn" data-comment-id="' + data.comment.commentId + '">' +
                                                                                        '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>' +
                                                                                        '</button>' +
                                                                                        '<button class="reply-btn" data-username="' + currentUsername + '" data-comment-id="' + data.comment.commentId + '">Reply</button>' +
                                                                                        '<button class="delete-comment-btn" data-comment-id="' + data.comment.commentId + '">Delete</button>' +
                                                                                        '</div>' +
                                                                                        '<div class="replies-container" id="replies-' + data.comment.commentId + '"></div>' +
                                                                                        '</div>';
                                                                                    commentsContainer.appendChild(newComment);
                                                                                    newComment.querySelector('.comment-like-btn').addEventListener('click', handleCommentLike);
                                                                                    newComment.querySelector('.delete-comment-btn').addEventListener('click', handleDeleteComment);
                                                                                    newComment.querySelector('.reply-btn').addEventListener('click', function () {
                                                                                        commentInput.value = '@' + currentUsername + ' ';
                                                                                        document.getElementById('parentCommentId').value = data.comment.commentId;
                                                                                        commentInput.focus();
                                                                                    });
                                                                                }

                                                                                commentInput.value = '';
                                                                                document.getElementById('parentCommentId').value = '';
                                                                                postCommentBtn.classList.remove('active');
                                                                                document.getElementById('commentsContainer').scrollTop = document.getElementById('commentsContainer').scrollHeight;
                                                                            }
                                                                        });
                                                                });
                                                            }
                                                        });

                                                        function handleCommentLike() {
                                                            var btn = this;
                                                            var commentId = btn.dataset.commentId;
                                                            var isLiked = btn.classList.contains('liked');
                                                            var action = isLiked ? 'unlike' : 'like';
                                                            fetch(contextPath + '/commentAction?action=' + action + '&commentId=' + commentId, {
                                                                method: 'POST',
                                                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                                                            })
                                                                .then(function (response) { return response.json(); })
                                                                .then(function (data) {
                                                                    if (data.success) {
                                                                        var svg = btn.querySelector('svg');
                                                                        var commentItem = btn.closest('.comment-item') || btn.closest('.reply-item');
                                                                        var likesSpan = commentItem.querySelector('.comment-likes');
                                                                        if (data.isLiked) {
                                                                            btn.classList.add('liked');
                                                                            svg.style.fill = '#ed4956';
                                                                            svg.style.stroke = '#ed4956';
                                                                        } else {
                                                                            btn.classList.remove('liked');
                                                                            svg.style.fill = 'none';
                                                                            svg.style.stroke = 'currentColor';
                                                                        }
                                                                        if (data.likeCount > 0) {
                                                                            if (!likesSpan) {
                                                                                likesSpan = document.createElement('span');
                                                                                likesSpan.className = 'comment-likes';
                                                                                btn.parentNode.insertBefore(likesSpan, btn.nextSibling);
                                                                            }
                                                                            likesSpan.textContent = data.likeCount + ' likes';
                                                                        } else if (likesSpan) {
                                                                            likesSpan.remove();
                                                                        }
                                                                    }
                                                                });
                                                        }

                                                        function handleDeleteComment() {
                                                            var btn = this;
                                                            var commentId = btn.dataset.commentId;
                                                            if (!confirm('Are you sure you want to delete this comment?')) return;
                                                            fetch(contextPath + '/commentAction?action=delete&commentId=' + commentId, {
                                                                method: 'POST',
                                                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                                                            })
                                                                .then(function (response) { return response.json(); })
                                                                .then(function (data) {
                                                                    if (data.success) {
                                                                        var commentItem = document.querySelector('.comment-item[data-comment-id="' + commentId + '"]') || document.querySelector('.reply-item[data-comment-id="' + commentId + '"]');
                                                                        if (commentItem) {
                                                                            commentItem.style.opacity = '0';
                                                                            commentItem.style.transform = 'translateX(-20px)';
                                                                            setTimeout(function () { commentItem.remove(); }, 300);
                                                                        }
                                                                    } else {
                                                                        alert('Failed to delete comment: ' + (data.error || 'Unknown error'));
                                                                    }
                                                                });
                                                        }

                                                        function escapeHtml(text) {
                                                            var div = document.createElement('div');
                                                            div.textContent = text;
                                                            return div.innerHTML;
                                                        }
                                                    </script>
                                                </body>

                                                </html>