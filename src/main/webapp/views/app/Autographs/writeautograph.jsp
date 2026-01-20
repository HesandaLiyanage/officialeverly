<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <% request.setCharacterEncoding("UTF-8"); response.setCharacterEncoding("UTF-8"); %>
        <%@ page import="com.demo.web.model.autograph" %>
            <% autograph ag=(autograph) request.getAttribute("autograph"); String shareToken=(String)
                request.getAttribute("shareToken"); String displayTitle=(ag !=null) ? ag.getTitle() : "Autograph Book" ;
                %>

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
                                this.initializeDraggableText();
                                this.initializeButtons();
                            }

                            initializeDraggableText() {
                                // Initial positions for dragging logic
                                this.writingArea.style.position = 'absolute';
                                this.writingArea.style.top = '10%';
                                this.writingArea.style.left = '10%';
                                this.writingArea.style.width = '80%';
                                this.makeDraggable(this.writingArea, true);

                                const authorWrapper = this.authorInput.parentElement;
                                authorWrapper.style.position = 'absolute';
                                authorWrapper.style.bottom = 'auto';
                                authorWrapper.style.right = 'auto';
                                authorWrapper.style.top = '85%';
                                authorWrapper.style.left = '60%';
                                this.makeDraggable(authorWrapper);
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

                            makeDraggable(element, isWritingArea = false) {
                                let isDragging = false;
                                let currentX;
                                let currentY;
                                let initialX;
                                let initialY;
                                let xOffset = 0;
                                let yOffset = 0;

                                const updateOffsets = () => {
                                    const rect = document.getElementById('autographPage').getBoundingClientRect();
                                    xOffset = (parseFloat(element.style.left) / 100) * rect.width;
                                    yOffset = (parseFloat(element.style.top) / 100) * rect.height;
                                };

                                element.addEventListener('mousedown', (e) => {
                                    if (isWritingArea) {
                                        const rect = element.getBoundingClientRect();
                                        const relativeX = e.clientX - rect.left;
                                        const relativeY = e.clientY - rect.top;
                                        if (relativeX > 30 && relativeY > 30) return;
                                    }

                                    updateOffsets();
                                    initialX = e.clientX - xOffset;
                                    initialY = e.clientY - yOffset;

                                    if (e.target === element || element.contains(e.target)) {
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

                                        const rect = document.getElementById('autographPage').getBoundingClientRect();
                                        let percentX = (currentX / rect.width) * 100;
                                        let percentY = (currentY / rect.height) * 100;

                                        percentX = Math.max(0, Math.min(95, percentX));
                                        percentY = Math.max(0, Math.min(95, percentY));

                                        element.style.left = percentX + '%';
                                        element.style.top = percentY + '%';

                                        xOffset = (percentX / 100) * rect.width;
                                        yOffset = (percentY / 100) * rect.height;
                                    }
                                });

                                document.addEventListener('mouseup', () => {
                                    if (isDragging) {
                                        isDragging = false;
                                        element.style.cursor = 'grab';
                                        element.style.zIndex = isWritingArea ? '2' : '10';
                                    }
                                });

                                element.addEventListener('dblclick', () => {
                                    if (!isWritingArea && !element.id.includes('author')) element.remove();
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

                                // Clone the page area for cleaning
                                const pageClone = document.getElementById('autographPage').cloneNode(true);

                                // Remove internal structure that isn't needed for viewing
                                const marginLine = pageClone.querySelector('.margin-line');
                                if (marginLine) marginLine.remove();

                                // Transform writing area to static div
                                const writingAreaClone = pageClone.querySelector('#writingArea');
                                writingAreaClone.removeAttribute('contenteditable');
                                writingAreaClone.removeAttribute('data-placeholder');
                                writingAreaClone.id = ''; // Remove ID to prevent duplicates in view
                                writingAreaClone.className = 'message-text';

                                // Transform author input to static div
                                const authorInputClone = pageClone.querySelector('#authorInput');
                                const authorWrapperClone = authorInputClone.parentElement;
                                const authorDiv = document.createElement('div');
                                authorDiv.className = 'author-signature';
                                authorDiv.textContent = '- ' + author;
                                authorWrapperClone.replaceChild(authorDiv, authorInputClone);

                                // Ensure all positioning styles are set as inline styles (not relying on CSS)
                                const decorationsContainerClone = pageClone.querySelector('.decorations-container');
                                if (decorationsContainerClone) {
                                    decorationsContainerClone.className = 'decorations'; // Match viewer CSS
                                    decorationsContainerClone.style.position = 'absolute';
                                    decorationsContainerClone.style.top = '0';
                                    decorationsContainerClone.style.left = '0';
                                    decorationsContainerClone.style.width = '100%';
                                    decorationsContainerClone.style.height = '100%';
                                    decorationsContainerClone.style.pointerEvents = 'none';

                                    // Add position:absolute to each decoration
                                    const decorations = decorationsContainerClone.querySelectorAll('.decoration');
                                    decorations.forEach(d => {
                                        d.style.position = 'absolute';
                                        d.style.zIndex = '5';
                                    });
                                }

                                // Ensure writing area and author also have explicit inline positioning
                                if (writingAreaClone) {
                                    writingAreaClone.style.position = 'absolute';
                                    writingAreaClone.style.zIndex = '2';
                                }
                                if (authorWrapperClone) {
                                    authorWrapperClone.style.position = 'absolute';
                                    authorWrapperClone.style.zIndex = '10';
                                }

                                // Capture the full HTML content
                                const fullContentHtml = pageClone.innerHTML;

                                // DEBUG: Log the captured HTML to verify positioning is preserved
                                console.log('=== Captured HTML Content ===');
                                console.log(fullContentHtml);
                                console.log('=== End Captured HTML ===');

                                const formData = new URLSearchParams();
                                formData.append('token', '<%= shareToken %>');
                                formData.append('content', fullContentHtml);
                                formData.append('author', author);
                                // We still send plain content for indexing or fallback if needed
                                formData.append('contentPlain', message);

                                const submitBtn = document.getElementById('submitBtn');
                                const originalBtnText = submitBtn.textContent;
                                submitBtn.disabled = true;
                                submitBtn.textContent = 'Uploading...';

                                fetch('${pageContext.request.contextPath}/submit-autograph', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: formData
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            alert('Entry uploaded successfully!');
                                            // Clear current entries to allow a fresh one
                                            this.writingArea.innerHTML = '';
                                            this.authorInput.value = '';
                                            this.decorationsContainer.innerHTML = '';
                                        } else {
                                            alert('Error: ' + (data.message || 'Failed to save entry'));
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert('An error occurred while submitting.');
                                    })
                                    .finally(() => {
                                        submitBtn.disabled = false;
                                        submitBtn.textContent = originalBtnText;
                                    });
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