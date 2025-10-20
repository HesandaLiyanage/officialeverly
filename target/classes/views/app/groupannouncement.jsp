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
  <main class="main-content">
    <!-- Page Header -->
    <div class="page-header">
      <h1 class="group-name">Family Memories</h1>
      <p class="group-creator">Created by You</p>
    </div>

    <!-- Tab Navigation -->
    <div class="tab-nav">
      <a href="${pageContext.request.contextPath}/groupmemories?groupId=1" class="tab-link">Memories</a>
      <a href="${pageContext.request.contextPath}/groupannouncement?groupId=1" class="tab-link active">Announcements</a>
      <a href="${pageContext.request.contextPath}/groupmembers?groupId=1" class="tab-link">Members</a>
    </div>

    <!-- Announcements Grid -->
    <div class="announcements-grid">
      <div class="announcement-card">
        <div class="announcement-header">
          <h3>Mandahasa Concert</h3>
          <span class="announcement-time">2d</span>
        </div>
        <p class="announcement-text">Happening On NAT this Friday. <a href="#" class="inline-link">More Info →</a></p>
        <div class="announcement-footer">
          <span class="announcement-author">Admin</span>
        </div>
      </div>

      <div class="announcement-card">
        <div class="announcement-header">
          <h3>Summer Reunion</h3>
          <span class="announcement-time">3d</span>
        </div>
        <p class="announcement-text">Planning our annual summer reunion for late August. Share your availability!</p>
        <div class="announcement-footer">
          <span class="announcement-author">Sarah</span>
        </div>
      </div>

      <div class="announcement-card">
        <div class="announcement-header">
          <h3>Photo Album Update</h3>
          <span class="announcement-time">5d</span>
        </div>
        <p class="announcement-text">New photos from beach trip added to shared album. Check them out!</p>
        <div class="announcement-footer">
          <span class="announcement-author">Michael</span>
        </div>
      </div>

      <div class="announcement-card">
        <div class="announcement-header">
          <h3>First Meeting Details</h3>
          <span class="announcement-time">1w</span>
        </div>
        <p class="announcement-text">Meeting at Cozy Corner Cafe on July 15th at 7 PM. Discussion about "The Secret Garden".</p>
        <div class="announcement-footer">
          <span class="announcement-author">Admin</span>
        </div>
      </div>

      <div class="announcement-card">
        <div class="announcement-header">
          <h3>Holiday Party</h3>
          <span class="announcement-time">1w</span>
        </div>
        <p class="announcement-text">Save the date! December 20th. More details coming soon 🎄✨</p>
        <div class="announcement-footer">
          <span class="announcement-author">Admin</span>
        </div>
      </div>

      <div class="announcement-card">
        <div class="announcement-header">
          <h3>Birthday Celebrations</h3>
          <span class="announcement-time">3w</span>
        </div>
        <p class="announcement-text">Celebrating Sarah's and David's birthdays on the 28th. Surprise party! 🎂</p>
        <div class="announcement-footer">
          <span class="announcement-author">Emma</span>
        </div>
      </div>

      <div class="announcement-card">
        <div class="announcement-header">
          <h3>Book Selection</h3>
          <span class="announcement-time">2d</span>
        </div>
        <p class="announcement-text">First book: "The Secret Garden" by Frances Hodgson Burnett. Start reading!</p>
        <div class="announcement-footer">
          <span class="announcement-author">Admin</span>
        </div>
      </div>

      <div class="announcement-card">
        <div class="announcement-header">
          <h3>Group Rules</h3>
          <span class="announcement-time">2w</span>
        </div>
        <p class="announcement-text">Reminder: Keep posts family-friendly and respectful. Let's maintain the positive vibe! ❤️</p>
        <div class="announcement-footer">
          <span class="announcement-author">Admin</span>
        </div>
      </div>
    </div>

    <!-- Floating Create Announcement Button -->
    <div class="floating-buttons" id="floatingButtons">
      <a href="${pageContext.request.contextPath}/createannouncement?groupId=1" class="floating-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        New Post
      </a>
    </div>
  </main>
</div>

<jsp:include page="../public/footer.jsp" />

<script src="${pageContext.request.contextPath}/resources/js/groupfloating.js"></script>

</body>
</html>