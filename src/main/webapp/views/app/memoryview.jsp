<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <jsp:include page="../public/header2.jsp" />
            <html>

            <head>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/memoryviewer.css">
                <style>
                    /* Floating Action Buttons Container */
                    .floating-buttons-memory-viewer {
                        position: fixed;
                        bottom: 30px;
                        right: 30px;
                        display: flex;
                        flex-direction: column;
                        gap: 12px;
                        z-index: 1000;
                    }

                    /* Floating Button Base Style */
                    .floating-btn-memory-viewer {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        gap: 10px;
                        padding: 12px 24px;
                        border: none;
                        border-radius: 24px;
                        font-family: "Plus Jakarta Sans", sans-serif;
                        font-size: 15px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        text-decoration: none;
                        white-space: nowrap;
                        box-shadow: 0 4px 14px rgba(154, 116, 216, 0.35);
                    }

                    .floating-btn-memory-viewer:hover {
                        transform: translateY(-2px);
                    }

                    .floating-btn-memory-viewer:active {
                        transform: translateY(0);
                    }

                    /* Edit Button Specific Style */
                    .floating-btn-memory-viewer.edit-btn {
                        background: #9A74D8;
                        color: #ffffff;
                    }

                    .floating-btn-memory-viewer.edit-btn:hover {
                        background: #8a64c8;
                        box-shadow: 0 6px 20px rgba(154, 116, 216, 0.45);
                    }

                    /* Delete Button Specific Style */
                    .floating-btn-memory-viewer.delete-btn {
                        background: #EADDFF;
                        color: #9A74D8;
                    }

                    .floating-btn-memory-viewer.delete-btn:hover {
                        background: #FFFFFF;
                        color: #8a64c8;
                        box-shadow: 0 6px 20px rgba(234, 221, 255, 0.6);
                    }

                    /* Photo grid styles */
                    .photos-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                        gap: 16px;
                        margin-top: 20px;
                    }

                    .photo-item {
                        position: relative;
                        border-radius: 12px;
                        overflow: hidden;
                        cursor: pointer;
                        aspect-ratio: 1;
                        background: #f0f0f0;
                    }

                    .photo-item img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                        transition: transform 0.3s ease;
                    }

                    .photo-item:hover img {
                        transform: scale(1.05);
                    }

                    /* No media message */
                    .no-media {
                        text-align: center;
                        padding: 60px 20px;
                        color: #666;
                    }

                    .no-media svg {
                        width: 64px;
                        height: 64px;
                        color: #ccc;
                        margin-bottom: 16px;
                    }

                    /* Lightbox */
                    .lightbox {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.9);
                        z-index: 2000;
                        justify-content: center;
                        align-items: center;
                    }

                    .lightbox.active {
                        display: flex;
                    }

                    .lightbox img {
                        max-width: 90%;
                        max-height: 90%;
                        object-fit: contain;
                    }

                    .lightbox-close {
                        position: absolute;
                        top: 20px;
                        right: 20px;
                        background: none;
                        border: none;
                        color: white;
                        font-size: 32px;
                        cursor: pointer;
                    }

                    .lightbox-nav {
                        position: absolute;
                        top: 50%;
                        transform: translateY(-50%);
                        background: rgba(255, 255, 255, 0.2);
                        border: none;
                        color: white;
                        padding: 20px;
                        cursor: pointer;
                        border-radius: 50%;
                    }

                    .lightbox-nav.prev {
                        left: 20px;
                    }

                    .lightbox-nav.next {
                        right: 20px;
                    }
                </style>
            </head>

            <body>
                <div class="memory-viewer-wrapper">
                    <div class="memory-viewer-container">
                        <!-- Navigation Header -->
                        <div class="viewer-header">
                            <c:choose>
                                <c:when test="${isGroupMemory}">
                                    <a href="${pageContext.request.contextPath}/groupmemories?groupId=${group.groupId}"
                                        class="nav-btn prev-album">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <polyline points="15 18 9 12 15 6"></polyline>
                                        </svg>
                                        Back to Group Memories
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/memories" class="nav-btn prev-album">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <polyline points="15 18 9 12 15 6"></polyline>
                                        </svg>
                                        Back to Memories
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            <h1 class="memory-title" id="memoryTitle">
                                <c:out value="${memory.title}" default="Untitled Memory" />
                            </h1>
                            <div></div> <!-- Spacer -->
                        </div>

                        <!-- Memory Info -->
                        <div class="photo-info">
                            <div class="info-left">
                                <p class="photo-date" id="photoDate">
                                    <fmt:formatDate value="${memory.createdTimestamp}" pattern="MMMM d, yyyy" />
                                </p>
                                <c:if test="${not empty memory.description}">
                                    <p class="photo-description" id="photoDescription">
                                        <c:out value="${memory.description}" />
                                    </p>
                                </c:if>
                            </div>
                        </div>

                        <!-- Photo Grid -->
                        <c:choose>
                            <c:when test="${empty mediaItems}">
                                <div class="no-media">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                        <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                        <polyline points="21 15 16 10 5 21"></polyline>
                                    </svg>
                                    <h3>No photos in this memory yet</h3>
                                    <p>Add photos to your memory by editing it.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="photos-grid" id="photosGrid">
                                    <c:forEach var="media" items="${mediaItems}" varStatus="status">
                                        <div class="photo-item" onclick="openLightbox(${status.index})"
                                            data-media-id="${media.mediaId}">
                                            <!-- Debug: All media items should use viewmedia servlet -->
                                            <img src="${pageContext.request.contextPath}/viewmedia?id=${media.mediaId}"
                                                alt="${media.title}" loading="lazy"
                                                onerror="console.error('Failed to load media ID: ${media.mediaId}'); this.style.background='#ffcccc';">
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Interactions Bar -->
                        <div class="interactions-bar">
                            <button class="interaction-btn like-btn" id="likeBtn">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                    </path>
                                </svg>
                                <span id="likeCount">0</span>
                            </button>
                            <c:if test="${not isGroupMemory}">
                                <button class="interaction-btn share-btn" id="shareBtn">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="18" cy="5" r="3"></circle>
                                        <circle cx="6" cy="12" r="3"></circle>
                                        <circle cx="18" cy="19" r="3"></circle>
                                        <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
                                        <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
                                    </svg>
                                    Share
                                </button>
                            </c:if>
                        </div>

                        <!-- Comments Section -->
                        <div class="comments-section" id="commentsSection">
                            <h3 class="comments-title">Comments</h3>
                            <div class="comments-list" id="commentsList">
                                <p class="no-comments">No comments yet. Be the first to comment!</p>
                            </div>
                            <div class="comment-input-container">
                                <div class="comment-avatar"></div>
                                <input type="text" class="comment-input" placeholder="Add a comment..."
                                    id="commentInput">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Lightbox for viewing photos -->
                <div class="lightbox" id="lightbox">
                    <button class="lightbox-close" onclick="closeLightbox()">&times;</button>
                    <button class="lightbox-nav prev" onclick="prevImage()">&#8249;</button>
                    <img id="lightboxImg" src="" alt="Memory Photo">
                    <button class="lightbox-nav next" onclick="nextImage()">&#8250;</button>
                </div>

                <!-- Floating Action Buttons (only shown for users with edit permission) -->
                <c:if test="${canEdit}">
                    <div class="floating-buttons-memory-viewer">
                        <a href="/editmemory?id=${memory.memoryId}" class="floating-btn-memory-viewer edit-btn">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                            </svg>
                            Edit Memory
                        </a>
                        <button class="floating-btn-memory-viewer delete-btn" onclick="confirmDelete()">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M3 6h18"></path>
                                <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
                                <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
                            </svg>
                            Delete Memory
                        </button>
                    </div>
                </c:if>

                <jsp:include page="../public/footer.jsp" />

                <script>
                    // Lightbox functionality
                    let currentImageIndex = 0;
                    const mediaItems = [];

                    // Populate media items array from grid
                    document.querySelectorAll('.photo-item img').forEach((img, index) => {
                        mediaItems.push(img.src);
                    });

                    function openLightbox(index) {
                        currentImageIndex = index;
                        document.getElementById('lightboxImg').src = mediaItems[index];
                        document.getElementById('lightbox').classList.add('active');
                        document.body.style.overflow = 'hidden';
                    }

                    function closeLightbox() {
                        document.getElementById('lightbox').classList.remove('active');
                        document.body.style.overflow = '';
                    }

                    function nextImage() {
                        if (currentImageIndex < mediaItems.length - 1) {
                            currentImageIndex++;
                            document.getElementById('lightboxImg').src = mediaItems[currentImageIndex];
                        }
                    }

                    function prevImage() {
                        if (currentImageIndex > 0) {
                            currentImageIndex--;
                            document.getElementById('lightboxImg').src = mediaItems[currentImageIndex];
                        }
                    }

                    // Keyboard navigation for lightbox
                    document.addEventListener('keydown', function (e) {
                        if (document.getElementById('lightbox').classList.contains('active')) {
                            if (e.key === 'ArrowRight') nextImage();
                            if (e.key === 'ArrowLeft') prevImage();
                            if (e.key === 'Escape') closeLightbox();
                        }
                    });

                    // Close lightbox on background click
                    document.getElementById('lightbox').addEventListener('click', function (e) {
                        if (e.target === this) {
                            closeLightbox();
                        }
                    });

                    // Confirmation function for delete button
                    function confirmDelete() {
                        if (confirm("Are you sure you want to delete this memory? This action cannot be undone.")) {
                            window.location.href = '/deletememory?id=${memory.memoryId}';
                        }
                    }

                    // Like button toggle (client-side only for now)
                    document.getElementById('likeBtn').addEventListener('click', function () {
                        this.classList.toggle('liked');
                        const countEl = document.getElementById('likeCount');
                        let count = parseInt(countEl.textContent);
                        countEl.textContent = this.classList.contains('liked') ? count + 1 : count - 1;
                    });
                </script>
            </body>

            </html>