<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <%@ page import="java.util.List, java.util.Map, com.demo.web.model.Memory.Memory" %>

                    <jsp:include page="/views/public/header2.jsp" />
                    <html>

                    <body>
                        <link rel="stylesheet" type="text/css"
                            href="${pageContext.request.contextPath}/resources/css/memories.css">
                        <link rel="stylesheet" type="text/css"
                            href="${pageContext.request.contextPath}/resources/css/memoryrecap.css">

                        <div class="page-wrapper">
                            <main class="main-content">
                                <!-- Tab Navigation -->
                                <div class="tab-nav">
                                    <button onclick="window.location.href='/memoriesview'">Memories</button>
                                    <button onclick="window.location.href='/collabmemoriesview'">Collab
                                        Memories</button>
                                    <button class="active" onclick="window.location.href='/memoryrecapview'">Memory
                                        Recap</button>
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
                                    <div class="recap-filter-pills">
                                        <button class="recap-pill active" data-filter="all">All</button>
                                        <button class="recap-pill" data-filter="time">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            By Time
                                        </button>
                                        <button class="recap-pill" data-filter="event">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                            </svg>
                                            By Event
                                        </button>
                                        <button class="recap-pill" data-filter="group">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="9" cy="7" r="4"></circle>
                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                            </svg>
                                            By Group
                                        </button>
                                    </div>
                                </div>

                                <!-- Recap Cards Grid - dynamic from backend -->
                                <div class="memories-grid" id="recapGrid"
                                    style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">

                                    <c:choose>
                                        <c:when test="${not empty allRecaps}">
                                            <c:forEach var="recap" items="${allRecaps}" varStatus="status">
                                                <div class="memory-card recap-card-item"
                                                    data-title="${fn:escapeXml(recap.label)}"
                                                    data-category="${recap.category}"
                                                    onclick="openRecapViewer('recap-${status.index}')"
                                                    style="cursor: pointer;">
                                                    <div class="memory-image recap-cover
                                                        <c:choose>
                                                            <c:when test='${recap.category == " time"}'>time-gradient
                                        </c:when>
                                        <c:when test='${recap.category == "event"}'>event-gradient</c:when>
                                        <c:when test='${recap.category == "group"}'>friends-gradient</c:when>
                                        <c:otherwise>time-gradient</c:otherwise>
                                    </c:choose>
                                    ">
                                    <div class="recap-cover-content">
                                        <div class="recap-cover-icon">
                                            <c:choose>
                                                <c:when test='${recap.category == "time"}'>
                                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10"></circle>
                                                        <polyline points="12 6 12 12 16 14">
                                                        </polyline>
                                                    </svg>
                                                </c:when>
                                                <c:when test='${recap.category == "event"}'>
                                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14">
                                                        </path>
                                                        <polyline points="22 4 12 14.01 9 11.01">
                                                        </polyline>
                                                    </svg>
                                                </c:when>
                                                <c:when test='${recap.category == "group"}'>
                                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2">
                                                        </path>
                                                        <circle cx="9" cy="7" r="4"></circle>
                                                    </svg>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div class="recap-cover-year">${recap.emoji}</div>
                                    </div>
                                    <div class="recap-badge
                                                            <c:choose>
                                                                <c:when test='${recap.category == " time"}'>time-badge
                                        </c:when>
                                        <c:when test='${recap.category == "event"}'>event-badge</c:when>
                                        <c:when test='${recap.category == "group"}'>people-badge</c:when>
                                        </c:choose>
                                        ">
                                        <c:choose>
                                            <c:when test='${recap.category == "time"}'>
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5">
                                                    <circle cx="12" cy="12" r="10"></circle>
                                                    <polyline points="12 6 12 12 16 14">
                                                    </polyline>
                                                </svg>
                                                <span>Time</span>
                                            </c:when>
                                            <c:when test='${recap.category == "event"}'>
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5">
                                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14">
                                                    </path>
                                                    <polyline points="22 4 12 14.01 9 11.01">
                                                    </polyline>
                                                </svg>
                                                <span>Event</span>
                                            </c:when>
                                            <c:when test='${recap.category == "group"}'>
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2">
                                                    </path>
                                                    <circle cx="9" cy="7" r="4"></circle>
                                                </svg>
                                                <span>Group</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="memory-content">
                                    <h3 class="memory-title">${fn:escapeXml(recap.label)}</h3>
                                    <p class="memory-date">${recap.memoryCount} memories</p>
                                    <p class="recap-subtitle">${fn:escapeXml(recap.subtitle)}</p>
                                </div>
                        </div>
                        </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 60px 20px; color: #6c757d;">
                                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#d1d5db"
                                    stroke-width="1.5" style="margin: 0 auto 16px;">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                                <h3 style="margin-bottom: 8px; color: #9ca3af;">No Recaps Yet</h3>
                                <p style="font-size: 14px;">Start creating memories and join groups to
                                    see your recaps here!</p>
                            </div>
                        </c:otherwise>
                        </c:choose>

                        </div>

                        <!-- Empty state container for search -->
                        <div id="emptyStateContainer" style="display: none; min-height: 600px;">
                            <p style="text-align: center; color: #6c757d; margin: 40px 0; font-size: 16px;">No
                                recaps found</p>
                        </div>
                        </main>

                        <aside class="sidebar">
                            <!-- Quick Stats Section -->
                            <div class="sidebar-section">
                                <h3 class="sidebar-title">Quick Stats</h3>
                                <ul class="favorites-list">
                                    <li class="favorite-item">
                                        <div class="favorite-icon"
                                            style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                            📸</div>
                                        <span class="favorite-name">Total Memories:
                                            ${totalMemories != null ? totalMemories : 0}</span>
                                    </li>
                                    <li class="favorite-item">
                                        <div class="favorite-icon"
                                            style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                                            🎉</div>
                                        <span class="favorite-name">Events:
                                            ${totalEvents != null ? totalEvents : 0}</span>
                                    </li>
                                    <li class="favorite-item">
                                        <div class="favorite-icon"
                                            style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                                            👥</div>
                                        <span class="favorite-name">Groups:
                                            ${totalGroups != null ? totalGroups : 0}</span>
                                    </li>
                                </ul>
                            </div>
                        </aside>
                        </div>

                        <jsp:include page="/views/public/footer.jsp" />

                        <!-- WhatsApp Status-Style Story Viewer Modal -->
                        <div class="recap-modal-overlay" id="recapModal">
                            <div class="story-viewer" id="storyViewer">
                                <!-- Progress Bars -->
                                <div class="story-progress-bars" id="progressBars"></div>

                                <!-- Header -->
                                <div class="story-header">
                                    <div class="story-info">
                                        <div class="story-avatar" id="storyAvatar">📸</div>
                                        <div class="story-details">
                                            <div class="story-name" id="storyName">My Memories</div>
                                            <div class="story-time" id="storyTime">Just now</div>
                                        </div>
                                    </div>
                                    <button class="story-close-btn" onclick="closeRecapViewer()">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <line x1="18" y1="6" x2="6" y2="18"></line>
                                            <line x1="6" y1="6" x2="18" y2="18"></line>
                                        </svg>
                                    </button>
                                </div>

                                <!-- Story Content -->
                                <div class="story-content" id="storyContent"></div>

                                <!-- Navigation Areas -->
                                <div class="story-nav story-nav-prev" onclick="previousStory()"></div>
                                <div class="story-nav story-nav-next" onclick="nextStory()"></div>

                                <!-- Reaction Button -->
                                <button class="story-reaction-btn" onclick="addReaction()">❤️</button>
                            </div>
                        </div>

                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                // ── Search functionality ──
                                const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');
                                const recapGrid = document.getElementById('recapGrid');
                                const emptyStateContainer = document.getElementById('emptyStateContainer');

                                if (memoriesSearchBtn) {
                                    memoriesSearchBtn.addEventListener('click', function (event) {
                                        event.stopPropagation();

                                        const searchBtnElement = this;
                                        const searchContainer = searchBtnElement.parentElement;

                                        const searchBox = document.createElement('div');
                                        searchBox.className = 'memories-search-expanded';
                                        searchBox.innerHTML = '<div class="memories-search-icon">' +
                                            '<svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">' +
                                            '<circle cx="11" cy="11" r="8"></circle>' +
                                            '<path d="m21 21-4.35-4.35"></path>' +
                                            '</svg></div>' +
                                            '<input type="text" id="searchInput" placeholder="Search recaps..." autofocus>' +
                                            '<button class="memories-search-close">' +
                                            '<svg viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">' +
                                            '<line x1="18" y1="6" x2="6" y2="18"></line>' +
                                            '<line x1="6" y1="6" x2="18" y2="18"></line>' +
                                            '</svg></button>';

                                        searchContainer.replaceChild(searchBox, searchBtnElement);

                                        const input = searchBox.querySelector('input');
                                        input.focus();

                                        const closeSearch = () => {
                                            const newSearchBtn = document.createElement('button');
                                            newSearchBtn.className = 'memories-search-btn';
                                            newSearchBtn.id = 'memoriesSearchBtn';
                                            newSearchBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                                                '<circle cx="11" cy="11" r="8"></circle>' +
                                                '<path d="m21 21-4.35-4.35"></path></svg>';
                                            searchContainer.replaceChild(newSearchBtn, searchBox);
                                            const cards = document.querySelectorAll('.recap-card-item');
                                            cards.forEach(card => card.style.display = 'block');
                                            if (recapGrid) recapGrid.style.display = 'grid';
                                            if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                            document.querySelectorAll('.recap-pill').forEach(p => p.classList.remove('active'));
                                            document.querySelector('.recap-pill[data-filter="all"]').classList.add('active');
                                        };

                                        searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

                                        input.addEventListener('input', function (e) {
                                            const query = e.target.value.toLowerCase();
                                            const recapCards = document.querySelectorAll('.recap-card-item');
                                            let visibleCount = 0;

                                            recapCards.forEach(card => {
                                                const title = card.getAttribute('data-title') ? card.getAttribute('data-title').toLowerCase() : '';
                                                if (title.includes(query)) {
                                                    card.style.display = 'block';
                                                    visibleCount++;
                                                } else {
                                                    card.style.display = 'none';
                                                }
                                            });

                                            if (visibleCount === 0 && query !== '') {
                                                if (recapGrid) recapGrid.style.display = 'none';
                                                if (emptyStateContainer) emptyStateContainer.style.display = 'block';
                                            } else {
                                                if (recapGrid) recapGrid.style.display = 'grid';
                                                if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                            }
                                        });
                                    });
                                }

                                // ── Filter Pills ──
                                const filterPills = document.querySelectorAll('.recap-pill');
                                filterPills.forEach(pill => {
                                    pill.addEventListener('click', function () {
                                        filterPills.forEach(p => p.classList.remove('active'));
                                        this.classList.add('active');

                                        const filter = this.getAttribute('data-filter');
                                        const recapCards = document.querySelectorAll('.recap-card-item');
                                        let visibleCount = 0;

                                        recapCards.forEach(card => {
                                            if (filter === 'all' || card.getAttribute('data-category') === filter) {
                                                card.style.display = 'block';
                                                visibleCount++;
                                            } else {
                                                card.style.display = 'none';
                                            }
                                        });

                                        if (visibleCount === 0) {
                                            if (recapGrid) recapGrid.style.display = 'none';
                                            if (emptyStateContainer) emptyStateContainer.style.display = 'block';
                                        } else {
                                            if (recapGrid) recapGrid.style.display = 'grid';
                                            if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                        }
                                    });
                                });

                                // ── Card entrance animations ──
                                const cards = document.querySelectorAll('.recap-card-item');
                                cards.forEach((card, index) => {
                                    card.style.opacity = '0';
                                    card.style.transform = 'translateY(20px)';
                                    setTimeout(() => {
                                        card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                                        card.style.opacity = '1';
                                        card.style.transform = 'translateY(0)';
                                    }, index * 80);
                                });
                            });

                            // ── Build recap data from server-side model ──
                            var recapData = {};
                            <%
                                @SuppressWarnings("unchecked")
                            List < Map < String, Object >> allRecaps = (List < Map < String, Object >>) request.getAttribute("allRecaps");
                            if (allRecaps != null) {
                                for (int i = 0; i < allRecaps.size(); i++) {
                                    Map < String, Object > recap = allRecaps.get(i);
                                        String label = (String) recap.get("label");
                                        String emoji = (String) recap.get("emoji");
                                    @SuppressWarnings("unchecked")
                                    List < Memory > memories = (List < Memory >) recap.get("memories");

                                        // Escape for JS
                                        String escapedLabel = label != null ? label.replace("'", "\\'").replace("\"", "\\\"") : "";
                                        String escapedEmoji = emoji != null ? emoji : "📸";
                            %>
                                        recapData['recap-<%= i %>'] = {
                                        name: "<%= escapedLabel %>",
                                            avatar: "<%= escapedEmoji %>",
                                                memories: [
                                    <% if (memories != null) {
                                            for (int j = 0; j < memories.size(); j++) {
                                            Memory memory = memories.get(j);
                                            String memTitle = memory.getTitle() != null ? memory.getTitle().replace("'", "\\'").replace("\"", "\\\"") : "Memory";
                                            String memDesc = memory.getDescription() != null ? memory.getDescription().replace("'", "\\'").replace("\"", "\\\"") : "";
                                            String coverUrl = memory.getCoverUrl();
                                            int memoryId = memory.getMemoryId();
                                    %>
                                                    {
                                                        image: "<%= coverUrl != null ? coverUrl : "" %>",
                                                        title: "<%= memTitle %>",
                                                        caption: "<%= memDesc %>",
                                                        memoryId: <%= memoryId %>
                                    }<%= (j < memories.size() - 1) ? "," : "" %>
                                    <% }
                                    } %>
                                ]
                                };
                            <% }
                            } %>

                                // ── WhatsApp Status-Style Story Viewer ──
                                let currentRecap = null;
                            let currentIndex = 0;
                            let progressTimer = null;

                            function openRecapViewer(recapId) {
                                currentRecap = recapData[recapId];
                                if (!currentRecap || currentRecap.memories.length === 0) return;
                                currentIndex = 0;

                                const modal = document.getElementById('recapModal');
                                document.getElementById('storyName').textContent = currentRecap.name;
                                document.getElementById('storyAvatar').textContent = currentRecap.avatar;

                                modal.classList.add('active');
                                document.body.style.overflow = 'hidden';
                                loadStory();
                            }

                            function closeRecapViewer() {
                                document.getElementById('recapModal').classList.remove('active');
                                document.body.style.overflow = 'auto';
                                if (progressTimer) clearTimeout(progressTimer);
                            }

                            function loadStory() {
                                if (!currentRecap) return;

                                const memories = currentRecap.memories;

                                // Create progress bars
                                document.getElementById('progressBars').innerHTML = memories.map(function (_, i) {
                                    return '<div class="progress-bar ' + (i < currentIndex ? 'completed' : '') + ' ' + (i === currentIndex ? 'active' : '') + '">' +
                                        '<div class="progress-fill"></div>' +
                                        '</div>';
                                }).join('');

                                // Create story slides
                                var memory = memories[currentIndex];
                                var hasImage = memory.image && memory.image.length > 0;

                                if (hasImage) {
                                    document.getElementById('storyContent').innerHTML =
                                        '<div class="story-slide active">' +
                                        '<img src="' + memory.image + '" alt="' + memory.title + '" class="story-image">' +
                                        '<div class="story-caption">' +
                                        '<div class="caption-title">' + memory.title + '</div>' +
                                        '<div class="caption-text">' + memory.caption + '</div>' +
                                        '</div></div>';
                                } else {
                                    // No image - show a gradient card with title
                                    document.getElementById('storyContent').innerHTML =
                                        '<div class="story-slide active" style="display:flex;align-items:center;justify-content:center;background:linear-gradient(135deg, #667eea 0%, #764ba2 100%);">' +
                                        '<div style="text-align:center;color:white;padding:40px;">' +
                                        '<div style="font-size:48px;margin-bottom:16px;">' + currentRecap.avatar + '</div>' +
                                        '<div style="font-size:24px;font-weight:700;margin-bottom:8px;">' + memory.title + '</div>' +
                                        '<div style="font-size:16px;opacity:0.8;">' + memory.caption + '</div>' +
                                        '</div></div>';
                                }

                                // Update time display
                                document.getElementById('storyTime').textContent = (currentIndex + 1) + ' of ' + memories.length;

                                startProgress();
                            }

                            function startProgress() {
                                if (progressTimer) clearTimeout(progressTimer);
                                progressTimer = setTimeout(() => nextStory(), 5000);
                            }

                            function nextStory() {
                                if (!currentRecap) return;
                                if (currentIndex < currentRecap.memories.length - 1) {
                                    currentIndex++;
                                    loadStory();
                                } else {
                                    closeRecapViewer();
                                }
                            }

                            function previousStory() {
                                if (!currentRecap) return;
                                if (currentIndex > 0) {
                                    currentIndex--;
                                    loadStory();
                                }
                            }

                            function addReaction() {
                                const btn = document.querySelector('.story-reaction-btn');
                                btn.style.transform = 'scale(1.3)';
                                setTimeout(() => btn.style.transform = 'scale(1)', 300);
                            }

                            // Keyboard navigation
                            document.addEventListener('keydown', (e) => {
                                const modal = document.getElementById('recapModal');
                                if (!modal.classList.contains('active')) return;

                                if (e.key === 'ArrowRight') nextStory();
                                else if (e.key === 'ArrowLeft') previousStory();
                                else if (e.key === 'Escape') closeRecapViewer();
                            });

                            // Close when clicking outside
                            document.getElementById('recapModal')?.addEventListener('click', (e) => {
                                if (e.target.id === 'recapModal') closeRecapViewer();
                            });
                        </script>
                    </body>

                    </html>