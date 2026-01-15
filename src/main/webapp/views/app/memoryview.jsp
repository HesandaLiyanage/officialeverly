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

                    /* Vault Button Specific Style */
                    .floating-btn-memory-viewer.vault-btn {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: #ffffff;
                    }

                    .floating-btn-memory-viewer.vault-btn:hover {
                        background: linear-gradient(135deg, #5a6fd6 0%, #6a4190 100%);
                        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.45);
                    }

                    /* Vault Password Modal */
                    .vault-modal-overlay {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.6);
                        z-index: 3000;
                        justify-content: center;
                        align-items: center;
                    }

                    .vault-modal-overlay.active {
                        display: flex;
                    }

                    .vault-modal {
                        background: white;
                        padding: 30px;
                        border-radius: 16px;
                        max-width: 400px;
                        width: 90%;
                        text-align: center;
                    }

                    .vault-modal h3 {
                        margin: 0 0 10px 0;
                        color: #333;
                    }

                    .vault-modal p {
                        color: #666;
                        margin-bottom: 20px;
                    }

                    .vault-modal input {
                        width: 100%;
                        padding: 12px;
                        border: 2px solid #e0e0e0;
                        border-radius: 8px;
                        font-size: 16px;
                        margin-bottom: 15px;
                        box-sizing: border-box;
                    }

                    .vault-modal input:focus {
                        border-color: #9A74D8;
                        outline: none;
                    }

                    .vault-modal-buttons {
                        display: flex;
                        gap: 10px;
                        justify-content: center;
                    }

                    .vault-modal-btn {
                        padding: 10px 24px;
                        border: none;
                        border-radius: 8px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                    }

                    .vault-modal-btn.confirm {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }

                    .vault-modal-btn.cancel {
                        background: #f0f0f0;
                        color: #666;
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
                            <a href="/memories" class="nav-btn prev-album">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                                Back to Memories
                            </a>
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

                        <!-- Collaborative Memory Section -->
                        <c:if test="${isCollaborative}">
                            <div class="collab-section"
                                style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 12px; padding: 20px; margin-bottom: 24px; color: white;">
                                <div
                                    style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="8.5" cy="7" r="4"></circle>
                                            <line x1="20" y1="8" x2="20" y2="14"></line>
                                            <line x1="23" y1="11" x2="17" y2="11"></line>
                                        </svg>
                                        <div>
                                            <span style="font-weight: 600;">Collaborative Memory</span>
                                            <c:if test="${not empty members}">
                                                <span
                                                    style="opacity: 0.8; font-size: 13px; margin-left: 8px;">${members.size()}
                                                    member<c:if test="${members.size() != 1}">s</c:if></span>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- Invite Link for Owner Only -->
                                    <c:if test="${isOwner}">
                                        <div style="display: flex; gap: 10px; align-items: center;">
                                            <button type="button" onclick="generateAndCopyLink()" id="copyLinkBtn"
                                                style="padding: 10px 20px; background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3); border-radius: 8px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71">
                                                    </path>
                                                    <path
                                                        d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71">
                                                    </path>
                                                </svg>
                                                <span id="copyLinkBtnText">Copy Invite Link</span>
                                            </button>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Member List (collapsed by default, expand on click) -->
                                <c:if test="${not empty members}">
                                    <div
                                        style="margin-top: 16px; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.2);">
                                        <div style="font-size: 13px; opacity: 0.9;">
                                            <c:forEach var="member" items="${members}" varStatus="status">
                                                <span
                                                    style="display: inline-flex; align-items: center; background: rgba(255,255,255,0.15); padding: 4px 12px; border-radius: 20px; margin: 4px;">
                                                    ${member.username}
                                                    <c:if test="${member.role eq 'owner'}">
                                                        <span style="margin-left: 4px; font-size: 11px;">(owner)</span>
                                                    </c:if>
                                                </span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>

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

                <!-- Floating Action Buttons -->
                <div class="floating-buttons-memory-viewer">
                    <button class="floating-btn-memory-viewer vault-btn" onclick="openVaultModal()">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        Move to Vault
                    </button>
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

                <!-- Vault Password Modal -->
                <div class="vault-modal-overlay" id="vaultModal">
                    <div class="vault-modal">
                        <h3>🔒 Move to Vault</h3>
                        <p>Enter your vault password to move this memory to the vault.</p>
                        <input type="password" id="vaultPasswordInput" placeholder="Vault password">
                        <div class="vault-modal-buttons">
                            <button class="vault-modal-btn cancel" onclick="closeVaultModal()">Cancel</button>
                            <button class="vault-modal-btn confirm" onclick="moveToVault()">Move to Vault</button>
                        </div>
                    </div>
                </div>

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

                    // Vault modal functions
                    function openVaultModal() {
                        document.getElementById('vaultModal').classList.add('active');
                        document.getElementById('vaultPasswordInput').focus();
                    }

                    function closeVaultModal() {
                        document.getElementById('vaultModal').classList.remove('active');
                        document.getElementById('vaultPasswordInput').value = '';
                    }

                    function moveToVault() {
                        const password = document.getElementById('vaultPasswordInput').value;
                        if (!password) {
                            alert('Please enter your vault password');
                            return;
                        }

                        const formData = new FormData();
                        formData.append('type', 'memory');
                        formData.append('id', '${memory.memoryId}');
                        formData.append('action', 'add');
                        formData.append('vaultPassword', password);

                        fetch('${pageContext.request.contextPath}/moveToVault', {
                            method: 'POST',
                            body: formData
                        })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    alert('Memory moved to vault successfully!');
                                    window.location.href = '${pageContext.request.contextPath}/memories';
                                } else if (data.redirectToSetup) {
                                    alert('You need to set up your vault first. You will be redirected to create a vault password.');
                                    window.location.href = '${pageContext.request.contextPath}/vaultSetup';
                                } else {
                                    alert('Error: ' + (data.error || 'Failed to move to vault'));
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('Error moving to vault. Please try again.');
                            });

                        closeVaultModal();
                    }

                    // Close vault modal on background click
                    document.getElementById('vaultModal').addEventListener('click', function (e) {
                        if (e.target === this) {
                            closeVaultModal();
                        }
                    });

                    // Generate and copy invite link for collaborative memories
                    function generateAndCopyLink() {
                        const btn = document.getElementById('copyLinkBtn');
                        const btnText = document.getElementById('copyLinkBtnText');

                        btn.disabled = true;
                        btnText.textContent = 'Generating...';

                        fetch('${pageContext.request.contextPath}/memory/generate-invite', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: 'memoryId=${memory.memoryId}'
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.success) {
                                    // Copy to clipboard
                                    navigator.clipboard.writeText(data.inviteUrl).then(() => {
                                        btnText.textContent = 'Link Copied!';
                                        setTimeout(() => {
                                            btnText.textContent = 'Copy Invite Link';
                                            btn.disabled = false;
                                        }, 2000);
                                    }).catch(() => {
                                        // Fallback for older browsers
                                        const tempInput = document.createElement('input');
                                        tempInput.value = data.inviteUrl;
                                        document.body.appendChild(tempInput);
                                        tempInput.select();
                                        document.execCommand('copy');
                                        document.body.removeChild(tempInput);

                                        btnText.textContent = 'Link Copied!';
                                        setTimeout(() => {
                                            btnText.textContent = 'Copy Invite Link';
                                            btn.disabled = false;
                                        }, 2000);
                                    });
                                } else {
                                    alert('Failed to generate invite link: ' + (data.error || 'Unknown error'));
                                    btnText.textContent = 'Copy Invite Link';
                                    btn.disabled = false;
                                }
                            })
                            .catch(err => {
                                console.error('Error generating invite link:', err);
                                alert('Error generating invite link');
                                btnText.textContent = 'Copy Invite Link';
                                btn.disabled = false;
                            });
                    }
                </script>
            </body>

            </html>