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

                    /* Edit Button Specific Style */
                    .floating-btn-memory-viewer.edit-btn {
                        background: #9A74D8;
                        color: #ffffff;
                    }

                    .floating-btn-memory-viewer.edit-btn:hover {
                        background: #8a64c8;
                        box-shadow: 0 6px 20px rgba(154, 116, 216, 0.45);
                    }

                    /* Share Button Specific Style */
                    .floating-btn-memory-viewer.share-btn {
                        background: linear-gradient(135deg, #9A74D8, #7C5AB8);
                        color: #ffffff;
                    }

                    .floating-btn-memory-viewer.share-btn:hover {
                        background: linear-gradient(135deg, #8a64c8, #6C4AA8);
                        box-shadow: 0 6px 20px rgba(154, 116, 216, 0.45);
                    }

                    /* Delete/Leave Button Specific Style */
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

                    /* Collab Badge */
                    .collab-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        background: linear-gradient(135deg, #9A74D8, #7C5AB8);
                        color: white;
                        padding: 6px 14px;
                        border-radius: 20px;
                        font-size: 13px;
                        font-weight: 600;
                        margin-right: 12px;
                    }

                    /* Members Section */
                    .members-section {
                        background: #f8f9fa;
                        border-radius: 16px;
                        padding: 24px;
                        margin-top: 30px;
                    }

                    .members-title {
                        font-size: 18px;
                        font-weight: 600;
                        margin-bottom: 20px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        color: #333;
                    }

                    .members-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                        gap: 16px;
                    }

                    .member-card {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 12px 16px;
                        background: white;
                        border-radius: 12px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                    }

                    .member-avatar {
                        width: 44px;
                        height: 44px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #9A74D8, #7C5AB8);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-weight: 600;
                        font-size: 18px;
                    }

                    .member-info {
                        flex: 1;
                    }

                    .member-name {
                        font-weight: 600;
                        color: #333;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .owner-badge {
                        background: #ffd700;
                        color: #333;
                        padding: 2px 8px;
                        border-radius: 10px;
                        font-size: 11px;
                        font-weight: 600;
                    }

                    .member-joined {
                        font-size: 12px;
                        color: #888;
                        margin-top: 2px;
                    }

                    .member-remove-btn {
                        background: #ff4757;
                        color: white;
                        border: none;
                        padding: 6px 12px;
                        border-radius: 8px;
                        font-size: 12px;
                        cursor: pointer;
                        opacity: 0;
                        transition: opacity 0.2s;
                    }

                    .member-card:hover .member-remove-btn {
                        opacity: 1;
                    }

                    /* Share Modal */
                    .share-modal {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.5);
                        z-index: 3000;
                        align-items: center;
                        justify-content: center;
                    }

                    .share-modal.active {
                        display: flex;
                    }

                    .share-modal-content {
                        background: white;
                        border-radius: 20px;
                        padding: 30px;
                        max-width: 450px;
                        width: 90%;
                        position: relative;
                    }

                    .share-modal-title {
                        font-size: 22px;
                        font-weight: 600;
                        margin-bottom: 10px;
                        text-align: center;
                    }

                    .share-link-box {
                        display: flex;
                        gap: 10px;
                        margin: 20px 0;
                    }

                    .share-link-input {
                        flex: 1;
                        padding: 14px 16px;
                        border: 2px solid #e0e0e0;
                        border-radius: 12px;
                        font-size: 14px;
                    }

                    .copy-btn {
                        background: #9A74D8;
                        color: white;
                        border: none;
                        padding: 14px 24px;
                        border-radius: 12px;
                        cursor: pointer;
                        font-weight: 600;
                    }

                    .share-socials {
                        display: flex;
                        justify-content: center;
                        gap: 15px;
                        margin-top: 20px;
                    }

                    .social-btn {
                        width: 50px;
                        height: 50px;
                        border-radius: 50%;
                        border: none;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        transition: transform 0.2s;
                    }

                    .social-btn:hover {
                        transform: scale(1.1);
                    }

                    .social-btn.whatsapp {
                        background: #25D366;
                    }

                    .social-btn.twitter {
                        background: #1DA1F2;
                    }

                    .social-btn svg {
                        width: 24px;
                        height: 24px;
                        fill: white;
                    }

                    .close-modal-btn {
                        position: absolute;
                        top: 15px;
                        right: 20px;
                        background: none;
                        border: none;
                        font-size: 28px;
                        cursor: pointer;
                        color: #888;
                    }
                </style>
            </head>

            <body>
                <div class="memory-viewer-wrapper">
                    <div class="memory-viewer-container">
                        <!-- Navigation Header -->
                        <div class="viewer-header">
                            <a href="/collabmemories" class="nav-btn prev-album">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                Back to Collab Memories
                            </a>
                            <h1 class="memory-title" id="memoryTitle">
                                <c:out value="${memory.title}" default="Untitled Memory" />
                            </h1>
                            <div></div>
                        </div>

                        <!-- Memory Info -->
                        <div class="photo-info">
                            <div class="info-left">
                                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                                    <span class="collab-badge">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                        </svg>
                                        ${members.size()} Members
                                    </span>
                                </div>
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
                                            <img src="${pageContext.request.contextPath}/viewmedia?id=${media.mediaId}"
                                                alt="${media.title}" loading="lazy">
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Members Section -->
                        <div class="members-section">
                            <h3 class="members-title">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                                Memory Collaborators
                            </h3>
                            <div class="members-grid">
                                <c:forEach var="member" items="${members}">
                                    <div class="member-card">
                                        <div class="member-avatar">
                                            ${member.username.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div class="member-info">
                                            <div class="member-name">
                                                ${member.username}
                                                <c:if test="${member.role eq 'owner'}">
                                                    <span class="owner-badge">Owner</span>
                                                </c:if>
                                            </div>
                                            <div class="member-joined">
                                                Joined
                                                <fmt:formatDate value="${member.joinedAt}" pattern="MMM d, yyyy" />
                                            </div>
                                        </div>
                                        <c:if test="${isOwner and member.role ne 'owner'}">
                                            <button class="member-remove-btn"
                                                onclick="removeMember(${member.userId})">Remove</button>
                                        </c:if>
                                    </div>
                                </c:forEach>
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

                <!-- Floating Action Buttons -->
                <div class="floating-buttons-memory-viewer">
                    <c:if test="${isOwner}">
                        <button class="floating-btn-memory-viewer share-btn" onclick="openShareModal()">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2.5">
                                <circle cx="18" cy="5" r="3"></circle>
                                <circle cx="6" cy="12" r="3"></circle>
                                <circle cx="18" cy="19" r="3"></circle>
                                <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
                                <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
                            </svg>
                            Share Memory
                        </button>
                    </c:if>
                    <a href="/editmemory?id=${memory.memoryId}" class="floating-btn-memory-viewer edit-btn">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                        </svg>
                        Edit Memory
                    </a>
                    <c:choose>
                        <c:when test="${isOwner}">
                            <button class="floating-btn-memory-viewer delete-btn" onclick="confirmDelete()">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M3 6h18"></path>
                                    <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
                                    <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
                                </svg>
                                Delete Memory
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="floating-btn-memory-viewer delete-btn" onclick="leaveMemory()">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                    <polyline points="16 17 21 12 16 7"></polyline>
                                    <line x1="21" y1="12" x2="9" y2="12"></line>
                                </svg>
                                Leave Memory
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Share Modal -->
                <div class="share-modal" id="shareModal">
                    <div class="share-modal-content">
                        <button class="close-modal-btn" onclick="closeShareModal()">&times;</button>
                        <h2 class="share-modal-title">Invite Collaborators</h2>
                        <p style="text-align: center; color: #666;">
                            Anyone with this link can join and add photos to this memory
                        </p>
                        <div class="share-link-box">
                            <input type="text" class="share-link-input" id="shareLinkInput" readonly
                                placeholder="Generating link...">
                            <button class="copy-btn" onclick="copyLink()">Copy</button>
                        </div>
                        <div class="share-socials">
                            <button class="social-btn whatsapp" onclick="shareWhatsApp()">
                                <svg viewBox="0 0 24 24">
                                    <path
                                        d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" />
                                </svg>
                            </button>
                            <button class="social-btn twitter" onclick="shareTwitter()">
                                <svg viewBox="0 0 24 24">
                                    <path
                                        d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <jsp:include page="../public/footer.jsp" />

                <script>
                    const memoryId = ${ memory.memoryId };
                    let shareUrl = '';

                    // Lightbox functionality
                    let currentImageIndex = 0;
                    const mediaItems = [];

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

                    document.addEventListener('keydown', function (e) {
                        if (document.getElementById('lightbox').classList.contains('active')) {
                            if (e.key === 'ArrowRight') nextImage();
                            if (e.key === 'ArrowLeft') prevImage();
                            if (e.key === 'Escape') closeLightbox();
                        }
                    });

                    document.getElementById('lightbox').addEventListener('click', function (e) {
                        if (e.target === this) closeLightbox();
                    });

                    // Share functionality
                    function openShareModal() {
                        document.getElementById('shareModal').classList.add('active');
                        fetch('/generateCollabShareLink', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'memoryId=' + memoryId
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.success) {
                                    shareUrl = data.shareUrl;
                                    document.getElementById('shareLinkInput').value = shareUrl;
                                } else {
                                    alert('Error generating share link: ' + data.error);
                                }
                            })
                            .catch(err => {
                                console.error('Error:', err);
                                alert('Failed to generate share link');
                            });
                    }

                    function closeShareModal() {
                        document.getElementById('shareModal').classList.remove('active');
                    }

                    function copyLink() {
                        const input = document.getElementById('shareLinkInput');
                        input.select();
                        document.execCommand('copy');
                        alert('Link copied to clipboard!');
                    }

                    function shareWhatsApp() {
                        window.open('https://wa.me/?text=' + encodeURIComponent('Join my memory on Everly: ' + shareUrl), '_blank');
                    }

                    function shareTwitter() {
                        window.open('https://twitter.com/intent/tweet?text=' + encodeURIComponent('Check out this memory!') + '&url=' + encodeURIComponent(shareUrl), '_blank');
                    }

                    // Memory actions
                    function confirmDelete() {
                        if (confirm("Are you sure you want to delete this memory? This action cannot be undone.")) {
                            window.location.href = '/deletememory?id=' + memoryId;
                        }
                    }

                    function leaveMemory() {
                        if (!confirm('Are you sure you want to leave this memory? You will lose access to it.')) return;
                        fetch('/leavecollab', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'memoryId=' + memoryId
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.success) {
                                    window.location.href = '/collabmemories';
                                } else {
                                    alert('Error: ' + data.error);
                                }
                            })
                            .catch(err => {
                                console.error('Error:', err);
                                alert('Failed to leave memory');
                            });
                    }

                    function removeMember(userId) {
                        if (!confirm('Are you sure you want to remove this member?')) return;
                        fetch('/removecollabmember', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'memoryId=' + memoryId + '&memberId=' + userId
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.success) {
                                    location.reload();
                                } else {
                                    alert('Error: ' + data.error);
                                }
                            })
                            .catch(err => {
                                console.error('Error:', err);
                                alert('Failed to remove member');
                            });
                    }

                    // Close modal on outside click
                    document.getElementById('shareModal').addEventListener('click', function (e) {
                        if (e.target === this) closeShareModal();
                    });
                </script>
            </body>

            </html>