<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.autograph" %>
        <%@ page import="com.demo.web.model.autographEntry" %>
            <%@ page import="java.util.List" %>
                <% autograph ag=(autograph) request.getAttribute("autograph"); List<autographEntry> entries = (List
                    <autographEntry>) request.getAttribute("entries");
                        String shareToken = (String) request.getAttribute("shareToken");
                        %>

                        <jsp:include page="../public/header2.jsp" />
                        <html>

                        <head>
                            <title>
                                <%= ag !=null ? ag.getTitle() : "Shared Autograph" %>
                            </title>
                            <link rel="stylesheet" type="text/css"
                                href="${pageContext.request.contextPath}/resources/css/autographviewer.css">
                            <style>
                                .shared-badge {
                                    display: inline-block;
                                    padding: 4px 12px;
                                    background: rgba(154, 116, 216, 0.1);
                                    color: #9A74D8;
                                    border-radius: 12px;
                                    font-size: 12px;
                                    font-weight: 600;
                                    margin-bottom: 8px;
                                }

                                .btn-write {
                                    display: inline-block;
                                    padding: 10px 20px;
                                    background: #9A74D8;
                                    color: white !important;
                                    border-radius: 20px;
                                    text-decoration: none;
                                    font-weight: 600;
                                    transition: all 0.3s;
                                }

                                .btn-write:hover {
                                    background: #8e68cc;
                                    transform: translateY(-2px);
                                }
                            </style>
                        </head>

                        <body>
                            <div class="autograph-viewer-wrapper">
                                <div class="autograph-viewer-container">
                                    <!-- Navigation Header -->
                                    <div class="viewer-header">
                                        <div style="flex: 1;"></div>
                                        <div style="text-align: center;">
                                            <span class="shared-badge">Shared Autograph Book</span>
                                            <h1 class="book-title" id="bookTitle">
                                                <%= ag !=null ? ag.getTitle() : "Autograph Book" %>
                                            </h1>
                                        </div>
                                        <div style="flex: 1; text-align: right;">
                                            <a href="${pageContext.request.contextPath}/share/<%= shareToken %>"
                                                class="btn-write">
                                                Write Entry
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Page Viewer -->
                                    <div class="page-viewer">
                                        <button class="arrow-btn left-arrow" id="prevPage">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <polyline points="15 18 9 12 15 6"></polyline>
                                            </svg>
                                        </button>

                                        <div class="page-container" id="pageContainer">
                                            <div class="autograph-page" id="autographPage">
                                                <!-- Page Content -->
                                                <div class="page-content" id="pageContent">
                                                    <% if (entries==null || entries.isEmpty()) { %>
                                                        <div class="no-entries"
                                                            style="text-align: center; padding-top: 100px;">
                                                            <p style="font-size: 18px; color: #666;">No autographs yet.
                                                                Be the first to write one! ✨</p>
                                                            <a href="${pageContext.request.contextPath}/share/<%= shareToken %>"
                                                                style="display: inline-block; margin-top: 20px; padding: 12px 24px; background: #9A74D8; color: white; border-radius: 24px; text-decoration: none; font-weight: 600;">
                                                                Write Your Autograph
                                                            </a>
                                                        </div>
                                                        <% } %>
                                                </div>

                                                <!-- Page Number -->
                                                <div class="page-number" id="pageNumber"></div>
                                            </div>
                                        </div>

                                        <button class="arrow-btn right-arrow" id="nextPage">
                                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <polyline points="9 18 15 12 9 6"></polyline>
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <jsp:include page="../public/footer.jsp" />

                            <!-- Hidden data for JavaScript -->
                            <input type="hidden" id="entriesData" value='[<% 
    if (entries != null) {
        for (int i = 0; i < entries.size(); i++) {
            autographEntry entry = entries.get(i);
            // Escape double quotes and backslashes for JSON compatibility within single quotes
            String content = entry.getContent().replace("\\", "\\\\").replace("\"", "\\\"");
            // Replace newlines for JSON
            content = content.replace("\n", "\\n").replace("\r", "\\r");
%>{"content": "<%= content %>", "submittedAt": "<%= entry.getSubmittedAt() %>"}<%= i < entries.size() - 1 ? "," : "" %><% 
        }
    } 
%>]'>

                            <script>
                                class SharedAutographViewer {
                                    constructor() {
                                        try {
                                            const dataVal = document.getElementById('entriesData').value;
                                            this.entries = JSON.parse(dataVal);
                                        } catch (e) {
                                            console.error("Error parsing entries data", e);
                                            this.entries = [];
                                        }
                                        this.currentPageIndex = 0;
                                        this.initializeElements();
                                        this.attachEventListeners();

                                        if (this.entries.length > 0) {
                                            this.loadPage(0);
                                        }
                                    }

                                    initializeElements() {
                                        this.pageContentEl = document.getElementById('pageContent');
                                        this.pageNumberEl = document.getElementById('pageNumber');
                                    }

                                    attachEventListeners() {
                                        const prevBtn = document.getElementById('prevPage');
                                        const nextBtn = document.getElementById('nextPage');

                                        if (prevBtn) prevBtn.addEventListener('click', () => this.previousPage());
                                        if (nextBtn) nextBtn.addEventListener('click', () => this.nextPage());

                                        document.addEventListener('keydown', (e) => {
                                            if (e.key === 'ArrowLeft') this.previousPage();
                                            if (e.key === 'ArrowRight') this.nextPage();
                                        });
                                    }

                                    loadPage(index) {
                                        if (index < 0 || index >= this.entries.length) return;
                                        this.currentPageIndex = index;
                                        const entry = this.entries[index];

                                        // Parse content (format: Author: Message |DECORATIONS|JSON)
                                        let author = "Anonymous";
                                        let message = entry.content;
                                        let decorationsHtml = "";

                                        if (message.includes(': ')) {
                                            const parts = message.split(': ');
                                            author = parts[0];
                                            message = parts.slice(1).join(': ');
                                        }

                                        if (message.includes(' |DECORATIONS|')) {
                                            const parts = message.split(' |DECORATIONS|');
                                            message = parts[0];
                                            try {
                                                const decons = JSON.parse(parts[1]);
                                                decons.forEach(dec => {
                                                    decorationsHtml += `<span class="${dec.className}" style="position: absolute; top: ${dec.top}; left: ${dec.left};">${dec.content}</span>`;
                                                });
                                            } catch (e) { }
                                        }

                                        this.pageContentEl.style.opacity = '0';
                                        setTimeout(() => {
                                            this.pageContentEl.innerHTML = `
                    <div class="message-text">
                        <p class="main-message">${message}</p>
                        <div class="decorations">
                            ${decorationsHtml}
                        </div>
                        <div class="author-name">- ${author}</div>
                    </div>
                `;
                                            this.pageNumberEl.textContent = `Page ${index + 1} of ${this.entries.length}`;
                                            this.pageContentEl.style.opacity = '1';
                                        }, 300);
                                    }

                                    previousPage() {
                                        if (this.currentPageIndex > 0) {
                                            this.loadPage(this.currentPageIndex - 1);
                                        }
                                    }

                                    nextPage() {
                                        if (this.currentPageIndex < this.entries.length - 1) {
                                            this.loadPage(this.currentPageIndex + 1);
                                        }
                                    }
                                }

                                document.addEventListener('DOMContentLoaded', () => {
                                    new SharedAutographViewer();
                                });
                            </script>
                        </body>

                        </html>