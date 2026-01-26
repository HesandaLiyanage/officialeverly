<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Memory -
          <c:out value="${memory.title}" default="Untitled" />
        </title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/editmemory.css">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
          rel="stylesheet">
      </head>

      <body>

        <jsp:include page="../public/header2.jsp" />

        <div class="page-wrapper">
          <div class="edit-memory-container">
            <h1 class="page-title">Edit Memory</h1>

            <form class="memory-form" id="memoryForm" action="/updatememory" method="POST"
              enctype="multipart/form-data">
              <!-- Hidden Memory ID -->
              <input type="hidden" name="memoryId" value="${memory.memoryId}">

              <!-- Memory Name Input -->
              <div class="form-group">
                <label class="form-label">Name of the memory</label>
                <input type="text" class="form-input" name="memoryName" placeholder="e.g., Summer Vacation"
                  value="<c:out value='${memory.title}'/>" required />
              </div>

              <!-- Description Input -->
              <div class="form-group">
                <label class="form-label">Description</label>
                <textarea class="form-input" name="memoryDescription" placeholder="Describe this memory..."
                  rows="4"><c:out value='${memory.description}'/></textarea>
              </div>

              <!-- Date Display (read-only) -->
              <div class="form-group">
                <label class="form-label">Created Date</label>
                <div class="input-with-icon">
                  <input type="text" class="form-input date-input"
                    value="<fmt:formatDate value='${memory.createdTimestamp}' pattern='MMMM d, yyyy'/>" readonly
                    disabled />
                  <div class="input-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                      stroke-linecap="round" stroke-linejoin="round">
                      <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                      <line x1="16" y1="2" x2="16" y2="6"></line>
                      <line x1="8" y1="2" x2="8" y2="6"></line>
                      <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                  </div>
                </div>
              </div>

              <!-- Existing Media Display -->
              <div class="form-group">
                <label class="form-label">Current Media</label>
                <div class="existing-media" id="existingMedia">
                  <c:choose>
                    <c:when test="${empty mediaItems}">
                      <p style="color: #666; text-align: center; padding: 20px;">No media files in this memory yet.</p>
                    </c:when>
                    <c:otherwise>
                      <c:forEach var="media" items="${mediaItems}">
                        <div class="existing-file-preview" data-file-id="${media.mediaId}">
                          <c:choose>
                            <c:when test="${media.mediaType eq 'image' or media.mimeType.startsWith('image/')}">
                              <img src="${pageContext.request.contextPath}/viewMedia?id=${media.mediaId}"
                                alt="${media.title}"
                                onerror="this.src='${pageContext.request.contextPath}/resources/images/default-memory.jpg'">
                            </c:when>
                            <c:otherwise>
                              <div class="video-placeholder">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2">
                                  <polygon points="5 3 19 12 5 21 5 3"></polygon>
                                </svg>
                              </div>
                              <span class="file-name">${media.originalFilename}</span>
                            </c:otherwise>
                          </c:choose>
                          <button type="button" class="remove-existing-file"
                            onclick="removeExistingFile(this, ${media.mediaId})">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                              stroke-width="2">
                              <line x1="18" y1="6" x2="6" y2="18"></line>
                              <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                          </button>
                        </div>
                      </c:forEach>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>

              <!-- Add New Media Upload Area -->
              <div class="form-group">
                <label class="form-label">Add New Media (Optional)</label>
                <div class="upload-area" id="uploadArea">
                  <div class="upload-content">
                    <div class="upload-icon">
                      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                        stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="17 8 12 3 7 8"></polyline>
                        <line x1="12" y1="3" x2="12" y2="15"></line>
                      </svg>
                    </div>
                    <h3 class="upload-title">Add More Media</h3>
                    <p class="upload-description">Drag and drop or click to upload photos and videos</p>
                    <button type="button" class="browse-btn" id="browseBtn">Browse Files</button>
                    <input type="file" class="file-input" id="fileInput" name="mediaFiles" accept="image/*,video/*"
                      multiple hidden />
                  </div>
                  <div class="preview-container" id="previewContainer"></div>
                </div>
              </div>

              <!-- Form Actions -->
              <div class="form-actions">
                <button type="button" class="cancel-btn" id="cancelBtn">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                    stroke-linecap="round" stroke-linejoin="round">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                  </svg>
                  Cancel
                </button>
                <button type="submit" class="submit-btn">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                    stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                  </svg>
                  Save Changes
                </button>
              </div>

            </form>
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
            const cancelBtn = document.getElementById('cancelBtn');
            const removedFileIds = [];

            // Cancel button handler - go back to memory view
            cancelBtn.addEventListener('click', function () {
              window.location.href = '/memoryview?id=${memory.memoryId}';
            });

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

            // Handle new files
            function handleFiles(files) {
              if (files.length === 0) return;

              uploadArea.classList.add('has-files');

              Array.from(files).forEach(file => {
                if (file.type.startsWith('image/')) {
                  const reader = new FileReader();
                  reader.onload = function (e) {
                    const preview = document.createElement('div');
                    preview.className = 'file-preview';
                    preview.innerHTML = `
              <img src="${e.target.result}" alt="Preview">
              <button type="button" class="remove-file" onclick="removeNewFile(this)">
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
            <button type="button" class="remove-file" onclick="removeNewFile(this)">
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

            // Remove existing file
            window.removeExistingFile = function (button, fileId) {
              const preview = button.closest('.existing-file-preview');
              preview.style.opacity = '0.5';
              preview.style.pointerEvents = 'none';
              removedFileIds.push(fileId);

              // Add hidden input for removed file
              const hiddenInput = document.createElement('input');
              hiddenInput.type = 'hidden';
              hiddenInput.name = 'removedFileIds[]';
              hiddenInput.value = fileId;
              memoryForm.appendChild(hiddenInput);

              console.log('Marked for removal:', fileId);
            };

            // Remove new file
            window.removeNewFile = function (button) {
              const preview = button.closest('.file-preview');
              preview.remove();

              if (previewContainer.children.length === 0) {
                uploadArea.classList.remove('has-files');
                fileInput.value = '';
              }
            };

            // Form submission is handled normally by HTML form POST
          });
        </script>

      </body>

      </html>