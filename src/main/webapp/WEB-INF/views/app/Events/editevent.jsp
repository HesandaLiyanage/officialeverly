<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/editevent.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
        rel="stylesheet">
</head>

<body>

    <jsp:include page="/WEB-INF/views/public/header2.jsp" />

    <div class="page-wrapper">
        <div class="create-event-container">
            <h1 class="page-title">Edit Event</h1>
            <p class="page-subtitle">Update your event details and information.</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error"
                    style="background: #fee; border: 1px solid #fcc; padding: 12px; border-radius: 8px; margin-bottom: 20px; color: #c00;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                        stroke="currentColor" stroke-width="2"
                        style="vertical-align: middle; margin-right: 8px;">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>

            <form class="event-form" id="eventForm"
                action="${pageContext.request.contextPath}/updateEvent"
                method="post" enctype="multipart/form-data">

                <input type="hidden" name="event_id" value="${event.eventId}" />

                <!-- Event Title -->
                <div class="form-group">
                    <label class="form-label">Event Title <span style="color: #ef4444;">*</span></label>
                    <input type="text" class="form-input" name="e_title" id="e_title"
                        placeholder="e.g., Birthday Party, Family Reunion"
                        value="${fn:escapeXml(event.title)}" required />
                </div>

                <!-- Event Description -->
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea class="form-input form-textarea" name="e_description" id="e_description"
                        placeholder="Describe the event"
                        rows="4">${fn:escapeXml(event.description)}</textarea>
                </div>

                <!-- Event Date -->
                <div class="form-group">
                    <label class="form-label">Event Date <span style="color: #ef4444;">*</span></label>
                    <input type="date" class="form-input" name="e_date"
                        id="e_date" value="${formattedDate}" required />
                </div>

                <!-- Select Groups (checkboxes for multi-group) -->
                <div class="form-group">
                    <label class="form-label">Assign to Groups <span style="color: #ef4444;">*</span></label>
                    <p style="font-size: 0.85rem; color: #6b7280; margin-bottom: 12px;">
                        Select one or more groups. You can add or remove groups.</p>
                    <div class="group-checkbox-list" id="groupCheckboxList">
                        <c:choose>
                            <c:when test="${not empty userGroups}">
                                <c:forEach var="group" items="${userGroups}">
                                    <label class="group-checkbox-item">
                                        <input type="checkbox" name="group_ids"
                                            value="${group.groupId}"
                                            class="group-checkbox"
                                            <c:forEach var="gid" items="${eventGroupIds}">
                                                <c:if test="${gid == group.groupId}">checked</c:if>
                                            </c:forEach> />
                                        <span class="group-checkbox-label">
                                            <span class="group-checkbox-name">
                                                ${fn:escapeXml(group.name)}
                                            </span>
                                        </span>
                                        <span class="group-checkbox-check">
                                            <svg width="16" height="16"
                                                viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor"
                                                stroke-width="3"
                                                stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <polyline points="20 6 9 17 4 12">
                                                </polyline>
                                            </svg>
                                        </span>
                                    </label>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="padding: 20px; text-align: center; color: #9ca3af;">
                                    No groups available</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Event Picture Upload Area -->
                <div class="form-group">
                    <label class="form-label">Event Picture</label>
                    <div class="upload-area" id="uploadArea"
                        <c:if test="${not empty displayImageUrl}">class="has-files"</c:if>>
                        <div class="upload-content"
                            <c:if test="${not empty displayImageUrl}">style="display: none;"</c:if>>
                            <div class="upload-icon">
                                <svg width="48" height="48"
                                    viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2"
                                    stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <rect x="3" y="3" width="18" height="18"
                                        rx="2" ry="2"></rect>
                                    <circle cx="8.5" cy="8.5" r="1.5">
                                    </circle>
                                    <polyline points="21 15 16 10 5 21">
                                    </polyline>
                                </svg>
                            </div>
                            <h3 class="upload-title">Change Event Picture</h3>
                            <p class="upload-description">Drag and drop or click to upload</p>
                            <p class="upload-hint">PNG, JPG, GIF up to 10MB</p>
                            <button type="button" class="browse-btn" id="browseBtn">Browse Files</button>
                            <input type="file" class="file-input" id="fileInput" name="event_pic"
                                accept="image/png, image/jpeg, image/gif" hidden />
                        </div>
                        <div class="preview-container" id="previewContainer">
                            <c:if test="${not empty displayImageUrl}">
                                <div class="file-preview">
                                    <img src="${displayImageUrl}" alt="Current Event Picture">
                                    <button type="button" class="remove-file" onclick="removeFile()">
                                        <svg width="16" height="16"
                                            viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <line x1="18" y1="6" x2="6" y2="18"></line>
                                            <line x1="6" y1="6" x2="18" y2="18"></line>
                                        </svg>
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    <p style="font-size: 0.875rem; color: #6b7280; margin-top: 8px;">
                        Leave empty to keep the current picture
                    </p>
                </div>

                <!-- Submit Buttons -->
                <div class="form-actions">
                    <button type="button" class="cancel-btn"
                        onclick="window.location.href='${pageContext.request.contextPath}/events'">
                        Cancel
                    </button>
                    <button type="submit" class="submit-btn" id="submitBtn">
                        <svg width="20" height="20" viewBox="0 0 24 24"
                            fill="none" stroke="currentColor"
                            stroke-width="2" stroke-linecap="round"
                            stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12" />
                        </svg>
                        Save Changes
                    </button>
                </div>

            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/public/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const uploadArea = document.getElementById('uploadArea');
            const fileInput = document.getElementById('fileInput');
            const browseBtn = document.getElementById('browseBtn');
            const previewContainer = document.getElementById('previewContainer');
            const eventForm = document.getElementById('eventForm');
            const submitBtn = document.getElementById('submitBtn');
            const dateInput = document.getElementById('e_date');

            if (dateInput) {
                const today = new Date().toISOString().split('T')[0];
                dateInput.setAttribute('min', today);
            }

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
                    alert('Please upload an image file (PNG, JPG, or GIF)');
                    fileInput.value = '';
                    return;
                }
                const maxSize = 10 * 1024 * 1024;
                if (file.size > maxSize) {
                    alert('File size must be less than 10MB');
                    fileInput.value = '';
                    return;
                }

                previewContainer.innerHTML = '';
                uploadArea.classList.add('has-files');
                document.querySelector('.upload-content').style.display = 'none';

                const reader = new FileReader();
                reader.onload = function (e) {
                    const preview = document.createElement('div');
                    preview.className = 'file-preview';
                    preview.innerHTML = `
                        <img src="${'${e.target.result}'}" alt="Event Picture Preview">
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
                document.querySelector('.upload-content').style.display = 'block';
                fileInput.value = '';
            };

            // Form validation
            eventForm.addEventListener('submit', function (e) {
                const titleInput = document.getElementById('e_title');
                const dateInput = document.getElementById('e_date');
                const descInput = document.getElementById('e_description');
                const title = (titleInput.value || '').trim();
                const date = dateInput.value;
                const description = (descInput.value || '').trim();
                const checkedGroups = document.querySelectorAll('input[name="group_ids"]:checked');
                const today = new Date().toISOString().split('T')[0];

                titleInput.value = title;
                descInput.value = description;

                if (!title) { e.preventDefault(); alert('Please enter an event title'); return false; }
                if (title.length < 2 || title.length > 120) { e.preventDefault(); alert('Event title must be between 2 and 120 characters.'); titleInput.focus(); return false; }
                if (!date) { e.preventDefault(); alert('Please select an event date'); return false; }
                if (date < today) { e.preventDefault(); alert('Event date must be today or a future date.'); dateInput.focus(); return false; }
                if (description.length > 1000) { e.preventDefault(); alert('Description must be 1000 characters or less.'); descInput.focus(); return false; }
                if (checkedGroups.length === 0) { e.preventDefault(); alert('Please select at least one group'); return false; }

                submitBtn.disabled = true;
                submitBtn.innerHTML = `
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="animation: spin 1s linear infinite;">
                        <circle cx="12" cy="12" r="10"></circle>
                    </svg>
                    Updating...
                `;
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

        /* Group Checkbox Styles */
        .group-checkbox-list {
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
            max-height: 250px;
            overflow-y: auto;
        }

        .group-checkbox-item {
            display: flex;
            align-items: center;
            padding: 14px 16px;
            cursor: pointer;
            transition: background 0.15s ease;
            border-bottom: 1px solid #f3f4f6;
            gap: 12px;
        }

        .group-checkbox-item:last-child {
            border-bottom: none;
        }

        .group-checkbox-item:hover {
            background: #f9fafb;
        }

        .group-checkbox-item input[type="checkbox"] {
            display: none;
        }

        .group-checkbox-label {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .group-checkbox-name {
            font-weight: 600;
            font-size: 0.95rem;
            color: #111827;
        }

        .group-checkbox-check {
            width: 24px;
            height: 24px;
            border: 2px solid #d1d5db;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            color: white;
            flex-shrink: 0;
        }

        .group-checkbox-check svg {
            opacity: 0;
            transition: opacity 0.2s ease;
        }

        .group-checkbox-item input[type="checkbox"]:checked~.group-checkbox-check {
            background: #9A74D8;
            border-color: #9A74D8;
        }

        .group-checkbox-item input[type="checkbox"]:checked~.group-checkbox-check svg {
            opacity: 1;
        }

        .group-checkbox-item input[type="checkbox"]:checked~.group-checkbox-label .group-checkbox-name {
            color: #9A74D8;
        }
    </style>

</body>

</html>
