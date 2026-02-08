<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Test Page</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    padding: 40px;
                    background: #f5f5f5;
                }

                .card {
                    background: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                }

                .success {
                    color: green;
                    font-weight: bold;
                }

                .info {
                    color: #333;
                    margin: 10px 0;
                }
            </style>
        </head>

        <body>
            <div class="card">
                <h1>Test Page</h1>
                <p class="success">✓ JSP is rendering correctly!</p>

                <div class="info">
                    <p><strong>Memories attribute:</strong> ${empty memories ? 'NULL or EMPTY' : 'Has data'}</p>
                    <p><strong>Memories size:</strong> ${memories != null ? memories.size() : 'null'}</p>
                    <p><strong>Feed Profile:</strong> ${feedProfile != null ? feedProfile.feedUsername : 'null'}</p>
                </div>

                <c:if test="${not empty memories}">
                    <h2>Available Memories:</h2>
                    <ul>
                        <c:forEach var="memory" items="${memories}">
                            <li>${memory.title} (ID: ${memory.memoryId})</li>
                        </c:forEach>
                    </ul>
                </c:if>

                <p><a href="${pageContext.request.contextPath}/feed">Back to Feed</a></p>
            </div>
        </body>

        </html>