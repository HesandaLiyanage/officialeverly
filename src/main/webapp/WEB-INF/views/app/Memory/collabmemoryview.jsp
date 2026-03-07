<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <c:out value="${memory.title}" default="Collab Memory" /> - Everly
                    </title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memoryviewer.css">
                </head>

                <body>
                    <div class="mv-page">
                        <!-- Close button -->
                        <a href="${pageContext.request.contextPath}/collabmemories" class="mv-close-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </a>

                        <div class="mv-wrapper">
                            <!-- LEFT: Media Section -->
                            <div class="mv-media-section">
                                <c:choose>
                                    <c:when test="${not empty mediaItems}">
                                        <div class="mv-carousel" data-current-slide="0">
                                            <div class="mv-carousel-track">
                                                <c:forEach var="media" items="${mediaItems}" varStatus="status">
                                                    <div class="mv-slide">
                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(media.mimeType, 'video/')}">
                                                                <video
                                                                    src="${pageContext.request.contextPath}/viewmedia?id=${media.mediaId}"
                                                                    controls></video>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/viewmedia?id=${media.mediaId}"
                                                                    alt="${media.title}">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <c:if test="${fn:length(mediaItems) > 1}">
                                                <button class="mv-carousel-btn prev" type="button"
                                                    onclick="moveCarousel(-1)">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <polyline points="15 18 9 12 15 6"></polyline>
                                                    </svg>
                                                </button>
                                                <button class="mv-carousel-btn next" type="button"
                                                    onclick="moveCarousel(1)">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <polyline points="9 18 15 12 9 6"></polyline>
                                                    </svg>
                                                </button>
                                                <div class="mv-carousel-dots">
                                                    <c:forEach var="media" items="${mediaItems}" varStatus="status">
                                                        <div
                                                            class="mv-carousel-dot${status.index == 0 ? ' active' : ''}">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mv-no-media">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="1.5">
                                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                                <polyline points="21 15 16 10 5 21"></polyline>
                                            </svg>
                                            <h3>No photos yet</h3>
                                            <p>Add photos by editing this memory</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- RIGHT: Details Section -->
                            <div class="mv-details-section">
                                <!-- Header -->
                                <div class="mv-header">
                                    <div class="mv-header-left">
                                        <div class="mv-avatar">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5">
                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="9" cy="7" r="4"></circle>
                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                            </svg>
                                        </div>
                                        <div class="mv-header-text">
                                            <h3>Collab Memory</h3>
                                            <div class="mv-type-badge">
                                                <svg width="10" height="10" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                    <circle cx="9" cy="7" r="4"></circle>
                                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                </svg>
                                                ${fn:length(members)} member${fn:length(members) != 1 ? 's' : ''}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Scrollable Content -->
                                <div class="mv-content">
                                    <!-- Title -->
                                    <div class="mv-info-group">
                                        <div class="mv-info-value title">
                                            <c:out value="${memory.title}" default="Untitled Memory" />
                                        </div>
                                    </div>

                                    <!-- Date -->
                                    <div class="mv-info-group">
                                        <div class="mv-info-value date">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                            </svg>
                                            <fmt:formatDate value="${memory.createdTimestamp}" pattern="MMMM d, yyyy" />
                                        </div>
                                    </div>

                                    <!-- Description -->
                                    <c:if test="${not empty memory.description}">
                                        <div class="mv-divider"></div>
                                        <div class="mv-info-group">
                                            <div class="mv-info-label">Description</div>
                                            <div class="mv-info-value">
                                                <c:out value="${memory.description}" />
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="mv-divider"></div>

                                    <!-- Photo count -->
                                    <div class="mv-info-group">
                                        <div class="mv-photo-count">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                                <polyline points="21 15 16 10 5 21"></polyline>
                                            </svg>
                                            <c:choose>
                                                <c:when test="${not empty mediaItems}">
                                                    ${fn:length(mediaItems)} photo${fn:length(mediaItems) != 1 ? 's' :
                                                    ''}
                                                </c:when>
                                                <c:otherwise>0 photos</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Collaborators -->
                                    <c:if test="${not empty members}">
                                        <div class="mv-divider"></div>
                                        <div class="mv-info-group mv-collabs">
                                            <div class="mv-info-label">Collaborators</div>
                                            <div class="mv-collab-list">
                                                <c:forEach var="member" items="${members}">
                                                    <div class="mv-collab-item">
                                                        <div class="mv-collab-avatar">
                                                            ${fn:toUpperCase(fn:substring(member.username, 0, 1))}
                                                        </div>
                                                        <div class="mv-collab-info">
                                                            <div class="mv-collab-name">
                                                                ${member.username}
                                                                <c:if test="${member.role eq 'owner'}">
                                                                    <span class="mv-owner-badge">Owner</span>
                                                                </c:if>
                                                            </div>
                                                            <div class="mv-collab-date">
                                                                Joined
                                                                <fmt:formatDate value="${member.joinedAt}"
                                                                    pattern="MMM d, yyyy" />
                                                            </div>
                                                        </div>
                                                        <c:if test="${isOwner and member.role ne 'owner'}">
                                                            <button class="mv-collab-remove"
                                                                onclick="removeMember(${member.userId})"
                                                                title="Remove member">
                                                                <svg width="14" height="14" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor"
                                                                    stroke-width="2.5">
                                                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                                                </svg>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Actions bar -->
                                <div class="mv-actions-bar">
                                    <c:if test="${isOwner}">
                                        <button class="mv-action-btn primary" onclick="openShareModal()">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2.5">
                                                <circle cx="18" cy="5" r="3"></circle>
                                                <circle cx="6" cy="12" r="3"></circle>
                                                <circle cx="18" cy="19" r="3"></circle>
                                                <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
                                                <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
                                            </svg>
                                            Invite
                                        </button>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/editmemory?id=${memory.memoryId}"
                                        class="mv-action-btn secondary">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                        </svg>
                                        Edit
                                    </a>
                                    <c:choose>
                                        <c:when test="${isOwner}">
                                            <button class="mv-action-btn danger" onclick="confirmDelete()">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2.5">
                                                    <path d="M3 6h18"></path>
                                                    <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
                                                    <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
                                                </svg>
                                                Delete
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="mv-action-btn danger" onclick="leaveMemory()">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2.5">
                                                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                                    <polyline points="16 17 21 12 16 7"></polyline>
                                                    <line x1="21" y1="12" x2="9" y2="12"></line>
                                                </svg>
                                                Leave
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Share Modal -->
                    <div class="mv-share-modal" id="shareModal">
                        <div class="mv-share-content">
                            <button class="mv-share-close" onclick="closeShareModal()">&times;</button>
                            <h2 class="mv-share-title">Invite Collaborators</h2>
                            <p class="mv-share-subtitle">Anyone with this link can join and add photos</p>
                            <div class="mv-share-link-box">
                                <input type="text" class="mv-share-link-input" id="shareLinkInput" readonly
                                    placeholder="Generating link...">
                                <button class="mv-share-copy-btn" onclick="copyLink()">Copy</button>
                            </div>
                            <div class="mv-share-socials">
                                <button class="mv-social-btn whatsapp" onclick="shareWhatsApp()">
                                    <svg viewBox="0 0 24 24">
                                        <path
                                            d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" />
                                    </svg>
                                </button>
                                <button class="mv-social-btn twitter" onclick="shareTwitter()">
                                    <svg viewBox="0 0 24 24">
                                        <path
                                            d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z" />
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </div>

                    <script>
                        var memoryId = ${ memory.memoryId };
                        var shareUrl = '';

                        // Carousel functionality
                        var currentSlide = 0;
                        var totalSlides = document.querySelectorAll('.mv-slide').length;

                        function moveCarousel(direction) {
                            var newSlide = currentSlide + direction;
                            if (newSlide < 0 || newSlide >= totalSlides) return;
                            currentSlide = newSlide;
                            var track = document.querySelector('.mv-carousel-track');
                            if (track) track.style.transform = 'translateX(-' + (currentSlide * 100) + '%)';
                            var dots = document.querySelectorAll('.mv-carousel-dot');
                            dots.forEach(function (dot, i) {
                                dot.classList.toggle('active', i === currentSlide);
                            });
                        }

                        // Keyboard navigation
                        document.addEventListener('keydown', function (e) {
                            if (document.getElementById('shareModal').classList.contains('active')) return;
                            if (e.key === 'ArrowRight') moveCarousel(1);
                            if (e.key === 'ArrowLeft') moveCarousel(-1);
                            if (e.key === 'Escape') window.location.href = '${pageContext.request.contextPath}/collabmemories';
                        });

                        // Share functionality
                        function openShareModal() {
                            document.getElementById('shareModal').classList.add('active');
                            fetch('${pageContext.request.contextPath}/generateCollabShareLink', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'memoryId=' + memoryId
                            })
                                .then(function (res) { return res.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        shareUrl = data.shareUrl;
                                        document.getElementById('shareLinkInput').value = shareUrl;
                                    } else {
                                        alert('Error generating share link: ' + data.error);
                                    }
                                })
                                .catch(function (err) {
                                    console.error('Error:', err);
                                    alert('Failed to generate share link');
                                });
                        }

                        function closeShareModal() {
                            document.getElementById('shareModal').classList.remove('active');
                        }

                        function copyLink() {
                            var input = document.getElementById('shareLinkInput');
                            input.select();
                            document.execCommand('copy');
                            var btn = document.querySelector('.mv-share-copy-btn');
                            btn.textContent = 'Copied!';
                            setTimeout(function () { btn.textContent = 'Copy'; }, 2000);
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
                                window.location.href = '${pageContext.request.contextPath}/deletememory?id=' + memoryId;
                            }
                        }

                        function leaveMemory() {
                            if (!confirm('Are you sure you want to leave this memory? You will lose access to it.')) return;
                            fetch('${pageContext.request.contextPath}/leavecollab', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'memoryId=' + memoryId
                            })
                                .then(function (res) { return res.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        window.location.href = '${pageContext.request.contextPath}/collabmemories';
                                    } else {
                                        alert('Error: ' + data.error);
                                    }
                                })
                                .catch(function (err) {
                                    console.error('Error:', err);
                                    alert('Failed to leave memory');
                                });
                        }

                        function removeMember(userId) {
                            if (!confirm('Are you sure you want to remove this member?')) return;
                            fetch('${pageContext.request.contextPath}/removecollabmember', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'memoryId=' + memoryId + '&memberId=' + userId
                            })
                                .then(function (res) { return res.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        location.reload();
                                    } else {
                                        alert('Error: ' + data.error);
                                    }
                                })
                                .catch(function (err) {
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