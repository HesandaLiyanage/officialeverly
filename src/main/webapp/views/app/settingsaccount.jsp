<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Settings - Account</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
    </head>

    <body>
        <jsp:include page="../public/header2.jsp" />

        <div class="settings-container">
            <h2>Settings</h2>
            <div class="settings-tabs">
                <a href="${pageContext.request.contextPath}/settingsaccount" class="tab active">Account</a>
                <a href="${pageContext.request.contextPath}/settingssubscription" class="tab">Subscription</a>
                <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy & Security</a>
                <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
                <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
                <a href="${pageContext.request.contextPath}/settingsappearance" class="tab">Appearance</a>
            </div>

            <% String error=(String) request.getAttribute("error"); %>
                <% if (error !=null) { %>
                    <div class="deactivate-error">
                        <%= error %>
                    </div>
                    <% } %>

                        <div class="account-section">
                            <h3>Account</h3>

                            <div class="setting-item">
                                <div class="icon">👤</div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/editprofile">
                                        <p class="title">Profile</p>
                                        <p class="desc">Manage your profile information</p>
                                    </a>
                                </div>
                            </div>

                            <div class="setting-item">
                                <div class="icon">📰</div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/feededitprofile">
                                        <p class="title">Feed Profile</p>
                                        <p class="desc">Manage your public profile information</p>
                                    </a>
                                </div>
                            </div>

                            <div class="setting-item">
                                <div class="icon">💎</div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/settingssubscription"
                                        style="text-decoration: none;">
                                        <p class="title">Manage Subscription</p>
                                        <p class="desc">View plan, billing, and storage details</p>
                                    </a>
                                </div>
                            </div>

                            <div class="setting-item">
                                <div class="icon">📱</div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/linkeddevices"
                                        style="text-decoration: none;">
                                        <p class="title">Linked Devices</p>
                                        <p class="desc">Manage devices logged into your account</p>
                                    </a>
                                </div>
                            </div>

                            <button class="deactivate-btn" id="openDeactivateModal">Deactivate the Account</button>
                        </div>
        </div>

        <!-- Deactivate Account Confirmation Modal -->
        <div class="deactivate-modal-overlay" id="deactivateModal">
            <div class="deactivate-modal">
                <div class="deactivate-modal-icon">⚠️</div>
                <h3>Deactivate Your Account?</h3>
                <p class="deactivate-modal-desc">
                    Your account will be temporarily deactivated. This means:
                </p>
                <ul class="deactivate-info-list">
                    <li>You won't be able to log in until you reactivate</li>
                    <li>Your profile won't be visible to other users</li>
                    <li>Your data will <strong>not</strong> be deleted</li>
                    <li>You can reactivate anytime by logging in again</li>
                </ul>
                <form action="${pageContext.request.contextPath}/deactivateaccount" method="POST" id="deactivateForm">
                    <div class="deactivate-modal-actions">
                        <button type="button" class="deactivate-cancel-btn" id="cancelDeactivate">Cancel</button>
                        <button type="submit" class="deactivate-confirm-btn">Yes, Deactivate</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const openBtn = document.getElementById('openDeactivateModal');
                const modal = document.getElementById('deactivateModal');
                const cancelBtn = document.getElementById('cancelDeactivate');
                const form = document.getElementById('deactivateForm');

                // Open modal
                openBtn.addEventListener('click', function () {
                    modal.classList.add('active');
                });

                // Close modal on cancel
                cancelBtn.addEventListener('click', function () {
                    modal.classList.remove('active');
                });

                // Close modal on overlay click
                modal.addEventListener('click', function (e) {
                    if (e.target === modal) {
                        modal.classList.remove('active');
                    }
                });

                // Close modal on Escape key
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && modal.classList.contains('active')) {
                        modal.classList.remove('active');
                    }
                });

                // Disable submit button after click to prevent double-submit
                form.addEventListener('submit', function () {
                    const submitBtn = form.querySelector('.deactivate-confirm-btn');
                    submitBtn.disabled = true;
                    submitBtn.textContent = 'Deactivating...';
                });
            });
        </script>

        <jsp:include page="../public/footer.jsp" />
    </body>

    </html>