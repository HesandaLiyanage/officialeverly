<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.autograph" %>
        <% autograph ag=(autograph) request.getAttribute("autograph"); String shareToken=(String)
            request.getAttribute("shareToken"); String displayTitle=(ag !=null) ? ag.getTitle() : "Autograph Book" ; %>

            <jsp:include page="../../public/header2.jsp" />
            <html>

            <head>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/writeautograph.css">
            </head>

            <body>

                <div class="write-autograph-wrapper">
                    <div class="write-autograph-container">
                        <!-- Header -->
                        <div class="write-header">
                            <h1 class="book-title">Write Your Autograph</h1>
                            <p class="book-subtitle">For <%= displayTitle %>
                            </p>
                        </div>

                        <!-- Main Content -->
                        <div class="write-content">
                            <!-- Toolbar -->
                            <div class="toolbar">
                                <div class="toolbar-section">
                                    <h3 class="toolbar-title">Text Formatting</h3>
                                    <div class="format-buttons">
                                        <button class="format-btn" id="boldBtn" title="Bold">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5">
                                                <path d="M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path>
                                                <path d="M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path>
                                            </svg>
                                        </button>
                                        <button class="format-btn" id="italicBtn" title="Italic">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5">
                                                <line x1="19" y1="4" x2="10" y2="4"></line>
                                                <line x1="14" y1="20" x2="5" y2="20"></line>
                                                <line x1="15" y1="4" x2="9" y2="20"></line>
                                            </svg>
                                        </button>
                                        <button class="format-btn" id="underlineBtn" title="Underline">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5">
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
                            </div>

                            <!-- Autograph Page -->
                            <div class="page-area">
                                <div class="autograph-page" id="autographPage">
                                    <!-- Red margin line -->
                                    <div class="margin-line"></div>

                                    <!-- Writing Area -->
                                    <div class="writing-area" id="writingArea" contenteditable="true"
                                        data-placeholder="Start writing your message...">
                                    </div>

                                    <!-- Decorations Container -->
                                    <div class="decorations-container" id="decorationsContainer">
                                        <!-- Draggable emojis/stickers will be added here -->
                                    </div>

                                    <!-- Author Name Input -->
                                    <div class="author-input-wrapper">
                                        <input type="text" class="author-input" id="authorInput"
                                            placeholder="- Your Name" maxlength="30">
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="action-buttons">
                                    <button class="action-btn cancel-btn" id="cancelBtn">Cancel</button>
                                    <button class="action-btn submit-btn" id="submitBtn">Submit Autograph</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <jsp:include page="../../public/footer.jsp" />

                <script>
                    class AutographWriter {
                        constructor() {
                            this.writingArea = document.getElementById('writingArea');
                            this.decorationsContainer = document.getElementById('decorationsContainer');
                            this.authorInput = document.getElementById('authorInput');
                            this.selectedElement = null;

                            this.initializeFormatting();
                            this.initializeEmojis();
                            this.initializeDoodles();
                            this.initializeButtons();
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
                            let currentX;
                            let currentY;
                            let initialX;
                            let initialY;
                            let xOffset = 0;
                            let yOffset = 0;

                            element.addEventListener('mousedown', (e) => {
                                initialX = e.clientX - xOffset;
                                initialY = e.clientY - yOffset;

                                if (e.target === element) {
                                    isDragging = true;
                                    element.style.cursor = 'grabbing';
                                    element.style.zIndex = '1000';
                                }
                            });

                            document.addEventListener('mousemove', (e) => {
                                if (isDragging) {
                                    e.preventDefault();
                                    currentX = e.clientX - initialX;
                                    currentY = e.clientY - initialY;

                                    xOffset = currentX;
                                    yOffset = currentY;

                                    const rect = this.decorationsContainer.getBoundingClientRect();
                                    const percentX = (currentX / rect.width) * 100;
                                    const percentY = (currentY / rect.height) * 100;

                                    element.style.left = percentX + '%';
                                    element.style.top = percentY + '%';
                                }
                            });

                            document.addEventListener('mouseup', () => {
                                initialX = currentX;
                                initialY = currentY;
                                isDragging = false;
                                element.style.cursor = 'grab';
                                element.style.zIndex = '5';
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
                                if (confirm('Are you sure you want to cancel? Your autograph will be lost.')) {
                                    window.history.back();
                                }
                            });

                            submitBtn.addEventListener('click', () => {
                                this.submitAutograph();
                            });
                        }

                        submitAutograph() {
                            const message = this.writingArea.innerHTML.trim();
                            const author = this.authorInput.value.trim();

                            if (!message || message === '<br>') {
                                alert('Please write a message!');
                                this.writingArea.focus();
                                return;
                            }

                            if (!author) {
                                alert('Please enter your name!');
                                this.authorInput.focus();
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

                            // Populated hidden form
                            document.getElementById('contentField').value = message;
                            document.getElementById('authorField').value = author;
                            document.getElementById('decorationsField').value = JSON.stringify(decorations);

                            console.log('Submitting autograph via form');
                            document.getElementById('autographForm').submit();
                        }
                    }

                    // Initialize when DOM is ready
                    document.addEventListener('DOMContentLoaded', () => {
                        new AutographWriter();
                    });
                </script>
                <form id="autographForm" action="${pageContext.request.contextPath}/submit-autograph" method="post"
                    style="display: none;">

                    <input type="hidden" name="token" value="<%= shareToken %>">
                    <input type="hidden" name="content" id="contentField">
                    <input type="hidden" name="author" id="authorField">
                    <input type="hidden" name="decorations" id="decorationsField">
                </form>

            </body>

            </html>