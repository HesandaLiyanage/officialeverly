<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                /* Memory Type Tabs */
                .memory-type-tabs {
                    display: flex;
                    background: #f1f5f9;
                    border-radius: 16px;
                    padding: 6px;
                    margin-bottom: 30px;
                }

                .memory-type-tab {
                    flex: 1;
                    padding: 14px 20px;
                    border: none;
                    background: transparent;
                    border-radius: 12px;
                    font-size: 15px;
                    font-weight: 600;
                    color: #64748b;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                }

                .memory-type-tab:hover {
                    color: #475569;
                }

                .memory-type-tab.active {
                    background: white;
                    color: #6366f1;
                    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.15);
                }

                .memory-type-tab.active.collab {
                    color: #9A74D8;
                    box-shadow: 0 4px 12px rgba(154, 116, 216, 0.2);
                }

                .memory-type-tab svg {
                    width: 20px;
                    height: 20px;
                }

                .collab-info {
                    display: none;
                    background: linear-gradient(135deg, rgba(154, 116, 216, 0.1), rgba(124, 90, 184, 0.08));
                    border: 1px solid rgba(154, 116, 216, 0.3);
                    border-radius: 12px;
                    padding: 16px 20px;
                    margin-bottom: 24px;
                }

                .collab-info.visible {
                    display: flex;
                    align-items: flex-start;
                    gap: 12px;
                }

                .collab-info-icon {
                    color: #9A74D8;
                    flex-shrink: 0;
                }

                .collab-info-text {
                    font-size: 14px;
                    color: #6b7280;
                    line-height: 1.5;
                }

                .collab-info-text strong {
                    color: #9A74D8;
                }
            </style>
        </head>

        <body>

            <jsp:include page="../public/header2.jsp" />

            <div class="page-wrapper">
                <div class="create-memory-container">
                    <h1 class="page-title">Create a Memory</h1>

                    <!-- Memory Type Tabs -->
                    <div class="memory-type-tabs">
                        <button type="button" class="memory-type-tab <c:if test='${param.type != " collab"}'>active
                            </c:if>" id="normalTab" onclick="switchTab('normal')">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                            Memory
                        </button>
                        <button type="button" class="memory-type-tab collab <c:if test='${param.type == "
                            collab"}'>active</c:if>" id="collabTab" onclick="switchTab('collab')">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            Collab Memory
                        </button>
                    </div>

                    <!-- Collab Info Banner -->
                    <div class="collab-info <c:if test='${param.type == " collab"}'>visible</c:if>" id="collabInfo">
                        <div class="collab-info-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                        </div>
                        <div class="collab-info-text">
                            <strong>Collaborative Memory</strong> - After creating, you'll get a share link to invite
                            others.
                            Everyone with the link can add photos and edit the memory together!
                        </div>
                    </div>

                    <form class="memory-form" id="memoryForm" enctype="multipart/form-data">
                        <!-- Hidden field for collaborative -->
                        <input type="hidden" name="isCollaborative" id="isCollaborative"
                            value="${param.type == 'collab' ? 'true' : 'false'}">

                        <!-- Memory Name Input -->
                        <div class="form-group">
                            <label class="form-label">Name of the memory</label>
                            <input type="text" class="form-input" name="memoryName" placeholder="e.g., Summer Vacation"
                                required />
                        </div>

                        <!-- Date Input -->
                        <div class="form-group">
                            <label class="form-label">Date of the memory</label>
                            <div class="input-with-icon">
                                <input type="date" class="form-input date-input" name="memoryDate" required />
                                <div class="input-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <!-- Media Upload Area -->
                        <div class="form-group">
                            <div class="upload-area" id="uploadArea">
                                <div class="upload-content">
                                    <div class="upload-icon">
                                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round">
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

                        <!-- Submit Button -->
                        <div class="form-actions">
                            <button type="submit" class="submit-btn" id="submitBtn">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                    <polyline points="17 8 12 3 7 8"></polyline>
                                    <line x1="12" y1="3" x2="12" y2="15"></line>
                                </svg>
                                <span id="btnText">Create Memory</span>
                            </button>
                        </div>

                    </form>
                </div>
            </div>

            <!-- Loading overlay -->
            <div id="loadingOverlay"
                style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); z-index: 9999; justify-content: center; align-items: center;">
                <div style="text-align: center; color: white;">
                    <div style="font-size: 48px; margin-bottom: 20px;">📸</div>
                    <h2>Uploading your memory...</h2>
                    <p>Please wait while we save your photos</p>
                </div>
            </div>

            <jsp:include page="../public/footer.jsp" />

            <script>
                // Tab switching
                function switchTab(type) {
                    const normalTab = document.getElementById('normalTab');
                    const collabTab = document.getElementById('collabTab');
                    const collabInfo = document.getElementById('collabInfo');
                    const isCollaborative = document.getElementById('isCollaborative');

                    if (type === 'collab') {
                        normalTab.classList.remove('active');
                        collabTab.classList.add('active');
                        collabInfo.classList.add('visible');
                        isCollaborative.value = 'true';
                    } else {
                        collabTab.classList.remove('active');
                        normalTab.classList.add('active');
                        collabInfo.classList.remove('visible');
                        isCollaborative.value = 'false';
                    }
                }

                document.addEventListener('DOMContentLoaded', function () {
                    const uploadArea = document.getElementById('uploadArea');
                    const fileInput = document.getElementById('fileInput');
                    const browseBtn = document.getElementById('browseBtn');
                    const previewContainer = document.getElementById('previewContainer');
                    const memoryForm = document.getElementById('memoryForm');
                    const submitBtn = document.getElementById('submitBtn');
                    const btnText = document.getElementById('btnText');
                    const loadingOverlay = document.getElementById('loadingOverlay');

                    // Browse button click
                    browseBtn.addEventListener('click', function (e) {
                        e.stopPropagation();
                        fileInput.click();
                    });

                    // Upload area click
                    uploadArea.addEventListener('click', function (e) {
                        if (!e.target.closest('.browse-btn')) {
                            fileInput.click();
                        }
                    });

                    // File input change
                    fileInput.addEventListener('change', function (e) {
                        handleFiles(e.target.files);
                    });

                    // Drag and drop
                    uploadArea.addEventListener('dragover', function (e) {
                        e.preventDefault();
                        uploadArea.classList.add('drag-over');
                    });

                    uploadArea.addEventListener('dragleave', function (e) {
                        e.preventDefault();
                        uploadArea.classList.remove('drag-over');
                    });

                    uploadArea.addEventListener('drop', function (e) {
                        e.preventDefault();
                        uploadArea.classList.remove('drag-over');
                        handleFiles(e.dataTransfer.files);
                    });

                    // Handle files
                    function handleFiles(files) {
                        if (files.length === 0) return;

                        previewContainer.innerHTML = '';
                        uploadArea.classList.add('has-files');

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
                                    previewContainer.appendChild(preview);
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
                                previewContainer.appendChild(preview);
                            }
                        });
                    }

                    // Remove file
                    window.removeFile = function (button) {
                        const preview = button.closest('.file-preview');
                        preview.remove();

                        if (previewContainer.children.length === 0) {
                            uploadArea.classList.remove('has-files');
                            fileInput.value = '';
                        }
                    };

                    // Form submission with AJAX
                    memoryForm.addEventListener('submit', function (e) {
                        e.preventDefault();

                        const formData = new FormData(memoryForm);
                        const isCollab = document.getElementById('isCollaborative').value === 'true';

                        // Validate
                        const memoryName = formData.get('memoryName');
                        if (!memoryName || memoryName.trim() === '') {
                            alert('Please enter a memory name');
                            return;
                        }

                        if (fileInput.files.length === 0) {
                            alert('Please select at least one photo or video');
                            return;
                        }

                        // Show loading overlay
                        loadingOverlay.style.display = 'flex';
                        submitBtn.disabled = true;
                        btnText.textContent = 'Creating...';

                        console.log('Uploading memory:', memoryName, 'Collab:', isCollab);
                        console.log('Files:', fileInput.files.length);

                        // Submit via AJAX
                        fetch('${pageContext.request.contextPath}/createMemoryServlet', {
                            method: 'POST',
                            body: formData
                        })
                            .then(response => {
                                if (!response.ok) {
                                    return response.json().then(data => {
                                        throw new Error(data.error || 'Upload failed');
                                    });
                                }
                                return response.json();
                            })
                            .then(data => {
                                console.log('Success:', data);

                                // Hide loading
                                loadingOverlay.style.display = 'none';

                                // Show success message
                                alert('Memory created successfully! ' + data.filesUploaded + ' files uploaded.');

                                // Redirect based on memory type or source
                                const urlParams = new URLSearchParams(window.location.search);
                                const source = urlParams.get('source');

                                if (source === 'post') {
                                    // Creating memory for a post - auto-post it
                                    const postFormData = new FormData();
                                    postFormData.append('memoryId', data.memoryId);
                                    postFormData.append('caption', '');

                                    fetch('${pageContext.request.contextPath}/createPost', {
                                        method: 'POST',
                                        body: postFormData
                                    })
                                        .then(response => response.json())
                                        .then(postData => {
                                            if (postData.success) {
                                                alert('Memory created and posted to your feed!');
                                                window.location.href = '${pageContext.request.contextPath}/feed';
                                            } else {
                                                alert('Memory created! ' + (postData.error || 'Could not create post automatically.'));
                                                window.location.href = '${pageContext.request.contextPath}/feed';
                                            }
                                        })
                                        .catch(err => {
                                            console.error('Post error:', err);
                                            alert('Memory created! Go to feed to see your posts.');
                                            window.location.href = '${pageContext.request.contextPath}/feed';
                                        });
                                } else if (data.isCollaborative) {
                                    window.location.href = '${pageContext.request.contextPath}/collabmemoryview?id=' + data.memoryId;
                                } else {
                                    window.location.href = '${pageContext.request.contextPath}/memories';
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                loadingOverlay.style.display = 'none';
                                submitBtn.disabled = false;
                                btnText.textContent = 'Create Memory';
                                alert('Error: ' + error.message);
                            });
                    });
                });
            </script>

        </body>

        </html>