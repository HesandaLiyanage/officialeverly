<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Memory</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/creatememory.css">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
        <style>
            /* Tab styles for create memory page */
            .create-tabs {
                display: flex;
                gap: 0;
                margin-bottom: 24px;
                background: #f1f3f5;
                border-radius: 12px;
                padding: 4px;
            }

            .create-tab {
                flex: 1;
                padding: 12px 24px;
                border: none;
                background: transparent;
                font-family: 'Plus Jakarta Sans', sans-serif;
                font-size: 14px;
                font-weight: 600;
                color: #6b7280;
                cursor: pointer;
                border-radius: 10px;
                transition: all 0.2s ease;
            }

            .create-tab:hover {
                color: #1a1a2e;
            }

            .create-tab.active {
                background: white;
                color: #9A74D8;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            }

            .tab-content {
                display: none;
            }

            .tab-content.active {
                display: block;
            }

            /* Success popup modal */
            .success-modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                z-index: 10000;
                justify-content: center;
                align-items: center;
                backdrop-filter: blur(4px);
            }

            .success-modal-overlay.active {
                display: flex;
            }

            .success-modal {
                background: white;
                border-radius: 20px;
                padding: 40px;
                max-width: 480px;
                width: 90%;
                text-align: center;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                animation: modalSlideIn 0.3s ease;
            }

            @keyframes modalSlideIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px) scale(0.95);
                }

                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .success-icon {
                width: 80px;
                height: 80px;
                background: #9A74D8;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 24px;
            }

            .success-icon svg {
                width: 40px;
                height: 40px;
                stroke: white;
            }

            .success-modal h2 {
                font-size: 24px;
                color: #1a1a2e;
                margin: 0 0 8px 0;
            }

            .success-modal p {
                font-size: 14px;
                color: #6b7280;
                margin: 0 0 24px 0;
            }

            .invite-link-box {
                background: #f8f9fb;
                border-radius: 12px;
                padding: 16px;
                margin-bottom: 24px;
            }

            .invite-link-box label {
                display: block;
                font-size: 12px;
                font-weight: 600;
                color: #6b7280;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .invite-link-input-group {
                display: flex;
                gap: 10px;
            }

            .invite-link-input-group input {
                flex: 1;
                padding: 12px 16px;
                border: 2px solid #e5e7eb;
                border-radius: 10px;
                font-size: 14px;
                color: #1a1a2e;
                background: white;
            }

            .copy-btn {
                padding: 12px 20px;
                background: #9A74D8;
                color: white;
                border: none;
                border-radius: 10px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.2s ease;
            }

            .copy-btn:hover {
                background: #8B65C9;
            }

            .copy-btn.copied {
                background: #10b981;
            }

            .modal-actions {
                display: flex;
                gap: 12px;
            }

            .modal-btn {
                flex: 1;
                padding: 14px 24px;
                border-radius: 12px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .modal-btn-secondary {
                background: #f3f4f6;
                color: #374151;
                border: none;
            }

            .modal-btn-secondary:hover {
                background: #e5e7eb;
            }

            .modal-btn-primary {
                background: #9A74D8;
                color: white;
                border: none;
            }

            .modal-btn-primary:hover {
                background: #8B65C9;
            }

            /* Override submit button to match theme */
            .submit-btn {
                background: #9A74D8 !important;
            }

            .submit-btn:hover {
                background: #8B65C9 !important;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../public/header2.jsp" />

        <div class="page-wrapper">
            <div class="create-memory-container">
                <h1 class="page-title">Create a Memory</h1>

                <!-- Tab Navigation -->
                <div class="create-tabs">
                    <button type="button" class="create-tab active" data-tab="memory" onclick="switchTab('memory')">
                        📸 Memory
                    </button>
                    <button type="button" class="create-tab" data-tab="collab" onclick="switchTab('collab')">
                        👥 Collab Memory
                    </button>
                </div>

                <!-- Memory Tab Content -->
                <div id="memoryTab" class="tab-content active">
                    <form class="memory-form" id="memoryForm" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label">Name of the memory</label>
                            <input type="text" class="form-input" name="memoryName" placeholder="e.g., Summer Vacation"
                                required />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Date of the memory</label>
                            <div class="input-with-icon">
                                <input type="date" class="form-input date-input" name="memoryDate" required />
                                <div class="input-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="upload-area" id="uploadArea">
                                <div class="upload-content">
                                    <div class="upload-icon">
                                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                            <polyline points="17 8 12 3 7 8"></polyline>
                                            <line x1="12" y1="3" x2="12" y2="15"></line>
                                        </svg>
                                    </div>
                                    <h3 class="upload-title">Add Media</h3>
                                    <p class="upload-description">Drag and drop or click to upload photos and videos</p>
                                    <button type="button" class="browse-btn" id="browseBtn">Browse Files</button>
                                    <input type="file" class="file-input" id="fileInput" name="mediaFiles"
                                        accept="image/*,video/*" multiple hidden />
                                </div>
                                <div class="preview-container" id="previewContainer"></div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="submit-btn" id="submitBtn">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                    <polyline points="17 8 12 3 7 8"></polyline>
                                    <line x1="12" y1="3" x2="12" y2="15"></line>
                                </svg>
                                <span id="btnText">Upload Memory</span>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Collab Memory Tab Content -->
                <div id="collabTab" class="tab-content">
                    <form class="memory-form" id="collabMemoryForm" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label">Name of the collab memory</label>
                            <input type="text" class="form-input" name="memoryName"
                                placeholder="e.g., Beach Trip with Friends" required />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Date of the memory</label>
                            <div class="input-with-icon">
                                <input type="date" class="form-input date-input" name="memoryDate" required />
                                <div class="input-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="upload-area" id="collabUploadArea">
                                <div class="upload-content">
                                    <div class="upload-icon">
                                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                            <polyline points="17 8 12 3 7 8"></polyline>
                                            <line x1="12" y1="3" x2="12" y2="15"></line>
                                        </svg>
                                    </div>
                                    <h3 class="upload-title">Add Media</h3>
                                    <p class="upload-description">Drag and drop or click to upload photos and videos</p>
                                    <button type="button" class="browse-btn" id="collabBrowseBtn">Browse Files</button>
                                    <input type="file" class="file-input" id="collabFileInput" name="mediaFiles"
                                        accept="image/*,video/*" multiple hidden />
                                </div>
                                <div class="preview-container" id="collabPreviewContainer"></div>
                            </div>
                        </div>

                        <input type="hidden" name="isCollab" value="true" />

                        <div class="form-actions">
                            <button type="submit" class="submit-btn" id="collabSubmitBtn">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="8.5" cy="7" r="4"></circle>
                                    <line x1="20" y1="8" x2="20" y2="14"></line>
                                    <line x1="23" y1="11" x2="17" y2="11"></line>
                                </svg>
                                <span id="collabBtnText">Create Collab Memory</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Loading overlay -->
        <div id="loadingOverlay"
            style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); z-index: 9999; justify-content: center; align-items: center;">
            <div style="text-align: center; color: white;">
                <div style="font-size: 48px; margin-bottom: 20px;">📸</div>
                <h2>Uploading your memory...</h2>
                <p>Please wait while we save your files</p>
            </div>
        </div>

        <!-- Success Modal with Invite Link -->
        <div class="success-modal-overlay" id="successModal">
            <div class="success-modal">
                <div class="success-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </div>
                <h2>Collab Memory Created!</h2>
                <p>Share this link with friends to let them add their photos too</p>

                <div class="invite-link-box">
                    <label>Invite Link</label>
                    <div class="invite-link-input-group">
                        <input type="text" id="inviteLinkInput" readonly placeholder="Generating link...">
                        <button type="button" class="copy-btn" id="copyLinkBtn" onclick="copyInviteLink()">Copy</button>
                    </div>
                </div>

                <div class="modal-actions">
                    <button type="button" class="modal-btn modal-btn-secondary"
                        onclick="closeModalAndRedirect()">Done</button>
                </div>
            </div>
        </div>

        <jsp:include page="../public/footer.jsp" />

        <script>
            function switchTab(tabName) {
                document.querySelectorAll('.create-tab').forEach(tab => tab.classList.remove('active'));
                document.querySelector('[data-tab="' + tabName + '"]').classList.add('active');

                document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
                document.getElementById(tabName + 'Tab').classList.add('active');

                document.querySelector('.page-title').textContent = tabName === 'collab' ? 'Create a Collab Memory' : 'Create a Memory';
            }

            function copyInviteLink() {
                const input = document.getElementById('inviteLinkInput');
                input.select();
                document.execCommand('copy');

                const btn = document.getElementById('copyLinkBtn');
                btn.textContent = 'Copied!';
                btn.classList.add('copied');
                setTimeout(() => {
                    btn.textContent = 'Copy';
                    btn.classList.remove('copied');
                }, 2000);
            }

            function closeModalAndRedirect() {
                document.getElementById('successModal').classList.remove('active');
                window.location.href = '${pageContext.request.contextPath}/collabmemories';
            }

            document.addEventListener('DOMContentLoaded', function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('tab') === 'collab') {
                    switchTab('collab');
                }

                const uploadArea = document.getElementById('uploadArea');
                const fileInput = document.getElementById('fileInput');
                const browseBtn = document.getElementById('browseBtn');
                const previewContainer = document.getElementById('previewContainer');
                const memoryForm = document.getElementById('memoryForm');
                const loadingOverlay = document.getElementById('loadingOverlay');

                const collabUploadArea = document.getElementById('collabUploadArea');
                const collabFileInput = document.getElementById('collabFileInput');
                const collabBrowseBtn = document.getElementById('collabBrowseBtn');
                const collabPreviewContainer = document.getElementById('collabPreviewContainer');
                const collabMemoryForm = document.getElementById('collabMemoryForm');

                setupFileUpload(uploadArea, fileInput, browseBtn, previewContainer);
                setupFileUpload(collabUploadArea, collabFileInput, collabBrowseBtn, collabPreviewContainer);

                function setupFileUpload(area, input, btn, container) {
                    btn.addEventListener('click', function (e) {
                        e.stopPropagation();
                        input.click();
                    });

                    area.addEventListener('click', function (e) {
                        if (!e.target.closest('.browse-btn')) {
                            input.click();
                        }
                    });

                    input.addEventListener('change', function (e) {
                        handleFiles(e.target.files, area, container);
                    });

                    area.addEventListener('dragover', function (e) {
                        e.preventDefault();
                        area.classList.add('drag-over');
                    });

                    area.addEventListener('dragleave', function (e) {
                        e.preventDefault();
                        area.classList.remove('drag-over');
                    });

                    area.addEventListener('drop', function (e) {
                        e.preventDefault();
                        area.classList.remove('drag-over');
                        handleFiles(e.dataTransfer.files, area, container);
                    });
                }

                function handleFiles(files, area, container) {
                    if (files.length === 0) return;
                    container.innerHTML = '';
                    area.classList.add('has-files');

                    Array.from(files).forEach(file => {
                        if (file.type.startsWith('image/')) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const preview = document.createElement('div');
                                preview.className = 'file-preview';
                                preview.innerHTML = `
                                <img src="${e.target.result}" alt="Preview">
                                <button type="button" class="remove-file" onclick="removeFile(this)">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                </button>
                            `;
                                container.appendChild(preview);
                            };
                            reader.readAsDataURL(file);
                        } else if (file.type.startsWith('video/')) {
                            const preview = document.createElement('div');
                            preview.className = 'file-preview video-preview';
                            preview.innerHTML = `
                            <div class="video-placeholder">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="5 3 19 12 5 21 5 3"></polygon>
                                </svg>
                            </div>
                            <span class="file-name">${file.name}</span>
                            <button type="button" class="remove-file" onclick="removeFile(this)">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                </svg>
                            </button>
                        `;
                            container.appendChild(preview);
                        }
                    });
                }

                window.removeFile = function (button) {
                    const preview = button.closest('.file-preview');
                    const container = preview.parentElement;
                    const area = container.closest('.upload-area');
                    preview.remove();
                    if (container.children.length === 0) {
                        area.classList.remove('has-files');
                    }
                };

                // Regular memory form
                memoryForm.addEventListener('submit', function (e) {
                    e.preventDefault();
                    submitMemoryForm(memoryForm, fileInput, document.getElementById('submitBtn'), document.getElementById('btnText'), false);
                });

                // Collab memory form
                collabMemoryForm.addEventListener('submit', function (e) {
                    e.preventDefault();
                    submitMemoryForm(collabMemoryForm, collabFileInput, document.getElementById('collabSubmitBtn'), document.getElementById('collabBtnText'), true);
                });

                function submitMemoryForm(form, input, btn, text, isCollab) {
                    const formData = new FormData(form);
                    const memoryName = formData.get('memoryName');

                    if (!memoryName || memoryName.trim() === '') {
                        alert('Please enter a memory name');
                        return;
                    }

                    if (input.files.length === 0) {
                        alert('Please select at least one photo or video');
                        return;
                    }

                    loadingOverlay.style.display = 'flex';
                    btn.disabled = true;
                    text.textContent = 'Uploading...';

                    fetch('${pageContext.request.contextPath}/createMemoryServlet', {
                        method: 'POST',
                        body: formData
                    })
                        .then(response => response.json())
                        .then(data => {
                            loadingOverlay.style.display = 'none';

                            if (data.error) {
                                throw new Error(data.error);
                            }

                            if (isCollab && data.memoryId) {
                                // Generate invite link for collab memory
                                fetch('${pageContext.request.contextPath}/memory/generate-invite', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'memoryId=' + data.memoryId
                                })
                                    .then(res => res.json())
                                    .then(inviteData => {
                                        if (inviteData.success && inviteData.inviteUrl) {
                                            document.getElementById('inviteLinkInput').value = inviteData.inviteUrl;
                                            document.getElementById('successModal').classList.add('active');
                                        } else {
                                            alert('Memory created! Redirecting...');
                                            window.location.href = '${pageContext.request.contextPath}/collabmemories';
                                        }
                                    })
                                    .catch(err => {
                                        alert('Memory created! Redirecting...');
                                        window.location.href = '${pageContext.request.contextPath}/collabmemories';
                                    });
                            } else {
                                alert('Memory created successfully!');
                                window.location.href = '${pageContext.request.contextPath}/memories';
                            }

                            btn.disabled = false;
                            text.textContent = isCollab ? 'Create Collab Memory' : 'Upload Memory';
                        })
                        .catch(error => {
                            loadingOverlay.style.display = 'none';
                            btn.disabled = false;
                            text.textContent = isCollab ? 'Create Collab Memory' : 'Upload Memory';
                            alert('Error: ' + error.message);
                        });
                }
            });
        </script>
    </body>

    </html>