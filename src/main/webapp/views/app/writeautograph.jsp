<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.dao.autographDAO" %>
        <%@ page import="com.demo.web.model.autograph" %>
            <%@ page import="com.demo.web.dao.userDAO" %>
                <%@ page import="com.demo.web.model.user" %>
                    <% String shareToken=request.getParameter("token"); String bookTitle="Autograph Book" ; String
                        ownerName="" ; boolean validToken=false; if (shareToken !=null && !shareToken.isEmpty()) { try {
                        autographDAO agDao=new autographDAO(); autograph ag=agDao.getAutographByShareToken(shareToken);
                        if (ag !=null) { validToken=true; bookTitle=ag.getTitle() !=null ? ag.getTitle()
                        : "Autograph Book" ; userDAO uDao=new userDAO(); user owner=uDao.findById(ag.getUserId()); if
                        (owner !=null && owner.getUsername() !=null) { ownerName=owner.getUsername(); } } } catch
                        (Exception e) { e.printStackTrace(); } } if (!validToken) {
                        response.sendRedirect(request.getContextPath() + "/autographs" ); return; }
                        request.setAttribute("_shareToken", shareToken); request.setAttribute("_bookTitle", bookTitle);
                        request.setAttribute("_ownerName", ownerName); %>
                        <jsp:include page="../public/header2.jsp" />
                        <html>

                        <head>
                            <link rel="stylesheet" type="text/css"
                                href="${pageContext.request.contextPath}/resources/css/writeautograph.css">
                        </head>

                        <body>
                            <div class="write-autograph-wrapper">
                                <div class="write-autograph-container">
                                    <div class="write-header">
                                        <h1 class="book-title">Write Your Autograph</h1>
                                        <p class="book-subtitle">For ${_ownerName}'s ${_bookTitle}</p>
                                    </div>
                                    <div class="write-content">
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
                                                <h3 class="toolbar-title">Emojis &amp; Stickers</h3>
                                                <div class="emoji-grid" id="emojiGrid">
                                                    <button class="emoji-btn"
                                                        data-emoji="&#10084;&#65039;">&#10084;&#65039;</button>
                                                    <button class="emoji-btn" data-emoji="&#128156;">&#128156;</button>
                                                    <button class="emoji-btn" data-emoji="&#10024;">&#10024;</button>
                                                    <button class="emoji-btn" data-emoji="&#127775;">&#127775;</button>
                                                    <button class="emoji-btn" data-emoji="&#128171;">&#128171;</button>
                                                    <button class="emoji-btn" data-emoji="&#127881;">&#127881;</button>
                                                    <button class="emoji-btn" data-emoji="&#127882;">&#127882;</button>
                                                    <button class="emoji-btn" data-emoji="&#127880;">&#127880;</button>
                                                    <button class="emoji-btn" data-emoji="&#127752;">&#127752;</button>
                                                    <button class="emoji-btn" data-emoji="&#127800;">&#127800;</button>
                                                    <button class="emoji-btn" data-emoji="&#127802;">&#127802;</button>
                                                    <button class="emoji-btn" data-emoji="&#127803;">&#127803;</button>
                                                    <button class="emoji-btn"
                                                        data-emoji="&#9728;&#65039;">&#9728;&#65039;</button>
                                                    <button class="emoji-btn" data-emoji="&#11088;">&#11088;</button>
                                                    <button class="emoji-btn" data-emoji="&#127891;">&#127891;</button>
                                                    <button class="emoji-btn" data-emoji="&#128218;">&#128218;</button>
                                                    <button class="emoji-btn"
                                                        data-emoji="&#9999;&#65039;">&#9999;&#65039;</button>
                                                    <button class="emoji-btn" data-emoji="&#127912;">&#127912;</button>
                                                    <button class="emoji-btn" data-emoji="&#129419;">&#129419;</button>
                                                    <button class="emoji-btn" data-emoji="&#127925;">&#127925;</button>
                                                </div>
                                            </div>
                                            <div class="toolbar-section">
                                                <h3 class="toolbar-title">Doodles</h3>
                                                <div class="doodle-grid">
                                                    <button class="doodle-btn" data-doodle="&#9825;"
                                                        data-type="heart">&#9825;</button>
                                                    <button class="doodle-btn" data-doodle="&#9733;"
                                                        data-type="star">&#9733;</button>
                                                    <button class="doodle-btn" data-doodle="&#9834;"
                                                        data-type="music">&#9834;</button>
                                                    <button class="doodle-btn" data-doodle="&#9734;"
                                                        data-type="star">&#9734;</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="page-area">
                                            <div class="autograph-page" id="autographPage">
                                                <div class="margin-line"></div>
                                                <div class="writing-area" id="writingArea" contenteditable="true"
                                                    data-placeholder="Start writing your message..."></div>
                                                <div class="decorations-container" id="decorationsContainer"></div>
                                                <div class="author-input-wrapper">
                                                    <input type="text" class="author-input" id="authorInput"
                                                        placeholder="- Your Name" maxlength="30">
                                                </div>
                                            </div>
                                            <div class="action-buttons">
                                                <button class="action-btn cancel-btn" id="cancelBtn">Cancel</button>
                                                <button class="action-btn submit-btn" id="submitBtn">Submit
                                                    Autograph</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <jsp:include page="../public/footer.jsp" />
                            <input type="hidden" id="shareTokenValue" value="${_shareToken}" />
                            <input type="hidden" id="contextPathValue" value="${pageContext.request.contextPath}" />
                            <script>
                                class AutographWriter {
                                    constructor() {
                                        this.writingArea = document.getElementById('writingArea');
                                        this.decorationsContainer = document.getElementById('decorationsContainer');
                                        this.authorInput = document.getElementById('authorInput');
                                        this.selectedElement = null;
                                        this.shareToken = document.getElementById('shareTokenValue').value;
                                        this.contextPath = document.getElementById('contextPathValue').value;
                                        this.initializeFormatting();
                                        this.initializeEmojis();
                                        this.initializeDoodles();
                                        this.initializeButtons();
                                    }
                                    initializeFormatting() {
                                        var boldBtn = document.getElementById('boldBtn');
                                        var italicBtn = document.getElementById('italicBtn');
                                        var underlineBtn = document.getElementById('underlineBtn');
                                        var self = this;
                                        boldBtn.addEventListener('click', function () { document.execCommand('bold', false, null); self.writingArea.focus(); });
                                        italicBtn.addEventListener('click', function () { document.execCommand('italic', false, null); self.writingArea.focus(); });
                                        underlineBtn.addEventListener('click', function () { document.execCommand('underline', false, null); self.writingArea.focus(); });
                                    }
                                    initializeEmojis() {
                                        var emojiButtons = document.querySelectorAll('.emoji-btn');
                                        var self = this;
                                        emojiButtons.forEach(function (btn) {
                                            btn.addEventListener('click', function () { self.addDecoration(btn.getAttribute('data-emoji'), 'emoji'); });
                                        });
                                    }
                                    initializeDoodles() {
                                        var doodleButtons = document.querySelectorAll('.doodle-btn');
                                        var self = this;
                                        doodleButtons.forEach(function (btn) {
                                            btn.addEventListener('click', function () { self.addDecoration(btn.getAttribute('data-doodle'), 'doodle', btn.getAttribute('data-type')); });
                                        });
                                    }
                                    addDecoration(content, className, type) {
                                        type = type || '';
                                        var decoration = document.createElement('div');
                                        decoration.className = 'decoration ' + className;
                                        if (type) decoration.classList.add(type);
                                        decoration.textContent = content;
                                        decoration.draggable = true;
                                        decoration.style.top = (Math.random() * 60 + 10) + '%';
                                        decoration.style.left = (Math.random() * 70 + 10) + '%';
                                        this.makeDraggable(decoration);
                                        this.decorationsContainer.appendChild(decoration);
                                    }
                                    makeDraggable(element) {
                                        var isDragging = false;
                                        var startMouseX, startMouseY, startLeft, startTop;
                                        var self = this;
                                        element.addEventListener('mousedown', function (e) {
                                            if (e.target === element) {
                                                isDragging = true;
                                                element.style.cursor = 'grabbing';
                                                element.style.zIndex = '1000';
                                                var containerRect = self.decorationsContainer.getBoundingClientRect();
                                                var elemRect = element.getBoundingClientRect();
                                                startMouseX = e.clientX;
                                                startMouseY = e.clientY;
                                                startLeft = elemRect.left - containerRect.left;
                                                startTop = elemRect.top - containerRect.top;
                                                e.preventDefault();
                                            }
                                        });
                                        document.addEventListener('mousemove', function (e) {
                                            if (isDragging) {
                                                e.preventDefault();
                                                var containerRect = self.decorationsContainer.getBoundingClientRect();
                                                var newLeft = startLeft + (e.clientX - startMouseX);
                                                var newTop = startTop + (e.clientY - startMouseY);
                                                element.style.left = ((newLeft / containerRect.width) * 100) + '%';
                                                element.style.top = ((newTop / containerRect.height) * 100) + '%';
                                            }
                                        });
                                        document.addEventListener('mouseup', function () {
                                            if (isDragging) {
                                                isDragging = false;
                                                element.style.cursor = 'grab';
                                                element.style.zIndex = '5';
                                            }
                                        });
                                        element.addEventListener('dblclick', function () { element.remove(); });
                                        element.style.cursor = 'grab';
                                    }
                                    initializeButtons() {
                                        var cancelBtn = document.getElementById('cancelBtn');
                                        var submitBtn = document.getElementById('submitBtn');
                                        var self = this;
                                        cancelBtn.addEventListener('click', function () {
                                            if (confirm('Are you sure you want to cancel? Your autograph will be lost.')) { window.history.back(); }
                                        });
                                        submitBtn.addEventListener('click', function () { self.submitAutograph(); });
                                    }
                                    submitAutograph() {
                                        var message = this.writingArea.innerHTML.trim();
                                        var author = this.authorInput.value.trim();
                                        if (!message || message === '<br>') { alert('Please write a message!'); this.writingArea.focus(); return; }
                                        if (!author) { alert('Please enter your name!'); this.authorInput.focus(); return; }
                                        var submitBtn = document.getElementById('submitBtn');
                                        submitBtn.disabled = true;
                                        submitBtn.textContent = 'Submitting...';

                                        // Capture full canvas state
                                        var page = document.getElementById('autographPage');
                                        var pageRect = page.getBoundingClientRect();
                                        var canvasWidth = pageRect.width;
                                        var canvasHeight = pageRect.height;

                                        // Build elements array
                                        var elements = [];
                                        var elemId = 0;

                                        // Add the text content as an element
                                        elements.push({
                                            id: 'elem_' + (elemId++),
                                            type: 'text',
                                            content: message,
                                            x_pct: 0,
                                            y_pct: 0
                                        });

                                        // Add each decoration (emoji/doodle) with its position
                                        var decorations = document.querySelectorAll('.decoration');
                                        decorations.forEach(function (dec) {
                                            var decType = 'emoji';
                                            var classList = dec.className || '';
                                            if (classList.indexOf('doodle') !== -1) decType = 'doodle';
                                            var subType = '';
                                            if (classList.indexOf('heart') !== -1) subType = 'heart';
                                            else if (classList.indexOf('star') !== -1) subType = 'star';
                                            else if (classList.indexOf('music') !== -1) subType = 'music';
                                            elements.push({
                                                id: 'elem_' + (elemId++),
                                                type: decType,
                                                sub_type: subType,
                                                content: dec.textContent,
                                                top_pct: dec.style.top,
                                                left_pct: dec.style.left
                                            });
                                        });

                                        var entryData = {
                                            canvas: { width: Math.round(canvasWidth), height: Math.round(canvasHeight) },
                                            elements: elements,
                                            author: author
                                        };

                                        var formData = new URLSearchParams();
                                        formData.append('token', this.shareToken);
                                        formData.append('message', message);
                                        formData.append('author', author);
                                        formData.append('entry_data', JSON.stringify(entryData));
                                        var cp = this.contextPath;
                                        fetch(cp + '/submitAutographEntry', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                            body: formData.toString()
                                        })
                                            .then(function (resp) { return resp.json(); })
                                            .then(function (data) {
                                                if (data.success) {
                                                    alert('Your autograph has been submitted!');
                                                    window.location.href = cp + '/autographs';
                                                } else {
                                                    alert('Error: ' + data.message);
                                                    submitBtn.disabled = false;
                                                    submitBtn.textContent = 'Submit Autograph';
                                                }
                                            })
                                            .catch(function (err) {
                                                console.error('Submit error:', err);
                                                alert('Error submitting autograph. Please try again.');
                                                submitBtn.disabled = false;
                                                submitBtn.textContent = 'Submit Autograph';
                                            });
                                    }
                                }
                                document.addEventListener('DOMContentLoaded', function () { new AutographWriter(); });
                            </script>
                        </body>

                        </html>