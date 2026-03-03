<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web.model.Journal" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonElement" %>

<%
    // Retrieve the Journal object from the request attribute set by the logic handler
    Journal journal = (Journal) request.getAttribute("journal");
    String errorMessage = (String) request.getAttribute("error");

    String existingTitle = "";
    String existingHtmlContent = "";
    String existingDecorationsJson = "[]";

    if (journal != null) {
        existingTitle = journal.getTitle();
        String rawContent = journal.getContent();
        if (rawContent != null) {
            try {
                // Parse the JSON content string to extract htmlContent and decorations
                Gson gson = new Gson();
                JsonObject contentObj = gson.fromJson(rawContent, JsonObject.class);
                existingHtmlContent = contentObj.get("htmlContent").getAsString();
                JsonElement decorationsElement = contentObj.get("decorations");

                if (decorationsElement != null && !decorationsElement.isJsonNull() && decorationsElement.isJsonArray()) {
                    existingDecorationsJson = decorationsElement.toString();
                }
            } catch (Exception e) {
                System.out.println("Error parsing journal content JSON for edit: " + e.getMessage());
                // Set error message if parsing fails
                errorMessage = "Error loading journal content for editing: " + e.getMessage();
            }
        }
    }
%>

<%@ page errorPage="/views/public/500.jsp" %>

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
            <h1 class="book-title">Edit Your Journal</h1>
            <p class="book-subtitle">Editing: <%= existingTitle %></p>
        </div>

        <%-- Display Error Message if present --%>
        <% if (errorMessage != null) { %>
        <div style="background: #fee; border: 1px solid #fcc; padding: 12px; border-radius: 8px; margin: 10px 30px; color: #c00;">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            <%= errorMessage %>
        </div>
        <% } %>

        <!-- Main Content -->
        <div class="write-content">
            <!-- Toolbar -->
            <div class="toolbar">
                <div class="toolbar-section">
                    <h3 class="toolbar-title">Text Formatting</h3>
                    <div class="format-buttons">
                        <button class="format-btn" id="boldBtn" title="Bold">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <path d="M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path>
                                <path d="M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path>
                            </svg>
                        </button>
                        <button class="format-btn" id="italicBtn" title="Italic">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="19" y1="4" x2="10" y2="4"></line>
                                <line x1="14" y1="20" x2="5" y2="20"></line>
                                <line x1="15" y1="4" x2="9" y2="20"></line>
                            </svg>
                        </button>
                        <button class="format-btn" id="underlineBtn" title="Underline">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
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
                    <div class="writing-area" id="writingArea" contenteditable="true" data-placeholder="Start writing your message...">
                        <%= existingHtmlContent %>
                    </div>

                    <!-- Decorations Container -->
                    <div class="decorations-container" id="decorationsContainer">
                        <!-- Decorations will be loaded here by JavaScript -->
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/journalview?id=<%= journal != null ? journal.getJournalId() : "" %>" class="action-btn cancel-btn" id="cancelBtn">Cancel</a>
                    <button class="action-btn submit-btn" id="submitBtn">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Hidden form for submission -->
<form id="journalForm" action="${pageContext.request.contextPath}/editjournal" method="post">
    <input type="hidden" name="journalId" value="<%= journal != null ? journal.getJournalId() : "" %>">
    <input type="hidden" name="content" id="contentField">
    <input type="hidden" name="decorations" id="decorationsField">
    <!-- Optional: Include a hidden input for title if you want to allow title editing -->
    <!-- <input type="hidden" name="title" id="titleField"> -->
</form>

<jsp:include page="../public/footer.jsp" />

<script>
    class AutographWriter {
        constructor(htmlContent, decorationsJson) {
            this.writingArea = document.getElementById('writingArea');
            this.decorationsContainer = document.getElementById('decorationsContainer');
            this.journalForm = document.getElementById('journalForm');
            this.contentField = document.getElementById('contentField');
            this.decorationsField = document.getElementById('decorationsField');
            this.selectedElement = null;

            // Pre-populate decorations from server data
            this.loadExistingDecorations(decorationsJson);

            this.initializeFormatting();
            this.initializeEmojis();
            this.initializeDoodles();
            this.initializeButtons();
        }

        loadExistingDecorations(decorationsJson) {
            if (!decorationsJson) return;

            try {
                const decorations = JSON.parse(decorationsJson);
                if (Array.isArray(decorations)) {
                    decorations.forEach(dec => {
                        const decoration = document.createElement('div');
                        decoration.className = `decoration ${dec.className}`;
                        decoration.textContent = dec.content;
                        decoration.draggable = true;

                        // Set position from saved data
                        decoration.style.top = dec.top;
                        decoration.style.left = dec.left;

                        // Make it draggable
                        this.makeDraggable(decoration);

                        this.decorationsContainer.appendChild(decoration);
                    });
                }
            } catch (e) {
                console.error('Error loading existing decorations:', e);
            }
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

            // Random initial position if not specified (e.g., for new additions)
            if (!decoration.style.top || !decoration.style.left) {
                const randomTop = Math.random() * 60 + 10;
                const randomLeft = Math.random() * 70 + 10;
                decoration.style.top = randomTop + '%';
                decoration.style.left = randomLeft + '%';
            }

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
            const submitBtn = document.getElementById('submitBtn');

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

            // Set hidden form fields
            this.contentField.value = message;
            this.decorationsField.value = JSON.stringify(decorations);

            console.log('Submitting journal edit...');
            console.log('Content:', message);
            console.log('Decorations:', decorations);

            // Submit the form
            this.journalForm.submit();
        }
    }

    // Initialize when DOM is ready, passing existing content and decorations
    document.addEventListener('DOMContentLoaded', () => {
        new AutographWriter(`<%= existingHtmlContent.replace("\\", "\\\\").replace("\"", "\\\"") %>`, `<%= existingDecorationsJson.replace("\\", "\\\\").replace("\"", "\\\"") %>`);
    });
</script>

</body>
</html>