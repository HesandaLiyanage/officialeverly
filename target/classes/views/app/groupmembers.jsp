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
      <a href="${pageContext.request.contextPath}/groupannouncement?groupId=1" class="tab-link">Announcements</a>
      <a href="${pageContext.request.contextPath}/groupmembers?groupId=1" class="tab-link active">Members</a>
    </div>

    <!-- Members Grid -->
    <div class="members-grid">
      <a href="${pageContext.request.contextPath}/groupprofile?memberId=1&groupId=1" class="member-card">
        <div class="member-avatar admin-avatar">SC</div>
        <div class="member-details">
          <h3 class="member-name">Sophia Carter</h3>
          <span class="member-role admin">Admin</span>
        </div>
      </a>

      <a href="${pageContext.request.contextPath}/groupprofile?memberId=2&groupId=1" class="member-card">
        <div class="member-avatar avatar-1">LB</div>
        <div class="member-details">
          <h3 class="member-name">Liam Bennett</h3>
          <span class="member-role">Member</span>
        </div>
      </a>

      <a href="${pageContext.request.contextPath}/groupprofile?memberId=3&groupId=1" class="member-card">
        <div class="member-avatar avatar-2">OH</div>
        <div class="member-details">
          <h3 class="member-name">Olivia Hayes</h3>
          <span class="member-role">Member</span>
        </div>
      </a>

      <a href="${pageContext.request.contextPath}/groupprofile?memberId=4&groupId=1" class="member-card">
        <div class="member-avatar avatar-3">NP</div>
        <div class="member-details">
          <h3 class="member-name">Noah Parker</h3>
          <span class="member-role">Member</span>
        </div>
      </a>

      <a href="${pageContext.request.contextPath}/groupprofile?memberId=5&groupId=1" class="member-card">
        <div class="member-avatar avatar-4">AF</div>
        <div class="member-details">
          <h3 class="member-name">Ava Foster</h3>
          <span class="member-role">Member</span>
        </div>
      </a>

      <a href="${pageContext.request.contextPath}/groupprofile?memberId=6&groupId=1" class="member-card">
        <div class="member-avatar avatar-5">EM</div>
        <div class="member-details">
          <h3 class="member-name">Ethan Mitchell</h3>
          <span class="member-role">Member</span>
        </div>
      </a>

      <a href="${pageContext.request.contextPath}/groupprofile?memberId=7&groupId=1" class="member-card">
        <div class="member-avatar avatar-6">IR</div>
        <div class="member-details">
          <h3 class="member-name">Isabella Rose</h3>
          <span class="member-role">Member</span>
        </div>
      </a>

      <a href="${pageContext.request.contextPath}/groupprofile?memberId=8&groupId=1" class="member-card">
        <div class="member-avatar avatar-7">JT</div>
        <div class="member-details">
          <h3 class="member-name">James Turner</h3>
          <span class="member-role">Member</span>
        </div>
      </a>
    </div>

    <!-- Floating Add Memory Button -->
    <div class="floating-buttons" id="floatingButtons">
      <a href="${pageContext.request.contextPath}/creatememory?groupId=1" class="floating-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        Add Memory
      </a>
      <a href="${pageContext.request.contextPath}/editgroup?groupId=1" class="floating-btn edit-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path>
        </svg>
        Edit Group
      </a>
    </div>
  </main>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
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

</body>
</html>