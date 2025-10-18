<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../public/header2.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sophia Bennett - Family Memories</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groupmemories.css">
    <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="header.css">
    <link rel="stylesheet" href="footer.css">
</head>
<body>

<!-- Main Content -->
<main class="container">
    <div class="page-header">
        <h1>Family Memories</h1>
        <p>Created by You.</p>
    </div>

    <!-- Tab Navigation -->
    <div class="tab-nav">
        <button class="tab-btn">Memories</button>
        <button class="tab-btn">Announcements</button>
        <button class="tab-btn active">Members</button>
    </div>

    <!-- Member Profile -->
    <div class="member-profile">

        <!-- Back Button -->
        <button class="back-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 12H5M12 19l-7-7 7-7"></path>
            </svg>
        </button>

        <!-- Avatar & Info -->
        <div class="profile-avatar">
            <img src="https://via.placeholder.com/100?text=SB" alt="Sophia Bennett">
        </div>

        <div class="profile-info">
            <h2>Sophia Bennett</h2>
            <p class="profile-role">Member</p>
            <p class="profile-joined">Joined 3 months ago</p>
        </div>

        <!-- Divider -->
        <div class="divider"></div>

        <!-- Email -->
        <div class="profile-detail">
            <label>Email</label>
            <p>sophia.bennett@email.com</p>
        </div>

        <!-- Permissions -->
        <div class="profile-detail">
            <label>Permissions</label>
            <div class="permissions-dropdown">
                <span>Editor</span>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="6 9 12 15 18 9"></polyline>
                </svg>
            </div>
        </div>

        <!-- Remove Button -->
        <button class="remove-btn">Remove from the group</button>

    </div>

</main>

<!-- Include Footer -->
<jsp:include page="../public/footer.jsp"/>


<script>
    // Tab Navigation Logic
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
        });
    });

    // Back Button
    document.querySelector('.back-btn').addEventListener('click', () => {
        window.history.back();
    });

    // Permissions Dropdown (Simple Toggle)
    document.querySelector('.permissions-dropdown').addEventListener('click', () => {
        alert('Permissions dropdown would open here.');
    });
</script>

</body>
</html>