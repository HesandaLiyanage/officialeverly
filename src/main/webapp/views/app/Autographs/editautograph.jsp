<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Autograph Book</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/autograph.css">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
    </head>

    <body>

        <jsp:include page="../../public/header2.jsp" />

        <div class="page-wrapper">
            <div class="create-autograph-container">
                <h1 class="page-title">Edit Autograph Book</h1>
                <p class="page-subtitle">Update your book details and keep your memories alive.</p>

                <form class="autograph-form" id="autographForm"
                    action="${pageContext.request.contextPath}/updateautograph" method="post"
                    enctype="multipart/form-data">
                    <input type="hidden" name="autographId" value="${autograph.autographId}" />

                    <!-- Book Title Input -->
                    <div class="form-group">
                        <label class="form-label">Book Title</label>
                        <input type="text" class="form-input" name="bookTitle" id="bookTitle"
                            placeholder="e.g., Graduation 2024" value="${autograph.title}" required />
                    </div>

                    <!-- Description Input -->
                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea class="form-input form-textarea" name="description" id="description"
                            placeholder="A short description" rows="4">${autograph.description}</textarea>
                    </div>

                    <!-- Cover Image Upload Area -->
                    <div class="form-group">
                        <label class="form-label">Cover Image</label>
                        <div class="upload-area" id="uploadArea">
                            <div class="upload-content">
                                <div class="upload-icon">
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                        <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                        <polyline points="21 15 16 10 5 21"></polyline>
                                    </svg>
                                </div>
                                <h3 class="upload-title">Change Cover Image</h3>
                                <p class="upload-description">Drag and drop or click to upload</p>
                                <button type="button" class="browse-btn" id="browseBtn">Browse Files</button>
                                <input type="file" class="file-input" id="fileInput" name="coverImage" accept="image/*"
                                    hidden />
                            </div>
                            <div class="preview-container" id="previewContainer">
                                <% if (request.getAttribute("autograph") !=null &&
                                    ((com.demo.web.model.autograph)request.getAttribute("autograph")).getAutographPicUrl()
                                    !=null) { String
                                    picUrl=((com.demo.web.model.autograph)request.getAttribute("autograph")).getAutographPicUrl();
                                    %>
                                    <div class="file-preview">
                                        <img src="${pageContext.request.contextPath}/dbimages/<%= picUrl %>"
                                            alt="Current Cover">
                                        <button type="button" class="remove-file" onclick="removeFile()">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                                <line x1="6" y1="6" x2="18" y2="18"></line>
                                            </svg>
                                        </button>
                                    </div>
                                    <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="cancel-btn"
                            onclick="window.location.href='${pageContext.request.contextPath}/autographs'">
                            Cancel
                        </button>
                        <button type="submit" class="submit-btn" id="submitBtn">
                            Save Changes
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

                browseBtn.addEventListener('click', () => fileInput.click());
                uploadArea.addEventListener('click', (e) => {
                    if (!e.target.closest('.browse-btn') && !e.target.closest('.remove-file')) fileInput.click();
                });

                fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

                uploadArea.addEventListener('dragover', (e) => { e.preventDefault(); uploadArea.classList.add('drag-over'); });
                uploadArea.addEventListener('dragleave', () => uploadArea.classList.remove('drag-over'));
                uploadArea.addEventListener('drop', (e) => {
                    e.preventDefault();
                    uploadArea.classList.remove('drag-over');
                    handleFiles(e.dataTransfer.files);
                });

                function handleFiles(files) {
                    if (files.length === 0) return;
                    const file = files[0];
                    if (!file.type.startsWith('image/')) { alert('Please upload an image'); return; }

                    previewContainer.innerHTML = '';
                    uploadArea.classList.add('has-files');
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        const div = document.createElement('div');
                        div.className = 'file-preview';
                        div.innerHTML = `<img src="${e.target.result}" alt="Preview"><button type="button" class="remove-file" onclick="removeFile()"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg></button>`;
                        previewContainer.appendChild(div);
                    };
                    reader.readAsDataURL(file);
                }

                window.removeFile = function () {
                    previewContainer.innerHTML = '';
                    uploadArea.classList.remove('has-files');
                    fileInput.value = '';
                };
            });
        </script>
    </body>

    </html>