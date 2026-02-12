<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.GroupAnnouncement" %>
        <%@ page import="com.demo.web.model.user" %>
            <jsp:include page="../public/header2.jsp" />
            <html>

            <head>
                <title>Announcement Details - Everly</title>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
                <style>
                    .announcement-detail-container {
                        max-width: 900px;
                        margin: 40px auto;
                        background: white;
                        padding: 50px;
                        border-radius: 24px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
                    }

                    .detail-header {
                        border-bottom: 2px solid #f3f4f6;
                        margin-bottom: 30px;
                        padding-bottom: 20px;
                    }

                    .detail-title {
                        font-size: 36px;
                        font-weight: 800;
                        color: #111827;
                        margin-bottom: 20px;
                        line-height: 1.2;
                        letter-spacing: -1px;
                    }

                    .author-meta {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .author-avatar {
                        width: 44px;
                        height: 44px;
                        border-radius: 50%;
                        background: #9A74D8;
                        color: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        font-size: 16px;
                    }

                    .author-info {
                        display: flex;
                        flex-direction: column;
                    }

                    .author-name {
                        font-weight: 700;
                        color: #374151;
                        font-size: 15px;
                    }

                    .post-date {
                        font-size: 13px;
                        color: #9ca3af;
                        font-weight: 500;
                    }

                    .detail-content {
                        font-size: 18px;
                        line-height: 1.8;
                        color: #374151;
                        white-space: pre-wrap;
                        margin-bottom: 40px;
                    }

                    .detail-footer {
                        border-top: 2px solid #f3f4f6;
                        padding-top: 30px;
                    }

                    .back-link {
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        color: #9A74D8;
                        text-decoration: none;
                        font-weight: 700;
                        font-size: 15px;
                        transition: all 0.2s ease;
                    }

                    .back-link:hover {
                        color: #8a64c8;
                        transform: translateX(-4px);
                    }
                </style>
            </head>

            <body>
                <% GroupAnnouncement ga=(GroupAnnouncement) request.getAttribute("announcement"); %>
                    <div class="page-wrapper">
                        <div class="announcement-detail-container">
                            <div class="detail-header">
                                <h1 class="detail-title">
                                    <%= ga !=null ? ga.getTitle() : "Announcement" %>
                                </h1>
                                <div class="author-meta">
                                    <div class="author-avatar">
                                        <%= ga !=null && ga.getPostedBy() !=null ?
                                            ga.getPostedBy().getUsername().substring(0, 1).toUpperCase() : "A" %>
                                    </div>
                                    <div class="author-info">
                                        <span class="author-name">Posted by <%= ga !=null && ga.getPostedBy() !=null ?
                                                ga.getPostedBy().getUsername() : "Unknown" %></span>
                                        <span class="post-date">
                                            <%= ga !=null ? ga.getCreatedAt().toString() : "" %>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="detail-content">
                                <%= ga !=null ? ga.getContent() : "" %>
                            </div>

                            <% if (ga !=null && ga.getEventId() !=null) { %>
                                <div style="margin-bottom: 30px;">
                                    <a href="${pageContext.request.contextPath}/eventinfo?id=<%= ga.getEventId() %>"
                                        style="display: inline-flex; align-items: center; gap: 10px; padding: 14px 28px; background: linear-gradient(135deg, #9A74D8, #7c5cbf); color: white; text-decoration: none; border-radius: 14px; font-weight: 700; font-size: 15px; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(154, 116, 216, 0.3);"
                                        onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 20px rgba(154, 116, 216, 0.4)';"
                                        onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 15px rgba(154, 116, 216, 0.3)';">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                        </svg>
                                        Go to Event
                                    </a>
                                </div>
                                <% } %>

                                    <div class="detail-footer">
                                        <a href="${pageContext.request.contextPath}/groupannouncement?groupId=<%= ga != null ? ga.getGroupId() : "" %>"
                                            class="back-link">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <line x1="19" y1="12" x2="5" y2="12"></line>
                                                <polyline points="12 19 5 12 12 5"></polyline>
                                            </svg>
                                            Back to All Announcements
                                        </a>
                                    </div>
                        </div>
                    </div>
                    <jsp:include page="../public/footer.jsp" />
            </body>

            </html>