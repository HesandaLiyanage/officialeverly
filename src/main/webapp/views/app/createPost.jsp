<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Create Post - Everly</title>
            <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Plus Jakarta Sans', sans-serif;
                    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                    min-height: 100vh;
                }

                .page-wrapper {
                    max-width: 600px;
                    margin: 0 auto;
                    padding: 20px;
                    padding-top: 100px;
                }

                .back-button {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    color: #64748b;
                    text-decoration: none;
                    font-size: 14px;
                    font-weight: 500;
                    margin-bottom: 24px;
                    transition: color 0.2s;
                }

                .back-button:hover {
                    color: #334155;
                }

                .page-title {
                    font-size: 28px;
                    font-weight: 700;
                    color: #1e293b;
                    margin-bottom: 8px;
                }

                .page-subtitle {
                    font-size: 15px;
                    color: #64748b;
                    margin-bottom: 32px;
                }

                .option-cards {
                    display: flex;
                    flex-direction: column;
                    gap: 16px;
                }

                .option-card {
                    background: white;
                    border-radius: 20px;
                    padding: 28px;
                    cursor: pointer;
                    border: 2px solid transparent;
                    transition: all 0.3s ease;
                    text-decoration: none;
                    display: block;
                }

                .option-card:hover {
                    transform: translateY(-4px);
                    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.1);
                }

                .option-card.existing:hover {
                    border-color: #9A74D8;
                }

                .option-card.new:hover {
                    border-color: #6366f1;
                }

                .option-header {
                    display: flex;
                    align-items: center;
                    gap: 16px;
                    margin-bottom: 12px;
                }

                .option-icon {
                    width: 56px;
                    height: 56px;
                    border-radius: 16px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .option-icon.existing {
                    background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%);
                }

                .option-icon.new {
                    background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                }

                .option-icon svg {
                    width: 28px;
                    height: 28px;
                    color: white;
                }

                .option-title {
                    font-size: 18px;
                    font-weight: 600;
                    color: #1e293b;
                }

                .option-description {
                    font-size: 14px;
                    color: #64748b;
                    line-height: 1.6;
                }

                .option-arrow {
                    margin-left: auto;
                    color: #cbd5e1;
                    transition: transform 0.2s;
                }

                .option-card:hover .option-arrow {
                    transform: translateX(4px);
                    color: #94a3b8;
                }

                .divider {
                    display: flex;
                    align-items: center;
                    gap: 16px;
                    margin: 8px 0;
                }

                .divider-line {
                    flex: 1;
                    height: 1px;
                    background: #e2e8f0;
                }

                .divider-text {
                    font-size: 13px;
                    color: #94a3b8;
                    font-weight: 500;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../public/header2.jsp" />

            <div class="page-wrapper">
                <a href="${pageContext.request.contextPath}/feed" class="back-button">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M19 12H5M12 19l-7-7 7-7" />
                    </svg>
                    Back to Feed
                </a>

                <h1 class="page-title">Create a Post</h1>
                <p class="page-subtitle">Share a memory with everyone on your feed</p>

                <div class="option-cards">
                    <!-- Use Existing Memory -->
                    <a href="${pageContext.request.contextPath}/createPost?action=selectMemory"
                        class="option-card existing">
                        <div class="option-header">
                            <div class="option-icon existing">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                    <circle cx="8.5" cy="8.5" r="1.5" />
                                    <polyline points="21 15 16 10 5 21" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="option-title">Use an existing memory</h3>
                            </div>
                            <div class="option-arrow">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M9 18l6-6-6-6" />
                                </svg>
                            </div>
                        </div>
                        <p class="option-description">
                            Choose from your saved memories to share on your public feed. Your original memory stays
                            private.
                        </p>
                    </a>

                    <div class="divider">
                        <div class="divider-line"></div>
                        <span class="divider-text">OR</span>
                        <div class="divider-line"></div>
                    </div>

                    <!-- Create New Memory -->
                    <a href="${pageContext.request.contextPath}/creatememory?source=post" class="option-card new">
                        <div class="option-header">
                            <div class="option-icon new">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10" />
                                    <line x1="12" y1="8" x2="12" y2="16" />
                                    <line x1="8" y1="12" x2="16" y2="12" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="option-title">Create a new memory</h3>
                            </div>
                            <div class="option-arrow">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M9 18l6-6-6-6" />
                                </svg>
                            </div>
                        </div>
                        <p class="option-description">
                            Upload new photos or videos. This will be saved as a memory and automatically shared as a
                            post.
                        </p>
                    </a>
                </div>
            </div>

            <jsp:include page="../public/footer.jsp" />
        </body>

        </html>