<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!-- Collab Memories Page Content -->
            <jsp:include page="../public/header2.jsp" />
            <html>

            <body>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/memories.css">

                <!-- Wrap everything after header -->
                <div class="page-wrapper">
                    <main class="main-content">
                        <!-- Tab Navigation -->
                        <div class="tab-nav">
                            <button data-tab="memories" onclick="window.location.href='/memories'">Memories</button>
                            <button class="active" data-tab="collab">Collab Memories</button>
                            <button data-tab="recap" onclick="window.location.href='/memoryrecap'">Memory Recap</button>
                        </div>

                        <!-- Search and Filters -->
                        <div class="search-filters" style="margin-top: 10px; margin-bottom: 15px;">
                            <div class="memories-search-container">
                                <button class="memories-search-btn" id="memoriesSearchBtn">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <path d="m21 21-4.35-4.35"></path>
                                    </svg>
                                </button>
                            </div>
                            <button class="filter-btn" id="dateFilter">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <polyline points="19 12 12 19 5 12"></polyline>
                                </svg>
                                Date
                            </button>
                        </div>

                        <!-- Error Message -->
                        <c:if test="${not empty errorMessage}">
                            <div
                                style="background: #ffe0e0; border: 1px solid #ff6b6b; padding: 15px; margin: 15px 0; border-radius: 8px; color: #c92a2a;">
                                <strong>Error:</strong> ${errorMessage}
                            </div>
                        </c:if>

                        <!-- Collab Memories Grid -->
                        <div class="memories-grid" id="collabMemoriesGrid"
                            style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
                            <c:choose>
                                <c:when test="${empty memories}">
                                    <div style="text-align: center; padding: 60px 20px; color: #888;">
                                        <svg width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="#ccc"
                                            stroke-width="1.5" style="margin-bottom: 20px;">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                        </svg>
                                        <h3 style="margin-bottom: 10px; font-weight: 600; color: #666;">No Collab
                                            Memories Yet</h3>
                                        <p style="margin-bottom: 20px;">Create a collaborative memory to share with
                                            friends and family</p>
                                        <a href="/creatememory?type=collab" class="floating-btn"
                                            style="display: inline-flex; text-decoration: none;">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5">
                                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                            </svg>
                                            Create Collab Memory
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="memory" items="${memories}">
                                        <c:set var="coverUrl"
                                            value="${requestScope['cover_'.concat(memory.memoryId)]}" />
                                        <c:set var="memberCount"
                                            value="${requestScope['memberCount_'.concat(memory.memoryId)]}" />
                                        <c:set var="isOwner"
                                            value="${requestScope['isOwner_'.concat(memory.memoryId)]}" />

                                        <c:set var="finalCover"
                                            value="${not empty coverUrl ? coverUrl : pageContext.request.contextPath.concat('/resources/images/default-memory.jpg')}" />

                                        <div class="memory-card" data-title="${memory.title}"
                                            onclick="location.href='/collabmemoryview?id=${memory.memoryId}'"
                                            style="cursor: pointer;">
                                            <div class="memory-image" style="background-image: url('${finalCover}');">
                                                <!-- Collab badge -->
                                                <div class="collab-badge">
                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2.5">
                                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                        <circle cx="9" cy="7" r="4"></circle>
                                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                    </svg>
                                                    <span>${memberCount != null ? memberCount : '1'}</span>
                                                </div>

                                                <!-- Share button (only for owners) -->
                                                <c:if test="${isOwner}">
                                                    <button class="share-memory-btn"
                                                        onclick="event.stopPropagation(); openShareModal(${memory.memoryId})"
                                                        title="Share memory">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <circle cx="18" cy="5" r="3"></circle>
                                                            <circle cx="6" cy="12" r="3"></circle>
                                                            <circle cx="18" cy="19" r="3"></circle>
                                                            <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
                                                            <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
                                                        </svg>
                                                    </button>
                                                </c:if>
                                            </div>
                                            <div class="memory-content">
                                                <h3 class="memory-title">${memory.title}</h3>
                                                <p class="memory-date">
                                                    <fmt:formatDate value="${memory.createdTimestamp}"
                                                        pattern="MMMM d, yyyy" />
                                                </p>
                                                <c:if test="${isOwner}">
                                                    <p class="memory-collaborators"
                                                        style="color: #9A74D8; font-size: 12px;">You own this memory</p>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </main>

                    <aside class="sidebar">
                        <!-- Floating Action Buttons -->
                        <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
                            <a href="/creatememory?type=collab" class="floating-btn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                Create Collab
                            </a>
                            <a href="/vaultmemories" class="floating-btn vault-btn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                                Vault
                            </a>
                        </div>
                    </aside>
                </div>

                <!-- Share Modal -->
                <div class="share-modal" id="shareModal">
                    <div class="share-modal-content">
                        <button class="close-modal-btn" onclick="closeShareModal()">&times;</button>
                        <h2 class="share-modal-title">Share Memory</h2>
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

                <style>
                    /* Additional styles for collab memories */
                    .collab-badge {
                        position: absolute;
                        top: 12px;
                        right: 12px;
                        background: rgba(154, 116, 216, 0.95);
                        color: white;
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                        display: flex;
                        align-items: center;
                        gap: 6px;
                        box-shadow: 0 2px 8px rgba(154, 116, 216, 0.4);
                        z-index: 2;
                    }

                    .collab-badge svg {
                        width: 14px;
                        height: 14px;
                    }

                    .share-memory-btn {
                        position: absolute;
                        bottom: 12px;
                        right: 12px;
                        background: rgba(255, 255, 255, 0.95);
                        border: none;
                        width: 36px;
                        height: 36px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                        transition: all 0.2s;
                        z-index: 2;
                    }

                    .share-memory-btn:hover {
                        background: #9A74D8;
                    }

                    .share-memory-btn:hover svg {
                        stroke: white;
                    }

                    .memory-collaborators {
                        font-size: 13px;
                        color: #9A74D8;
                        margin-top: 4px;
                        font-weight: 500;
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
                        position: relative;
                    }

                    .share-modal-title {
                        font-size: 20px;
                        font-weight: 600;
                        margin-bottom: 10px;
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
                        right: 15px;
                        background: none;
                        border: none;
                        font-size: 24px;
                        cursor: pointer;
                        color: #888;
                    }
                </style>

                <script>
                    let currentMemoryId = null;
                    let shareUrl = '';

                    function openShareModal(memoryId) {
                        currentMemoryId = memoryId;
                        document.getElementById('shareModal').classList.add('active');
                        document.getElementById('shareLinkInput').value = 'Generating link...';

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
                                    document.getElementById('shareLinkInput').value = 'Error: ' + data.error;
                                }
                            })
                            .catch(err => {
                                console.error('Error:', err);
                                document.getElementById('shareLinkInput').value = 'Failed to generate link';
                            });
                    }

                    function closeShareModal() {
                        document.getElementById('shareModal').classList.remove('active');
                        currentMemoryId = null;
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

                    // Close modal on outside click
                    document.getElementById('shareModal').addEventListener('click', function (e) {
                        if (e.target === this) {
                            closeShareModal();
                        }
                    });
                </script>

            </body>

            </html>