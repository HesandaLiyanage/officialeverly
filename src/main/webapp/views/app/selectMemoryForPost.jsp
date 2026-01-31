<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ page import="java.util.List" %>
            <%@ page import="com.demo.web.model.Memory" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Select Memory - Everly</title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
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
                            max-width: 900px;
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

                        .memories-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                            gap: 20px;
                        }

                        .memory-card {
                            background: white;
                            border-radius: 16px;
                            overflow: hidden;
                            cursor: pointer;
                            border: 3px solid transparent;
                            transition: all 0.3s ease;
                            position: relative;
                        }

                        .memory-card:hover {
                            transform: translateY(-4px);
                            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.12);
                            border-color: #9A74D8;
                        }

                        .memory-card.selected {
                            border-color: #9A74D8;
                            box-shadow: 0 0 0 4px rgba(154, 116, 216, 0.2);
                        }

                        .memory-card.posted {
                            opacity: 0.6;
                            pointer-events: none;
                        }

                        .memory-cover {
                            width: 100%;
                            height: 160px;
                            object-fit: cover;
                            background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e1 100%);
                        }

                        .memory-placeholder {
                            width: 100%;
                            height: 160px;
                            background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .memory-placeholder svg {
                            width: 48px;
                            height: 48px;
                            color: white;
                            opacity: 0.6;
                        }

                        .memory-info {
                            padding: 16px;
                        }

                        .memory-title {
                            font-size: 16px;
                            font-weight: 600;
                            color: #1e293b;
                            margin-bottom: 4px;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .memory-description {
                            font-size: 13px;
                            color: #64748b;
                            display: -webkit-box;
                            -webkit-line-clamp: 2;
                            -webkit-box-orient: vertical;
                            overflow: hidden;
                        }

                        .posted-badge {
                            position: absolute;
                            top: 12px;
                            right: 12px;
                            background: rgba(0, 0, 0, 0.7);
                            color: white;
                            padding: 4px 10px;
                            border-radius: 12px;
                            font-size: 11px;
                            font-weight: 600;
                        }

                        .check-icon {
                            position: absolute;
                            top: 12px;
                            left: 12px;
                            width: 28px;
                            height: 28px;
                            background: #9A74D8;
                            border-radius: 50%;
                            display: none;
                            align-items: center;
                            justify-content: center;
                        }

                        .memory-card.selected .check-icon {
                            display: flex;
                        }

                        .check-icon svg {
                            width: 16px;
                            height: 16px;
                            color: white;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 60px 20px;
                        }

                        .empty-state-icon {
                            width: 80px;
                            height: 80px;
                            background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e1 100%);
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 auto 20px;
                        }

                        .empty-state-icon svg {
                            width: 40px;
                            height: 40px;
                            color: #94a3b8;
                        }

                        .empty-state h3 {
                            font-size: 18px;
                            color: #475569;
                            margin-bottom: 8px;
                        }

                        .empty-state p {
                            font-size: 14px;
                            color: #94a3b8;
                            margin-bottom: 24px;
                        }

                        .empty-state a {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                            color: white;
                            padding: 12px 24px;
                            border-radius: 12px;
                            text-decoration: none;
                            font-weight: 600;
                            transition: transform 0.2s;
                        }

                        .empty-state a:hover {
                            transform: translateY(-2px);
                        }

                        .action-bar {
                            position: fixed;
                            bottom: 0;
                            left: 0;
                            right: 0;
                            background: white;
                            padding: 16px 24px;
                            box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.1);
                            display: none;
                            align-items: center;
                            justify-content: space-between;
                            z-index: 100;
                        }

                        .action-bar.visible {
                            display: flex;
                        }

                        .selected-info {
                            font-size: 14px;
                            color: #64748b;
                        }

                        .selected-info strong {
                            color: #1e293b;
                        }

                        .post-btn {
                            background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%);
                            color: white;
                            border: none;
                            padding: 12px 28px;
                            border-radius: 12px;
                            font-size: 15px;
                            font-weight: 600;
                            cursor: pointer;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            transition: transform 0.2s, box-shadow 0.2s;
                        }

                        .post-btn:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 8px 20px rgba(154, 116, 216, 0.4);
                        }

                        .post-btn:disabled {
                            opacity: 0.6;
                            cursor: not-allowed;
                            transform: none;
                        }

                        /* Caption Modal */
                        .modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            right: 0;
                            bottom: 0;
                            background: rgba(0, 0, 0, 0.5);
                            display: none;
                            align-items: center;
                            justify-content: center;
                            z-index: 1000;
                        }

                        .modal-overlay.visible {
                            display: flex;
                        }

                        .modal-content {
                            background: white;
                            border-radius: 20px;
                            padding: 28px;
                            max-width: 480px;
                            width: 90%;
                        }

                        .modal-title {
                            font-size: 20px;
                            font-weight: 600;
                            color: #1e293b;
                            margin-bottom: 8px;
                        }

                        .modal-subtitle {
                            font-size: 14px;
                            color: #64748b;
                            margin-bottom: 20px;
                        }

                        .caption-input {
                            width: 100%;
                            padding: 14px 16px;
                            border: 2px solid #e2e8f0;
                            border-radius: 12px;
                            font-size: 14px;
                            font-family: inherit;
                            resize: none;
                            margin-bottom: 20px;
                            transition: border-color 0.2s;
                        }

                        .caption-input:focus {
                            outline: none;
                            border-color: #9A74D8;
                        }

                        .modal-actions {
                            display: flex;
                            gap: 12px;
                            justify-content: flex-end;
                        }

                        .modal-btn {
                            padding: 12px 24px;
                            border-radius: 10px;
                            font-size: 14px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .modal-btn.cancel {
                            background: #f1f5f9;
                            color: #64748b;
                            border: none;
                        }

                        .modal-btn.cancel:hover {
                            background: #e2e8f0;
                        }

                        .modal-btn.submit {
                            background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%);
                            color: white;
                            border: none;
                        }

                        .modal-btn.submit:hover {
                            transform: translateY(-2px);
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="../public/header2.jsp" />

                    <div class="page-wrapper">
                        <a href="${pageContext.request.contextPath}/createPost" class="back-button">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <path d="M19 12H5M12 19l-7-7 7-7" />
                            </svg>
                            Back
                        </a>

                        <h1 class="page-title">Select a Memory</h1>
                        <p class="page-subtitle">Choose a memory to share on your feed</p>

                        <c:choose>
                            <c:when test="${not empty memories}">
                                <div class="memories-grid">
                                    <c:forEach var="memory" items="${memories}">
                                        <div class="memory-card" data-memory-id="${memory.memoryId}"
                                            data-title="${memory.title}">
                                            <div class="check-icon">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="3">
                                                    <polyline points="20 6 9 17 4 12" />
                                                </svg>
                                            </div>
                                            <c:choose>
                                                <c:when test="${not empty memory.coverUrl}">
                                                    <img src="${memory.coverUrl}" alt="${memory.title}"
                                                        class="memory-cover">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="memory-placeholder">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="1.5">
                                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                                            <circle cx="8.5" cy="8.5" r="1.5" />
                                                            <polyline points="21 15 16 10 5 21" />
                                                        </svg>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="memory-info">
                                                <h3 class="memory-title">${memory.title}</h3>
                                                <p class="memory-description">${memory.description}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                            <circle cx="8.5" cy="8.5" r="1.5" />
                                            <polyline points="21 15 16 10 5 21" />
                                        </svg>
                                    </div>
                                    <h3>No memories yet</h3>
                                    <p>Create your first memory to share it on your feed</p>
                                    <a href="${pageContext.request.contextPath}/creatememory?source=post">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <line x1="12" y1="8" x2="12" y2="16" />
                                            <line x1="8" y1="12" x2="16" y2="12" />
                                        </svg>
                                        Create Memory
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Action Bar -->
                    <div class="action-bar" id="actionBar">
                        <div class="selected-info">
                            Selected: <strong id="selectedTitle">None</strong>
                        </div>
                        <button class="post-btn" id="postBtn" disabled>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z" />
                            </svg>
                            Share to Feed
                        </button>
                    </div>

                    <!-- Caption Modal -->
                    <div class="modal-overlay" id="captionModal">
                        <div class="modal-content">
                            <h2 class="modal-title">Add a Caption</h2>
                            <p class="modal-subtitle">Write something about this memory (optional)</p>
                            <textarea class="caption-input" id="captionInput" rows="3"
                                placeholder="What's this memory about?"></textarea>
                            <div class="modal-actions">
                                <button class="modal-btn cancel" id="cancelBtn">Cancel</button>
                                <button class="modal-btn submit" id="submitPostBtn">Post</button>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../public/footer.jsp" />

                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const memoryCards = document.querySelectorAll('.memory-card:not(.posted)');
                            const actionBar = document.getElementById('actionBar');
                            const postBtn = document.getElementById('postBtn');
                            const selectedTitle = document.getElementById('selectedTitle');
                            const captionModal = document.getElementById('captionModal');
                            const captionInput = document.getElementById('captionInput');
                            const cancelBtn = document.getElementById('cancelBtn');
                            const submitPostBtn = document.getElementById('submitPostBtn');

                            let selectedMemoryId = null;

                            memoryCards.forEach(card => {
                                card.addEventListener('click', function () {
                                    // Deselect all
                                    memoryCards.forEach(c => c.classList.remove('selected'));

                                    // Select this one
                                    this.classList.add('selected');
                                    selectedMemoryId = this.dataset.memoryId;
                                    selectedTitle.textContent = this.dataset.title;

                                    // Show action bar
                                    actionBar.classList.add('visible');
                                    postBtn.disabled = false;
                                });
                            });

                            postBtn.addEventListener('click', function () {
                                captionModal.classList.add('visible');
                            });

                            cancelBtn.addEventListener('click', function () {
                                captionModal.classList.remove('visible');
                            });

                            captionModal.addEventListener('click', function (e) {
                                if (e.target === captionModal) {
                                    captionModal.classList.remove('visible');
                                }
                            });

                            submitPostBtn.addEventListener('click', function () {
                                if (!selectedMemoryId) return;

                                submitPostBtn.disabled = true;
                                submitPostBtn.textContent = 'Posting...';

                                const formData = new FormData();
                                formData.append('memoryId', selectedMemoryId);
                                formData.append('caption', captionInput.value);

                                fetch('${pageContext.request.contextPath}/createPost', {
                                    method: 'POST',
                                    body: formData
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            alert('Posted successfully!');
                                            window.location.href = '${pageContext.request.contextPath}/feed';
                                        } else {
                                            alert('Error: ' + data.error);
                                            submitPostBtn.disabled = false;
                                            submitPostBtn.textContent = 'Post';
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert('Failed to create post');
                                        submitPostBtn.disabled = false;
                                        submitPostBtn.textContent = 'Post';
                                    });
                            });
                        });
                    </script>
                </body>

                </html>