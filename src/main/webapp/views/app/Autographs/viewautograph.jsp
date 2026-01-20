<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <% request.setCharacterEncoding("UTF-8"); response.setCharacterEncoding("UTF-8"); %>
        <%@ page import="com.demo.web.model.AutographEntry" %>
            <%@ page import="java.util.List" %>
                <%@ page import="com.google.gson.Gson" %>
                    <jsp:include page="../../public/header2.jsp" />
                    <% List<AutographEntry> entries = (List<AutographEntry>) request.getAttribute("entries");
                            Gson gson = new com.google.gson.GsonBuilder()
                            .disableHtmlEscaping()
                            .create();
                            String entriesJson = gson.toJson(entries != null ? entries :
                            java.util.Collections.emptyList());
                            %>
                            <html>

                            <head>
                                <link rel="stylesheet" type="text/css"
                                    href="${pageContext.request.contextPath}/resources/css/autographviewer.css">
                                <style>
                                    .floating-buttons {
                                        position: fixed;
                                        bottom: 30px;
                                        right: 30px;
                                        display: flex;
                                        flex-direction: column;
                                        gap: 12px;
                                        z-index: 100;
                                    }

                                    .floating-btn {
                                        display: inline-flex;
                                        align-items: center;
                                        justify-content: center;
                                        gap: 10px;
                                        padding: 12px 24px;
                                        border: none;
                                        border-radius: 24px;
                                        background: #9A74D8;
                                        box-shadow: 0 4px 14px rgba(154, 116, 216, 0.35);
                                        font-family: "Plus Jakarta Sans", sans-serif;
                                        font-size: 15px;
                                        font-weight: 600;
                                        color: #ffffff;
                                        cursor: pointer;
                                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                                        text-decoration: none;
                                        white-space: nowrap;
                                        min-width: 140px;
                                    }

                                    .floating-btn:hover {
                                        background: #8a64c8;
                                        transform: translateY(-2px);
                                    }

                                    .floating-btn.delete-btn {
                                        background: #EADDFF;
                                        color: #9A74D8;
                                    }

                                    .rich-autograph-entry {
                                        position: relative;
                                        width: 100%;
                                        height: 600px;
                                        min-height: 600px;
                                        box-sizing: border-box;
                                    }

                                    .message-text {
                                        font-size: 1.2rem;
                                        line-height: 1.6;
                                        margin-bottom: 20px;
                                        white-space: pre-wrap;
                                        position: absolute;
                                    }

                                    .author-signature {
                                        text-align: right;
                                        font-style: italic;
                                        font-weight: 600;
                                        position: absolute;
                                        color: #6b7280;
                                        font-size: 17px;
                                    }

                                    .decorations-container {
                                        position: absolute;
                                        top: 0;
                                        left: 0;
                                        width: 100%;
                                        height: 100%;
                                        pointer-events: none;
                                    }

                                    .decoration {
                                        position: absolute;
                                        font-size: 2rem;
                                    }

                                    .emoji {
                                        font-size: 2.5rem;
                                    }

                                    .doodle {
                                        font-size: 3rem;
                                    }
                                </style>
                            </head>

                            <body>
                                <div class="autograph-viewer-wrapper">
                                    <div class="autograph-viewer-container">
                                        <div class="viewer-header">
                                            <button class="nav-btn" id="prevPage">Previous</button>
                                            <h1 class="book-title" id="bookTitle">${autograph.title}</h1>
                                            <button class="nav-btn" id="nextPage">Next</button>
                                        </div>
                                        <div class="page-viewer">
                                            <div class="page-container">
                                                <div class="autograph-page">
                                                    <div class="page-content" id="pageContent"></div>
                                                    <div class="page-number" id="pageNumber"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <form id="deleteAutographForm"
                                    action="${pageContext.request.contextPath}/deleteautograph" method="post"
                                    style="display: none;">
                                    <input type="hidden" name="autographId" value="${autograph.autographId}">
                                </form>

                                <div class="floating-buttons">
                                    <a href="/editautograph?id=${autograph.autographId}" class="floating-btn">Edit</a>
                                    <button class="floating-btn delete-btn" id="deleteBtn">Delete</button>
                                </div>

                                <div id="entriesData" style="display: none;">
                                    <%= entriesJson %>
                                </div>
                                <jsp:include page="../../public/footer.jsp" />


                                <script>
                                    class AutographViewer {
                                        constructor(pages) {
                                            this.pages = pages;
                                            this.currentIndex = 0;
                                            this.pageContentEl = document.getElementById('pageContent');
                                            this.pageNumberEl = document.getElementById('pageNumber');
                                            this.attachListeners();
                                            this.render();
                                        }
                                        attachListeners() {
                                            document.getElementById('prevPage').addEventListener('click', () => this.prev());
                                            document.getElementById('nextPage').addEventListener('click', () => this.next());
                                        }
                                        prev() { if (this.currentIndex > 0) { this.currentIndex--; this.render(); } }
                                        next() { if (this.currentIndex < this.pages.length - 1) { this.currentIndex++; this.render(); } }
                                        render() {
                                            if (this.pages.length === 0) {
                                                this.pageContentEl.innerHTML = "<div class='no-entries'>No entries yet.</div>";
                                                this.pageNumberEl.textContent = "0/0";
                                                return;
                                            }
                                            const page = this.pages[this.currentIndex];
                                            this.pageContentEl.innerHTML = page.content;
                                            this.pageNumberEl.textContent = "Page " + (this.currentIndex + 1) + " of " + this.pages.length;
                                        }
                                    }

                                    document.addEventListener('DOMContentLoaded', () => {
                                        // Extract data from hidden div
                                        const entriesText = document.getElementById('entriesData').textContent;
                                        const rawEntries = JSON.parse(entriesText || '[]');
                                        const pages = rawEntries.map(entry => ({
                                            content: entry.content
                                        }));

                                        new AutographViewer(pages);

                                        document.getElementById('deleteBtn')?.addEventListener('click', () => {
                                            if (confirm('Delete?')) document.getElementById('deleteAutographForm').submit();
                                        });
                                    });
                                </script>
                            </body>

                            </html>