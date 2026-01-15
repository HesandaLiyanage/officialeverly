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
    </head>

    <body>

        <jsp:include page="../public/header2.jsp" />

        <div class="page-wrapper">
            <div class="create-memory-container">
                <h1 class="page-title">Create a Memory</h1>

                <form class="memory-form" id="memoryForm" enctype="multipart/form-data">

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

                    <!-- Collaboration Toggle -->
                    <div class="form-group">
                        <label class="form-label">Collaboration Settings</label>
                        <div class="collab-toggle-container"
                            style="background: #f8f9fb; border-radius: 12px; padding: 16px;">
                            <label class="toggle-wrapper" style="display: flex; align-items: center; cursor: pointer;">
                                <input type="checkbox" id="collabToggle" name="isCollab"
                                    style="width: 20px; height: 20px; margin-right: 12px; accent-color: #667eea;">
                                <div>
                                    <span style="font-weight: 600; color: #1a1a2e;">Make this a collaborative
                                        memory</span>
                                    <p style="font-size: 13px; color: #6b7280; margin-top: 4px;">
                                        Allow others to add photos and content via an invite link
                                    </p>
                                </div>
                            </label>
                        </div>

                        <!-- Invite Link Section (shown after creation) -->
                        <div id="inviteLinkSection"
                            style="display: none; margin-top: 16px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 12px; padding: 20px; color: white;">
                            <div style="display: flex; align-items: center; margin-bottom: 12px;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" style="margin-right: 10px;">
                                    <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path>
                                    <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path>
                                </svg>
                                <span style="font-weight: 600;">Invite Link Generated!</span>
                            </div>
                            <div style="display: flex; gap: 10px;">
                                <input type="text" id="inviteLinkInput" readonly
                                    style="flex: 1; padding: 12px; border-radius: 8px; border: none; background: rgba(255,255,255,0.2); color: white;">
                                <button type="button" id="copyLinkBtn" onclick="copyInviteLink()"
                                    style="padding: 12px 20px; background: white; color: #667eea; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                                    Copy
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Media Upload Area -->
                    <div class="form-group">
                        <div class="upload-area" id="uploadArea">
                            <div class="upload-content">
                                <div class="upload-icon">
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                        <polyline points="17 8 12 3 7 8"></polyline>
                                        <line x1="12" y1="3" x2="12" y2="15"></line>
                                    </svg>
                                </div>
                                <h3 class="upload-title">Add Media</h3>
                                <p class="upload-description">Drag and drop or click to upload photos and videos</p>
                                <p class="upload-description" style="font-size: 12px; color: #666; margin-top: 5px;">
                                    🔒 All files will be encrypted automatically
                                </p>
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
                            <span id="btnText">Upload Memory</span>
                        </button>
                    </div>

                </form>
            </div>
        </div>

        <!-- Loading overlay -->
        <div id="loadingOverlay"
            style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); z-index: 9999; justify-content: center; align-items: center;">
            <div style="text-align: center; color: white;">
                <div style="font-size: 48px; margin-bottom: 20px;">🔒</div>
                <h2>Encrypting and uploading...</h2>
                <p>Please wait while we secure your memories</p>
            </div>
        </div>

        <jsp:include page="../public/footer.jsp" />

        <script>
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
                    btnText.textContent = 'Encrypting...';

                    console.log('Uploading memory:', memoryName);
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

                            // Check if collab toggle is checked
                            const collabToggle = document.getElementById('collabToggle');

                            if (collabToggle.checked && data.memoryId) {
                                // Generate invite link
                                fetch('${pageContext.request.contextPath}/memory/generate-invite', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded'
                                    },
                                    body: 'memoryId=' + data.memoryId
                                })
                                    .then(res => res.json())
                                    .then(inviteData => {
                                        loadingOverlay.style.display = 'none';

                                        if (inviteData.success) {
                                            // Show invite link section
                                            const inviteLinkSection = document.getElementById('inviteLinkSection');
                                            const inviteLinkInput = document.getElementById('inviteLinkInput');
                                            inviteLinkSection.style.display = 'block';
                                            inviteLinkInput.value = inviteData.inviteUrl;

                                            submitBtn.disabled = false;
                                            btnText.textContent = 'Memory Created!';

                                            alert('Collaborative memory created! Copy the invite link to share with others.');
                                        } else {
                                            alert('Memory created, but invite link generation failed. You can generate it later from edit page.');
                                            window.location.href = '${pageContext.request.contextPath}/memories';
                                        }
                                    })
                                    .catch(err => {
                                        console.error('Invite link error:', err);
                                        loadingOverlay.style.display = 'none';
                                        alert('Memory created! Files uploaded and encrypted. (Invite link generation failed)');
                                        window.location.href = '${pageContext.request.contextPath}/memories';
                                    });
                            } else {
                                // Hide loading
                                loadingOverlay.style.display = 'none';

                                // Show success message
                                alert('Memory created successfully! ' + data.filesUploaded + ' files uploaded and encrypted.');

                                // Redirect to memories page
                                window.location.href = '${pageContext.request.contextPath}/memories';
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            loadingOverlay.style.display = 'none';
                            submitBtn.disabled = false;
                            btnText.textContent = 'Upload Memory';
                            alert('Error: ' + error.message);
                        });
                });
            });

            // Copy invite link function
            function copyInviteLink() {
                const inviteLinkInput = document.getElementById('inviteLinkInput');
                inviteLinkInput.select();
                document.execCommand('copy');

                const copyBtn = document.getElementById('copyLinkBtn');
                copyBtn.textContent = 'Copied!';
                setTimeout(() => {
                    copyBtn.textContent = 'Copy';
                }, 2000);
            }
            window.copyInviteLink = copyInviteLink;
        </script>

    </body>

    </html>