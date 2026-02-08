<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.FeedProfile" %>
        <% FeedProfile feedProfile=(FeedProfile) request.getAttribute("feedProfile"); if (feedProfile==null) {
            feedProfile=(FeedProfile) session.getAttribute("feedProfile"); } String feedUsername=(feedProfile !=null) ?
            feedProfile.getFeedUsername() : "" ; String feedBio=(feedProfile !=null && feedProfile.getFeedBio() !=null)
            ? feedProfile.getFeedBio() : "" ; String feedProfilePicture=(feedProfile !=null &&
            feedProfile.getFeedProfilePictureUrl() !=null) ? feedProfile.getFeedProfilePictureUrl() : null; String
            feedInitials=(feedProfile !=null) ? feedProfile.getInitials() : "U" ; %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Edit Public Profile - Everly</title>
                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/resources/css/editpublicprofile.css">
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <style>
                    .profile-avatar-large {
                        width: 100px;
                        height: 100px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 32px;
                        font-weight: 700;
                        color: white;
                        background: linear-gradient(135deg, #9A74D8 0%, #764ba2 100%);
                        box-shadow: 0 4px 20px rgba(154, 116, 216, 0.3);
                        object-fit: cover;
                    }

                    .profile-avatar-large img {
                        width: 100%;
                        height: 100%;
                        border-radius: 50%;
                        object-fit: cover;
                    }

                    .back-link {
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        color: #6b7280;
                        text-decoration: none;
                        font-size: 14px;
                        margin-bottom: 24px;
                        transition: color 0.2s;
                    }

                    .back-link:hover {
                        color: #6366f1;
                    }

                    .back-link svg {
                        width: 18px;
                        height: 18px;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="../public/header2.jsp" />

                <main class="profile-container">
                    <a href="${pageContext.request.contextPath}/publicprofile" class="back-link">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                            stroke-linecap="round" stroke-linejoin="round">
                            <line x1="19" y1="12" x2="5" y2="12" />
                            <polyline points="12 19 5 12 12 5" />
                        </svg>
                        Back to Profile
                    </a>

                    <h1>Edit Public Profile</h1>
                    <p>Update your public information visible to others on the feed</p>

                    <% String errorMessage=(String) request.getAttribute("errorMessage"); %>
                        <% if (errorMessage !=null) { %>
                            <div class="error">
                                <%= errorMessage %>
                            </div>
                            <% } %>

                                <% String successMessage=(String) request.getAttribute("successMessage"); %>
                                    <% if (successMessage !=null) { %>
                                        <div class="success">
                                            <%= successMessage %>
                                        </div>
                                        <% } %>

                                            <form action="${pageContext.request.contextPath}/updateFeedProfile"
                                                method="POST" class="profile-form" id="profileForm"
                                                enctype="multipart/form-data">

                                                <!-- Profile Picture -->
                                                <div class="form-group">
                                                    <label>Profile Picture</label>
                                                    <div class="profile-picture-section">
                                                        <div class="picture-preview-wrapper">
                                                            <% if (feedProfilePicture !=null &&
                                                                !feedProfilePicture.isEmpty() &&
                                                                !feedProfilePicture.contains("default")) { %>
                                                                <img src="<%= feedProfilePicture %>" alt="Profile"
                                                                    class="picture-preview profile-avatar-large"
                                                                    id="previewImage">
                                                                <% } else { %>
                                                                    <div class="profile-avatar-large" id="previewImage">
                                                                        <%= feedInitials %>
                                                                    </div>
                                                                    <% } %>

                                                                        <div class="picture-upload-section">
                                                                            <div class="file-input-wrapper">
                                                                                <input type="file" id="profilePicture"
                                                                                    name="profile_picture"
                                                                                    accept="image/jpeg,image/jpg,image/png,image/gif"
                                                                                    onchange="previewFile()">
                                                                                <label for="profilePicture"
                                                                                    class="file-upload-btn">
                                                                                    <svg width="18" height="18"
                                                                                        viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2"
                                                                                        stroke-linecap="round"
                                                                                        stroke-linejoin="round">
                                                                                        <path
                                                                                            d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4">
                                                                                        </path>
                                                                                        <polyline
                                                                                            points="17 8 12 3 7 8">
                                                                                        </polyline>
                                                                                        <line x1="12" y1="3" x2="12"
                                                                                            y2="15"></line>
                                                                                    </svg>
                                                                                    Upload Photo
                                                                                </label>
                                                                            </div>
                                                                            <div class="file-name" id="fileName"></div>
                                                                            <div class="file-hint">JPG, PNG or GIF (max
                                                                                5MB)</div>
                                                                        </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Username (read-only) -->
                                                <div class="form-group">
                                                    <label for="username">Username</label>
                                                    <input type="text" id="username" name="username"
                                                        value="@<%= feedUsername %>" disabled
                                                        style="background: #f3f4f6; cursor: not-allowed;">
                                                    <div class="char-count" style="color: #6b7280;">Username cannot be
                                                        changed</div>
                                                </div>

                                                <!-- Bio -->
                                                <div class="form-group">
                                                    <label for="bio">
                                                        Bio
                                                        <span class="optional">(optional)</span>
                                                    </label>
                                                    <textarea id="bio" name="bio"
                                                        placeholder="Tell others about yourself..."
                                                        maxlength="500"><%= feedBio %></textarea>
                                                    <div class="char-count">
                                                        <span id="bioCount">
                                                            <%= feedBio.length() %>
                                                        </span>/500
                                                    </div>
                                                </div>

                                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                            </form>

                                            <div class="extra-links">
                                                <a href="${pageContext.request.contextPath}/publicprofile">Cancel</a>
                                            </div>
                </main>

                <jsp:include page="../public/footer.jsp" />

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const bio = document.getElementById('bio');
                        const bioCount = document.getElementById('bioCount');
                        const form = document.getElementById('profileForm');

                        // Update character count on input
                        bio.addEventListener('input', function () {
                            updateCharCount(bio, bioCount, 500);
                        });

                        function updateCharCount(input, counter, maxLength) {
                            const count = input.value.length;
                            counter.textContent = count;

                            // Color coding for near limit
                            if (count >= maxLength * 0.9) {
                                counter.style.color = '#ef4444';
                            } else if (count >= maxLength * 0.7) {
                                counter.style.color = '#f59e0b';
                            } else {
                                counter.style.color = '#9ca3af';
                            }
                        }
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
                            reader.onload = function (e) {
                                if (preview.tagName === 'IMG') {
                                    preview.src = e.target.result;
                                } else {
                                    // Replace placeholder with actual image
                                    const img = document.createElement('img');
                                    img.src = e.target.result;
                                    img.alt = 'Profile';
                                    img.className = 'picture-preview profile-avatar-large';
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