<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.eventId != null ? 'Edit Event' : 'Create Event'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/createevent.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<jsp:include page="../public/header2.jsp" />

<div class="page-wrapper">
    <div class="create-event-container">
        <h1 class="page-title">${param.eventId != null ? 'Edit Event' : 'Create an Event'}</h1>

        <form class="event-form" id="eventForm" enctype="multipart/form-data">

            <!-- Hidden field for event ID (used when editing) -->
            <input type="hidden" id="eventId" name="eventId" value="${param.eventId}" />

            <!-- Event Title -->
            <div class="form-group">
                <label class="form-label">Event Title</label>
                <input
                        type="text"
                        class="form-input"
                        id="eventTitle"
                        name="eventTitle"
                        placeholder="e.g., Summer Music Festival"
                        required
                />
            </div>

            <!-- Event Type -->
            <div class="form-group">
                <label class="form-label">Event Type</label>
                <select class="form-select" id="eventType" name="eventType" required>
                    <option value="" disabled selected>Select event type</option>
                    <option value="concert">Concert</option>
                    <option value="conference">Conference</option>
                    <option value="workshop">Workshop</option>
                    <option value="meetup">Meetup</option>
                    <option value="party">Party</option>
                    <option value="sports">Sports</option>
                    <option value="other">Other</option>
                </select>
            </div>

            <!-- Date Input -->
            <div class="form-group">
                <label class="form-label">Event Date</label>
                <div class="input-with-icon">
                    <input
                            type="date"
                            class="form-input date-input"
                            id="eventDate"
                            name="eventDate"
                            required
                    />
                    <div class="input-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Location -->
            <div class="form-group">
                <label class="form-label">Location</label>
                <input
                        type="text"
                        class="form-input"
                        id="location"
                        name="location"
                        placeholder="e.g., Central Park, New York"
                        required
                />
            </div>

            <!-- Description -->
            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea
                        class="form-textarea"
                        id="description"
                        name="description"
                        rows="5"
                        placeholder="Tell us more about your event..."
                ></textarea>
            </div>

            <!-- Image Upload Area -->
            <div class="form-group">
                <label class="form-label">Event Cover Photo</label>
                <div class="upload-area" id="uploadArea">
                    <div class="upload-content">
                        <div class="upload-icon">
                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                        </div>
                        <h3 class="upload-title">Upload Cover Photo</h3>
                        <p class="upload-description">Drag and drop or click to upload an image</p>
                        <button type="button" class="browse-btn" id="browseBtn">Browse Files</button>
                        <input
                                type="file"
                                class="file-input"
                                id="imageUpload"
                                name="eventImage"
                                accept="image/*"
                                hidden
                        />
                    </div>
                    <div class="image-preview-container" id="imagePreviewContainer">
                        <img src="" alt="Event cover preview" class="image-preview" id="imagePreview" />
                        <button type="button" class="remove-image" id="removeImage">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Group Selection -->
            <div class="form-group">
                <label class="form-label">Assign to Group</label>
                <select class="form-select" id="groupSelect" name="groupId" required>
                    <option value="" disabled selected>Select the group you want to assign</option>
                    <option value="1">Family Circle</option>
                    <option value="2">College Friends</option>
                    <option value="3">Work Team</option>
                    <option value="4">Sports Club</option>
                </select>
            </div>

            <!-- Tags Input -->
            <div class="form-group">
                <label class="form-label">Tags</label>
                <div class="tags-container" id="tagsContainer">
                    <input
                            type="text"
                            class="tags-input"
                            id="tagsInput"
                            placeholder="Type and press Enter to add tags"
                    />
                </div>
                <input type="hidden" id="tagsHidden" name="tags" />
            </div>

            <!-- Form Actions -->
            <div class="form-actions">
                <button type="submit" class="submit-btn" id="submitBtn">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    ${param.eventId != null ? 'Update Event' : 'Create Event'}
                </button>
                <button type="button" class="cancel-btn" onclick="window.location.href='${pageContext.request.contextPath}/events'">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                    Cancel
                </button>
            </div>

        </form>
    </div>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const uploadArea = document.getElementById('uploadArea');
        const imageUpload = document.getElementById('imageUpload');
        const browseBtn = document.getElementById('browseBtn');
        const imagePreview = document.getElementById('imagePreview');
        const imagePreviewContainer = document.getElementById('imagePreviewContainer');
        const removeImage = document.getElementById('removeImage');
        const eventForm = document.getElementById('eventForm');
        const tagsContainer = document.getElementById('tagsContainer');
        const tagsInput = document.getElementById('tagsInput');
        const tagsHidden = document.getElementById('tagsHidden');
        let tags = [];

        // Check if we're in edit mode
        const eventId = document.getElementById('eventId').value;
        const isEditMode = eventId && eventId.trim() !== '';

        // If in edit mode, load existing event data
        if (isEditMode) {
            loadEventData(eventId);
        }

        // Image Upload Handlers
        browseBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            imageUpload.click();
        });

        uploadArea.addEventListener('click', function(e) {
            if (!e.target.closest('.browse-btn') && !e.target.closest('.remove-image')) {
                imageUpload.click();
            }
        });

        imageUpload.addEventListener('change', function(e) {
            handleImageUpload(e.target.files[0]);
        });

        // Drag and Drop
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
            const file = e.dataTransfer.files[0];
            if (file && file.type.startsWith('image/')) {
                handleImageUpload(file);
            }
        });

        function handleImageUpload(file) {
            if (!file || !file.type.startsWith('image/')) return;

            const reader = new FileReader();
            reader.onload = function(e) {
                imagePreview.src = e.target.result;
                uploadArea.classList.add('has-image');
            };
            reader.readAsDataURL(file);
        }

        removeImage.addEventListener('click', function(e) {
            e.stopPropagation();
            imagePreview.src = '';
            uploadArea.classList.remove('has-image');
            imageUpload.value = '';
        });

        // Tags Management
        tagsInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                const tagValue = tagsInput.value.trim();
                if (tagValue && !tags.includes(tagValue)) {
                    tags.push(tagValue);
                    addTagElement(tagValue);
                    tagsInput.value = '';
                    updateTagsHidden();
                }
            }
        });

        function addTagElement(tagValue) {
            const tagElement = document.createElement('div');
            tagElement.className = 'tag';
            tagElement.innerHTML = `
            ${tagValue}
            <button type="button" class="tag-remove" onclick="removeTag('${tagValue}')">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        `;
            tagsContainer.insertBefore(tagElement, tagsInput);
        }

        window.removeTag = function(tagValue) {
            tags = tags.filter(t => t !== tagValue);
            const tagElements = tagsContainer.querySelectorAll('.tag');
            tagElements.forEach(el => {
                if (el.textContent.trim().startsWith(tagValue)) {
                    el.remove();
                }
            });
            updateTagsHidden();
        };

        function updateTagsHidden() {
            tagsHidden.value = tags.join(',');
        }

        // Load Event Data (for edit mode)
        function loadEventData(eventId) {
            // This would typically fetch data from your backend
            // For now, using mock data as an example
            fetch(`${pageContext.request.contextPath}/api/events/${eventId}`)
                .then(response => response.json())
                .then(event => {
                    document.getElementById('eventTitle').value = event.title || '';
                    document.getElementById('eventType').value = event.type || '';
                    document.getElementById('eventDate').value = event.date || '';
                    document.getElementById('location').value = event.location || '';
                    document.getElementById('description').value = event.description || '';
                    document.getElementById('groupSelect').value = event.groupId || '';

                    // Load existing image
                    if (event.imageUrl) {
                        imagePreview.src = event.imageUrl;
                        uploadArea.classList.add('has-image');
                    }

                    // Load existing tags
                    if (event.tags) {
                        const existingTags = event.tags.split(',');
                        existingTags.forEach(tag => {
                            if (tag.trim()) {
                                tags.push(tag.trim());
                                addTagElement(tag.trim());
                            }
                        });
                        updateTagsHidden();
                    }
                })
                .catch(error => {
                    console.error('Error loading event data:', error);
                });
        }

        // Form Submission
        eventForm.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(eventForm);

            // Set the endpoint based on whether we're creating or updating
            const endpoint = isEditMode
                ? `${pageContext.request.contextPath}/api/events/update`
                : `${pageContext.request.contextPath}/api/events/create`;

            fetch(endpoint, {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(isEditMode ? 'Event updated successfully!' : 'Event created successfully!');
                        window.location.href = `${pageContext.request.contextPath}/events`;
                    } else {
                        alert('Error: ' + (data.message || 'Something went wrong'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to save event. Please try again.');
                });
        });
    });
</script>

</body>
</html>