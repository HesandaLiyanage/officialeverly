<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="com.demo.web.model.autograph" %>

        <jsp:include page="../public/header2.jsp" />

        <% autograph ag=(autograph) request.getAttribute("autograph"); String shareToken=(String)
            request.getAttribute("shareToken"); %>

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
                            <h1 class="book-title">Write in Autograph Book</h1>
                            <p class="book-subtitle">
                                <%= ag.getTitle() %>
                            </p>
                        </div>

                        <!-- Main Content (UNCHANGED UI) -->
                        <div class="write-content">
                            <!-- Toolbar -->
                            <!-- 🔹 KEEP YOUR EXISTING TOOLBAR CODE EXACTLY AS IS 🔹 -->

                            <!-- Writing Page -->
                            <div class="page-area">
                                <div class="autograph-page">
                                    <div class="margin-line"></div>

                                    <div class="writing-area" id="writingArea" contenteditable="true"></div>

                                    <div class="decorations-container" id="decorationsContainer"></div>
                                </div>

                                <div class="action-buttons">
                                    <button class="action-btn cancel-btn" id="cancelBtn">Cancel</button>
                                    <button class="action-btn submit-btn" id="submitBtn">Submit Message</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hidden form -->
                <form id="autographForm" action="${pageContext.request.contextPath}/submitAutographEntry" method="post"
                    style="display:none;">

                    <input type="hidden" name="shareToken" value="<%= shareToken %>">
                    <input type="hidden" name="content" id="contentField">
                    <input type="hidden" name="decorations" id="decorationsField">
                </form>

                <jsp:include page="../public/footer.jsp" />

                <script>
                    // SAME JS AS JOURNAL, only submit target changes
                    const submitBtn = document.getElementById('submitBtn');
                    const cancelBtn = document.getElementById('cancelBtn');

                    submitBtn.addEventListener('click', () => {
                        const content = document.getElementById('writingArea').innerHTML.trim();
                        if (!content) {
                            alert('Please write something!');
                            return;
                        }

                        const decorations = [];
                        document.querySelectorAll('.decoration').forEach(dec => {
                            decorations.push({
                                content: dec.textContent,
                                className: dec.className,
                                top: dec.style.top,
                                left: dec.style.left
                            });
                        });

                        document.getElementById('contentField').value = content;
                        document.getElementById('decorationsField').value = JSON.stringify(decorations);

                        document.getElementById('autographForm').submit();
                    });

                    cancelBtn.addEventListener('click', () => {
                        window.location.href = '/';
                    });
                </script>

            </body>

            </html>