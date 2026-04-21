<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="/WEB-INF/views/public/header2.jsp" />
<html>

<head>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/resources/css/writejournal.css">
</head>

<body>

    <div class="write-autograph-wrapper">
        <div class="write-autograph-container">
            <!-- Header -->
            <div class="write-header">
                <h1 class="book-title">Edit Journal Entry</h1>
                <p class="book-subtitle">${fn:escapeXml(journalTitle)}</p>
            </div>

            <c:if test="${not empty error}">
                <div
                    style="background: #fee; border: 1px solid #fcc; padding: 12px; border-radius: 8px; margin: 0 20px 15px; color: #c00; font-size: 14px;">
                    ${fn:escapeXml(error)}
                </div>
            </c:if>

            <!-- Main Content -->
            <div class="write-content">
                <!-- Toolbar -->
                <div class="toolbar">
                    <div class="toolbar-section">
                        <h3 class="toolbar-title">Text Formatting</h3>
                        <div class="format-buttons">
                            <button class="format-btn" id="boldBtn" title="Bold">
                                <svg width="18" height="18" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z">
                                    </path>
                                    <path d="M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z">
                                    </path>
                                </svg>
                            </button>
                            <button class="format-btn" id="italicBtn" title="Italic">
                                <svg width="18" height="18" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <line x1="19" y1="4" x2="10" y2="4"></line>
                                    <line x1="14" y1="20" x2="5" y2="20"></line>
                                    <line x1="15" y1="4" x2="9" y2="20"></line>
                                </svg>
                            </button>
                            <button class="format-btn" id="underlineBtn"
                                title="Underline">
                                <svg width="18" height="18" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M6 3v7a6 6 0 0 0 6 6 6 6 0 0 0 6-6V3">
                                    </path>
                                    <line x1="4" y1="21" x2="20" y2="21"></line>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <div class="toolbar-section">
                        <h3 class="toolbar-title">Emojis & Stickers</h3>
                        <div class="emoji-grid" id="emojiGrid">
                            <button class="emoji-btn" data-emoji="&#x2764;&#xFE0F;">&#x2764;&#xFE0F;</button>
                            <button class="emoji-btn" data-emoji="&#x1F49C;">&#x1F49C;</button>
                            <button class="emoji-btn" data-emoji="&#x2728;">&#x2728;</button>
                            <button class="emoji-btn" data-emoji="&#x1F31F;">&#x1F31F;</button>
                            <button class="emoji-btn" data-emoji="&#x1F4AB;">&#x1F4AB;</button>
                            <button class="emoji-btn" data-emoji="&#x1F389;">&#x1F389;</button>
                            <button class="emoji-btn" data-emoji="&#x1F38A;">&#x1F38A;</button>
                            <button class="emoji-btn" data-emoji="&#x1F388;">&#x1F388;</button>
                            <button class="emoji-btn" data-emoji="&#x1F308;">&#x1F308;</button>
                            <button class="emoji-btn" data-emoji="&#x1F338;">&#x1F338;</button>
                            <button class="emoji-btn" data-emoji="&#x1F33A;">&#x1F33A;</button>
                            <button class="emoji-btn" data-emoji="&#x1F33B;">&#x1F33B;</button>
                            <button class="emoji-btn" data-emoji="&#x2600;&#xFE0F;">&#x2600;&#xFE0F;</button>
                            <button class="emoji-btn" data-emoji="&#x2B50;">&#x2B50;</button>
                            <button class="emoji-btn" data-emoji="&#x1F393;">&#x1F393;</button>
                            <button class="emoji-btn" data-emoji="&#x1F4DA;">&#x1F4DA;</button>
                            <button class="emoji-btn" data-emoji="&#x270F;&#xFE0F;">&#x270F;&#xFE0F;</button>
                            <button class="emoji-btn" data-emoji="&#x1F3A8;">&#x1F3A8;</button>
                            <button class="emoji-btn" data-emoji="&#x1F98B;">&#x1F98B;</button>
                            <button class="emoji-btn" data-emoji="&#x1F3B5;">&#x1F3B5;</button>
                        </div>
                    </div>

                    <div class="toolbar-section">
                        <h3 class="toolbar-title">Doodles</h3>
                        <div class="doodle-grid">
                            <button class="doodle-btn" data-doodle="&#x2661;"
                                data-type="heart">&#x2661;</button>
                            <button class="doodle-btn" data-doodle="&#x2605;"
                                data-type="star">&#x2605;</button>
                            <button class="doodle-btn" data-doodle="&#x266A;"
                                data-type="music">&#x266A;</button>
                            <button class="doodle-btn" data-doodle="&#x2606;"
                                data-type="star">&#x2606;</button>
                        </div>
                    </div>

                    <!-- Paper Themes -->
                    <div class="toolbar-section">
                        <h3 class="toolbar-title">Themes</h3>
                        <div class="paper-theme-grid">
                            <button type="button" class="paper-theme-btn"
                                data-theme="theme-lined"
                                data-bg="${pageContext.request.contextPath}/resources/assets/journal1.png"
                                style="background-image: url('${pageContext.request.contextPath}/resources/assets/journal1.png'); background-size: cover; background-position: center; background-repeat: no-repeat;">
                            </button>
                            <button type="button" class="paper-theme-btn"
                                data-theme="theme-lined"
                                data-bg="${pageContext.request.contextPath}/resources/assets/journal3.jpg"
                                style="background-image: url('${pageContext.request.contextPath}/resources/assets/journal3.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat;">
                            </button>
                            <button type="button" class="paper-theme-btn"
                                data-theme="theme-lined"
                                data-bg="${pageContext.request.contextPath}/resources/assets/journal2.jpg"
                                style="background-image: url('${pageContext.request.contextPath}/resources/assets/journal2.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat;">
                            </button>
                            <button type="button" class="paper-theme-btn"
                                data-theme="theme-lined"
                                data-bg="${pageContext.request.contextPath}/resources/assets/journal4.jpg"
                                style="background-image: url('${pageContext.request.contextPath}/resources/assets/journal4.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat;">
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Autograph Page -->
                <div class="page-area">
                    <div class="autograph-page" id="autographPage">
                        <!-- Red margin line -->
                        <div class="margin-line"></div>

                        <!-- Writing Area -->
                        <div class="writing-area" id="writingArea"
                            contenteditable="true">
                        </div>

                        <!-- Decorations Container -->
                        <div class="decorations-container" id="decorationsContainer">
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <button class="action-btn cancel-btn"
                            id="cancelBtn">Cancel</button>
                        <button class="action-btn submit-btn" id="submitBtn">Save
                            Changes</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden form for submission -->
    <form id="journalForm" action="${pageContext.request.contextPath}/editjournal/save"
        method="post" style="display: none;">
        <input type="hidden" name="journalId" id="journalIdField" value="${journalId}">
        <input type="hidden" name="title" id="titleField" value="${fn:escapeXml(journalTitle)}">
        <input type="hidden" name="content" id="contentField">
        <input type="hidden" name="decorations" id="decorationsField">
        <input type="hidden" name="backgroundTheme" id="backgroundThemeField">
    </form>

    <jsp:include page="/WEB-INF/views/public/footer.jsp" />

    <!-- Pass data via template blocks to avoid IDE JS/JSX linting errors -->
    <script type="text/template" id="journalDataHtml">${not empty htmlContentJson ? htmlContentJson : '""'}</script>
    <script type="text/template" id="journalDataDecorations">${not empty decorationsJsonEscaped ? decorationsJsonEscaped : '[]'}</script>
    <script type="text/template" id="journalDataBackground">${not empty backgroundThemeJson ? backgroundThemeJson : '""'}</script>

    <script>
        // Pre-populate data from server
        var existingHtml = '';
        var existingDecorations = [];
        var existingBackground = '';

        (function () {
            try {
                var elHtml = document.getElementById('journalDataHtml');
                var elDec = document.getElementById('journalDataDecorations');
                var elBg = document.getElementById('journalDataBackground');

                if (elHtml && elHtml.textContent.trim().length > 0) {
                    existingHtml = JSON.parse(elHtml.textContent);
                }
                if (elDec && elDec.textContent.trim().length > 0) {
                    var parsedDecorations = JSON.parse(elDec.textContent);
                    if (typeof parsedDecorations === 'string') {
                        try {
                            parsedDecorations = JSON.parse(parsedDecorations);
                        } catch (ignored) {
                            parsedDecorations = [];
                        }
                    }
                    existingDecorations = Array.isArray(parsedDecorations) ? parsedDecorations : [];
                }
                if (elBg && elBg.textContent.trim().length > 0) {
                    existingBackground = JSON.parse(elBg.textContent);
                }
            } catch (e) {
                console.error('Error parsing existing data:', e);
            }
        })();

        class JournalEditor {
            constructor() {
                this.writingArea = document.getElementById('writingArea');
                this.decorationsContainer = document.getElementById('decorationsContainer');
                this.journalForm = document.getElementById('journalForm');
                this.contentField = document.getElementById('contentField');
                this.decorationsField = document.getElementById('decorationsField');
                this.currentBackgroundTheme = existingBackground || '';

                this.initializeFormatting();
                this.initializeEmojis();
                this.initializeDoodles();
                this.initializeButtons();
                this.initializePaperThemes();
                this.loadExistingContent();
            }

            loadExistingContent() {
                // Load existing HTML content
                if (existingHtml) {
                    this.writingArea.innerHTML = existingHtml;
                }

                // Load existing decorations
                if (Array.isArray(existingDecorations) && existingDecorations.length > 0) {
                    existingDecorations.forEach(dec => {
                        var decoration = document.createElement('div');
                        decoration.className = dec.className || 'decoration';
                        decoration.textContent = dec.content;
                        decoration.draggable = true;
                        decoration.style.top = dec.top;
                        decoration.style.left = dec.left;
                        this.makeDraggable(decoration);
                        this.decorationsContainer.appendChild(decoration);
                    });
                }

                // Load existing background theme
                if (existingBackground) {
                    this.currentBackgroundTheme = existingBackground;
                    this.writingArea.style.backgroundImage = "url('" + existingBackground + "')";
                    this.writingArea.style.backgroundSize = 'cover';
                    this.writingArea.style.backgroundPosition = 'center';
                    this.writingArea.style.backgroundRepeat = 'no-repeat';

                    // Mark the matching theme button as active
                    var buttons = document.querySelectorAll('.paper-theme-btn');
                    var matchedThemeButton = false;
                    buttons.forEach(function (btn) {
                        btn.classList.remove('active');
                        if (btn.dataset.bg && JournalEditor.normalizeThemePath(btn.dataset.bg) === JournalEditor.normalizeThemePath(existingBackground)) {
                            btn.classList.add('active');
                            matchedThemeButton = true;
                        }
                    });
                    if (!matchedThemeButton && buttons.length > 0) {
                        buttons[0].classList.remove('active');
                    }
                } else {
                    // Default to first theme
                    var firstBtn = document.querySelector('.paper-theme-btn');
                    if (firstBtn) {
                        firstBtn.classList.add('active');
                        var bgImage = firstBtn.dataset.bg;
                        if (bgImage) {
                            this.currentBackgroundTheme = bgImage;
                            this.writingArea.style.backgroundImage = "url('" + bgImage + "')";
                            this.writingArea.style.backgroundSize = 'cover';
                            this.writingArea.style.backgroundPosition = 'center';
                            this.writingArea.style.backgroundRepeat = 'no-repeat';
                        }
                    }
                }
            }

            initializeFormatting() {
                document.getElementById('boldBtn').addEventListener('click', () => {
                    document.execCommand('bold', false, null);
                    this.writingArea.focus();
                });
                document.getElementById('italicBtn').addEventListener('click', () => {
                    document.execCommand('italic', false, null);
                    this.writingArea.focus();
                });
                document.getElementById('underlineBtn').addEventListener('click', () => {
                    document.execCommand('underline', false, null);
                    this.writingArea.focus();
                });
            }

            initializeEmojis() {
                document.querySelectorAll('.emoji-btn').forEach(btn => {
                    btn.addEventListener('click', () => {
                        this.addDecoration(btn.getAttribute('data-emoji'), 'emoji');
                    });
                });
            }

            initializeDoodles() {
                document.querySelectorAll('.doodle-btn').forEach(btn => {
                    btn.addEventListener('click', () => {
                        this.addDecoration(btn.getAttribute('data-doodle'), 'doodle', btn.getAttribute('data-type'));
                    });
                });
            }

            initializePaperThemes() {
                var buttons = document.querySelectorAll('.paper-theme-btn');
                var writingArea = this.writingArea;

                buttons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        buttons.forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');
                        var bgImage = btn.dataset.bg;
                        if (bgImage) {
                            this.currentBackgroundTheme = bgImage;
                            writingArea.style.backgroundImage = "url('" + bgImage + "')";
                            writingArea.style.backgroundSize = 'cover';
                            writingArea.style.backgroundPosition = 'center';
                            writingArea.style.backgroundRepeat = 'no-repeat';
                        } else {
                            this.currentBackgroundTheme = '';
                            writingArea.style.backgroundImage = 'none';
                            writingArea.style.backgroundColor = 'transparent';
                        }
                    });
                });
            }

            addDecoration(content, className, type) {
                var decoration = document.createElement('div');
                decoration.className = 'decoration ' + className;
                if (type) decoration.classList.add(type);
                decoration.textContent = content;
                decoration.draggable = true;
                var randomTop = Math.random() * 60 + 10;
                var randomLeft = Math.random() * 70 + 10;
                decoration.style.top = randomTop + '%';
                decoration.style.left = randomLeft + '%';
                this.makeDraggable(decoration);
                this.decorationsContainer.appendChild(decoration);
            }

            makeDraggable(element) {
                var isDragging = false;
                var startX, startY, initialLeft, initialTop;
                var self = this;

                element.addEventListener('mousedown', function (e) {
                    if (e.target === element) {
                        isDragging = true;
                        element.style.cursor = 'grabbing';
                        element.style.zIndex = '1000';
                        var rect = element.getBoundingClientRect();
                        var containerRect = self.decorationsContainer.getBoundingClientRect();
                        startX = e.clientX;
                        startY = e.clientY;
                        initialLeft = rect.left - containerRect.left;
                        initialTop = rect.top - containerRect.top;
                        e.preventDefault();
                    }
                });

                document.addEventListener('mousemove', function (e) {
                    if (isDragging) {
                        e.preventDefault();
                        var deltaX = e.clientX - startX;
                        var deltaY = e.clientY - startY;
                        var newLeft = initialLeft + deltaX;
                        var newTop = initialTop + deltaY;
                        var containerRect = self.decorationsContainer.getBoundingClientRect();
                        element.style.left = (newLeft / containerRect.width) * 100 + '%';
                        element.style.top = (newTop / containerRect.height) * 100 + '%';
                    }
                });

                document.addEventListener('mouseup', function () {
                    if (isDragging) {
                        isDragging = false;
                        element.style.cursor = 'grab';
                        element.style.zIndex = '5';
                    }
                });

                element.addEventListener('dblclick', function () {
                    element.remove();
                });

                element.style.cursor = 'grab';
            }

            initializeButtons() {
                document.getElementById('cancelBtn').addEventListener('click', () => {
                    if (confirm('Are you sure you want to cancel? Unsaved changes will be lost.')) {
                        window.location.href = '${pageContext.request.contextPath}/journalview?id=${journalId}';
                    }
                });

                document.getElementById('submitBtn').addEventListener('click', () => {
                    this.submitJournal();
                });
            }

            submitJournal() {
                var message = this.writingArea.innerHTML.trim();

                if (!message || message === '<br>') {
                    alert('Please write a message!');
                    this.writingArea.focus();
                    return;
                }

                var decorations = [];
                document.querySelectorAll('.decoration').forEach(function (dec) {
                    decorations.push({
                        content: dec.textContent,
                        className: dec.className,
                        top: dec.style.top,
                        left: dec.style.left
                    });
                });

                // Get selected background theme
                var activeThemeBtn = document.querySelector('.paper-theme-btn.active');
                var backgroundTheme = activeThemeBtn ? (activeThemeBtn.dataset.bg || '') : this.currentBackgroundTheme;

                this.contentField.value = message;
                this.decorationsField.value = JSON.stringify(decorations);
                document.getElementById('backgroundThemeField').value = backgroundTheme;

                this.journalForm.submit();
            }

            static normalizeThemePath(themePath) {
                if (!themePath) {
                    return '';
                }

                try {
                    var parsedUrl = new URL(themePath, window.location.origin);
                    return decodeURIComponent(parsedUrl.pathname).replace(/\/+/g, '/');
                } catch (e) {
                    return decodeURIComponent(themePath).replace(/\/+/g, '/');
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            new JournalEditor();
        });
    </script>

</body>

</html>
