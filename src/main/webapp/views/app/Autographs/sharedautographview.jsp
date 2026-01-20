<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <% request.setCharacterEncoding("UTF-8"); response.setCharacterEncoding("UTF-8"); %>
        <%@ page import="com.demo.web.model.autograph" %>
            <%@ page import="com.demo.web.model.AutographEntry" %>
                <%@ page import="java.util.List" %>
                    <% autograph ag=(autograph) request.getAttribute("autograph"); List<AutographEntry> entries = (List
                        <AutographEntry>) request.getAttribute("entries");
                            String shareToken = (String) request.getAttribute("shareToken");
                            String title = (ag != null) ? ag.getTitle() : "Autograph Book";
                            %>

                            <jsp:include page="../../public/header2.jsp" />
                            <html>

                            <head>
                                <link rel="stylesheet" type="text/css"
                                    href="${pageContext.request.contextPath}/resources/css/viewautograph.css">
                                <style>
                                    .shared-view-header {
                                        text-align: center;
                                        padding: 40px 20px;
                                        background: linear-gradient(135deg, #6e8efb, #a777e3);
                                        color: white;
                                        border-bottom-left-radius: 30px;
                                        border-bottom-right-radius: 30px;
                                        margin-bottom: 30px;
                                    }

                                    .entries-container {
                                        max-width: 1000px;
                                        margin: 0 auto;
                                        padding: 20px;
                                        display: grid;
                                        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                                        gap: 25px;
                                    }

                                    .entry-card {
                                        background: white;
                                        padding: 25px;
                                        border-radius: 20px;
                                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                                        position: relative;
                                        min-height: 200px;
                                        display: flex;
                                        flex-direction: column;
                                        justify-content: space-between;
                                        transition: transform 0.3s ease;
                                    }

                                    .entry-card:hover {
                                        transform: translateY(-5px);
                                    }

                                    .entry-content {
                                        font-family: 'Inter', sans-serif;
                                        font-size: 1.1rem;
                                        line-height: 1.6;
                                        color: #333;
                                        white-space: pre-wrap;
                                        position: relative;
                                        width: 100%;
                                        height: 100%;
                                    }

                                    /* Ensure generated absolute elements stay within the card */
                                    .rich-autograph-entry {
                                        position: relative !important;
                                        height: 600px !important;
                                        min-height: 600px !important;
                                    }

                                    .entry-date {
                                        font-size: 0.85rem;
                                        color: #888;
                                        margin-top: 15px;
                                        text-align: right;
                                    }

                                    .no-entries {
                                        text-align: center;
                                        padding: 50px;
                                        color: #666;
                                        grid-column: 1 / -1;
                                    }

                                    .back-to-write {
                                        display: inline-block;
                                        margin-top: 20px;
                                        padding: 12px 25px;
                                        background: white;
                                        color: #6e8efb;
                                        border-radius: 30px;
                                        text-decoration: none;
                                        font-weight: 600;
                                        transition: all 0.3s ease;
                                    }

                                    .back-to-write:hover {
                                        background: #f8f9fa;
                                        transform: scale(1.05);
                                    }
                                </style>
                            </head>

                            <body>

                                <div class="shared-view-header">
                                    <h1>
                                        <%= title %>
                                    </h1>
                                    <p>Viewing all entries in this autograph book</p>
                                    <a href="${pageContext.request.contextPath}/share/<%= shareToken %>"
                                        class="back-to-write">Write an Autograph</a>
                                </div>

                                <div class="entries-container">
                                    <% if (entries !=null && !entries.isEmpty()) { for (AutographEntry entry : entries)
                                        { %>
                                        <div class="entry-card">
                                            <div class="entry-content">
                                                <%= entry.getContent() %>
                                            </div>
                                            <div class="entry-date">
                                                <%= entry.getSubmittedAt() !=null ?
                                                    entry.getSubmittedAt().toString().substring(0, 16) : "Just now" %>
                                            </div>
                                        </div>
                                        <% } } else { %>
                                            <div class="no-entries">
                                                <h3>No entries yet. Be the first to write!</h3>
                                            </div>
                                            <% } %>
                                </div>

                                <jsp:include page="../../public/footer.jsp" />

                            </body>

                            </html>