<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Collab Memory -
                    <c:out value="${memory.title}" default="Untitled" />
                </title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memoryview.css">
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <style>
                    .collab-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        background: linear-gradient(135deg, #9A74D8, #7C5AB8);
                        color: white;
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 13px;
                        font-weight: 600;
                    }

                    .members-section {
                        background: var(--card-bg, #fff);
                        border-radius: 16px;
                        padding: 20px;
                        margin-top: 20px;
                    }

                    .members-title {
                        font-size: 18px;
                        font-weight: 600;
                        margin-bottom: 15px;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .member-item {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: 12px 0;
                        border-bottom: 1px solid rgba(0, 0, 0, 0.08);
                    }

                    .member-item:last-child {
                        border-bottom: none;
                    }

                    .member-info {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .member-avatar {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #667eea, #764ba2);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-weight: 600;
                        font-size: 16px;
                    }

                    .member-name {
                        font-weight: 500;
                    }

                    .member-role {
                        font-size: 12px;
                        color: #888;
                        text-transform: capitalize;
                    }

                    .owner-badge {
                        background: #ffd700;
                        color: #333;
                        padding: 2px 8px;
                        border-radius: 12px;
                        font-size: 11px;
                        font-weight: 600;
                    }

                    .remove-btn {
                        background: #ff4757;
                        color: white;
                        border: none;
                        padding: 6px 12px;
                        border-radius: 8px;
                        font-size: 12px;
                        cursor: pointer;
                        transition: background 0.2s;
                    }

                    .remove-btn:hover {
                        background: #e84141;
                    }

                    .leave-btn {
                        background: #ff6b6b;
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 12px;
                        font-size: 14px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .leave-btn:hover {
                        background: #ee5a5a;
                    }

                    .share-btn-collab {
                        background: linear-gradient(135deg, #9A74D8, #7C5AB8);
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 12px;
                        font-size: 14px;
                        font-weight: 500;
                        cursor: pointer;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        transition: all 0.2s;
                    }

                    .share-btn-collab:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(154, 116, 216, 0.4);
                    }

                    .action-buttons {
                        display: flex;
                        gap: 12px;
                        margin-top: 20px;
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
                        z-index: 1000;
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
                    }

                    .share-modal-title {
                        font-size: 20px;
                        font-weight: 600;
                        margin-bottom: 20px;
                        text-align: center;
                    }

                    .share-link-box {
                        display: flex;
                        gap: 10px;
                        margin-bottom: 20px;
                    }

                    .share-link-input {
                        flex: 1;
                        padding: 12px 15px;
                        border: 2px solid #e0e0e0;
                        border-radius: 12px;
                        font-size: 14px;
                    }

                    .copy-btn {
                        background: #6366f1;
                        color: white;
                        border: none;
                        padding: 12px 20px;
                        border-radius: 12px;
                        cursor: pointer;
                        font-weight: 500;
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

                    .social-btn.instagram {
                        background: linear-gradient(45deg, #f09433, #e6683c, #dc2743, #cc2366, #bc1888);
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
                        right: 15px;
                        background: none;
                        border: none;
                        font-size: 24px;
                        cursor: pointer;
                        color: #888;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="../public/header2.jsp" />

                <div class="page-wrapper">
                    <main class="memory-view-container">
                        <!-- Header Section -->
                        <div class="memory-header">
                            <div class="header-content">
                                <div class="title-section">
                                    <h1 class="memory-title">
                                        <c:out value="${memory.title}" default="Untitled Memory" />
                                    </h1>
                                    <div style="display: flex; align-items: center; gap: 12px; margin-top: 10px;">
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
                                        <span class="memory-date">
                                            <fmt:formatDate value="${memory.createdTimestamp}" pattern="MMMM d, yyyy" />
                                        </span>
                                    </div>
                                </div>
                                <div class="header-actions">
                                    <c:if test="${isOwner}">
                                        <button class="share-btn-collab" onclick="openShareModal()">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="18" cy="5" r="3"></circle>
                                                <circle cx="6" cy="12" r="3"></circle>
                                                <circle cx="18" cy="19" r="3"></circle>
                                                <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
                                                <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
                                            </svg>
                                            Share
                                        </button>
                                    </c:if>
                                    <a href="/editmemory?id=${memory.memoryId}" class="edit-btn">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                        </svg>
                                        Edit
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Description -->
                        <c:if test="${not empty memory.description}">
                            <div class="memory-description">
                                <p>
                                    <c:out value="${memory.description}" />
                                </p>
                            </div>
                        </c:if>

                        <!-- Media Gallery -->
                        <div class="media-gallery">
                            <c:choose>
                                <c:when test="${empty mediaItems}">
                                    <div class="empty-media">
                                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="1.5">
                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                            <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                            <polyline points="21 15 16 10 5 21"></polyline>
                                        </svg>
                                        <p>No photos or videos yet</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="gallery-grid">
                                        <c:forEach var="media" items="${mediaItems}">
                                            <div class="gallery-item">
                                                <c:choose>
                                                    <c:when
                                                        test="${media.mediaType eq 'IMAGE' or media.mimeType.startsWith('image/')}">
                                                        <img src="${pageContext.request.contextPath}/viewMedia?id=${media.mediaId}"
                                                            alt="${media.title}" onclick="openLightbox(this.src)"
                                                            onerror="this.src='${pageContext.request.contextPath}/resources/images/default-memory.jpg'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <video controls>
                                                            <source
                                                                src="${pageContext.request.contextPath}/viewMedia?id=${media.mediaId}"
                                                                type="${media.mimeType}">
                                                        </video>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Members Section -->
                        <div class="members-section">
                            <h2 class="members-title">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                                Memory Members
                            </h2>
                            <c:forEach var="member" items="${members}">
                                <div class="member-item">
                                    <div class="member-info">
                                        <div class="member-avatar">
                                            ${member.username.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div>
                                            <div class="member-name">
                                                ${member.username}
                                                <c:if test="${member.role eq 'owner'}">
                                                    <span class="owner-badge">Owner</span>
                                                </c:if>
                                            </div>
                                            <div class="member-role">
                                                Joined
                                                <fmt:formatDate value="${member.joinedAt}" pattern="MMM d, yyyy" />
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${isOwner and member.role ne 'owner'}">
                                        <button class="remove-btn"
                                            onclick="removeMember(${member.userId})">Remove</button>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <c:choose>
                                <c:when test="${isOwner}">
                                    <a href="/deletememory?id=${memory.memoryId}" class="leave-btn"
                                        onclick="return confirm('Are you sure you want to delete this memory? This cannot be undone.');">
                                        Delete Memory
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="leave-btn" onclick="leaveMemory()">Leave Memory</button>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <a href="/collabmemories" class="back-link">← Back to Collab Memories</a>
                    </main>
                </div>

                <!-- Share Modal -->
                <div class="share-modal" id="shareModal">
                    <div class="share-modal-content" style="position: relative;">
                        <button class="close-modal-btn" onclick="closeShareModal()">&times;</button>
                        <h2 class="share-modal-title">Share this Memory</h2>
                        <p style="text-align: center; color: #666; margin-bottom: 20px;">
                            Anyone with this link can join and edit this memory
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

                    function openShareModal() {
                        document.getElementById('shareModal').classList.add('active');
                        // Generate share link
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
                        window.open('https://twitter.com/intent/tweet?text=' + encodeURIComponent('Check out this memory I\'m creating on Everly!') + '&url=' + encodeURIComponent(shareUrl), '_blank');
                    }

                    function leaveMemory() {
                        if (!confirm('Are you sure you want to leave this memory? You will lose access to it.')) {
                            return;
                        }
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
                        if (!confirm('Are you sure you want to remove this member?')) {
                            return;
                        }
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
                        if (e.target === this) {
                            closeShareModal();
                        }
                    });
                </script>
            </body>

            </html>