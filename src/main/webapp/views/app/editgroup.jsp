<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web.model.Group" %>
<%
    Group group = (Group) request.getAttribute("group");
    if (group == null) {
        response.sendRedirect(request.getContextPath() + "/groups");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Group</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groups.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<jsp:include page="../public/header2.jsp" />

<div class="page-wrapper">
    <div class="create-group-container">
        <h1 class="page-title">Edit Group</h1>
        <p class="page-subtitle">Update your group information and settings.</p>

        <form class="group-form" id="groupForm" action="<%= request.getContextPath() %>/editgroupservlet" method="post" enctype="multipart/form-data">

            <!-- Hidden field for group ID -->
            <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />

            <!-- Group Name Input -->
            <div class="form-group">
                <label class="form-label">Group Name</label>
                <input
                        type="text"
                        class="form-input"
                        name="g_name"
                        id="g_name"
                        placeholder="e.g., Smith Family, College Friends 2024"
                        value="<%= group.getName() != null ? group.getName() : "" %>"
                        required
                />
            </div>

            <!-- Description Input -->
            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea
                        class="form-input form-textarea"
                        name="g_description"
                        id="g_description"
                        placeholder="Describe the purpose of this group and what memories you'll share together"
                        rows="4"
                ><%= group.getDescription() != null ? group.getDescription() : "" %></textarea>
            </div>

            <!-- Group Picture Upload Area -->
            <div class="form-group">
                <label class="form-label">Group Picture</label>
                <% if (group.getGroupPicUrl() != null && !group.getGroupPicUrl().isEmpty()) { %>
                <div class="current-picture" style="margin-bottom: 15px;">
                    <p style="font-size: 14px; color: #6b7280; margin-bottom: 10px;">Current picture:</p>
                    <img src="<%= group.getGroupPicUrl() %>" alt="Current group picture" style="max-width: 200px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                </div>
                <% } %>
                <div class="upload-area" id="uploadArea">
                    <div class="upload-content">
                        <div class="upload-icon">
                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                        </div>
                        <h3 class="upload-title">Change Group Picture</h3>
                        <p class="upload-description">Drag and drop or click to upload</p>
                        <p class="upload-hint">PNG, JPG, GIF up to 10MB</p>
                        <button type="button" class="browse-btn" id="browseBtn">Browse Files</button>
                        <input
                                type="file"
                                class="file-input"
                                id="fileInput"
                                name="group_pic"
                                accept="image/png, image/jpeg, image/gif"
                                hidden
                        />
                    </div>
                    <div class="preview-container" id="previewContainer"></div>
                </div>
            </div>

            <!-- Link Input -->
            <div class="form-group">
                <label class="form-label">Group Link</label>
                <div class="link-input-wrapper">
                    <span class="link-prefix">everly.com/groups/</span>
                    <input
                            type="text"
                            class="form-input link-input"
                            name="customLink"
                            id="customLink"
                            placeholder="your-group-name"
                            value="<%= group.getGroupUrl() != null ? group.getGroupUrl() : "" %>"
                            required
                    />
                    <button type="button" class="copy-btn" id="copyBtn" title="Copy link">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                            <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                        </svg>
                    </button>
                </div>
                <p class="form-hint" id="fullLinkDisplay">Full link: everly.com/groups/<%= group.getGroupUrl() != null ? group.getGroupUrl() : "your-group-name" %></p>
            </div>

            <!-- Submit Buttons -->
            <div class="form-actions">
                <button type="button" class="cancel-btn" onclick="window.location.href='<%= request.getContextPath() %>/groupmemories?groupId=<%= group.getGroupId() %>'">
                    Cancel
                </button>
                <button type="submit" class="submit-btn">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                        <polyline points="17 21 17 13 7 13 7 21"></polyline>
                        <polyline points="7 3 7 8 15 8"></polyline>
                    </svg>
                    Update Group
                </button>
            </div>

        </form>
    </div>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const uploadArea = document.getElementById('uploadArea');
        const fileInput = document.getElementById('fileInput');
        const browseBtn = document.getElementById('browseBtn');
        const previewContainer = document.getElementById('previewContainer');
        const customLink = document.getElementById('customLink');
        const fullLinkDisplay = document.getElementById('fullLinkDisplay');
        const copyBtn = document.getElementById('copyBtn');

        // File upload functionality
        browseBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            fileInput.click();
        });

        uploadArea.addEventListener('click', function(e) {
            if (!e.target.closest('.browse-btn') && !e.target.closest('.remove-file')) {
                fileInput.click();
            }
        });

        fileInput.addEventListener('change', function(e) {
            handleFiles(e.target.files);
        });

        uploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            uploadArea.classList.add('drag-over');
        });

        uploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('drag-over');
        });

        uploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('drag-over');
            handleFiles(e.dataTransfer.files);
        });

        function handleFiles(files) {
            if (files.length === 0) return;

            const file = files[0];

            if (!file.type.startsWith('image/')) {
                alert('Please upload an image file');
                return;
            }

            previewContainer.innerHTML = '';
            uploadArea.classList.add('has-files');

            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.createElement('div');
                preview.className = 'file-preview';
                preview.innerHTML = `
                    <img src="${e.target.result}" alt="Group Picture Preview">
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

        window.removeFile = function() {
            previewContainer.innerHTML = '';
            uploadArea.classList.remove('has-files');
            fileInput.value = '';
        };

        // Link input functionality - Update display with current value
        customLink.addEventListener('input', function() {
            const linkValue = this.value.trim() || 'your-group-name';
            fullLinkDisplay.textContent = `Full link: everly.com/groups/${linkValue}`;
        });

        // Copy link functionality
        copyBtn.addEventListener('click', function() {
            const linkValue = customLink.value.trim() || 'your-group-name';
            const fullLink = `everly.com/groups/${linkValue}`;

            navigator.clipboard.writeText(fullLink).then(function() {
                // Visual feedback
                copyBtn.innerHTML = `
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                `;
                copyBtn.style.color = '#10b981';

                setTimeout(function() {
                    copyBtn.innerHTML = `
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                            <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                        </svg>
                    `;
                    copyBtn.style.color = '';
                }, 2000);
            }).catch(function(err) {
                alert('Failed to copy link');
                console.error('Copy failed:', err);
            });
        });
    });
</script>

</body>
</html>