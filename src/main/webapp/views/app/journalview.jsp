<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.Journal" %>
        <%@ page import="com.google.gson.Gson" %>
            <%@ page import="com.google.gson.JsonObject" %>
                <%@ page import="com.google.gson.JsonElement" %>
                    <% Journal journal=(Journal) request.getAttribute("journal"); String errorMessage=(String)
                        request.getAttribute("error"); String title="No Journal Found" ; String
                        content="<p>No content available.</p>" ; String backgroundTheme="" ; String rawContentForJs="" ;
                        if (journal !=null) { title=journal.getTitle(); String rawContent=journal.getContent(); if
                        (rawContent !=null) { rawContentForJs=rawContent.replace("\\", "\\\\"
                        ).replace("\"", "\\\"").replace(" \n", "\\n" ).replace("\r", "\\r" ); try { Gson gson=new
                        Gson(); JsonObject contentObj=gson.fromJson(rawContent, JsonObject.class); String
                        htmlContent=contentObj.get("htmlContent").getAsString(); content=htmlContent; // Extract background theme if available 
                            JsonElement bgElement=contentObj.get("backgroundTheme"); if (bgElement !=null && !bgElement.isJsonNull()) { backgroundTheme=bgElement.getAsString(); } // Add decorations container if decorations exist 
                            JsonElement
                        decorationsElement=contentObj.get("decorations"); if (decorationsElement !=null &&
                        !decorationsElement.isJsonNull() && decorationsElement.isJsonArray()) { content
                        +="<div id='decorations-container' class='decorations-container'></div>" ; } } catch (Exception
                        e) { System.out.println("Error parsing journal content JSON: " + e.getMessage());
                content = " <p>Error loading content.</p>";
                        }
                        }
                        }
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>
                                <%= title %> - Everly
                            </title>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                                rel="stylesheet">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/resources/css/memoryviewer.css">
                            <style>
                                /* Journal-specific overrides */
                                .mv-media-section {
                                    background: #f8f5f0;
                                    position: relative;
                                }

                                /* Journal page area */
                                .jv-page-area {
                                    width: 100%;
                                    height: 500px;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    position: relative;
                                    overflow: hidden;
                                }

                                .jv-page {
                                    width: 92%;
                                    height: 92%;
                                    background: white;
                                    border-radius: 6px;
                                    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08), 0 0 0 1px rgba(0, 0, 0, 0.04);
                                    position: relative;
                                    overflow: hidden;
                                    background-size: cover;
                                    background-position: center;
                                    background-repeat: no-repeat;
                                }

                                .jv-page-content {
                                    width: 100%;
                                    height: 100%;
                                    padding: 32px 28px;
                                    overflow-y: auto;
                                    font-family: 'Plus Jakarta Sans', sans-serif;
                                    font-size: 15px;
                                    line-height: 1.8;
                                    color: #1e293b;
                                    position: relative;
                                    z-index: 2;
                                }

                                .jv-page-content::-webkit-scrollbar {
                                    width: 3px;
                                }

                                .jv-page-content::-webkit-scrollbar-thumb {
                                    background: rgba(0, 0, 0, 0.15);
                                    border-radius: 2px;
                                }

                                /* Decorations */
                                .jv-page-content .decorations-container {
                                    position: absolute;
                                    top: 0;
                                    left: 0;
                                    width: 100%;
                                    height: 100%;
                                    pointer-events: none;
                                    z-index: 3;
                                }

                                .jv-page-content .decoration {
                                    position: absolute;
                                    font-size: 2rem;
                                }

                                .jv-page-content .decoration.emoji {
                                    font-size: 2.5rem;
                                }

                                .jv-page-content .decoration.doodle {
                                    font-size: 3rem;
                                    opacity: 0.5;
                                }

                                /* No content state */
                                .jv-no-content {
                                    display: flex;
                                    flex-direction: column;
                                    align-items: center;
                                    justify-content: center;
                                    width: 100%;
                                    height: 100%;
                                    color: #9ca3af;
                                    gap: 12px;
                                    text-align: center;
                                    padding: 40px;
                                }

                                .jv-no-content svg {
                                    width: 48px;
                                    height: 48px;
                                    opacity: 0.4;
                                }

                                .jv-no-content h3 {
                                    font-size: 16px;
                                    font-weight: 600;
                                    color: #6b7280;
                                }

                                .jv-no-content p {
                                    font-size: 13px;
                                    color: #9ca3af;
                                }

                                /* Word count badge in details */
                                .jv-word-count {
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 6px;
                                    font-size: 12px;
                                    font-weight: 600;
                                    color: #9A74D8;
                                    background: #f3f0ff;
                                    padding: 4px 10px;
                                    border-radius: 12px;
                                    margin-top: 4px;
                                }
                            </style>
                        </head>

                        <body>
                            <div class="mv-page">
                                <!-- Close button -->
                                <a href="${pageContext.request.contextPath}/journals" class="mv-close-btn">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </a>

                                <div class="mv-wrapper">
                                    <!-- LEFT: Journal Content Display -->
                                    <div class="mv-media-section">
                                        <div class="jv-page-area">
                                            <div class="jv-page" id="journalPage" <% if (!backgroundTheme.isEmpty()) {
                                                %>
                                                style="background-image: url('<%= backgroundTheme %>');"
                                                    <% } %>
                                                        >
                                                        <div class="jv-page-content" id="pageContent">
                                                            <%= content %>
                                                        </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- RIGHT: Details Section -->
                                    <div class="mv-details-section">
                                        <!-- Header -->
                                        <div class="mv-header">
                                            <div class="mv-header-left">
                                                <div class="mv-avatar">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2.5">
                                                        <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z">
                                                        </path>
                                                    </svg>
                                                </div>
                                                <div class="mv-header-text">
                                                    <h3>Journal Entry</h3>
                                                    <div class="mv-type-badge">
                                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2.5">
                                                            <path
                                                                d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z">
                                                            </path>
                                                            <polyline points="14 2 14 8 20 8"></polyline>
                                                        </svg>
                                                        Personal Entry
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Scrollable Content -->
                                        <div class="mv-content">
                                            <!-- Title (Date) -->
                                            <div class="mv-info-group">
                                                <div class="mv-info-value title">
                                                    <%= title %>
                                                </div>
                                                <div class="jv-word-count" id="wordCount"></div>
                                            </div>

                                            <div class="mv-divider"></div>

                                            <!-- Preview text -->
                                            <div class="mv-info-group">
                                                <div class="mv-info-label">Preview</div>
                                                <div class="mv-info-value" id="textPreview"
                                                    style="color: #6b7280; font-size: 13px;">
                                                    <!-- Filled by JS -->
                                                </div>
                                            </div>

                                            <% if (!backgroundTheme.isEmpty()) { %>
                                                <div class="mv-divider"></div>
                                                <div class="mv-info-group">
                                                    <div class="mv-photo-count">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2">
                                                            </rect>
                                                            <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                                            <polyline points="21 15 16 10 5 21"></polyline>
                                                        </svg>
                                                        Custom theme applied
                                                    </div>
                                                </div>
                                                <% } %>
                                        </div>

                                        <!-- Actions bar -->
                                        <div class="mv-actions-bar">
                                            <% if (journal !=null) { %>
                                                <a href="${pageContext.request.contextPath}/editjournal?id=<%= journal.getJournalId() %>"
                                                    class="mv-action-btn primary">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2.5">
                                                        <path
                                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                                        </path>
                                                        <path
                                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                                        </path>
                                                    </svg>
                                                    Edit
                                                </a>
                                                <button class="mv-action-btn danger" id="deleteBtn">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2.5">
                                                        <path d="M3 6h18"></path>
                                                        <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
                                                        <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
                                                    </svg>
                                                    Delete
                                                </button>
                                                <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Delete Form -->
                            <form id="deleteJournalForm" action="${pageContext.request.contextPath}/journal/delete"
                                method="post" style="display:none;">
                                <input type="hidden" name="journalId"
                                    value="<%= journal != null ? journal.getJournalId() : "" %>">
                            </form>

                            <script>
                                // Render decorations
                                (function () {
                                    var rawContent = "<%= rawContentForJs %>";
                                    if (!rawContent) return;

                                    try {
                                        var contentObj = JSON.parse(rawContent);
                                        var decorations = contentObj.decorations;

                                        if (decorations && Array.isArray(decorations)) {
                                            var container = document.getElementById('decorations-container');
                                            if (!container) return;

                                            decorations.forEach(function (dec) {
                                                var decoration = document.createElement('div');
                                                decoration.className = 'decoration';

                                                if (dec.className && dec.className.includes('emoji')) {
                                                    decoration.classList.add('emoji');
                                                    decoration.style.fontSize = '28px';
                                                } else if (dec.className && dec.className.includes('doodle')) {
                                                    decoration.classList.add('doodle');
                                                    decoration.style.fontSize = '24px';
                                                    decoration.style.opacity = '0.5';
                                                    if (dec.className.includes('heart')) {
                                                        decoration.style.color = '#9A74D8';
                                                        decoration.style.fontSize = '28px';
                                                    } else if (dec.className.includes('star')) {
                                                        decoration.style.color = '#fbbf24';
                                                        decoration.style.fontSize = '22px';
                                                    } else if (dec.className.includes('music')) {
                                                        decoration.style.color = '#9A74D8';
                                                        decoration.style.fontSize = '24px';
                                                    }
                                                }

                                                decoration.textContent = dec.content;
                                                decoration.style.position = 'absolute';
                                                decoration.style.top = dec.top;
                                                decoration.style.left = dec.left;
                                                decoration.style.pointerEvents = 'none';
                                                decoration.style.userSelect = 'none';
                                                decoration.style.zIndex = '5';

                                                container.appendChild(decoration);
                                            });
                                        }
                                    } catch (e) {
                                        console.error('Error parsing decorations:', e);
                                    }
                                })();

                                // Word count and preview
                                (function () {
                                    var pageContent = document.getElementById('pageContent');
                                    var textContent = pageContent ? pageContent.textContent.trim() : '';
                                    var words = textContent.split(/\s+/).filter(function (w) { return w.length > 0; });
                                    var wordCountEl = document.getElementById('wordCount');
                                    if (wordCountEl) {
                                        wordCountEl.textContent = words.length + ' word' + (words.length !== 1 ? 's' : '');
                                    }
                                    var previewEl = document.getElementById('textPreview');
                                    if (previewEl) {
                                        var preview = textContent.substring(0, 120);
                                        if (textContent.length > 120) preview += '...';
                                        previewEl.textContent = preview || 'No text content';
                                    }
                                })();

                                // Delete
                                var deleteBtn = document.getElementById('deleteBtn');
                                if (deleteBtn) {
                                    deleteBtn.addEventListener('click', function () {
                                        if (confirm('Move this journal to the Recycle Bin? You can restore it later.')) {
                                            document.getElementById('deleteJournalForm').submit();
                                        }
                                    });
                                }

                                // Keyboard: Escape to go back
                                document.addEventListener('keydown', function (e) {
                                    if (e.key === 'Escape') {
                                        window.location.href = '${pageContext.request.contextPath}/journals';
                                    }
                                });
                            </script>
                        </body>

                        </html>
