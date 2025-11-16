<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Followers Page Content -->
<jsp:include page="../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/follow.css">

<!-- Followers Wrapper -->
<div class="followers-wrapper">
    <h1 class="followers-title">Followers</h1>

    <div class="followers-list">
        <!-- Follower Item 1 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100" alt="Sophia Bennett">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Sophia Bennett</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/followerprofile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 2 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100" alt="Ethan Carter">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Ethan Carter</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/followerprofile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 3 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100" alt="Olivia Davis">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Olivia Davis</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/followerprofile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 4 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100" alt="Liam Foster">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Liam Foster</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/profile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 5 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=100" alt="Ava Green">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Ava Green</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/profile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 6 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100" alt="Noah Harris">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Noah Harris</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/profile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 7 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100" alt="Isabella Jones">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Isabella Jones</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/profile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 8 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=100" alt="Jackson King">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Jackson King</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/profile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 9 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100" alt="Mia Lewis">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Mia Lewis</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/profile" class="view-profile-btn">View Profile</a>
        </div>

        <!-- Follower Item 10 -->
        <div class="follower-item">
            <div class="follower-avatar">
                <img src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=100" alt="Lucas Morgan">
            </div>
            <div class="follower-info">
                <h3 class="follower-name">Lucas Morgan</h3>
                <p class="follower-status">Follows you</p>
            </div>
            <a href="/profile" class="view-profile-btn">View Profile</a>
        </div>
    </div>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add hover effects or click handlers if needed
        const followerItems = document.querySelectorAll('.follower-item');

        followerItems.forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateX(5px)';
            });

            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateX(0)';
            });
        });
    });
</script>
</body>
</html>