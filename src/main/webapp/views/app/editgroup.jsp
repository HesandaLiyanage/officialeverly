<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.Group" %>
        <% Group group=(Group) request.getAttribute("group"); if (group==null) {
            response.sendRedirect(request.getContextPath() + "/groups" ); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Edit Group</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groups.css">
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
            </head>

            <body>

                <jsp:include page="../public/header2.jsp" />

                <div class="page-wrapper">
                    <div class="create-group-container">
                        <h1 class="page-title">Edit Group</h1>
                        <p class="page-subtitle">Update your group information and settings.</p>

                        <form class="group-form" id="groupForm"
                            action="<%= request.getContextPath() %>/editgroupservlet" method="post"
                            enctype="multipart/form-data">

                            <!-- Hidden field for group ID -->
                            <input type="hidden" name="groupId" value="<%= group.getGroupId() %>" />

                            <!-- Group Name Input -->
                            <div class="form-group">
                                <label class="form-label">Group Name</label>
                                <input type="text" class="form-input" name="g_name" id="g_name"
                                    placeholder="e.g., Smith Family, College Friends 2024"
                                    value="<%= group.getName() != null ? group.getName() : "" %>" required />
                            </div>

                            <!-- Description Input -->
                            <div class="form-group">
                                <label class="form-label">Description</label>
                                <textarea class="form-input form-textarea" name="g_description" id="g_description"
                                    placeholder="Describe the purpose of this group and what memories you'll share together"
                                    rows="4"><%= group.getDescription() != null ? group.getDescription() : "" %></textarea>
                            </div>

                            <!-- Group Picture Upload Area -->
                            <div class="form-group">
                                <label class="form-label">Group Picture</label>
                                <% if (group.getGroupPicUrl() !=null && !group.getGroupPicUrl().isEmpty()) { %>
                                    <div class="current-picture" style="margin-bottom: 15px;">
                                        <p style="font-size: 14px; color: #6b7280; margin-bottom: 10px;">Current
                                            picture:</p>
                                        <img src="<%= group.getGroupPicUrl() %>" alt="Current group picture"
                                            style="max-width: 200px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>
                                    <% } %>
                                        <div class="upload-area" id="uploadArea">
                                            <div class="upload-content">
                                                <div class="upload-icon">
                                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                        stroke-linejoin="round">
                                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                        <circle cx="9" cy="7" r="4"></circle>
                                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                    </svg>
                                                </div>
                                                <h3 class="upload-title">Change Group Picture</h3>
                                                <p class="upload-description">Drag and drop or click to upload</p>
                                                <p class="upload-hint">PNG, JPG, GIF up to 10MB</p>
                                                <button type="button" class="browse-btn" id="browseBtn">Browse
                                                    Files</button>
                                                <input type="file" class="file-input" id="fileInput" name="group_pic"
                                                    accept="image/png, image/jpeg, image/gif" hidden />
                                            </div>
                                            <div class="preview-container" id="previewContainer"></div>
                                        </div>
                            </div>


                            <!-- Submit Buttons -->
                            <div class="form-actions">
                                <button type="button" class="cancel-btn"
                                    onclick="window.location.href='<%= request.getContextPath() %>/groupmemories?groupId=<%= group.getGroupId() %>'">
                                    Cancel
                                </button>
                                <button type="submit" class="submit-btn">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z">
                                        </path>
                                        <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                        <polyline points="7 3 7 8 15 8"></polyline>
                                    </svg>
                                    Update Group
                                </button>
                            </div>

                        </form>

                        <!-- Delete Group Section (Admin only) -->
                        <div
                            style="margin-top: 40px; padding: 24px; background: #fef2f2; border: 1px solid #fecaca; border-radius: 16px;">
                            <h3
                                style="font-size: 16px; font-weight: 700; color: #dc2626; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#dc2626"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z">
                                    </path>
                                    <line x1="12" y1="9" x2="12" y2="13"></line>
                                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                </svg>
                                Danger Zone
                            </h3>
                            <p style="font-size: 14px; color: #991b1b; margin-bottom: 16px;">Deleting a group is
                                permanent. All members will be removed and all group memories will be unlinked.</p>
                            <button type="button" id="deleteGroupBtn" onclick="showDeleteModal()"
                                style="background: #dc2626; color: white; border: none; padding: 12px 24px; border-radius: 12px; font-size: 14px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px; transition: background 0.2s;"
                                onmouseover="this.style.background='#b91c1c'"
                                onmouseout="this.style.background='#dc2626'">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="3 6 5 6 21 6"></polyline>
                                    <path
                                        d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                    </path>
                                </svg>
                                Delete Group
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Delete Confirmation Modal -->
                <div id="deleteModal"
                    style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
                    <div
                        style="background: white; border-radius: 20px; padding: 32px; max-width: 420px; width: 90%; box-shadow: 0 25px 50px rgba(0,0,0,0.25);">
                        <div style="text-align: center; margin-bottom: 20px;">
                            <div
                                style="width: 56px; height: 56px; background: #fef2f2; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#dc2626"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="3 6 5 6 21 6"></polyline>
                                    <path
                                        d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                    </path>
                                </svg>
                            </div>
                            <h3 style="font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 8px;">Delete "
                                <%= group.getName() %>"?</h3>
                            <p style="font-size: 14px; color: #64748b; line-height: 1.5;">This will permanently delete
                                the group, remove all members, and unlink all group memories. This cannot be undone.</p>
                        </div>
                        <div style="display: flex; gap: 12px;">
                            <button type="button" onclick="hideDeleteModal()"
                                style="flex: 1; padding: 12px; border: 1px solid #e2e8f0; background: white; border-radius: 12px; font-size: 14px; font-weight: 600; color: #475569; cursor: pointer;">Cancel</button>
                            <form action="<%= request.getContextPath() %>/deletegroupservlet" method="POST"
                                style="flex: 1;">
                                <input type="hidden" name="groupId" value="<%= group.getGroupId() %>">
                                <button type="submit"
                                    style="width: 100%; padding: 12px; border: none; background: #dc2626; color: white; border-radius: 12px; font-size: 14px; font-weight: 600; cursor: pointer;">Delete
                                    Group</button>
                            </form>
                        </div>
                    </div>
                </div>

                <jsp:include page="../public/footer.jsp" />

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const uploadArea = document.getElementById('uploadArea');
                        const fileInput = document.getElementById('fileInput');
                        const browseBtn = document.getElementById('browseBtn');
                        const previewContainer = document.getElementById('previewContainer');

                        // File upload functionality
                        browseBtn.addEventListener('click', function (e) {
                            e.stopPropagation();
                            fileInput.click();
                        });

                        uploadArea.addEventListener('click', function (e) {
                            if (!e.target.closest('.browse-btn') && !e.target.closest('.remove-file')) {
                                fileInput.click();
                            }
                        });

                        fileInput.addEventListener('change', function (e) {
                            handleFiles(e.target.files);
                        });

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
                            reader.onload = function (e) {
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

                        window.removeFile = function () {
                            previewContainer.innerHTML = '';
                            uploadArea.classList.remove('has-files');
                            fileInput.value = '';
                        };
                    });

                    function showDeleteModal() {
                        document.getElementById('deleteModal').style.display = 'flex';
                    }
                    function hideDeleteModal() {
                        document.getElementById('deleteModal').style.display = 'none';
                    }
                    // Close modal on backdrop click
                    document.getElementById('deleteModal').addEventListener('click', function (e) {
                        if (e.target === this) hideDeleteModal();
                    });
                </script>

            </body>

            </html>