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
                        <c:out value="${memory.title}" default="Memory" /> - Everly
                    </title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memoryviewer.css">
                </head>

                <body>
                    <div class="mv-page">
                        <!-- Close button - back to list -->
                        <c:choose>
                            <c:when test="${isGroupMemory}">
                                <a href="${pageContext.request.contextPath}/groupmemories?groupId=${group.groupId}"
                                    class="mv-close-btn">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/memories" class="mv-close-btn">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </a>
                            </c:otherwise>
                        </c:choose>

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
                                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                                <polyline points="21 15 16 10 5 21"></polyline>
                                            </svg>
                                        </div>
                                        <div class="mv-header-text">
                                            <h3>Memory</h3>
                                            <c:choose>
                                                <c:when test="${isGroupMemory}">
                                                    <div class="mv-type-badge">
                                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2.5">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                            <circle cx="9" cy="7" r="4"></circle>
                                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                        </svg>
                                                        Group Memory
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="mv-type-badge">
                                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2.5">
                                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2">
                                                            </rect>
                                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                                        </svg>
                                                        Personal Memory
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
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

                                    <!-- Group info (if group memory) -->
                                    <c:if test="${isGroupMemory and not empty group}">
                                        <div class="mv-divider"></div>
                                        <div class="mv-info-group">
                                            <div class="mv-info-label">Group</div>
                                            <div class="mv-info-value">
                                                <c:out value="${group.name}" />
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Actions bar -->
                                <div class="mv-actions-bar">
                                    <c:if test="${canEdit}">
                                        <a href="${pageContext.request.contextPath}/editmemory?id=${memory.memoryId}"
                                            class="mv-action-btn primary">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2.5">
                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                                </path>
                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                                </path>
                                            </svg>
                                            Edit
                                        </a>
                                    </c:if>
                                    <c:if test="${not isGroupMemory}">
                                        <button class="mv-action-btn secondary" onclick="shareMemory()">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2.5">
                                                <circle cx="18" cy="5" r="3"></circle>
                                                <circle cx="6" cy="12" r="3"></circle>
                                                <circle cx="18" cy="19" r="3"></circle>
                                                <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
                                                <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
                                            </svg>
                                            Share
                                        </button>
                                    </c:if>
                                    <c:if test="${canEdit}">
                                        <button class="mv-action-btn danger" onclick="confirmDelete()">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2.5">
                                                <path d="M3 6h18"></path>
                                                <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
                                                <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
                                            </svg>
                                            Delete
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
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
                            if (e.key === 'ArrowRight') moveCarousel(1);
                            if (e.key === 'ArrowLeft') moveCarousel(-1);
                            if (e.key === 'Escape') {
                                <c:choose>
                                    <c:when test="${isGroupMemory}">
                                        window.location.href = '${pageContext.request.contextPath}/groupmemories?groupId=${group.groupId}';
                                    </c:when>
                                    <c:otherwise>
                                        window.location.href = '${pageContext.request.contextPath}/memories';
                                    </c:otherwise>
                                </c:choose>
                            }
                        });

                        function confirmDelete() {
                            if (confirm("Are you sure you want to delete this memory? This action cannot be undone.")) {
                                window.location.href = '${pageContext.request.contextPath}/deletememory?id=${memory.memoryId}';
                            }
                        }

                        function shareMemory() {
                            alert('Share link copied!');
                        }
                    </script>
                </body>

                </html>