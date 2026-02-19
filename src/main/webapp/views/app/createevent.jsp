<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.demo.web.model.Group" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Create Event</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/createevent.css">
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
            </head>

            <body>

                <jsp:include page="../public/header2.jsp" />

                <% List<Group> userGroups = (List<Group>) request.getAttribute("userGroups");
                        String errorMessage = (String) request.getAttribute("error");

                        // Check for error message in session (from redirect after failed submission)
                        if (errorMessage == null) {
                        errorMessage = (String) session.getAttribute("errorMessage");
                        if (errorMessage != null) {
                        session.removeAttribute("errorMessage");
                        }
                        }

                        // Get form data from session if validation failed (to preserve user input)
                        String savedTitle = (String) session.getAttribute("formData_e_title");
                        String savedDescription = (String) session.getAttribute("formData_e_description");
                        String savedDate = (String) session.getAttribute("formData_e_date");
                        String savedGroupId = (String) session.getAttribute("formData_group_id");

                        // Clear form data from session after reading
                        if (savedTitle != null) {
                        session.removeAttribute("formData_e_title");
                        session.removeAttribute("formData_e_description");
                        session.removeAttribute("formData_e_date");
                        session.removeAttribute("formData_group_id");
                        }
                        %>

                        <div class="page-wrapper">
                            <div class="create-event-container">
                                <h1 class="page-title">Create a New Event</h1>
                                <p class="page-subtitle">Plan and share special moments with your group members.</p>

                                <%-- Display Error Message --%>
                                    <% if (errorMessage !=null) { %>
                                        <div class="alert alert-error"
                                            style="background: #fee; border: 1px solid #fcc; padding: 12px; border-radius: 8px; margin-bottom: 20px; color: #c00;">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2"
                                                style="vertical-align: middle; margin-right: 8px;">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                            </svg>
                                            <%= errorMessage %>
                                        </div>
                                        <% } %>

                                            <form class="event-form" id="eventForm"
                                                action="${pageContext.request.contextPath}/saveEvent" method="post"
                                                enctype="multipart/form-data">

                                                <!-- Event Title Input -->
                                                <div class="form-group">
                                                    <label class="form-label">Event Title <span
                                                            style="color: #ef4444;">*</span></label>
                                                    <input type="text" class="form-input" name="e_title" id="e_title"
                                                        placeholder="e.g., Birthday Party, Family Reunion"
                                                        value="<%= savedTitle != null ? savedTitle : "" %>" required />
                                                </div>

                                                <!-- Event Description -->
                                                <div class="form-group">
                                                    <label class="form-label">Description</label>
                                                    <textarea class="form-input form-textarea" name="e_description"
                                                        id="e_description"
                                                        placeholder="Describe the event and what makes it special"
                                                        rows="4"><%= savedDescription != null ? savedDescription : "" %></textarea>
                                                </div>

                                                <!-- Event Date -->
                                                <div class="form-group">
                                                    <label class="form-label">Event Date <span
                                                            style="color: #ef4444;">*</span></label>
                                                    <input type="date" class="form-input" name="e_date" id="e_date"
                                                        value="<%= savedDate != null ? savedDate : "" %>" required />
                                                </div>

                                                <!-- Select Groups (Multi-select Checkboxes) -->
                                                <div class="form-group">
                                                    <label class="form-label">Select Groups <span
                                                            style="color: #ef4444;">*</span></label>
                                                    <p
                                                        style="font-size: 0.875rem; color: #6b7280; margin-bottom: 12px;">
                                                        Choose one or more groups to associate with this event. An
                                                        announcement will be posted to each selected group.
                                                    </p>
                                                    <div class="group-checkbox-list" id="groupCheckboxList">
                                                        <% if (userGroups !=null && !userGroups.isEmpty()) { for (Group
                                                            group : userGroups) { %>
                                                            <label class="group-checkbox-item">
                                                                <input type="checkbox" name="group_id"
                                                                    value="<%= group.getGroupId() %>"
                                                                    class="group-checkbox" />
                                                                <span class="group-checkbox-label">
                                                                    <%= group.getName() %>
                                                                </span>
                                                            </label>
                                                            <% } } else { %>
                                                                <p style="color: #6b7280; font-style: italic;">No groups
                                                                    available</p>
                                                                <% } %>
                                                    </div>
                                                    <% if (userGroups==null || userGroups.isEmpty()) { %>
                                                        <p
                                                            style="font-size: 0.875rem; color: #f59e0b; margin-top: 8px;">
                                                            You don't have any groups yet.
                                                            <a href="${pageContext.request.contextPath}/creategroup"
                                                                style="color: #6366f1; text-decoration: underline;">
                                                                Create a group first
                                                            </a>
                                                        </p>
                                                        <% } %>
                                                </div>

                                                <!-- Event Picture Upload Area -->
                                                <div class="form-group">
                                                    <label class="form-label">Event Picture</label>
                                                    <div class="upload-area" id="uploadArea">
                                                        <div class="upload-content">
                                                            <div class="upload-icon">
                                                                <svg width="48" height="48" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <rect x="3" y="3" width="18" height="18" rx="2"
                                                                        ry="2"></rect>
                                                                    <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                                                    <polyline points="21 15 16 10 5 21"></polyline>
                                                                </svg>
                                                            </div>
                                                            <h3 class="upload-title">Add Event Picture</h3>
                                                            <p class="upload-description">Drag and drop or click to
                                                                upload</p>
                                                            <p class="upload-hint">PNG, JPG, GIF up to 10MB</p>
                                                            <button type="button" class="browse-btn"
                                                                id="browseBtn">Browse Files</button>
                                                            <input type="file" class="file-input" id="fileInput"
                                                                name="event_pic"
                                                                accept="image/png, image/jpeg, image/gif" hidden />
                                                        </div>
                                                        <div class="preview-container" id="previewContainer"></div>
                                                    </div>
                                                </div>

                                                <!-- Submit Buttons -->
                                                <div class="form-actions">
                                                    <button type="button" class="cancel-btn"
                                                        onclick="window.location.href='/saveEvent'">
                                                        Cancel
                                                    </button>
                                                    <button type="submit" class="submit-btn" id="submitBtn">
                                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round">
                                                            <path d="M12 5v14M5 12h14" />
                                                        </svg>
                                                        Create Event
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
                                const eventForm = document.getElementById('eventForm');
                                const submitBtn = document.getElementById('submitBtn');

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

                                    // Validate file type
                                    if (!file.type.startsWith('image/')) {
                                        alert('Please upload an image file (PNG, JPG, or GIF)');
                                        fileInput.value = '';
                                        return;
                                    }

                                    // Validate file size (10MB)
                                    const maxSize = 10 * 1024 * 1024;
                                    if (file.size > maxSize) {
                                        alert('File size must be less than 10MB');
                                        fileInput.value = '';
                                        return;
                                    }

                                    previewContainer.innerHTML = '';
                                    uploadArea.classList.add('has-files');

                                    const reader = new FileReader();
                                    reader.onload = function (e) {
                                        const preview = document.createElement('div');
                                        preview.className = 'file-preview';
                                        preview.innerHTML = `
                    <img src="${e.target.result}" alt="Event Picture Preview">
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

                                // Set minimum date to today
                                const dateInput = document.getElementById('e_date');
                                const today = new Date().toISOString().split('T')[0];
                                dateInput.setAttribute('min', today);

                                // Form validation and submission
                                eventForm.addEventListener('submit', function (e) {
                                    const title = document.getElementById('e_title').value.trim();
                                    const date = document.getElementById('e_date').value;
                                    const checkedGroups = document.querySelectorAll('.group-checkbox:checked');

                                    if (!title) {
                                        e.preventDefault();
                                        alert('Please enter an event title');
                                        return false;
                                    }

                                    if (!date) {
                                        e.preventDefault();
                                        alert('Please select an event date');
                                        return false;
                                    }

                                    if (checkedGroups.length === 0) {
                                        e.preventDefault();
                                        alert('Please select at least one group');
                                        return false;
                                    }

                                    // Disable submit button to prevent double submission
                                    submitBtn.disabled = true;
                                    submitBtn.innerHTML = `
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="animation: spin 1s linear infinite;">
                    <circle cx="12" cy="12" r="10"></circle>
                </svg>
                Creating...
            `;

                                    // Let the form submit naturally
                                    return true;
                                });
                            });
                        </script>

                        <style>
                            @keyframes spin {
                                from {
                                    transform: rotate(0deg);
                                }

                                to {
                                    transform: rotate(360deg);
                                }
                            }

                            .group-checkbox-list {
                                display: flex;
                                flex-direction: column;
                                gap: 8px;
                                max-height: 240px;
                                overflow-y: auto;
                                padding: 12px;
                                border: 1px solid rgba(255, 255, 255, 0.1);
                                border-radius: 12px;
                                background: rgba(255, 255, 255, 0.03);
                            }

                            .group-checkbox-item {
                                display: flex;
                                align-items: center;
                                gap: 12px;
                                padding: 10px 14px;
                                border-radius: 8px;
                                cursor: pointer;
                                transition: background 0.2s ease;
                                border: 1px solid transparent;
                            }

                            .group-checkbox-item:hover {
                                background: rgba(99, 102, 241, 0.08);
                                border-color: rgba(99, 102, 241, 0.2);
                            }

                            .group-checkbox-item:has(.group-checkbox:checked) {
                                background: rgba(99, 102, 241, 0.12);
                                border-color: rgba(99, 102, 241, 0.35);
                            }

                            .group-checkbox {
                                width: 18px;
                                height: 18px;
                                accent-color: #6366f1;
                                cursor: pointer;
                                flex-shrink: 0;
                            }

                            .group-checkbox-label {
                                font-size: 0.95rem;
                                color: inherit;
                            }
                        </style>

            </body>

            </html>