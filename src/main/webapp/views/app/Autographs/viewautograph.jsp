<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <% request.setCharacterEncoding("UTF-8"); response.setCharacterEncoding("UTF-8"); %>
        <%@ page import="com.demo.web.model.AutographEntry" %>
            <%@ page import="com.demo.web.model.autograph" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="com.google.gson.Gson" %>
                        <% autograph ag=(autograph) request.getAttribute("autograph"); List<AutographEntry> entries =
                            (List<AutographEntry>) request.getAttribute("entries");
                                Gson gson = new com.google.gson.GsonBuilder().disableHtmlEscaping().create();
                                String entriesJson = gson.toJson(entries != null ? entries :
                                java.util.Collections.emptyList());
                                int entryCount = (entries != null) ? entries.size() : 0;
                                String displayTitle = (ag != null) ? ag.getTitle() : "Autograph Book";
                                String displayDesc = (ag != null && ag.getDescription() != null) ? ag.getDescription() :
                                "";
                                String createdDate = (ag != null && ag.getCreatedAt() != null)
                                ? new java.text.SimpleDateFormat("MMMM d, yyyy").format(ag.getCreatedAt()) : "";
                                %>
                                <!DOCTYPE html>
                                <html lang="en">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>
                                        <%= displayTitle %> - Everly
                                    </title>
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                                        rel="stylesheet">
                                    <link rel="stylesheet"
                                        href="${pageContext.request.contextPath}/resources/css/base.css">
                                    <link rel="stylesheet"
                                        href="${pageContext.request.contextPath}/resources/css/memoryviewer.css">
                                    <style>
                                        /* Autograph-specific overrides on top of memoryviewer.css */
                                        .mv-media-section {
                                            background: #fefcf3;
                                            position: relative;
                                        }

                                        /* Autograph page rendering area */
                                        .ag-page-area {
                                            width: 100%;
                                            height: 500px;
                                            display: flex;
                                            align-items: center;
                                            justify-content: center;
                                            position: relative;
                                            overflow: hidden;
                                        }

                                        .ag-page {
                                            width: 90%;
                                            height: 90%;
                                            background: white;
                                            border-radius: 4px;
                                            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.06), 0 0 0 1px rgba(0, 0, 0, 0.04);
                                            position: relative;
                                            overflow: hidden;
                                        }

                                        /* Notebook lines effect */
                                        .ag-page::before {
                                            content: '';
                                            position: absolute;
                                            left: 50px;
                                            top: 0;
                                            bottom: 0;
                                            width: 1px;
                                            background: rgba(220, 80, 80, 0.25);
                                        }

                                        .ag-page-content {
                                            width: 100%;
                                            height: 100%;
                                            padding: 20px 20px 20px 62px;
                                            overflow-y: auto;
                                            font-family: 'Plus Jakarta Sans', sans-serif;
                                            font-size: 15px;
                                            line-height: 1.7;
                                            color: #1e293b;
                                            position: relative;
                                        }

                                        .ag-page-content::-webkit-scrollbar {
                                            width: 3px;
                                        }

                                        .ag-page-content::-webkit-scrollbar-thumb {
                                            background: #d1d5db;
                                            border-radius: 2px;
                                        }

                                        /* Rendered entry elements */
                                        .ag-page-content .message-text {
                                            font-size: 15px;
                                            line-height: 1.7;
                                            white-space: pre-wrap;
                                            position: relative !important;
                                            top: auto !important;
                                            left: auto !important;
                                        }

                                        .ag-page-content .author-signature {
                                            text-align: right;
                                            font-style: italic;
                                            font-weight: 600;
                                            color: #6b7280;
                                            font-size: 15px;
                                            margin-top: 16px;
                                            position: relative !important;
                                            top: auto !important;
                                            left: auto !important;
                                        }

                                        .ag-page-content .decorations-container {
                                            position: relative;
                                            height: auto;
                                            pointer-events: none;
                                        }

                                        .ag-page-content .decoration {
                                            position: absolute !important;
                                            /* Let inline styles from DB determine top/left */
                                        }

                                        /* No entries state */
                                        .ag-no-entries {
                                            display: flex;
                                            flex-direction: column;
                                            align-items: center;
                                            justify-content: center;
                                            width: 100%;
                                            height: 100%;
                                            color: #9ca3af;
                                            gap: 12px;
                                            text-align: center;
                                            padding: 40px;
                                        }

                                        .ag-no-entries svg {
                                            width: 48px;
                                            height: 48px;
                                            opacity: 0.4;
                                        }

                                        .ag-no-entries h3 {
                                            font-size: 16px;
                                            font-weight: 600;
                                            color: #6b7280;
                                        }

                                        .ag-no-entries p {
                                            font-size: 13px;
                                            color: #9ca3af;
                                        }

                                        /* Page counter badge */
                                        .ag-page-counter {
                                            position: absolute;
                                            bottom: 16px;
                                            left: 50%;
                                            transform: translateX(-50%);
                                            background: rgba(0, 0, 0, 0.06);
                                            padding: 4px 14px;
                                            border-radius: 12px;
                                            font-size: 12px;
                                            font-weight: 600;
                                            color: #6b7280;
                                            z-index: 10;
                                        }

                                        /* Override: always show nav buttons in autograph area */
                                        .ag-page-area .mv-carousel-btn {
                                            opacity: 0.7;
                                            background: white;
                                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                        }

                                        .ag-page-area:hover .mv-carousel-btn {
                                            opacity: 1;
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="mv-page">
                                        <!-- Close button -->
                                        <a href="${pageContext.request.contextPath}/autographs" class="mv-close-btn">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                                <line x1="6" y1="6" x2="18" y2="18"></line>
                                            </svg>
                                        </a>

                                        <div class="mv-wrapper">
                                            <!-- LEFT: Autograph Entry Display -->
                                            <div class="mv-media-section">
                                                <div class="ag-page-area">
                                                    <div class="ag-page">
                                                        <div class="ag-page-content" id="pageContent">
                                                            <!-- Entries rendered here by JS -->
                                                        </div>
                                                    </div>

                                                    <!-- Nav buttons (reuse carousel button styles) -->
                                                    <button class="mv-carousel-btn prev" type="button" id="prevPage">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <polyline points="15 18 9 12 15 6"></polyline>
                                                        </svg>
                                                    </button>
                                                    <button class="mv-carousel-btn next" type="button" id="nextPage">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <polyline points="9 18 15 12 9 6"></polyline>
                                                        </svg>
                                                    </button>

                                                    <div class="ag-page-counter" id="pageCounter"></div>
                                                </div>
                                            </div>

                                            <!-- RIGHT: Details Section -->
                                            <div class="mv-details-section">
                                                <!-- Header -->
                                                <div class="mv-header">
                                                    <div class="mv-header-left">
                                                        <div class="mv-avatar">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2.5">
                                                                <path
                                                                    d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z">
                                                                </path>
                                                            </svg>
                                                        </div>
                                                        <div class="mv-header-text">
                                                            <h3>Autograph Book</h3>
                                                            <div class="mv-type-badge">
                                                                <svg width="10" height="10" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor"
                                                                    stroke-width="2.5">
                                                                    <path d="M12 20h9"></path>
                                                                    <path
                                                                        d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z">
                                                                    </path>
                                                                </svg>
                                                                <%= entryCount %> signature<%= entryCount !=1 ? "s" : ""
                                                                        %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Scrollable Content -->
                                                <div class="mv-content">
                                                    <!-- Title -->
                                                    <div class="mv-info-group">
                                                        <div class="mv-info-value title">
                                                            <%= displayTitle %>
                                                        </div>
                                                    </div>

                                                    <!-- Date -->
                                                    <% if (!createdDate.isEmpty()) { %>
                                                        <div class="mv-info-group">
                                                            <div class="mv-info-value date">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <rect x="3" y="4" width="18" height="18" rx="2"
                                                                        ry="2"></rect>
                                                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                                                </svg>
                                                                <%= createdDate %>
                                                            </div>
                                                        </div>
                                                        <% } %>

                                                            <!-- Description -->
                                                            <% if (!displayDesc.isEmpty()) { %>
                                                                <div class="mv-divider"></div>
                                                                <div class="mv-info-group">
                                                                    <div class="mv-info-label">Description</div>
                                                                    <div class="mv-info-value">
                                                                        <%= displayDesc %>
                                                                    </div>
                                                                </div>
                                                                <% } %>

                                                                    <div class="mv-divider"></div>

                                                                    <!-- Entry count -->
                                                                    <div class="mv-info-group">
                                                                        <div class="mv-photo-count">
                                                                            <svg viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path d="M12 20h9"></path>
                                                                                <path
                                                                                    d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z">
                                                                                </path>
                                                                            </svg>
                                                                            <%= entryCount %> entr<%= entryCount !=1
                                                                                    ? "ies" : "y" %>
                                                                        </div>
                                                                    </div>
                                                </div>

                                                <!-- Actions bar -->
                                                <div class="mv-actions-bar">
                                                    <button class="mv-action-btn primary" id="shareBtn"
                                                        onclick="openShareModal()">
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
                                                    <a href="${pageContext.request.contextPath}/editautograph?id=${autograph.autographId}"
                                                        class="mv-action-btn secondary">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2.5">
                                                            <path
                                                                d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                                            </path>
                                                            <path
                                                                d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                                            </path>
                                                        </svg>
                                                        Edit
                                                    </a>
                                                    <button class="mv-action-btn danger" id="deleteBtn">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2.5">
                                                            <path d="M3 6h18"></path>
                                                            <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
                                                            <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
                                                        </svg>
                                                        Delete
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Share Modal (reuses mv-share-modal styles from memoryviewer.css) -->
                                    <div class="mv-share-modal" id="shareModal">
                                        <div class="mv-share-content">
                                            <button class="mv-share-close" onclick="closeShareModal()">&times;</button>
                                            <h2 class="mv-share-title">Share Autograph Book</h2>
                                            <p class="mv-share-subtitle">Anyone with this link can sign your book</p>
                                            <div class="mv-share-link-box">
                                                <input type="text" class="mv-share-link-input" id="shareLinkInput"
                                                    readonly placeholder="Generating link...">
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

                                    <!-- Delete Form -->
                                    <form id="deleteAutographForm"
                                        action="${pageContext.request.contextPath}/deleteautograph" method="post"
                                        style="display:none;">
                                        <input type="hidden" name="autographId" value="${autograph.autographId}">
                                    </form>

                                    <!-- Entries data -->
                                    <div id="entriesData" style="display:none;">
                                        <%= entriesJson %>
                                    </div>

                                    <script>
                                        // --- Entry Viewer (page navigation) ---
                                        var currentIndex = 0;
                                        var pages = [];

                                        (function () {
                                            var entriesText = document.getElementById('entriesData').textContent;
                                            var rawEntries = JSON.parse(entriesText || '[]');
                                            pages = rawEntries.map(function (entry) { return entry.content; });
                                            render();
                                        })();

                                        function render() {
                                            var contentEl = document.getElementById('pageContent');
                                            var counterEl = document.getElementById('pageCounter');
                                            var prevBtn = document.getElementById('prevPage');
                                            var nextBtn = document.getElementById('nextPage');

                                            if (pages.length === 0) {
                                                contentEl.innerHTML = '<div class="ag-no-entries">' +
                                                    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">' +
                                                    '<path d="M12 20h9"></path>' +
                                                    '<path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>' +
                                                    '</svg>' +
                                                    '<h3>No entries yet</h3>' +
                                                    '<p>Share your book to start collecting signatures!</p>' +
                                                    '</div>';
                                                counterEl.textContent = '';
                                                prevBtn.style.display = 'none';
                                                nextBtn.style.display = 'none';
                                                return;
                                            }

                                            contentEl.innerHTML = pages[currentIndex];
                                            counterEl.textContent = 'Page ' + (currentIndex + 1) + ' of ' + pages.length;

                                            prevBtn.style.display = pages.length > 1 ? 'flex' : 'none';
                                            nextBtn.style.display = pages.length > 1 ? 'flex' : 'none';
                                            prevBtn.style.opacity = currentIndex > 0 ? '1' : '0.3';
                                            nextBtn.style.opacity = currentIndex < pages.length - 1 ? '1' : '0.3';
                                        }

                                        document.getElementById('prevPage').addEventListener('click', function () {
                                            if (currentIndex > 0) { currentIndex--; render(); }
                                        });
                                        document.getElementById('nextPage').addEventListener('click', function () {
                                            if (currentIndex < pages.length - 1) { currentIndex++; render(); }
                                        });

                                        // Keyboard navigation
                                        document.addEventListener('keydown', function (e) {
                                            if (document.getElementById('shareModal').classList.contains('active')) return;
                                            if (e.key === 'ArrowLeft') { if (currentIndex > 0) { currentIndex--; render(); } }
                                            if (e.key === 'ArrowRight') { if (currentIndex < pages.length - 1) { currentIndex++; render(); } }
                                            if (e.key === 'Escape') window.location.href = '${pageContext.request.contextPath}/autographs';
                                        });

                                        // --- Delete ---
                                        document.getElementById('deleteBtn').addEventListener('click', function () {
                                            if (confirm('Are you sure you want to delete this autograph book? This cannot be undone.')) {
                                                document.getElementById('deleteAutographForm').submit();
                                            }
                                        });

                                        // --- Share Modal ---
                                        var shareUrl = '';
                                        var autographId = '${autograph.getAutographId()}';

                                        function openShareModal() {
                                            document.getElementById('shareModal').classList.add('active');
                                            fetch('${pageContext.request.contextPath}/generateShareLink?autographId=' + autographId)
                                                .then(function (res) { return res.json(); })
                                                .then(function (data) {
                                                    if (data.success) {
                                                        shareUrl = data.shareUrl;
                                                        document.getElementById('shareLinkInput').value = shareUrl;
                                                    } else {
                                                        alert('Error generating share link: ' + (data.error || 'Unknown error'));
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
                                            window.open('https://wa.me/?text=' + encodeURIComponent('Sign my autograph book: ' + shareUrl), '_blank');
                                        }

                                        function shareTwitter() {
                                            window.open('https://twitter.com/intent/tweet?text=' + encodeURIComponent('Check out my autograph book!') + '&url=' + encodeURIComponent(shareUrl), '_blank');
                                        }

                                        // Close modal on outside click
                                        document.getElementById('shareModal').addEventListener('click', function (e) {
                                            if (e.target === this) closeShareModal();
                                        });
                                    </script>
                                </body>

                                </html>