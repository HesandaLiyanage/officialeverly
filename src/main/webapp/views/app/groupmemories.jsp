<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ page import="com.demo.web.model.Group" %>

                <jsp:include page="../public/header2.jsp" />
                <html>

                <body>
                    <link rel="stylesheet" type="text/css"
                        href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
                    <link rel="stylesheet" type="text/css"
                        href="${pageContext.request.contextPath}/resources/css/memories.css">

                    <style>
                        /* Group Memories Specific Overrides */
                        .group-memories-header {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            margin-bottom: 8px;
                        }

                        .group-memories-count {
                            font-size: 14px;
                            color: #6b7280;
                            font-weight: 500;
                        }

                        .memory-card {
                            transition: transform 0.2s ease, box-shadow 0.2s ease;
                        }

                        .memory-card:hover {
                            transform: translateY(-4px);
                            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
                        }

                        .memory-card .memory-creator {
                            display: flex;
                            align-items: center;
                            gap: 6px;
                            margin-top: 6px;
                            font-size: 12px;
                            color: #9ca3af;
                        }

                        .memory-card .memory-creator .creator-dot {
                            width: 6px;
                            height: 6px;
                            border-radius: 50%;
                            background: #6366f1;
                        }

                        .viewer-notice {
                            background: linear-gradient(135deg, #fef3c7, #fde68a);
                            border: 1px solid #f59e0b;
                            border-radius: 12px;
                            padding: 14px 20px;
                            margin-bottom: 16px;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            color: #92400e;
                            font-size: 14px;
                        }

                        .viewer-notice svg {
                            flex-shrink: 0;
                        }
                    </style>

                    <% Group group=(Group) request.getAttribute("group"); String currentUserRole=(String)
                        request.getAttribute("currentUserRole"); Boolean isAdmin=(Boolean)
                        request.getAttribute("isAdmin"); int groupId=group !=null ? group.getGroupId() : 0; String
                        groupName=group !=null ? group.getName() : "Group" ; boolean canCreate=isAdmin !=null && isAdmin
                        || "editor" .equals(currentUserRole); %>

                        <div class="page-wrapper">
                            <main class="main-content">
                                <!-- Page Header -->
                                <div class="page-header">
                                    <h1 class="group-name">
                                        <%= groupName %>
                                    </h1>
                                    <p class="group-creator">
                                        <% if (group !=null && group.getDescription() !=null &&
                                            !group.getDescription().isEmpty()) { %>
                                            <%= group.getDescription() %>
                                                <% } else { %>
                                                    Group Memories
                                                    <% } %>
                                    </p>
                                </div>

                                <!-- Tab Navigation -->
                                <div class="tab-nav">
                                    <a href="${pageContext.request.contextPath}/groupmemories?groupId=<%= groupId %>"
                                        class="tab-link active">Memories</a>
                                    <a href="${pageContext.request.contextPath}/groupannouncement?groupId=<%= groupId %>"
                                        class="tab-link">Announcements</a>
                                    <a href="${pageContext.request.contextPath}/groupmembers?groupId=<%= groupId %>"
                                        class="tab-link">Members</a>
                                </div>

                                <!-- Viewer Notice -->
                                <% if ("viewer".equals(currentUserRole)) { %>
                                    <div class="viewer-notice">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <line x1="12" y1="8" x2="12" y2="12"></line>
                                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                        </svg>
                                        You have viewer access. You can view memories but cannot add or edit them.
                                        Contact the group admin to request editor access.
                                    </div>
                                    <% } %>

                                        <!-- Search and Filters -->
                                        <div class="search-filters" style="margin-top: 10px; margin-bottom: 15px;">
                                            <div class="memories-search-container">
                                                <button class="memories-search-btn" id="memoriesSearchBtn">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                        <circle cx="11" cy="11" r="8"></circle>
                                                        <path d="m21 21-4.35-4.35"></path>
                                                    </svg>
                                                </button>
                                            </div>
                                            <div class="group-memories-count">
                                                <c:if test="${not empty memories}">
                                                    ${memories.size()} ${memories.size() == 1 ? 'memory' : 'memories'}
                                                </c:if>
                                            </div>
                                        </div>

                                        <!-- Error Messages -->
                                        <c:if test="${not empty errorMessage}">
                                            <div
                                                style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 15px; margin: 15px 0; border-radius: 8px;">
                                                <strong>Error:</strong> ${errorMessage}
                                            </div>
                                        </c:if>

                                        <!-- Memories Grid -->
                                        <div class="memories-grid" id="memoriesGrid"
                                            style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">
                                            <c:choose>
                                                <c:when test="${empty memories}">
                                                    <div
                                                        style="grid-column: 1/-1; text-align: center; padding: 60px; color: #888;">
                                                        <div style="font-size: 64px; margin-bottom: 20px;">📸</div>
                                                        <h3 style="margin-bottom: 10px;">No group memories yet</h3>
                                                        <% if (canCreate) { %>
                                                            <p style="margin-bottom: 30px;">Be the first to add a memory
                                                                to this group!</p>
                                                            <a href="${pageContext.request.contextPath}/creatememory?groupId=<%= groupId %>"
                                                                class="floating-btn"
                                                                style="display: inline-block; padding: 12px 30px; text-decoration: none;">
                                                                Create First Memory
                                                            </a>
                                                            <% } else { %>
                                                                <p>This group doesn't have any memories yet. An admin or
                                                                    editor can create them.</p>
                                                                <% } %>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="memory" items="${memories}">
                                                        <c:set var="coverUrl"
                                                            value="${requestScope['cover_'.concat(memory.memoryId)]}" />
                                                        <c:set var="finalCover"
                                                            value="${not empty coverUrl ? coverUrl : pageContext.request.contextPath.concat('/resources/images/default-memory.jpg')}" />

                                                        <div class="memory-card" data-title="${memory.title}"
                                                            onclick="location.href='${pageContext.request.contextPath}/memoryview?id=${memory.memoryId}'"
                                                            style="cursor: pointer;">
                                                            <div class="memory-image"
                                                                style="background-image: url('${finalCover}');">
                                                            </div>
                                                            <div class="memory-content">
                                                                <h3 class="memory-title">${memory.title}</h3>
                                                                <p class="memory-date">
                                                                    <fmt:formatDate value="${memory.createdTimestamp}"
                                                                        pattern="MMMM d, yyyy" />
                                                                </p>
                                                                <c:if test="${not empty memory.description}">
                                                                    <p class="memory-description"
                                                                        style="margin: 8px 0 0 0; color: #888; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                                        ${memory.description}
                                                                    </p>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Empty state container for search -->
                                        <div id="emptyStateContainer" style="display: none; min-height: 600px;">
                                            <p
                                                style="text-align: center; color: #6c757d; margin: 40px 0; font-size: 16px;">
                                                No memories found</p>
                                        </div>
                            </main>

                            <aside class="sidebar">
                                <!-- Group Info -->
                                <div class="sidebar-section">
                                    <h3 class="sidebar-title">Group Info</h3>
                                    <ul class="favorites-list">
                                        <li class="favorite-item">
                                            <div class="favorite-icon"
                                                style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 14px;">
                                                📷</div>
                                            <span class="favorite-name">Memories:
                                                <c:out value="${memories.size()}" default="0" />
                                            </span>
                                        </li>
                                        <li class="favorite-item">
                                            <div class="favorite-icon"
                                                style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 14px;">
                                                👤</div>
                                            <span class="favorite-name">Your Role:
                                                <strong style="text-transform: capitalize;">
                                                    <%= currentUserRole !=null ? currentUserRole : "member" %>
                                                </strong>
                                            </span>
                                        </li>
                                    </ul>
                                </div>

                                <!-- Floating Action Buttons -->
                                <div class="floating-buttons" id="floatingButtons"
                                    style="position: static; margin-top: 20px;">
                                    <% if (canCreate) { %>
                                        <a href="${pageContext.request.contextPath}/creatememory?groupId=<%= groupId %>"
                                            class="floating-btn">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                            </svg>
                                            Add Memory
                                        </a>
                                        <% } %>
                                            <a href="${pageContext.request.contextPath}/groupmembers?groupId=<%= groupId %>"
                                                class="floating-btn" style="background: #6366f1;">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                    <circle cx="9" cy="7" r="4"></circle>
                                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                </svg>
                                                Members
                                            </a>
                                            <% if (isAdmin==null || !isAdmin) { %>
                                                <button onclick="leaveGroup(<%= groupId %>)" class="floating-btn"
                                                    style="background: #ef4444;">
                                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                        stroke-linejoin="round">
                                                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                                        <polyline points="16 17 21 12 16 7"></polyline>
                                                        <line x1="21" y1="12" x2="9" y2="12"></line>
                                                    </svg>
                                                    Leave Group
                                                </button>
                                                <% } %>
                                </div>
                            </aside>
                        </div>

                        <jsp:include page="../public/footer.jsp" />

                        <!-- Search functionality -->
                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                const memoriesSearchBtn = document.getElementById('memoriesSearchBtn');
                                const memoriesGrid = document.getElementById('memoriesGrid');
                                const emptyStateContainer = document.getElementById('emptyStateContainer');

                                if (memoriesSearchBtn) {
                                    memoriesSearchBtn.addEventListener('click', function (event) {
                                        event.stopPropagation();

                                        const searchBtnElement = this;
                                        const searchContainer = searchBtnElement.parentElement;

                                        const searchBox = document.createElement('div');
                                        searchBox.className = 'memories-search-expanded';
                                        searchBox.innerHTML = `
                    <div class="memories-search-icon">
                      <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                      </svg>
                    </div>
                    <input type="text" id="searchInput" placeholder="Search group memories..." autofocus>
                    <button class="memories-search-close">
                      <svg viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                      </svg>
                    </button>
                  `;

                                        searchContainer.replaceChild(searchBox, searchBtnElement);

                                        const input = searchBox.querySelector('input');
                                        input.focus();

                                        const closeSearch = () => {
                                            const newSearchBtn = document.createElement('button');
                                            newSearchBtn.className = 'memories-search-btn';
                                            newSearchBtn.id = 'memoriesSearchBtn';
                                            newSearchBtn.innerHTML = `
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                      </svg>
                    `;
                                            searchContainer.replaceChild(newSearchBtn, searchBox);
                                            const cards = document.querySelectorAll('.memory-card');
                                            cards.forEach(card => card.style.display = 'block');
                                            if (memoriesGrid) memoriesGrid.style.display = 'grid';
                                            if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                        };

                                        searchBox.querySelector('.memories-search-close').addEventListener('click', closeSearch);

                                        input.addEventListener('input', function (e) {
                                            const query = e.target.value.toLowerCase();
                                            const memoryCards = document.querySelectorAll('.memory-card');
                                            let visibleCount = 0;

                                            memoryCards.forEach(card => {
                                                const title = card.getAttribute('data-title')?.toLowerCase() || '';
                                                const matches = title.includes(query);

                                                if (matches) {
                                                    card.style.display = 'block';
                                                    visibleCount++;
                                                } else {
                                                    card.style.display = 'none';
                                                }
                                            });

                                            if (visibleCount === 0 && query !== '') {
                                                if (memoriesGrid) memoriesGrid.style.display = 'none';
                                                if (emptyStateContainer) emptyStateContainer.style.display = 'block';
                                            } else {
                                                if (memoriesGrid) memoriesGrid.style.display = 'grid';
                                                if (emptyStateContainer) emptyStateContainer.style.display = 'none';
                                            }
                                        });
                                    });
                                }
                            });
                        </script>
                        <script>
                            function leaveGroup(groupId) {
                                if (!confirm('Are you sure you want to leave this group? You will lose access to all group memories.')) return;

                                const form = document.createElement('form');
                                form.method = 'POST';
                                form.action = '${pageContext.request.contextPath}/groupmembersservlet';

                                const fields = { action: 'leaveGroup', groupId: groupId };
                                for (const [key, value] of Object.entries(fields)) {
                                    const input = document.createElement('input');
                                    input.type = 'hidden';
                                    input.name = key;
                                    input.value = value;
                                    form.appendChild(input);
                                }

                                document.body.appendChild(form);
                                form.submit();
                            }
                        </script>
                </body>

                </html>