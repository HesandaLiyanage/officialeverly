<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Autograph Book</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/autograph.css">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
    </head>

    <body>

        <jsp:include page="../../public/header2.jsp" />

        <div class="page-wrapper">
            <div class="create-autograph-container">
                <h1 class="page-title">Create a New Autograph Book</h1>
                <p class="page-subtitle">Fill in the details to create your new book and start collecting memories.</p>

                <%-- Display error message if it exists --%>
                    <% String errorMsg=(String) request.getAttribute("error"); if (errorMsg !=null) { %>
                        <div
                            style="background-color: #fee; border: 1px solid #fcc; padding: 10px; border-radius: 6px; margin-bottom: 20px; color: #c00;">
                            <%= errorMsg %>
                        </div>
                        <% } %>

                            <form class="autograph-form" id="autographForm" action="/addautographservlet" method="post"
                                enctype="multipart/form-data">

                                <!-- Book Title Input -->
                                <div class="form-group">
                                    <label class="form-label">Book Title</label>
                                    <input type="text" class="form-input" name="bookTitle" id="bookTitle"
                                        placeholder="e.g., Graduation 2024, Summer Vacation" required />
                                </div>

                                <!-- Description Input -->
                                <div class="form-group">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-input form-textarea" name="description" id="description"
                                        placeholder="A short description of your book's theme" rows="4"></textarea>
                                </div>

                                <!-- Cover Image Upload Area -->
                                <div class="form-group">
                                    <label class="form-label">Cover Image</label>
                                    <div class="upload-area" id="uploadArea">
                                        <div class="upload-content">
                                            <div class="upload-icon">
                                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                                    <polyline points="21 15 16 10 5 21"></polyline>
                                                </svg>
                                            </div>
                                            <h3 class="upload-title">Add Cover Image</h3>
                                            <p class="upload-description">Drag and drop or click to upload</p>
                                            <p class="upload-hint">PNG, JPG, GIF up to 10MB</p>
                                            <button type="button" class="browse-btn" id="browseBtn">Browse
                                                Files</button>
                                            <input type="file" class="file-input" id="fileInput" name="coverImage"
                                                accept="image/png, image/jpeg, image/gif" hidden />
                                        </div>
                                        <div class="preview-container" id="previewContainer"></div>
                                    </div>
                                </div>

                                <!-- Link Input -->
                                <div class="form-group">
                                    <label class="form-label">Link</label>
                                    <div class="link-input-wrapper">
                                        <span class="link-prefix">everly.com/</span>
                                        <input type="text" class="form-input link-input" name="customLink"
                                            id="customLink" placeholder="yourname" required />
                                        <button type="button" class="copy-btn" id="copyBtn" title="Copy link">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                                                <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1">
                                                </path>
                                            </svg>
                                        </button>
                                    </div>
                                    <p class="form-hint" id="fullLinkDisplay">Full link: everly.com/username/name your
                                        auto!!!</p>
                                </div>

                                <!-- Add Your Own Memory Section -->
                                <div class="form-group">
                                    <label class="form-label">Add Your Own Memory (Optional)</label>
                                    <p class="form-hint">You can add your own message, photos, or voice notes to start
                                        the book.</p>
                                    <div class="memory-options">
                                        <button type="button" class="memory-btn">
                                            <span class="memory-icon"></span>
                                            Voice Note
                                        </button>
                                        <button type="button" class="memory-btn">
                                            <span class="memory-icon"></span>
                                            Image
                                        </button>
                                        <button type="button" class="memory-btn">
                                            <span class="memory-icon"></span>
                                            Video
                                        </button>
                                        <button type="button" class="memory-btn">
                                            <span class="memory-icon"></span>
                                            Sticker
                                        </button>
                                    </div>
                                </div>

                                <!-- Submit Buttons -->
                                <div class="form-actions">
                                    <button type="button" class="cancel-btn">
                                        Cancel
                                    </button>
                                    <button type="submit" class="submit-btn">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z">
                                            </path>
                                            <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                            <polyline points="7 3 7 8 15 8"></polyline>
                                        </svg>
                                        Create Book
                                    </button>
                                </div>

                            </form>
            </div>
        </div>

        <jsp:include page="../../public/footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const uploadArea = document.getElementById('uploadArea');
                const fileInput = document.getElementById('fileInput');
                const browseBtn = document.getElementById('browseBtn');
                const previewContainer = document.getElementById('previewContainer');
                // const autographForm = document.getElementById('autographForm'); // We don't need this listener anymore

                // Browse button click
                browseBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    fileInput.click();
                });

                // Upload area click
                uploadArea.addEventListener('click', function (e) {
                    if (!e.target.closest('.browse-btn') && !e.target.closest('.remove-file')) {
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

                    const file = files[0]; // Only take first file for cover image

                    if (!file.type.startsWith('image/')) {
                        alert('Please upload an image file');
                        return;
                    }

                    previewContainer.innerHTML = '';
                    uploadArea.classList.add('has-files');

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const preview = document.createElement('div');
                        preview.className = 'file-preview';
                        preview.innerHTML = `
                    <img src="${e.target.result}" alt="Cover Preview">
                    <button type="button" class="remove-file" onclick="removeFile()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                `;
                        previewContainer.appendChild(preview);
                    };
                    reader.readAsDataURL(file);
                }

                // Remove file
                window.removeFile = function () {
                    previewContainer.innerHTML = '';
                    uploadArea.classList.remove('has-files');
                    fileInput.value = '';
                };

                // Tag removal
                const tagRemoveButtons = document.querySelectorAll('.tag-remove');
                tagRemoveButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        this.closest('.tag').remove();
                    });
                });

                // Memory button interactions
                const memoryButtons = document.querySelectorAll('.memory-btn');
                memoryButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        this.classList.toggle('active');
                    });
                });

                // REMOVED the form submission listener that prevented default submission
                // The form will now submit normally to the action="/addautographservlet" URL.
            });
        </script>

    </body>

    </html>