<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/editevent.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<jsp:include page="../public/header2.jsp" />

<div class="page-wrapper">
    <div class="create-event-container">
        <h1 class="page-title">Edit Event</h1>
        <p class="page-subtitle">Update your event details and information.</p>

        <form class="event-form" id="eventForm" action="saveEvent.jsp" method="post" enctype="multipart/form-data">

            <!-- Event Title Input -->
            <div class="form-group">
                <label class="form-label">Event Title</label>
                <input
                        type="text"
                        class="form-input"
                        name="e_title"
                        id="e_title"
                        placeholder="e.g., Birthday Party, Family Reunion"
                        required
                />
            </div>

            <!-- Event Description -->
            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea
                        class="form-input form-textarea"
                        name="e_description"
                        id="e_description"
                        placeholder="Describe the event and what makes it special"
                        rows="4"
                ></textarea>
            </div>

            <!-- Event Date -->
            <div class="form-group">
                <label class="form-label">Event Date</label>
                <input
                        type="date"
                        class="form-input"
                        name="e_date"
                        id="e_date"
                        required
                />
            </div>

            <!-- Select Group -->
            <div class="form-group">
                <label class="form-label">Select Group</label>
                <select
                        class="form-input form-select"
                        name="group_id"
                        id="group_id"
                        required
                >
                    <option value="" disabled selected>Choose a group</option>
                    <!-- Groups will be populated dynamically -->
                    <option value="1">Smith Family</option>
                    <option value="2">College Friends</option>
                    <option value="3">Work Team</option>
                </select>
            </div>

            <!-- Event Picture Upload Area -->
            <div class="form-group">
                <label class="form-label">Event Picture</label>
                <div class="upload-area" id="uploadArea">
                    <div class="upload-content">
                        <div class="upload-icon">
                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                        </div>
                        <h3 class="upload-title">Change Event Picture</h3>
                        <p class="upload-description">Drag and drop or click to upload</p>
                        <p class="upload-hint">PNG, JPG, GIF up to 10MB</p>
                        <button type="button" class="browse-btn" id="browseBtn">Browse Files</button>
                        <input
                                type="file"
                                class="file-input"
                                id="fileInput"
                                name="event_pic"
                                accept="image/png, image/jpeg, image/gif"
                                hidden
                        />
                    </div>
                    <div class="preview-container" id="previewContainer"></div>
                </div>
            </div>

            <!-- Event Location (Optional) -->
            <div class="form-group">
                <label class="form-label">Location (Optional)</label>
                <input
                        type="text"
                        class="form-input"
                        name="e_location"
                        id="e_location"
                        placeholder="e.g., Central Park, 123 Main Street"
                />
            </div>

            <!-- Submit Buttons -->
            <div class="form-actions">
                <button type="button" class="cancel-btn" onclick="window.location.href='/events'">
                    Cancel
                </button>
                <button type="submit" class="submit-btn">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12" />
                    </svg>
                    Save Changes
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
        const eventForm = document.getElementById('eventForm');

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

        window.removeFile = function() {
            previewContainer.innerHTML = '';
            uploadArea.classList.remove('has-files');
            fileInput.value = '';
        };

        // Set minimum date to today
        const dateInput = document.getElementById('e_date');
        const today = new Date().toISOString().split('T')[0];
        dateInput.setAttribute('min', today);

        // Form submission
        eventForm.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(eventForm);

            console.log('Form submitted');
            console.log('Event Title:', formData.get('e_title'));
            console.log('Description:', formData.get('e_description'));
            console.log('Event Date:', formData.get('e_date'));
            console.log('Group ID:', formData.get('group_id'));
            console.log('Event Picture:', fileInput.files[0]);

            // TODO: Submit to server
            // For now, redirect
            window.location.href = '/events';
        });
    });
</script>

</body>
</html>