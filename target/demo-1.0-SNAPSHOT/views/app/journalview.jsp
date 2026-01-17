<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.Journal" %>
        <%@ page import="java.text.SimpleDateFormat" %>
            <%@ page import="com.google.gson.Gson" %>
                <%@ page import="com.google.gson.JsonObject" %>
                    <%@ page import="com.google.gson.JsonElement" %>
                        <% // Retrieve the Journal object from the request attribute set by the logic handler Journal
                            journal=(Journal) request.getAttribute("journal"); String errorMessage=(String)
                            request.getAttribute("error"); String title="No Journal Found" ; String
                            content="<p>No content available.</p>" ; String displayDate="Unknown Date" ; String
                            tag="#no-tag" ; // Default tag if needed if (journal !=null) { title=journal.getTitle();
                            String rawContent=journal.getContent(); if (rawContent !=null) { try { // Parse the JSON
                            content string to extract htmlContent and decorations Gson gson=new Gson(); JsonObject
                            contentObj=gson.fromJson(rawContent, JsonObject.class); String
                            htmlContent=contentObj.get("htmlContent").getAsString(); JsonElement
                            decorationsElement=contentObj.get("decorations"); content=htmlContent; // Use the HTML
                            content directly // Process decorations if they exist if (decorationsElement !=null &&
                            !decorationsElement.isJsonNull() && decorationsElement.isJsonArray()) { // Add a container
                            for decorations and append the decoration elements dynamically via JS content
                            +="<div id='decorations-container' class='decorations-container' style='position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none;'></div>"
                            ; } } catch (Exception e) { System.out.println("Error parsing journal content JSON: " + e.getMessage());
                content = " <p>Error loading content: " + e.getMessage() + "</p>";
                            }
                            }
                            // Use the title as the display date (assuming it's formatted like "24th October 2025")
                            displayDate = title;
                            }
                            %>

                            <jsp:include page="../public/header2.jsp" />
                            <html>

                            <head>
                                <link rel="stylesheet" type="text/css"
                                    href="${pageContext.request.contextPath}/resources/css/journalviewer.css">
                                <style>
                                    /* Floating Action Buttons - Positioned at bottom right */
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
                                        box-shadow: 0 6px 20px rgba(154, 116, 216, 0.45);
                                    }

                                    .floating-btn:active {
                                        transform: translateY(0);
                                    }

                                    .floating-btn svg {
                                        flex-shrink: 0;
                                    }

                                    .floating-btn.delete-btn {
                                        background: #EADDFF;
                                        color: #9A74D8;
                                        box-shadow: 0 4px 14px rgba(234, 221, 255, 0.5);
                                    }

                                    .floating-btn.delete-btn:hover {
                                        background: #FFFFFF;
                                        color: #8a64c8;
                                        transform: translateY(-2px);
                                        box-shadow: 0 6px 20px rgba(234, 221, 255, 0.6);
                                    }

                                    /* Responsive Design */
                                    @media (max-width: 768px) {
                                        .floating-buttons {
                                            bottom: 20px;
                                            right: 20px;
                                        }

                                        .floating-btn {
                                            padding: 10px 20px;
                                            font-size: 14px;
                                            min-width: 120px;
                                        }

                                        .floating-btn svg {
                                            width: 16px;
                                            height: 16px;
                                        }
                                    }

                                    @media (max-width: 480px) {
                                        .floating-buttons {
                                            bottom: 15px;
                                            right: 15px;
                                        }

                                        .floating-btn {
                                            padding: 9px 18px;
                                            font-size: 13px;
                                            gap: 8px;
                                            min-width: 110px;
                                        }
                                    }

                                    /* Vault Button Style */
                                    .floating-btn.vault-btn {
                                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                        color: #ffffff;
                                    }

                                    .floating-btn.vault-btn:hover {
                                        background: linear-gradient(135deg, #5a6fd6 0%, #6a4190 100%);
                                        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.45);
                                    }

                                    /* Vault Modal */
                                    .vault-modal-overlay {
                                        display: none;
                                        position: fixed;
                                        top: 0;
                                        left: 0;
                                        width: 100%;
                                        height: 100%;
                                        background: rgba(0, 0, 0, 0.6);
                                        z-index: 3000;
                                        justify-content: center;
                                        align-items: center;
                                    }

                                    .vault-modal-overlay.active {
                                        display: flex;
                                    }

                                    .vault-modal {
                                        background: white;
                                        padding: 30px;
                                        border-radius: 16px;
                                        max-width: 400px;
                                        width: 90%;
                                        text-align: center;
                                    }

                                    .vault-modal h3 {
                                        margin: 0 0 10px 0;
                                        color: #333;
                                    }

                                    .vault-modal p {
                                        color: #666;
                                        margin-bottom: 20px;
                                    }

                                    .vault-modal input {
                                        width: 100%;
                                        padding: 12px;
                                        border: 2px solid #e0e0e0;
                                        border-radius: 8px;
                                        font-size: 16px;
                                        margin-bottom: 15px;
                                        box-sizing: border-box;
                                    }

                                    .vault-modal input:focus {
                                        border-color: #9A74D8;
                                        outline: none;
                                    }

                                    .vault-modal-buttons {
                                        display: flex;
                                        gap: 10px;
                                        justify-content: center;
                                    }

                                    .vault-modal-btn {
                                        padding: 10px 24px;
                                        border: none;
                                        border-radius: 8px;
                                        font-size: 14px;
                                        font-weight: 600;
                                        cursor: pointer;
                                    }

                                    .vault-modal-btn.confirm {
                                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                        color: white;
                                    }

                                    .vault-modal-btn.cancel {
                                        background: #f0f0f0;
                                        color: #666;
                                    }
                                </style>
                            </head>

                            <body>

                                <div class="journal-viewer-wrapper">
                                    <div class="journal-viewer-container">
                                        <!-- Navigation Header -->
                                        <div class="viewer-header">
                                            <a href="${pageContext.request.contextPath}/journals"
                                                class="nav-btn prev-journal">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <polyline points="15 18 9 12 15 6"></polyline>
                                                </svg>
                                                Back to Journals
                                            </a>
                                            <h1 class="journal-title" id="journalTitle">
                                                <%= title %>
                                            </h1>
                                            <div style="width: 140px; text-align: center;"></div>
                                            <!-- Spacer for alignment -->
                                        </div>

                                        <!-- Journal Content Viewer -->
                                        <div class="page-viewer">
                                            <div class="page-container" id="pageContainer">
                                                <!-- Journal Page Content -->
                                                <div class="journal-page">
                                                    <!-- Favorite Heart - Placeholder -->
                                                    <button class="favorite-heart" id="favoriteHeart"
                                                        style="display: none;" title="Favorite (Not implemented yet)">
                                                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round">
                                                            <path
                                                                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                            </path>
                                                        </svg>
                                                    </button>

                                                    <!-- Entry Content -->
                                                    <div class="page-content" id="pageContent">
                                                        <%= content %>
                                                    </div>

                                                    <!-- Entry Date -->
                                                    <div class="page-date" id="pageDate">
                                                        <%= displayDate %>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Entry Info -->
                                        <div class="page-info">
                                            <p class="page-tag" id="pageTag">
                                                <%= tag %>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Hidden form for deletion -->
                                <form id="deleteJournalForm" action="${pageContext.request.contextPath}/journal/delete"
                                    method="post" style="display:none;">
                                    <input type="hidden" name="journalId" id="journalIdInput"
                                        value="<%= journal != null ? journal.getJournalId() : "" %>">
                                </form>

                                <!-- Floating Action Buttons -->
                                <div class="floating-buttons">
                                    <button class="floating-btn vault-btn" onclick="openVaultModal()"
                                        style="display: <%= journal != null ? " inline-flex" : "none" %>;">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        Vault
                                    </button>
                                    <a href="${pageContext.request.contextPath}/editjournal?id=<%= journal != null ? journal.getJournalId() : "" %>"
                                        class="floating-btn" style="display: <%= journal != null ? " inline-flex"
                                        : "none" %>;">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                        </svg>
                                        Edit
                                    </a>
                                    <button class="floating-btn delete-btn" id="deleteBtn"
                                        style="display: <%= journal != null ? " inline-flex" : "none" %>;">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <polyline points="3 6 5 6 21 6"></polyline>
                                            <path
                                                d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                            </path>
                                            <line x1="10" y1="11" x2="10" y2="17"></line>
                                            <line x1="14" y1="11" x2="14" y2="17"></line>
                                        </svg>
                                        Delete
                                    </button>
                                </div>

                                <!-- Vault Password Modal -->
                                <div class="vault-modal-overlay" id="vaultModal">
                                    <div class="vault-modal">
                                        <h3>🔒 Move to Vault</h3>
                                        <p>Enter your vault password to move this journal to the vault.</p>
                                        <input type="password" id="vaultPasswordInput" placeholder="Vault password">
                                        <div class="vault-modal-buttons">
                                            <button class="vault-modal-btn cancel"
                                                onclick="closeVaultModal()">Cancel</button>
                                            <button class="vault-modal-btn confirm" onclick="moveToVault()">Move to
                                                Vault</button>
                                        </div>
                                    </div>
                                </div>

                                <jsp:include page="../public/footer.jsp" />

                                <script>
                                    // Function to render decorations from server-side JSON
                                    function renderDecorations() {
                                        // Get the raw JSON string from the server-side JSP variable
                                        const rawContent = `<%= journal != null ? journal.getContent().replace("\\", "\\\\").replace("\"", "\\\"") : "" %>`;
                                        if (!rawContent) return;

                                        try {
                                            const contentObj = JSON.parse(rawContent);
                                            const decorations = contentObj.decorations;

                                            if (decorations && Array.isArray(decorations)) {
                                                const container = document.getElementById('decorations-container');
                                                if (!container) {
                                                    console.error('Decorations container not found');
                                                    return;
                                                }

                                                decorations.forEach(dec => {
                                                    const decoration = document.createElement('div');
                                                    decoration.className = 'decoration';
                                                    // Determine class based on className from JSON
                                                    if (dec.className.includes('emoji')) {
                                                        decoration.classList.add('decoration', 'emoji');
                                                        decoration.style.fontSize = '28px';
                                                    } else if (dec.className.includes('doodle')) {
                                                        decoration.classList.add('decoration', 'doodle');
                                                        decoration.style.fontSize = '24px';
                                                        decoration.style.opacity = '0.5';
                                                        // Add specific class for doodle type if present
                                                        if (dec.className.includes('heart')) {
                                                            decoration.classList.add('heart');
                                                            decoration.style.color = '#9A74D8';
                                                            decoration.style.fontSize = '28px';
                                                        } else if (dec.className.includes('star')) {
                                                            decoration.classList.add('star');
                                                            decoration.style.color = '#fbbf24';
                                                            decoration.style.fontSize = '22px';
                                                        } else if (dec.className.includes('music')) {
                                                            decoration.classList.add('music');
                                                            decoration.style.color = '#9A74D8';
                                                            decoration.style.fontSize = '24px';
                                                        }
                                                    } else {
                                                        // Fallback, add general decoration class
                                                        decoration.classList.add('decoration');
                                                    }

                                                    decoration.textContent = dec.content;
                                                    decoration.style.position = 'absolute'; // Ensure absolute positioning
                                                    decoration.style.top = dec.top;
                                                    decoration.style.left = dec.left;
                                                    decoration.style.pointerEvents = 'all'; // Allow interaction like double-click to remove
                                                    decoration.style.userSelect = 'none'; // Prevent text selection
                                                    decoration.style.zIndex = '5'; // Ensure it's above text but below controls if needed
                                                    decoration.style.cursor = 'grab'; // Show grab cursor

                                                    // Add double click to remove functionality (optional)
                                                    decoration.addEventListener('dblclick', function (e) {
                                                        e.stopPropagation(); // Prevent event bubbling if needed
                                                        decoration.remove();
                                                    });

                                                    container.appendChild(decoration);
                                                });
                                            }
                                        } catch (e) {
                                            console.error('Error parsing decorations JSON:', e);
                                        }
                                    }

                                    // Call the function to render decorations when the page loads
                                    document.addEventListener('DOMContentLoaded', renderDecorations);

                                    // Delete button functionality
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const deleteBtn = document.getElementById('deleteBtn');
                                        const deleteForm = document.getElementById('deleteJournalForm');

                                        if (deleteBtn && deleteForm) {
                                            deleteBtn.addEventListener('click', function (event) {
                                                event.preventDefault();
                                                const journalId = document.getElementById('journalIdInput').value;
                                                if (!journalId) {
                                                    alert('Journal ID is missing.');
                                                    return;
                                                }
                                                if (confirm('Move this journal to the Recycle Bin? You can restore it later.')) {
                                                    deleteForm.submit();
                                                }
                                            });
                                        }
                                    });

                                    // Vault modal functions
                                    function openVaultModal() {
                                        document.getElementById('vaultModal').classList.add('active');
                                        document.getElementById('vaultPasswordInput').focus();
                                    }

                                    function closeVaultModal() {
                                        document.getElementById('vaultModal').classList.remove('active');
                                        document.getElementById('vaultPasswordInput').value = '';
                                    }

                                    function moveToVault() {
                                        const password = document.getElementById('vaultPasswordInput').value;
                                        if (!password) {
                                            alert('Please enter your vault password');
                                            return;
                                        }

                                        const journalId = '<%= journal != null ? journal.getJournalId() : "" %>';
                                        const formData = new FormData();
                                        formData.append('type', 'journal');
                                        formData.append('id', journalId);
                                        formData.append('action', 'add');
                                        formData.append('vaultPassword', password);

                                        fetch('${pageContext.request.contextPath}/moveToVault', {
                                            method: 'POST',
                                            body: formData
                                        })
                                            .then(response => response.json())
                                            .then(data => {
                                                if (data.success) {
                                                    alert('Journal moved to vault successfully!');
                                                    window.location.href = '${pageContext.request.contextPath}/journals';
                                                } else if (data.redirectToSetup) {
                                                    alert('You need to set up your vault first. You will be redirected to create a vault password.');
                                                    window.location.href = '${pageContext.request.contextPath}/vaultSetup';
                                                } else {
                                                    alert('Error: ' + (data.error || 'Failed to move to vault'));
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error:', error);
                                                alert('Error moving to vault. Please try again.');
                                            });

                                        closeVaultModal();
                                    }

                                    // Close vault modal on background click
                                    document.getElementById('vaultModal').addEventListener('click', function (e) {
                                        if (e.target === this) {
                                            closeVaultModal();
                                        }
                                    });
                                </script>

                            </body>

                            </html>