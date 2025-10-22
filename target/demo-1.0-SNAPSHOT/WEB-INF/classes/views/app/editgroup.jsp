<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <p class="page-subtitle">Update your group details to keep everyone connected.</p>

        <form class="group-form" id="groupForm" action="saveGroup.jsp" method="post" enctype="multipart/form-data">

            <!-- Group Name Input -->
            <div class="form-group">
                <label class="form-label">Group Name</label>
                <input
                        type="text"
                        class="form-input"
                        name="g_name"
                        id="g_name"
                        placeholder="e.g., Smith Family, College Friends 2024"
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
                ></textarea>
            </div>

            <!-- Group Picture Upload Area -->
            <div class="form-group">
                <label class="form-label">Group Picture</label>
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
                        <h3 class="upload-title">Add Group Picture</h3>
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

            <!-- Privacy Settings -->
            <div class="form-group">
                <label class="form-label">Privacy Settings</label>
                <div class="privacy-options">
                    <label class="privacy-option">
                        <input type="radio" name="privacy" value="private" checked>
                        <div class="privacy-card">
                            <div class="privacy-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                            </div>
                            <div class="privacy-info">
                                <h4>Private</h4>
                                <p>Only invited members can view and contribute</p>
                            </div>
                        </div>
                    </label>
                    <label class="privacy-option">
                        <input type="radio" name="privacy" value="public">
                        <div class="privacy-card">
                            <div class="privacy-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <path d="M2 12h20"></path>
                                    <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                                </svg>
                            </div>
                            <div class="privacy-info">
                                <h4>Public</h4>
                                <p>Anyone can discover and join this group</p>
                            </div>
                        </div>
                    </label>
                </div>
            </div>

            <!-- Member Roles Section -->
            <div class="form-group">
                <label class="form-label">Invite Members (Optional)</label>
                <p class="form-hint">You can invite members now or add them later from the group settings.</p>
                <div class="invite-section">
                    <div class="invite-input-wrapper">
                        <input
                                type="email"
                                class="form-input"
                                id="inviteEmail"
                                placeholder="Enter email address"
                        />
                        <select class="role-select" id="roleSelect">
                            <option value="viewer">Viewer</option>
                            <option value="editor">Editor</option>
                            <option value="admin">Admin</option>
                        </select>
                        <button type="button" class="add-member-btn" id="addMemberBtn">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                            Add
                        </button>
                    </div>
                    <div class="invited-members-list" id="invitedMembersList">
                        <!-- Invited members will be added here dynamically -->
                    </div>
                </div>
            </div>

            <!-- Group Features -->
            <div class="form-group">
                <label class="form-label">Group Features</label>
                <p class="form-hint">Select features you want to enable for this group.</p>
                <div class="features-grid">
                    <label class="feature-option">
                        <input type="checkbox" name="features" value="shared_calendar" checked>
                        <div class="feature-card">
                            <span class="feature-icon">📅</span>
                            <span class="feature-name">Shared Calendar</span>
                        </div>
                    </label>
                    <label class="feature-option">
                        <input type="checkbox" name="features" value="event_planning" checked>
                        <div class="feature-card">
                            <span class="feature-icon">🎉</span>
                            <span class="feature-name">Event Planning</span>
                        </div>
                    </label>
                    <label class="feature-option">
                        <input type="checkbox" name="features" value="group_chat">
                        <div class="feature-card">
                            <span class="feature-icon">💬</span>
                            <span class="feature-name">Group Chat</span>
                        </div>
                    </label>
                    <label class="feature-option">
                        <input type="checkbox" name="features" value="shared_albums" checked>
                        <div class="feature-card">
                            <span class="feature-icon">📸</span>
                            <span class="feature-name">Shared Albums</span>
                        </div>
                    </label>
                </div>
            </div>

            <!-- Submit Buttons -->
            <div class="form-actions">
                <button type="button" class="cancel-btn" onclick="window.location.href='/groups'">
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
        const groupForm = document.getElementById('groupForm');
        const addMemberBtn = document.getElementById('addMemberBtn');
        const inviteEmail = document.getElementById('inviteEmail');
        const roleSelect = document.getElementById('roleSelect');
        const invitedMembersList = document.getElementById('invitedMembersList');

        let invitedMembers = [];

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

        // Add member functionality
        addMemberBtn.addEventListener('click', function() {
            const email = inviteEmail.value.trim();
            const role = roleSelect.value;

            if (!email) {
                alert('Please enter an email address');
                return;
            }

            if (!isValidEmail(email)) {
                alert('Please enter a valid email address');
                return;
            }

            if (invitedMembers.some(m => m.email === email)) {
                alert('This member has already been invited');
                return;
            }

            const member = { email, role };
            invitedMembers.push(member);
            renderInvitedMembers();
            inviteEmail.value = '';
        });

        function isValidEmail(email) {
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        }

        function renderInvitedMembers() {
            if (invitedMembers.length === 0) {
                invitedMembersList.innerHTML = '';
                return;
            }

            invitedMembersList.innerHTML = invitedMembers.map((member, index) => `
                <div class="invited-member-item">
                    <div class="member-info">
                        <span class="member-email">${member.email}</span>
                        <span class="member-role-badge ${member.role}">${member.role}</span>
                    </div>
                    <button type="button" class="remove-member-btn" onclick="removeMember(${index})">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                </div>
            `).join('');
        }

        window.removeMember = function(index) {
            invitedMembers.splice(index, 1);
            renderInvitedMembers();
        };

        // Form submission
        groupForm.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(groupForm);
            formData.append('invitedMembers', JSON.stringify(invitedMembers));

            console.log('Form submitted');
            console.log('Group Name:', formData.get('g_name'));
            console.log('Description:', formData.get('g_description'));
            console.log('Group Picture:', fileInput.files[0]);
            console.log('Invited Members:', invitedMembers);

            // TODO: Submit to server
            // For now, redirect
            window.location.href = '/groups';
        });
    });
</script>

</body>
</html>