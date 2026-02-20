<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.demo.web.model.autograph" %>
            <%@ page import="com.demo.web.model.AutographActivity" %>
                <%@ page import="java.util.Map" %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Autographs</title>
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/resources/css/autographcontent.css">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                            rel="stylesheet">
                    </head>

                    <body>

                        <jsp:include page="../../public/header2.jsp" />

                        <div class="page-wrapper" style="min-height: calc(100vh - 160px);">
                            <main class="main-content">

                                <!-- Page Header -->
                                <div class="tab-nav">
                                    <div class="page-title">Autographs
                                        <p class="page-subtitle">Share your book with friends and collect heartfelt
                                            messages.
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
                                        <% List<autograph> autographs = (List<autograph>)
                                                request.getAttribute("autographs");
                                                if (autographs != null && !autographs.isEmpty()) {
                                                for (autograph ag : autographs) {
                                                String formattedDate = ag.getCreatedAt() != null ?
                                                ag.getCreatedAt().toString().substring(0, 10) : "Unknown Date";
                                                String picUrl = ag.getAutographPicUrl() != null ?
                                                ag.getAutographPicUrl() :
                                                "default.jpg";
                                                %>
                                                <div class="autograph-card"
                                                    data-autograph-id="<%= ag.getAutographId() %>"
                                                    data-title="<%= ag.getTitle() %>">
                                                    <div class="autograph-image"
                                                        style="background-image: url('<%= request.getContextPath() %>/dbimages/<%= picUrl %>')">
                                                    </div>
                                                    <div class="autograph-content">
                                                        <h3 class="autograph-title">
                                                            <%= ag.getTitle() %>
                                                        </h3>
                                                        <p class="autograph-date">
                                                            <%= formattedDate %>
                                                        </p>
                                                        <div class="autograph-meta">
                                                            <div class="signer-avatars">
                                                                <% Map<Integer, List<String>> signersMap = (Map<Integer,
                                                                        List<String>>)
                                                                        request.getAttribute("signersMap");
                                                                        List<String> signers = signersMap != null ?
                                                                            signersMap.get(ag.getAutographId()) : null;
                                                                            String[] avatarGradients = {
                                                                            "linear-gradient(135deg, #667eea 0%, #764ba2
                                                                            100%)",
                                                                            "linear-gradient(135deg, #f093fb 0%, #f5576c
                                                                            100%)",
                                                                            "linear-gradient(135deg, #a8edea 0%, #fed6e3
                                                                            100%)",
                                                                            "linear-gradient(135deg, #ffecd2 0%, #fcb69f
                                                                            100%)",
                                                                            "linear-gradient(135deg, #ff9a9e 0%, #fecfef
                                                                            100%)"
                                                                            };
                                                                            int maxShow = 4;
                                                                            if (signers != null && !signers.isEmpty()) {
                                                                            int showCount = Math.min(signers.size(),
                                                                            maxShow);
                                                                            for (int si = 0; si < showCount; si++) {
                                                                                String sName=signers.get(si); String
                                                                                initial=sName.substring(0,
                                                                                1).toUpperCase(); int
                                                                                sHash=Math.abs(sName.hashCode()); String
                                                                                grad=avatarGradients[sHash %
                                                                                avatarGradients.length]; %>
                                                                                <div class="signer-avatar"
                                                                                    style="background: <%= grad %>; z-index: <%= (maxShow - si) %>;"
                                                                                    title="<%= sName %>">
                                                                                    <%= initial %>
                                                                                </div>
                                                                                <% } if (signers.size()> maxShow) { %>
                                                                                    <div class="signer-avatar signer-more"
                                                                                        style="z-index: 0;"
                                                                                        title="<%= (signers.size() - maxShow) %> more">
                                                                                        +<%= (signers.size() - maxShow)
                                                                                            %>
                                                                                    </div>
                                                                                    <% } } else { %>
                                                                                        <span class="no-signers">No
                                                                                            entries yet</span>
                                                                                        <% } %>
                                                            </div>
                                                            <button class="share-btn"
                                                                onclick="openSharePopup(event, '<%= ag.getAutographId() %>', '<%= ag.getTitle() %>')">
                                                                <svg viewBox="0 0 24 24" stroke-width="2"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <circle cx="18" cy="5" r="3"></circle>
                                                                    <circle cx="6" cy="12" r="3"></circle>
                                                                    <circle cx="18" cy="19" r="3"></circle>
                                                                    <line x1="8.59" y1="13.51" x2="15.42" y2="17.49">
                                                                    </line>
                                                                    <line x1="15.41" y1="6.51" x2="8.59" y2="10.49">
                                                                    </line>
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
                                                            <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z">
                                                            </path>
                                                        </svg>
                                                        <h3 style="margin: 0 0 10px; color: #374151;">No autograph books
                                                            found.
                                                        </h3>
                                                        <p style="margin: 0;">Start sharing your book and collecting
                                                            heartfelt
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
                                        <% List<AutographActivity> recentActivities = (List<AutographActivity>)
                                                request.getAttribute("recentActivities");
                                                if (recentActivities == null || recentActivities.isEmpty()) {
                                                %>
                                                <div
                                                    style="text-align: center; padding: 20px; color: #6b7280; font-size: 14px;">
                                                    <p>No recent activity yet.</p>
                                                    <p style="font-size: 12px;">Share your autograph books to see
                                                        activity
                                                        here!</p>
                                                </div>
                                                <% } else { String[]
                                                    gradients={ "linear-gradient(135deg, #667eea 0%, #764ba2 100%)"
                                                    , "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)"
                                                    , "linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)"
                                                    , "linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)"
                                                    , "linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)" }; for
                                                    (AutographActivity act : recentActivities) { int
                                                    userHash=Math.abs(act.getWriterUsername().hashCode()); String
                                                    gradient=gradients[userHash % gradients.length]; %>
                                                    <div class="activity-item">
                                                        <div class="activity-avatar"
                                                            style="background: <%= gradient %>;">
                                                            <span>
                                                                <%= act.getWriterInitials() %>
                                                            </span>
                                                        </div>
                                                        <div class="activity-info">
                                                            <p class="activity-text"><strong>
                                                                    <%= act.getWriterUsername() %>
                                                                </strong> wrote in <%= act.getAutographTitle() %>
                                                            </p>
                                                            <span class="activity-time">
                                                                <%= act.getRelativeTime() %>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <% } } %>

                                    </div>
                                </div>

                                <!-- Floating Action Button - Now static below sidebar -->
                                <div class="floating-buttons" id="floatingButtons"
                                    style="position: static; margin-top: 20px;">
                                    <a href="/addautograph" class="floating-btn">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
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
                                    <img src="${pageContext.request.contextPath}/resources/assets/whatsapp.jpeg"
                                        alt="WhatsApp" class="whatsapp-icon" />
                                    <span>WhatsApp</span>
                                </a>
                            </div>
                        </div>
                        <jsp:include page="../../public/footer.jsp" />

                        <script>
                            // Function to open share popup
                            function openSharePopup(event, autographId, title) {
                                event.stopPropagation();

                                var shareOverlay = document.getElementById('shareOverlay');
                                var whatsappShare = document.getElementById('whatsappShare');
                                var copyLinkBtn = document.getElementById('copyLinkBtn');
                                var copyLinkSpan = copyLinkBtn ? copyLinkBtn.querySelector('span') : null;

                                // Show the overlay immediately
                                if (shareOverlay) {
                                    shareOverlay.style.display = 'flex';
                                }

                                // Show loading state
                                if (copyLinkSpan) copyLinkSpan.textContent = 'Loading...';
                                if (whatsappShare) whatsappShare.href = '#';

                                // Fetch the proper share URL from the backend
                                fetch('/generateShareLink?autographId=' + encodeURIComponent(autographId))
                                    .then(function (resp) { return resp.json(); })
                                    .then(function (data) {
                                        if (data.success) {
                                            var shareUrl = data.shareUrl;
                                            window.currentShareUrl = shareUrl;
                                            window.currentShareTitle = title;
                                            if (copyLinkSpan) copyLinkSpan.textContent = 'Copy link';
                                            if (whatsappShare) {
                                                var whatsappText = 'Check out my autograph book: ' + title + ' - ' + shareUrl;
                                                whatsappShare.href = 'https://wa.me/?text=' + encodeURIComponent(whatsappText);
                                            }
                                        } else {
                                            var fallbackUrl = window.location.origin + '/autographview?id=' + encodeURIComponent(autographId);
                                            window.currentShareUrl = fallbackUrl;
                                            window.currentShareTitle = title;
                                            if (copyLinkSpan) copyLinkSpan.textContent = 'Copy link';
                                            if (whatsappShare) {
                                                var whatsappText = 'Check out my autograph book: ' + title + ' - ' + fallbackUrl;
                                                whatsappShare.href = 'https://wa.me/?text=' + encodeURIComponent(whatsappText);
                                            }
                                        }
                                    })
                                    .catch(function () {
                                        var fallbackUrl = window.location.origin + '/autographview?id=' + encodeURIComponent(autographId);
                                        window.currentShareUrl = fallbackUrl;
                                        window.currentShareTitle = title;
                                        if (copyLinkSpan) copyLinkSpan.textContent = 'Copy link';
                                        if (whatsappShare) {
                                            var whatsappText = 'Check out my autograph book: ' + title + ' - ' + fallbackUrl;
                                            whatsappShare.href = 'https://wa.me/?text=' + encodeURIComponent(whatsappText);
                                        }
                                    });
                            }

                            document.addEventListener('DOMContentLoaded', function () {

                                // Modern Search Functionality
                                function resetCards() {
                                    var autographCards = document.querySelectorAll('.autograph-card');
                                    autographCards.forEach(function (card) { card.style.display = ''; });
                                }

                                function openSearch(event) {
                                    event.stopPropagation();

                                    var searchBtnElement = event.currentTarget;
                                    var searchContainer = searchBtnElement.parentElement;

                                    var searchBox = document.createElement('div');
                                    searchBox.className = 'autographs-search-expanded';
                                    searchBox.innerHTML = '<div class="autographs-search-icon"><svg viewBox="0 0 24 24" fill="none" stroke="#6366f1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.35-4.35"></path></svg></div><input type="text" id="searchInput" placeholder="Search autograph books..." autofocus><button class="autographs-search-close"><svg viewBox="0 0 24 24" fill="none" stroke="#6b7280" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg></button>';

                                    searchContainer.replaceChild(searchBox, searchBtnElement);

                                    var input = searchBox.querySelector('input');
                                    input.focus();

                                    var closeSearch = function () {
                                        resetCards();
                                        var newSearchBtn = document.createElement('button');
                                        newSearchBtn.className = 'autographs-search-btn';
                                        newSearchBtn.id = 'autographsSearchBtn';
                                        newSearchBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.35-4.35"></path></svg>';
                                        searchContainer.replaceChild(newSearchBtn, searchBox);
                                        newSearchBtn.addEventListener('click', openSearch);
                                    };

                                    searchBox.querySelector('.autographs-search-close').addEventListener('click', closeSearch);

                                    input.addEventListener('blur', function () {
                                        setTimeout(function () {
                                            if (!document.activeElement || !document.activeElement.closest || !document.activeElement.closest('.autographs-search-expanded')) {
                                                closeSearch();
                                            }
                                        }, 200);
                                    });

                                    searchBox.addEventListener('mousedown', function (e) {
                                        if (!e.target.closest('.autographs-search-close')) {
                                            e.preventDefault();
                                            input.focus();
                                        }
                                    });

                                    // Search functionality
                                    input.addEventListener('input', function (e) {
                                        var query = e.target.value.toLowerCase().trim();
                                        var autographCards = document.querySelectorAll('.autograph-card');
                                        autographCards.forEach(function (card) {
                                            if (query === '') {
                                                card.style.display = '';
                                            } else {
                                                var cardTitle = card.getAttribute('data-title');
                                                cardTitle = cardTitle ? cardTitle.toLowerCase() : '';
                                                card.style.display = cardTitle.indexOf(query) !== -1 ? '' : 'none';
                                            }
                                        });
                                    });
                                }

                                var autographsSearchBtn = document.getElementById('autographsSearchBtn');
                                if (autographsSearchBtn) {
                                    autographsSearchBtn.addEventListener('click', openSearch);
                                }

                                // Autograph card click handlers
                                var autographCards = document.querySelectorAll('.autograph-card');
                                autographCards.forEach(function (card) {
                                    card.addEventListener('click', function () {
                                        console.log('Autograph book clicked:', this.querySelector('.autograph-title').textContent);
                                        var autographId = this.getAttribute('data-autograph-id');
                                        if (autographId) {
                                            window.location.href = '/autographview?id=' + encodeURIComponent(autographId);
                                        } else {
                                            console.error('Autograph ID not found for this card.');
                                        }
                                    });
                                });

                                // Activity item interactions
                                var activityItems = document.querySelectorAll('.activity-item');
                                activityItems.forEach(function (item) {
                                    item.addEventListener('click', function () {
                                        activityItems.forEach(function (i) { i.classList.remove('selected'); });
                                        this.classList.add('selected');
                                    });
                                });

                                // ===============================
                                // SHARE POPUP LOGIC
                                // ===============================
                                var shareOverlay = document.getElementById('shareOverlay');
                                var closeShare = document.getElementById('closeShare');
                                var copyLinkBtn = document.getElementById('copyLinkBtn');

                                // Close share popup
                                if (closeShare && shareOverlay) {
                                    closeShare.addEventListener('click', function () {
                                        shareOverlay.style.display = 'none';
                                    });

                                    shareOverlay.addEventListener('click', function (e) {
                                        if (e.target === shareOverlay) {
                                            shareOverlay.style.display = 'none';
                                        }
                                    });
                                }

                                // Copy link functionality
                                if (copyLinkBtn) {
                                    copyLinkBtn.addEventListener('click', function () {
                                        if (navigator.clipboard && navigator.clipboard.writeText) {
                                            navigator.clipboard.writeText(window.currentShareUrl).then(function () {
                                                var span = copyLinkBtn.querySelector('span');
                                                var originalText = span.textContent;
                                                span.textContent = 'Link copied!';
                                                setTimeout(function () {
                                                    span.textContent = originalText;
                                                }, 1500);
                                            }).catch(function () {
                                                alert('Copy failed. Please copy manually: ' + window.currentShareUrl);
                                            });
                                        } else {
                                            var tempInput = document.createElement('input');
                                            tempInput.value = window.currentShareUrl;
                                            document.body.appendChild(tempInput);
                                            tempInput.select();
                                            document.execCommand('copy');
                                            document.body.removeChild(tempInput);
                                            var span = copyLinkBtn.querySelector('span');
                                            span.textContent = 'Link copied!';
                                            setTimeout(function () {
                                                span.textContent = 'Copy link';
                                            }, 1500);
                                        }
                                    });
                                }
                            });
                        </script>

                    </body>

                    </html>