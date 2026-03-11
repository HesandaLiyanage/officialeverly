<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <jsp:include page="../public/header2.jsp" />
    <html>

    <head>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/writejournal.css">
    </head>

    <body>

        <div class="write-autograph-wrapper">
            <div class="write-autograph-container">
                <!-- Header -->
                <div class="write-header">
                    <h1 class="book-title">Write Your Journal</h1>
                    <p class="book-subtitle">My Journal 2025</p>
                </div>

                <!-- Main Content -->
                <div class="write-content">
                    <!-- Toolbar -->
                    <div class="toolbar">
                        <div class="toolbar-section">
                            <h3 class="toolbar-title">Text Formatting</h3>
                            <div class="format-buttons">
                                <button class="format-btn" id="boldBtn" title="Bold">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <path d="M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path>
                                        <path d="M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path>
                                    </svg>
                                </button>
                                <button class="format-btn" id="italicBtn" title="Italic">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <line x1="19" y1="4" x2="10" y2="4"></line>
                                        <line x1="14" y1="20" x2="5" y2="20"></line>
                                        <line x1="15" y1="4" x2="9" y2="20"></line>
                                    </svg>
                                </button>
                                <button class="format-btn" id="underlineBtn" title="Underline">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <path d="M6 3v7a6 6 0 0 0 6 6 6 6 0 0 0 6-6V3"></path>
                                        <line x1="4" y1="21" x2="20" y2="21"></line>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <div class="toolbar-section">
                            <h3 class="toolbar-title">Emojis & Stickers</h3>
                            <div class="emoji-grid" id="emojiGrid">
                                <button class="emoji-btn" data-emoji="❤️">❤️</button>
                                <button class="emoji-btn" data-emoji="💜">💜</button>
                                <button class="emoji-btn" data-emoji="✨">✨</button>
                                <button class="emoji-btn" data-emoji="🌟">🌟</button>
                                <button class="emoji-btn" data-emoji="💫">💫</button>
                                <button class="emoji-btn" data-emoji="🎉">🎉</button>
                                <button class="emoji-btn" data-emoji="🎊">🎊</button>
                                <button class="emoji-btn" data-emoji="🎈">🎈</button>
                                <button class="emoji-btn" data-emoji="🌈">🌈</button>
                                <button class="emoji-btn" data-emoji="🌸">🌸</button>
                                <button class="emoji-btn" data-emoji="🌺">🌺</button>
                                <button class="emoji-btn" data-emoji="🌻">🌻</button>
                                <button class="emoji-btn" data-emoji="☀️">☀️</button>
                                <button class="emoji-btn" data-emoji="⭐">⭐</button>
                                <button class="emoji-btn" data-emoji="🎓">🎓</button>
                                <button class="emoji-btn" data-emoji="📚">📚</button>
                                <button class="emoji-btn" data-emoji="✏️">✏️</button>
                                <button class="emoji-btn" data-emoji="🎨">🎨</button>
                                <button class="emoji-btn" data-emoji="🦋">🦋</button>
                                <button class="emoji-btn" data-emoji="🎵">🎵</button>
                            </div>
                        </div>

                        <div class="toolbar-section">
                            <h3 class="toolbar-title">Doodles</h3>
                            <div class="doodle-grid">
                                <button class="doodle-btn" data-doodle="♡" data-type="heart">♡</button>
                                <button class="doodle-btn" data-doodle="★" data-type="star">★</button>
                                <button class="doodle-btn" data-doodle="♪" data-type="music">♪</button>
                                <button class="doodle-btn" data-doodle="☆" data-type="star">☆</button>
                            </div>
                        </div>

                        <!-- Paper Themes -->
                        <div class="toolbar-section">
                            <h3 class="toolbar-title">Themes</h3>

                            <div class="paper-theme-grid">
                                <button type="button" class="paper-theme-btn active" data-theme="theme-lined"
                                    data-bg="${pageContext.request.contextPath}/resources/assets/journal1.png" style="background-image: url('${pageContext.request.contextPath}/resources/assets/journal1.png');
                                background-size: cover;
                                background-position: center;
                                background-repeat: no-repeat;
                                ">
                                </button>

                                <button type="button" class="paper-theme-btn" data-theme="theme-lined"
                                    data-bg="${pageContext.request.contextPath}/resources/assets/journal3.jpg" style="background-image: url('${pageContext.request.contextPath}/resources/assets/journal3.jpg');
                                background-size: cover;
                                background-position: center;
                                background-repeat: no-repeat;
                                ">
                                </button>

                                <button type="button" class="paper-theme-btn" data-theme="theme-lined"
                                    data-bg="${pageContext.request.contextPath}/resources/assets/journal2.jpg" style="background-image: url('${pageContext.request.contextPath}/resources/assets/journal2.jpg');
                                background-size: cover;
                                background-position: center;
                                background-repeat: no-repeat;
                                ">
                                </button>


                                <button type="button" class="paper-theme-btn" data-theme="theme-lined"
                                    data-bg="${pageContext.request.contextPath}/resources/assets/journal4.jpg" style="background-image: url('${pageContext.request.contextPath}/resources/assets/journal4.jpg');
                                background-size: cover;
                                background-position: center;
                                background-repeat: no-repeat;
                                ">
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
                            <div class="writing-area" id="writingArea" contenteditable="true">
                            </div>

                            <!-- Decorations Container -->
                            <div class="decorations-container" id="decorationsContainer">
                                <!-- Draggable emojis/stickers will be added here -->
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button class="action-btn cancel-btn" id="cancelBtn">Cancel</button>
                            <button class="action-btn submit-btn" id="submitBtn">Add to Journal</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Hidden form for submission -->
        <form id="journalForm" action="${pageContext.request.contextPath}/createjournal" method="post"
            style="display: none;">
            <input type="hidden" name="content" id="contentField">
            <input type="hidden" name="decorations" id="decorationsField">
            <input type="hidden" name="backgroundTheme" id="backgroundThemeField">
        </form>

        <jsp:include page="../public/footer.jsp" />

        <script>
            class AutographWriter {
                constructor() {
                    this.writingArea = document.getElementById('writingArea');
                    this.decorationsContainer = document.getElementById('decorationsContainer');
                    this.journalForm = document.getElementById('journalForm');
                    this.contentField = document.getElementById('contentField');
                    this.decorationsField = document.getElementById('decorationsField');
                    this.selectedElement = null;

                    this.initializeFormatting();
                    this.initializeEmojis();
                    this.initializeDoodles();
                    this.initializeButtons();
                    this.initializePaperThemes();

                }

                initializeFormatting() {
                    const boldBtn = document.getElementById('boldBtn');
                    const italicBtn = document.getElementById('italicBtn');
                    const underlineBtn = document.getElementById('underlineBtn');

                    boldBtn.addEventListener('click', () => {
                        document.execCommand('bold', false, null);
                        this.writingArea.focus();
                    });

                    italicBtn.addEventListener('click', () => {
                        document.execCommand('italic', false, null);
                        this.writingArea.focus();
                    });

                    underlineBtn.addEventListener('click', () => {
                        document.execCommand('underline', false, null);
                        this.writingArea.focus();
                    });
                }

                initializeEmojis() {
                    const emojiButtons = document.querySelectorAll('.emoji-btn');

                    emojiButtons.forEach(btn => {
                        btn.addEventListener('click', () => {
                            const emoji = btn.getAttribute('data-emoji');
                            this.addDecoration(emoji, 'emoji');
                        });
                    });
                }

                initializeDoodles() {
                    const doodleButtons = document.querySelectorAll('.doodle-btn');

                    doodleButtons.forEach(btn => {
                        btn.addEventListener('click', () => {
                            const doodle = btn.getAttribute('data-doodle');
                            const type = btn.getAttribute('data-type');
                            this.addDecoration(doodle, 'doodle', type);
                        });
                    });
                }

                initializePaperThemes() {
                    const buttons = document.querySelectorAll('.paper-theme-btn');
                    const writingArea = document.getElementById('writingArea');

                    buttons.forEach(btn => {
                        btn.addEventListener('click', () => {
                            // Remove active class from all buttons
                            buttons.forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');

                            const bgImage = btn.dataset.bg;

                            if (bgImage) {
                                writingArea.style.backgroundImage = `url('` + bgImage + `')`;
                                writingArea.style.backgroundSize = 'cover';
                                writingArea.style.backgroundPosition = 'center';
                                writingArea.style.backgroundRepeat = 'no-repeat';
                            } else {
                                writingArea.style.backgroundImage = 'none';
                                writingArea.style.backgroundColor = 'transparent';
                            }
                        });
                    });

                    // Set the default theme on page load
                    const activeBtn = document.querySelector('.paper-theme-btn.active');
                    if (activeBtn) {
                        const bgImage = activeBtn.dataset.bg;
                        if (bgImage) {
                            writingArea.style.backgroundImage = `url('` + bgImage + `')`;
                            writingArea.style.backgroundSize = 'cover';
                            writingArea.style.backgroundPosition = 'center';
                            writingArea.style.backgroundRepeat = 'no-repeat';
                        }
                    }
                }

                addDecoration(content, className, type = '') {
                    const decoration = document.createElement('div');
                    decoration.className = `decoration ${className}`;
                    if (type) decoration.classList.add(type);
                    decoration.textContent = content;
                    decoration.draggable = true;

                    // Random initial position
                    const randomTop = Math.random() * 60 + 10;
                    const randomLeft = Math.random() * 70 + 10;
                    decoration.style.top = randomTop + '%';
                    decoration.style.left = randomLeft + '%';

                    // Make it draggable
                    this.makeDraggable(decoration);

                    this.decorationsContainer.appendChild(decoration);
                }

                makeDraggable(element) {
                    let isDragging = false;
                    let startX;
                    let startY;
                    let initialLeft;
                    let initialTop;

                    element.addEventListener('mousedown', (e) => {
                        if (e.target === element) {
                            isDragging = true;
                            element.style.cursor = 'grabbing';
                            element.style.zIndex = '1000';

                            // Get the current position of the element
                            const rect = element.getBoundingClientRect();
                            const containerRect = this.decorationsContainer.getBoundingClientRect();

                            // Store initial mouse position
                            startX = e.clientX;
                            startY = e.clientY;

                            // Store initial element position relative to container
                            initialLeft = rect.left - containerRect.left;
                            initialTop = rect.top - containerRect.top;

                            e.preventDefault();
                        }
                    });

                    document.addEventListener('mousemove', (e) => {
                        if (isDragging) {
                            e.preventDefault();

                            // Calculate how much the mouse has moved
                            const deltaX = e.clientX - startX;
                            const deltaY = e.clientY - startY;

                            // Calculate new position
                            const newLeft = initialLeft + deltaX;
                            const newTop = initialTop + deltaY;

                            // Convert to percentage
                            const containerRect = this.decorationsContainer.getBoundingClientRect();
                            const percentX = (newLeft / containerRect.width) * 100;
                            const percentY = (newTop / containerRect.height) * 100;

                            // Update element position
                            element.style.left = percentX + '%';
                            element.style.top = percentY + '%';
                        }
                    });

                    document.addEventListener('mouseup', () => {
                        if (isDragging) {
                            isDragging = false;
                            element.style.cursor = 'grab';
                            element.style.zIndex = '5';
                        }
                    });

                    // Double click to remove
                    element.addEventListener('dblclick', () => {
                        element.remove();
                    });

                    element.style.cursor = 'grab';
                }

                initializeButtons() {
                    const cancelBtn = document.getElementById('cancelBtn');
                    const submitBtn = document.getElementById('submitBtn');

                    cancelBtn.addEventListener('click', () => {
                        if (confirm('Are you sure you want to cancel? Your journal will be lost.')) {
                            window.location.href = '${pageContext.request.contextPath}/journals';
                        }
                    });

                    submitBtn.addEventListener('click', () => {
                        this.submitJournal();
                    });
                }

                submitJournal() {
                    const message = this.writingArea.innerHTML.trim();

                    if (!message || message === '<br>') {
                        alert('Please write a message!');
                        this.writingArea.focus();
                        return;
                    }

                    // Get all decorations
                    const decorations = [];
                    document.querySelectorAll('.decoration').forEach(dec => {
                        decorations.push({
                            content: dec.textContent,
                            className: dec.className,
                            top: dec.style.top,
                            left: dec.style.left
                        });
                    });

                    // Get selected background theme
                    const activeThemeBtn = document.querySelector('.paper-theme-btn.active');
                    const backgroundTheme = activeThemeBtn ? (activeThemeBtn.dataset.bg || '') : '';

                    // Set hidden form fields
                    this.contentField.value = message;
                    this.decorationsField.value = JSON.stringify(decorations);
                    document.getElementById('backgroundThemeField').value = backgroundTheme;

                    console.log('Submitting journal...');
                    console.log('Content:', message);
                    console.log('Decorations:', decorations);

                    // Submit the form
                    this.journalForm.submit();
                }
            }

            // Initialize when DOM is ready
            document.addEventListener('DOMContentLoaded', () => {
                new AutographWriter();
            });
        </script>

    </body>

    </html>