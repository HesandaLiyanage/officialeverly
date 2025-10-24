<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Public Profile - Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/editpublicprofile.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<jsp:include page="../public/header2.jsp" />

<main class="profile-container">
    <h1>Edit Public Profile</h1>
    <p>Update your public information visible to others</p>

    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
    <div class="error"><%= errorMessage %></div>
    <% } %>

    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% if (successMessage != null) { %>
    <div class="success"><%= successMessage %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/settingsaccount" method="POST" class="profile-form" id="profileForm" enctype="multipart/form-data">

        <!-- Display Name -->
        <div class="form-group">
            <label for="displayName">Display Name</label>
            <input
                    type="text"
                    id="displayName"
                    name="display_name"
                    placeholder="Enter your display name"
                    value="${profile.displayName != null ? profile.displayName : ''}"
                    maxlength="50"
                    required>
            <div class="char-count">
                <span id="nameCount">0</span>/50
            </div>
        </div>

        <!-- Bio -->
        <div class="form-group">
            <label for="bio">
                Bio
                <span class="optional">(optional)</span>
            </label>
            <textarea
                    id="bio"
                    name="bio"
                    placeholder="Tell others about yourself..."
                    maxlength="200">${profile.bio != null ? profile.bio : ''}</textarea>
            <div class="char-count">
                <span id="bioCount">0</span>/200
            </div>
        </div>

        <!-- Profile Picture -->
        <div class="form-group">
            <label>Profile Picture</label>
            <div class="profile-picture-section">
                <div class="picture-preview-wrapper">
                    <%
                        String profilePicture = (String) request.getAttribute("profilePicture");
                        if (profilePicture != null && !profilePicture.isEmpty()) {
                    %>
                    <img src="${pageContext.request.contextPath}<%= profilePicture %>" alt="Profile" class="picture-preview" id="previewImage">
                    <% } else { %>
                    <div class="picture-preview placeholder" id="previewImage">👤</div>
                    <% } %>

                    <div class="picture-upload-section">
                        <div class="file-input-wrapper">
                            <input
                                    type="file"
                                    id="profilePicture"
                                    name="profile_picture"
                                    accept="image/jpeg,image/jpg,image/png,image/gif"
                                    onchange="previewFile()">
                            <label for="profilePicture" class="file-upload-btn">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                    <polyline points="17 8 12 3 7 8"></polyline>
                                    <line x1="12" y1="3" x2="12" y2="15"></line>
                                </svg>
                                Upload Photo
                            </label>
                        </div>
                        <div class="file-name" id="fileName"></div>
                        <div class="file-hint">JPG, PNG or GIF (max 5MB)</div>
                    </div>
                </div>
            </div>
        </div>

        <button type="submit" class="btn btn-primary">Save Profile</button>
    </form>

    <div class="extra-links">
        <a href="${pageContext.request.contextPath}/settingsprivacy">Account Settings</a>
    </div>
</main>

<jsp:include page="../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const displayName = document.getElementById('displayName');
        const bio = document.getElementById('bio');
        const nameCount = document.getElementById('nameCount');
        const bioCount = document.getElementById('bioCount');
        const form = document.getElementById('profileForm');

        // Update character counts on page load
        updateCharCount(displayName, nameCount);
        updateCharCount(bio, bioCount);

        // Character count update
        displayName.addEventListener('input', function() {
            updateCharCount(displayName, nameCount);
        });

        bio.addEventListener('input', function() {
            updateCharCount(bio, bioCount);
        });

        function updateCharCount(input, counter) {
            const count = input.value.length;
            counter.textContent = count;

            // Color coding for near limit
            const maxLength = parseInt(input.getAttribute('maxlength'));
            if (count >= maxLength * 0.9) {
                counter.style.color = '#ef4444';
            } else if (count >= maxLength * 0.7) {
                counter.style.color = '#f59e0b';
            } else {
                counter.style.color = '#9ca3af';
            }
        }

        // Form validation
        form.addEventListener('submit', function(e) {
            const nameValue = displayName.value.trim();

            if (nameValue.length === 0) {
                e.preventDefault();
                alert('Display name is required.');
                displayName.focus();
                return false;
            }

            if (nameValue.length < 2) {
                e.preventDefault();
                alert('Display name must be at least 2 characters long.');
                displayName.focus();
                return false;
            }
        });
    });

    // Profile picture preview
    function previewFile() {
        const input = document.getElementById('profilePicture');
        const preview = document.getElementById('previewImage');
        const fileName = document.getElementById('fileName');
        const file = input.files[0];

        if (file) {
            // Check file size (5MB max)
            if (file.size > 5 * 1024 * 1024) {
                alert('File size must be less than 5MB');
                input.value = '';
                return;
            }

            // Check file type
            const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
            if (!validTypes.includes(file.type)) {
                alert('Please upload a JPG, PNG or GIF image');
                input.value = '';
                return;
            }

            // Show file name
            fileName.textContent = file.name;

            // Preview image
            const reader = new FileReader();
            reader.onload = function(e) {
                if (preview.tagName === 'IMG') {
                    preview.src = e.target.result;
                } else {
                    // Replace placeholder with actual image
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.alt = 'Profile';
                    img.className = 'picture-preview';
                    img.id = 'previewImage';
                    preview.parentNode.replaceChild(img, preview);
                }
            };
            reader.readAsDataURL(file);
        }
    }
</script>

</body>
</html>