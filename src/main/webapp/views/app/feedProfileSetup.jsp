<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Feed Profile - Everly</title>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/base.css">
        <link rel="stylesheet" type="text/css"
            href="${pageContext.request.contextPath}/resources/css/feedprofilesetup.css">
    </head>

    <body>

        <jsp:include page="../public/header.jsp" />

        <main class="profile-container">
            <h1 class="profile-title">Create Your Feed Profile</h1>
            <p class="profile-subtitle">Choose a unique username to get started</p>

            <% String errorMessage=(String) request.getAttribute("errorMessage"); %>
                <% if (errorMessage !=null) { %>
                    <div class="error">
                        <%= errorMessage %>
                    </div>
                    <% } %>

                        <form class="profile-form" action="${pageContext.request.contextPath}/feedProfileSetupServlet"
                            method="post" enctype="multipart/form-data" id="feedProfileForm">

                            <!-- Username -->
                            <div class="form-group">
                                <label for="feedUsername" class="profile-label">Username</label>
                                <div class="input-with-prefix">
                                    <span class="input-prefix">@</span>
                                    <input type="text" id="feedUsername" name="feedUsername"
                                        class="profile-input with-prefix" placeholder="your_username"
                                        value="<%= request.getAttribute(" feedUsername") !=null ?
                                        request.getAttribute("feedUsername") : "" %>"
                                    required
                                    minlength="3"
                                    maxlength="30"
                                    pattern="[a-zA-Z0-9_]{3,30}"
                                    autocomplete="off">
                                </div>
                                <div class="input-hint">
                                    <span id="usernameHint">3-30 characters. Letters, numbers, and underscores
                                        only.</span>
                                </div>
                            </div>

                            <!-- Profile Picture -->
                            <div class="form-group">
                                <label class="profile-label">Profile Picture (Optional)</label>
                                <div class="profile-picture-section">
                                    <div class="profile-picture-container" id="pictureContainer">
                                        <svg class="upload-icon" width="48" height="48" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                            <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                            <polyline points="21 15 16 10 5 21"></polyline>
                                        </svg>
                                        <span class="upload-text">Click to upload</span>
                                        <span class="upload-subtext">JPG, PNG, GIF up to 10MB</span>
                                        <img class="profile-preview-image" id="previewImage" src="" alt="Preview">
                                        <button type="button" class="remove-picture" id="removePicture">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                                <line x1="6" y1="6" x2="18" y2="18"></line>
                                            </svg>
                                        </button>
                                    </div>
                                    <input type="file" id="profilePicture" name="profilePicture"
                                        class="profile-file-input" accept="image/*">
                                </div>
                            </div>

                            <!-- Bio -->
                            <div class="form-group">
                                <label for="feedBio" class="profile-label">Bio (Optional)</label>
                                <textarea id="feedBio" name="feedBio" class="profile-textarea"
                                    placeholder="Tell people a bit about yourself..." rows="3"
                                    maxlength="500"><%= request.getAttribute("feedBio") != null ? request.getAttribute("feedBio") : "" %></textarea>
                                <div class="input-hint">
                                    <span id="bioCounter">0/500 characters</span>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="profile-actions">
                                <button type="button"
                                    onclick="window.location.href='${pageContext.request.contextPath}/feedWelcome'"
                                    class="btn btn-secondary">Back</button>
                                <button type="submit" class="btn btn-primary" id="submitBtn">Create Profile</button>
                            </div>
                        </form>
        </main>

        <jsp:include page="../public/footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Profile picture handling
                const pictureContainer = document.getElementById('pictureContainer');
                const fileInput = document.getElementById('profilePicture');
                const previewImage = document.getElementById('previewImage');
                const removePicture = document.getElementById('removePicture');

                pictureContainer.addEventListener('click', function (e) {
                    if (e.target !== removePicture && !removePicture.contains(e.target)) {
                        fileInput.click();
                    }
                });

                fileInput.addEventListener('change', function () {
                    if (this.files && this.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            previewImage.src = e.target.result;
                            pictureContainer.classList.add('has-image');
                        };
                        reader.readAsDataURL(this.files[0]);
                    }
                });

                removePicture.addEventListener('click', function (e) {
                    e.stopPropagation();
                    fileInput.value = '';
                    previewImage.src = '';
                    pictureContainer.classList.remove('has-image');
                });

                // Bio character counter
                const bioTextarea = document.getElementById('feedBio');
                const bioCounter = document.getElementById('bioCounter');

                function updateBioCounter() {
                    const length = bioTextarea.value.length;
                    bioCounter.textContent = length + '/500 characters';
                    if (length > 450) {
                        bioCounter.style.color = '#ef4444';
                    } else {
                        bioCounter.style.color = '#6b7280';
                    }
                }

                bioTextarea.addEventListener('input', updateBioCounter);
                updateBioCounter();

                // Username validation visual feedback
                const usernameInput = document.getElementById('feedUsername');
                const usernameHint = document.getElementById('usernameHint');

                usernameInput.addEventListener('input', function () {
                    const value = this.value;
                    const isValid = /^[a-zA-Z0-9_]{3,30}$/.test(value);

                    if (value.length === 0) {
                        usernameHint.textContent = '3-30 characters. Letters, numbers, and underscores only.';
                        usernameHint.style.color = '#6b7280';
                    } else if (value.length < 3) {
                        usernameHint.textContent = 'Username must be at least 3 characters.';
                        usernameHint.style.color = '#f59e0b';
                    } else if (!isValid) {
                        usernameHint.textContent = 'Only letters, numbers, and underscores allowed.';
                        usernameHint.style.color = '#ef4444';
                    } else {
                        usernameHint.textContent = 'Looks good!';
                        usernameHint.style.color = '#10b981';
                    }
                });

                // Form submission loading state
                const form = document.getElementById('feedProfileForm');
                const submitBtn = document.getElementById('submitBtn');

                form.addEventListener('submit', function () {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = 'Creating Profile...';
                });
            });
        </script>

    </body>

    </html>