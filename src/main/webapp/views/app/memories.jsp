<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../public/header2.jsp" />

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/memories.css">

<div class="page-wrapper">
    <main class="main-content">
        <div class="tab-nav">
            <button class="active">Memories</button>
            <button onclick="window.location.href='/collabmemories'">Collab Memories</button>
            <button onclick="window.location.href='/memoryrecap'">Memory Recap</button>
        </div>

        <div class="search-filters" style="margin: 15px 0;">
            <button class="floating-btn" style="padding: 10px 20px;">
                <a href="/creatememory" style="color: white; text-decoration: none;">
                    Add Memory
                </a>
            </button>
        </div>

        <!-- Show warning if encryption not available -->
        <c:if test="${not encryptionAvailable}">
            <div style="background: #fff3cd; border: 1px solid #ffc107; padding: 15px; margin: 15px 0; border-radius: 8px;">
                <strong>⚠️ Encryption Not Available</strong>
                <p>Your encryption keys are not loaded. Please logout and login again to view encrypted memories.</p>
            </div>
        </c:if>

        <!-- Show error message if any -->
        <c:if test="${not empty errorMessage}">
            <div style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 15px; margin: 15px 0; border-radius: 8px;">
                <strong>Error:</strong> ${errorMessage}
            </div>
        </c:if>

        <div class="memories-grid">
            <c:choose>
                <c:when test="${empty memories}">
                    <!-- No memories - show empty state -->
                    <div style="grid-column: 1/-1; text-align: center; padding: 60px; color: #888;">
                        <div style="font-size: 64px; margin-bottom: 20px;">📸</div>
                        <h3 style="margin-bottom: 10px;">No memories yet</h3>
                        <p style="margin-bottom: 30px;">Start creating your first memory!</p>
                        <a href="/creatememory" class="floating-btn" style="display: inline-block; padding: 12px 30px; text-decoration: none;">
                            Create Your First Memory
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Display memories -->
                    <c:forEach var="memory" items="${memories}">
                        <!-- Get cover URL (set by servlet) -->
                        <c:set var="coverUrl" value="${requestScope['cover_'.concat(memory.memoryId)]}" />

                        <!-- Use cover if available, otherwise use default -->
                        <c:set var="finalCover" value="${not empty coverUrl ? coverUrl : pageContext.request.contextPath.concat('/resources/images/default-memory.jpg')}" />

                        <div class="memory-card" onclick="location.href='/memoryview?id=${memory.memoryId}'" style="cursor: pointer;">
                            <!-- Cover image - will be decrypted by ViewMediaServlet -->
                            <div class="memory-image" style="position: relative; width: 100%; height: 200px; overflow: hidden; border-radius: 12px 12px 0 0;">
                                <img src="${finalCover}"
                                     alt="${memory.title}"
                                     style="width: 100%; height: 100%; object-fit: cover;"
                                     onerror="this.src='${pageContext.request.contextPath}/resources/images/default-memory.jpg'">

                                <!-- Encryption indicator -->
                                <c:if test="${encryptionAvailable}">
                                    <div style="position: absolute; top: 10px; right: 10px; background: rgba(0,0,0,0.6); color: white; padding: 5px 10px; border-radius: 20px; font-size: 12px;">
                                        🔒 Encrypted
                                    </div>
                                </c:if>
                            </div>

                            <!-- Memory details -->
                            <div class="memory-content" style="padding: 15px;">
                                <h3 class="memory-title" style="margin: 0 0 8px 0; font-size: 18px;">
                                        ${memory.title}
                                </h3>
                                <p class="memory-date" style="margin: 0; color: #666; font-size: 14px;">
                                    <fmt:formatDate value="${memory.createdTimestamp}" pattern="MMMM d, yyyy"/>
                                </p>

                                <!-- Optional: Show description if available -->
                                <c:if test="${not empty memory.description}">
                                    <p style="margin: 8px 0 0 0; color: #888; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                            ${memory.description}
                                    </p>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="../public/footer.jsp" />
</div>

<!-- Optional: Loading indicator for images -->
<style>
    .memory-image img {
        transition: opacity 0.3s ease;
    }

    .memory-image img[src*="viewMedia"] {
        background: #f0f0f0;
    }

    /* Optional: Add loading spinner */
    .memory-card {
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .memory-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 16px rgba(0,0,0,0.15);
    }
</style>

<!-- Optional: JavaScript for better UX -->
<script>
    // Add loading indicator for images
    document.addEventListener('DOMContentLoaded', function() {
        const images = document.querySelectorAll('.memory-image img[src*="viewMedia"]');

        images.forEach(img => {
            // Show loading state
            img.style.opacity = '0.5';

            img.addEventListener('load', function() {
                // Image loaded successfully
                img.style.opacity = '1';
                console.log('✓ Loaded:', img.src);
            });

            img.addEventListener('error', function() {
                // Image failed to load
                console.error('✗ Failed to load:', img.src);
                img.style.opacity = '1';
            });
        });
    });
</script>