<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Join Memory - Everly</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/app.css">
            <style>
                .join-container {
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    padding: 20px;
                }

                .join-card {
                    background: white;
                    border-radius: 20px;
                    padding: 40px;
                    max-width: 450px;
                    width: 100%;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                    text-align: center;
                }

                .join-icon {
                    width: 80px;
                    height: 80px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 24px;
                }

                .join-icon svg {
                    width: 40px;
                    height: 40px;
                    stroke: white;
                }

                .join-title {
                    font-size: 24px;
                    font-weight: 700;
                    color: #1a1a2e;
                    margin-bottom: 8px;
                }

                .join-subtitle {
                    color: #6b7280;
                    font-size: 16px;
                    margin-bottom: 32px;
                }

                .memory-preview {
                    background: #f8f9fb;
                    border-radius: 12px;
                    padding: 20px;
                    margin-bottom: 32px;
                    text-align: left;
                }

                .memory-preview-title {
                    font-weight: 600;
                    color: #1a1a2e;
                    font-size: 18px;
                    margin-bottom: 8px;
                }

                .memory-preview-desc {
                    color: #6b7280;
                    font-size: 14px;
                }

                .join-btn {
                    width: 100%;
                    padding: 16px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    border-radius: 12px;
                    color: white;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .join-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
                }

                .join-btn:disabled {
                    opacity: 0.6;
                    cursor: not-allowed;
                    transform: none;
                }

                .error-message {
                    background: #fee2e2;
                    color: #dc2626;
                    padding: 16px;
                    border-radius: 12px;
                    margin-bottom: 24px;
                }

                .error-icon {
                    width: 80px;
                    height: 80px;
                    background: #fee2e2;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 24px;
                }

                .error-icon svg {
                    width: 40px;
                    height: 40px;
                    stroke: #dc2626;
                }

                .back-link {
                    display: block;
                    margin-top: 20px;
                    color: #6b7280;
                    text-decoration: none;
                    font-size: 14px;
                }

                .back-link:hover {
                    color: #667eea;
                }

                .loading-spinner {
                    display: none;
                    width: 20px;
                    height: 20px;
                    border: 2px solid white;
                    border-top-color: transparent;
                    border-radius: 50%;
                    animation: spin 0.8s linear infinite;
                    margin: 0 auto;
                }

                @keyframes spin {
                    to {
                        transform: rotate(360deg);
                    }
                }
            </style>
        </head>

        <body>
            <div class="join-container">
                <div class="join-card">
                    <c:choose>
                        <c:when test="${not empty error}">
                            <div class="error-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="15" y1="9" x2="9" y2="15"></line>
                                    <line x1="9" y1="9" x2="15" y2="15"></line>
                                </svg>
                            </div>
                            <h1 class="join-title">Invite Link Invalid</h1>
                            <p class="error-message">${error}</p>
                            <a href="${pageContext.request.contextPath}/memories" class="join-btn"
                                style="text-decoration: none; display: block;">
                                Go to My Memories
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="join-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="8.5" cy="7" r="4"></circle>
                                    <line x1="20" y1="8" x2="20" y2="14"></line>
                                    <line x1="23" y1="11" x2="17" y2="11"></line>
                                </svg>
                            </div>
                            <h1 class="join-title">You're Invited!</h1>
                            <p class="join-subtitle">Someone has invited you to collaborate on a memory</p>

                            <div class="memory-preview">
                                <div class="memory-preview-title">${memory.title}</div>
                                <div class="memory-preview-desc">
                                    <c:choose>
                                        <c:when test="${not empty memory.description}">
                                            ${memory.description}
                                        </c:when>
                                        <c:otherwise>
                                            A shared memory waiting for your contributions
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <button class="join-btn" id="joinBtn" onclick="joinMemory()">
                                <span id="btnText">Join This Memory</span>
                                <div class="loading-spinner" id="loadingSpinner"></div>
                            </button>

                            <a href="${pageContext.request.contextPath}/memories" class="back-link">
                                ← Back to my memories
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <script>
                function joinMemory() {
                    const btn = document.getElementById('joinBtn');
                    const btnText = document.getElementById('btnText');
                    const spinner = document.getElementById('loadingSpinner');

                    btn.disabled = true;
                    btnText.style.display = 'none';
                    spinner.style.display = 'block';

                    fetch('${pageContext.request.contextPath}/invite/${token}', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                window.location.href = '${pageContext.request.contextPath}/memory/view?id=' + data.memoryId;
                            } else {
                                alert(data.error || 'Failed to join memory');
                                btn.disabled = false;
                                btnText.style.display = 'block';
                                spinner.style.display = 'none';
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('An error occurred. Please try again.');
                            btn.disabled = false;
                            btnText.style.display = 'block';
                            spinner.style.display = 'none';
                        });
                }
            </script>
        </body>

        </html>