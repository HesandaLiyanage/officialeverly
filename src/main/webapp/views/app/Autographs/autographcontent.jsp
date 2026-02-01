<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %> <!-- Add this import -->
        <%@ page import="com.demo.web.model.autograph" %> <!-- Add this import -->
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Autographs</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/autographcontent.css">
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
            </head>

            <body>

                <jsp:include page="../../public/header2.jsp" />

                <div class="page-wrapper">
                    <main class="main-content">

                        <!-- Page Header -->
                        <div class="tab-nav">
                            <div class="page-title">Autographs
                                <p class="page-subtitle">Share your book with friends and collect heartfelt messages.
                                </p>
                            </div>
                        </div>

                        <!-- Search Bar -->
                        <div class="search-filters" style="margin-top: 10px; margin-bottom: 15px;">
                            <div class="autographs-search-container">
                                <button class="autographs-search-btn" id="autographsSearchBtn">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <path d="m21 21-4.35-4.35"></path>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <!-- Autographs Grid -->
                        <div class="autographs-grid" id="autographsGrid"
                            style="max-height: calc(100vh - 300px); overflow-y: auto; padding-right: 10px;">

                            <%-- Check if the 'autographs' attribute exists and is not empty --%>
                                <% List<autograph> autographs = (List<autograph>) request.getAttribute("autographs");
                                        if (autographs != null && !autographs.isEmpty()) {
                                        for (autograph ag : autographs) {
                                        // Format the date (assuming you have a way to format it, or use a simple
                                        toString)
                                        String formattedDate = ag.getCreatedAt() != null ?
                                        ag.getCreatedAt().toString().substring(0, 10) : "Unknown Date";
                                        %>
                                        <!-- Added data-autograph-id attribute -->
                                        <div class="autograph-card" data-autograph-id="<%= ag.getAutographId() %>"
                                            data-title="<%= ag.getTitle() %>">
                                            <div class="autograph-image"
                                                style="background-image: url('<%= request.getContextPath() %>/dbimages/<%= ag.getAutographPicUrl() != null ? ag.getAutographPicUrl() : "
                                                default.jpg" %>')"></div>
                                            <div class="autograph-content">
                                                <h3 class="autograph-title">
                                                    <%= ag.getTitle() %>
                                                </h3>
                                                <p class="autograph-date">
                                                    <%= formattedDate %>
                                                </p>
                                                <div class="autograph-meta">
                                                    <span class="autograph-count">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                            <circle cx="9" cy="7" r="4"></circle>
                                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                        </svg>
                                                        <%= "N/A" %> signatures
                                                            <!-- You might need to calculate the signature count from another table -->
                                                    </span>
                                                    <button class="share-btn"
                                                        onclick="openSharePopup(event, '<%= ag.getAutographId() %>', '<%= ag.getTitle() %>')">
                                                        <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round"
                                                            stroke-linejoin="round">
                                                            <circle cx="18" cy="5" r="3"></circle>
                                                            <circle cx="6" cy="12" r="3"></circle>
                                                            <circle cx="18" cy="19" r="3"></circle>
                                                            <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line>
                                                            <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line>
                                                        </svg>
                                                        Share
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                        <% } } else { %>
                                            <div style="text-align: center; padding: 40px; color: #6b7280;">
                                                <svg width="64" height="64" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="1.5"
                                                    style="margin: 0 auto 20px; opacity: 0.5;">
                                                    <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                                </svg>
                                                <h3 style="margin: 0 0 10px; color: #374151;">No autograph books found.
                                                </h3>
                                                <p style="margin: 0;">Start sharing your book and collecting heartfelt
                                                    messages!</p>
                                            </div>
                                            <% } %>

                        </div>

                    </main>

                    <aside class="sidebar">

                        <!-- Recent Activity Section -->
                        <div class="sidebar-section">
                            <h3 class="sidebar-title">Recent Activity</h3>
                            <div class="activity-list">

                                <%@ page import="com.demo.web.model.AutographActivity" %>
                                    <% List<AutographActivity> recentActivities = (List<AutographActivity>)
                                            request.getAttribute("recentActivities");
                                            if (recentActivities != null && !recentActivities.isEmpty()) {
                                            // Define gradient colors for avatars
                                            String[] gradients = {
                                            "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
                                            "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)",
                                            "linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)",
                                            "linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)",
                                            "linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)",
                                            "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)",
                                            "linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)"
                                            };
                                            int colorIndex = 0;

                                            for (AutographActivity activity : recentActivities) {
                                            // Calculate relative time
                                            long diffMs = System.currentTimeMillis() -
                                            activity.getCreatedAt().getTime();
                                            long diffSec = diffMs / 1000;
                                            long diffMin = diffSec / 60;
                                            long diffHour = diffMin / 60;
                                            long diffDay = diffHour / 24;

                                            String relativeTime;
                                            if (diffMin < 1) { relativeTime="Just now" ; } else if (diffMin < 60) {
                                                relativeTime=diffMin + " min ago" ; } else if (diffHour < 24) {
                                                relativeTime=diffHour + " hour" + (diffHour> 1 ? "s" : "") + " ago";
                                                } else if (diffDay < 7) { relativeTime=diffDay + " day" + (diffDay> 1 ?
                                                    "s" : "") + " ago";
                                                    } else {
                                                    relativeTime = new java.text.SimpleDateFormat("MMM
                                                    d").format(activity.getCreatedAt());
                                                    }

                                                    String gradient = gradients[colorIndex % gradients.length];
                                                    colorIndex++;
                                                    %>
                                                    <div class="activity-item">
                                                        <div class="activity-avatar"
                                                            style="background: <%= gradient %>;">
                                                            <span>
                                                                <%= activity.getInitials() %>
                                                            </span>
                                                        </div>
                                                        <div class="activity-info">
                                                            <p class="activity-text"><strong>
                                                                    <%= activity.getInviteeUsername() %>
                                                                </strong> wrote in <%= activity.getBookTitle() %>
                                                            </p>
                                                            <span class="activity-time">
                                                                <%= relativeTime %>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <% } } else { %>
                                                        <div style="text-align: center; padding: 20px; color: #9ca3af;">
                                                            <svg width="40" height="40" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="1.5"
                                                                style="margin: 0 auto 10px; opacity: 0.5;">
                                                                <circle cx="12" cy="12" r="10"></circle>
                                                                <polyline points="12,6 12,12 16,14"></polyline>
                                                            </svg>
                                                            <p style="margin: 0; font-size: 14px;">No recent activity
                                                            </p>
                                                            <p style="margin: 5px 0 0; font-size: 12px; opacity: 0.7;">
                                                                Share your autograph books to start collecting
                                                                signatures!</p>
                                                        </div>
                                                        <% } %>

                            </div>
                        </div>


                        <!-- Floating Action Button - Now static below sidebar -->
                        <div class="floating-buttons" id="floatingButtons" style="position: static; margin-top: 20px;">
                            <a href="/addautograph" class="floating-btn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                Add a Book
                            </a>
                        </div>

                    </aside>
                </div>
                <!-- Share Popup Overlay -->
                <div class="share-overlay" id="shareOverlay">
                    <div class="share-modal">
                        <div class="share-header">
                            <h3>Share</h3>
                            <button class="close-share" id="closeShare">&times;</button>
                        </div>

                        <!-- Copy Link -->
                        <div class="share-option" id="copyLinkBtn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="9" y="9" width="13" height="13" rx="2"></rect>
                                <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                            </svg>
                            <span>Copy link</span>
                        </div>

                        <!-- WhatsApp -->
                        <a id="whatsappShare" class="share-option whatsapp" target="_blank">
                            <img src="${pageContext.request.contextPath}/resources/assets/whatsapp.jpeg" alt="WhatsApp"
                                class="whatsapp-icon" />
                            <span>WhatsApp</span>
                        </a>
                    </div>
                </div>
                <jsp:include page="../../public/footer.jsp" />

                <script>
                    // Function to open share popup
                    function openSharePopup(event, autographId, title) {
                        event.stopPropagation(); // Prevent card click

                        const shareOverlay = document.getElementById('shareOverlay');
                        const whatsappShare = document.getElementById('whatsappShare');

                        // Create the share URL
                        const baseUrl = window.location.origin;
                        fetch('/generateShareLink?autographId=' + encodeURIComponent(autographId))
                            .then(res => res.json())
                            .then(data => {
                                if (data.success) {
                                    window.currentShareUrl = data.shareUrl;

                                    const whatsappText = 'Check out my autograph book: ' + title + ' - ' + data.shareUrl;
                                    whatsappShare.href = 'https://wa.me/?text=' + encodeURIComponent(whatsappText);

                                    document.getElementById('shareOverlay').style.display = 'flex';
                                } else {
                                    alert('Unable to generate share link');
                                }
                            });


                        // Store for copy link function
                        window.currentShareUrl = shareUrl;
                        window.currentShareTitle = title;

                        // Update WhatsApp link
                        if (whatsappShare) {
                            const whatsappText = 'Check out my autograph book: ' + title + ' - ' + shareUrl;
                            whatsappShare.href = 'https://wa.me/?text=' + encodeURIComponent(whatsappText);
                        }

                        // Show the overlay
                        if (shareOverlay) {
                            shareOverlay.style.display = 'flex';
                        }
                    }

                    document.addEventListener('DOMContentLoaded', function () {

                        // Modern Search Functionality
                        const autographsSearchBtn = document.getElementById('autographsSearchBtn');

                        if (autographsSearchBtn) {
                            autographsSearchBtn.addEventListener('click', function (event) {
                                event.stopPropagation();

                                const searchBtnElement = this;
                                const searchContainer = searchBtnElement.parentElement;

                                const searchBox = document.createElement('div');
                                searchBox.className = 'autographs-search-expanded';
                                searchBox.innerHTML = `
                    <div class="autographs-search-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    </div>
                    <input type="text" id="searchInput" placeholder="Search autograph books..." autofocus>
                    <button class="autographs-search-close">
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
                                    newSearchBtn.className = 'autographs-search-btn';
                                    newSearchBtn.id = 'autographsSearchBtn';
                                    newSearchBtn.innerHTML = `
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                    `;
                                    searchContainer.replaceChild(newSearchBtn, searchBox);
                                    newSearchBtn.addEventListener('click', arguments.callee);
                                };

                                searchBox.querySelector('.autographs-search-close').addEventListener('click', closeSearch);

                                input.addEventListener('blur', function () {
                                    setTimeout(() => {
                                        if (!document.activeElement.closest('.autographs-search-expanded')) {
                                            closeSearch();
                                        }
                                    }, 150);
                                });

                                searchBox.addEventListener('mousedown', function (e) {
                                    e.preventDefault();
                                    input.focus();
                                });

                                // Search functionality
                                input.addEventListener('input', function (e) {
                                    const query = e.target.value.toLowerCase();
                                    const autographCards = document.querySelectorAll('.autograph-card');
                                    autographCards.forEach(card => {
                                        const title = card.getAttribute('data-title')?.toLowerCase() || '';
                                        card.style.display = title.includes(query) ? 'block' : 'none';
                                    });
                                });
                            });
                        }

                        // Autograph card click handlers
                        const autographCards = document.querySelectorAll('.autograph-card');
                        autographCards.forEach(card => {
                            card.addEventListener('click', function () {
                                console.log('Autograph book clicked:', this.querySelector('.autograph-title').textContent);
                                // Get the autograph ID from the data-autograph-id attribute added in JSP
                                const autographId = this.getAttribute('data-autograph-id');
                                if (autographId) {
                                    // Redirect to autograph detail page with the ID as a parameter
                                    window.location.href = '/autographview?id=' + encodeURIComponent(autographId);
                                } else {
                                    console.error('Autograph ID not found for this card.');
                                }
                            });
                        });

                        // Activity item interactions
                        const activityItems = document.querySelectorAll('.activity-item');
                        activityItems.forEach(item => {
                            item.addEventListener('click', function () {
                                activityItems.forEach(i => i.classList.remove('selected'));
                                this.classList.add('selected');
                            });
                        });
                        // ===============================
                        // SHARE POPUP LOGIC
                        // ===============================
                        const shareOverlay = document.getElementById('shareOverlay');
                        const closeShare = document.getElementById('closeShare');
                        const copyLinkBtn = document.getElementById('copyLinkBtn');
                        const whatsappShare = document.getElementById('whatsappShare');


                        // Close share popup
                        if (closeShare && shareOverlay) {
                            closeShare.addEventListener('click', () => {
                                shareOverlay.style.display = 'none';
                            });

                            shareOverlay.addEventListener('click', (e) => {
                                if (e.target === shareOverlay) {
                                    shareOverlay.style.display = 'none';
                                }
                            });
                        }

                        // Copy link functionality
                        if (copyLinkBtn) {
                            copyLinkBtn.addEventListener('click', () => {
                                if (navigator.clipboard && navigator.clipboard.writeText) {
                                    navigator.clipboard.writeText(currentShareUrl).then(() => {
                                        const span = copyLinkBtn.querySelector('span');
                                        const originalText = span.textContent;
                                        span.textContent = 'Copied!';
                                        setTimeout(() => {
                                            span.textContent = originalText;
                                        }, 1500);
                                    }).catch(() => {
                                        alert('Copy failed. Please copy manually: ' + currentShareUrl);
                                    });
                                } else {
                                    // Fallback for older browsers
                                    const tempInput = document.createElement('input');
                                    tempInput.value = currentShareUrl;
                                    document.body.appendChild(tempInput);
                                    tempInput.select();
                                    document.execCommand('copy');
                                    document.body.removeChild(tempInput);
                                    alert('Link copied!');
                                }
                            });
                        }
                    });
                </script>

            </body>

            </html>