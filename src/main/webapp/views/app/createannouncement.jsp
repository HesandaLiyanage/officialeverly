<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <jsp:include page="../public/header2.jsp" />
    <html>

    <head>
        <title>Create Announcement - Everly</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
        <style>
            .form-container {
                max-width: 800px;
                margin: 40px auto;
                background: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            }

            .form-header {
                margin-bottom: 30px;
            }

            .form-header h1 {
                font-size: 28px;
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 8px;
            }

            .form-header p {
                color: #6b7280;
                font-size: 15px;
            }

            .form-group {
                margin-bottom: 24px;
            }

            .form-group label {
                display: block;
                font-size: 14px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
            }

            .form-control {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid #e5e7eb;
                border-radius: 12px;
                font-size: 15px;
                font-family: inherit;
                transition: all 0.3s ease;
                box-sizing: border-box;
            }

            .form-control:focus {
                outline: none;
                border-color: #9A74D8;
                box-shadow: 0 0 0 4px rgba(154, 116, 216, 0.1);
            }

            textarea.form-control {
                resize: vertical;
                min-height: 200px;
            }

            .btn-submit {
                background: #9A74D8;
                color: white;
                border: none;
                padding: 14px 32px;
                font-size: 16px;
                font-weight: 700;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 100%;
            }

            .btn-submit:hover {
                background: #8a64c8;
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(154, 116, 216, 0.3);
            }

            .btn-cancel {
                display: block;
                text-align: center;
                margin-top: 16px;
                color: #6b7280;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
            }

            .btn-cancel:hover {
                color: #374151;
            }

            .error-message {
                background: #fee2e2;
                color: #dc2626;
                padding: 12px 16px;
                border-radius: 10px;
                margin-bottom: 20px;
                font-size: 14px;
                font-weight: 500;
            }
        </style>
    </head>

    <body>
        <div class="page-wrapper">
            <div class="form-container">
                <div class="form-header">
                    <h1>Create New Announcement</h1>
                    <p>Share important updates with your group members.</p>
                </div>

                <% String error=(String) request.getAttribute("errorMessage"); %>
                    <% if (error !=null) { %>
                        <div class="error-message">
                            <%= error %>
                        </div>
                        <% } %>

                            <form action="${pageContext.request.contextPath}/createannouncement" method="POST">
                                <input type="hidden" name="groupId" value="${groupId}">

                                <div class="form-group">
                                    <label for="title">Title</label>
                                    <input type="text" id="title" name="title" class="form-control"
                                        placeholder="What's this about?" required>
                                </div>

                                <div class="form-group">
                                    <label for="content">Announcement Details</label>
                                    <textarea id="content" name="content" class="form-control"
                                        placeholder="Write your message here..." required></textarea>
                                </div>

                                <button type="submit" class="btn-submit">Post Announcement</button>
                                <a href="${pageContext.request.contextPath}/groupannouncementservlet?groupId=${groupId}"
                                    class="btn-cancel">Cancel and Go Back</a>
                            </form>
            </div>
        </div>
        <jsp:include page="../public/footer.jsp" />
    </body>

    </html>