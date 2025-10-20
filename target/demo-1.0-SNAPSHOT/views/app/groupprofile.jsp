<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
</head>
<script>
    // Handle floating buttons position on scroll
    document.addEventListener('DOMContentLoaded', function() {
        function handleFloatingButtons() {
            const footer = document.querySelector('footer');
            const floatingButtons = document.getElementById('floatingButtons');

            if (!footer || !floatingButtons) return;

            const footerRect = footer.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            const buttonHeight = floatingButtons.offsetHeight;

            if (footerRect.top < windowHeight - buttonHeight - 40) {
                const stopPosition = footer.offsetTop - buttonHeight - 40;
                floatingButtons.style.position = 'absolute';
                floatingButtons.style.bottom = 'auto';
                floatingButtons.style.top = stopPosition + 'px';
            } else {
                floatingButtons.style.position = 'fixed';
                floatingButtons.style.bottom = '40px';
                floatingButtons.style.top = 'auto';
                floatingButtons.style.right = '40px';
            }
        }

        window.addEventListener('scroll', handleFloatingButtons);
        window.addEventListener('resize', handleFloatingButtons);
        handleFloatingButtons();
    });
</script>
<body>

<!-- Page Wrapper -->
<div class="page-wrapper">
    <main class="main-content profile-page">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="group-name">Family Memories</h1>
            <p class="group-creator">Created by You</p>
        </div>

        <!-- Tab Navigation -->
        <div class="tab-nav">
            <a href="${pageContext.request.contextPath}/groupmemories?groupId=1" class="tab-link">Memories</a>
            <a href="${pageContext.request.contextPath}/groupannouncement?groupId=1" class="tab-link">Announcements</a>
            <a href="${pageContext.request.contextPath}/groupmembers?groupId=1" class="tab-link active">Members</a>
        </div>

        <!-- Profile Card -->
        <div class="profile-card">
            <!-- Back Button -->
            <button class="back-btn" onclick="window.history.back()">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Back
            </button>

            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-avatar-large">SB</div>
                <div class="profile-info-main">
                    <h2 class="profile-name">Sophia Bennett</h2>
                    <span class="profile-badge member">Member</span>
                    <p class="profile-joined">Joined 3 months ago</p>
                </div>
            </div>

            <!-- Profile Details -->
            <div class="profile-details">
                <div class="profile-field">
                    <label>Email</label>
                    <p>sophia.bennett@email.com</p>
                </div>

                <div class="profile-field">
                    <label>Permissions</label>
                    <div class="permissions-select">
                        <select class="permissions-dropdown">
                            <option value="viewer">Viewer</option>
                            <option value="editor" selected>Editor</option>
                            <option value="admin">Admin</option>
                        </select>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <polyline points="6 9 12 15 18 9"></polyline>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Action Button -->
            <button class="remove-member-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="3 6 5 6 21 6"></polyline>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                </svg>
                Remove from Group
            </button>
        </div>
    </main>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Remove member confirmation
        document.querySelector('.remove-member-btn').addEventListener('click', function() {
            if (confirm('Are you sure you want to remove this member from the group?')) {
                // Handle removal logic here
                alert('Member removed successfully');
                window.history.back();
            }
        });

        // Permissions dropdown change
        document.querySelector('.permissions-dropdown').addEventListener('change', function() {
            alert('Permissions updated to: ' + this.options[this.selectedIndex].text);
        });
    });
</script>

</body>
</html>