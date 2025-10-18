<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../public/header2.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Family Memories - Announcements</title>
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
    <button class="tab-btn active">Announcements</button>
    <button class="tab-btn">Members</button>
  </div>

  <!-- Announcements List -->
  <div class="announcements-list">

    <!-- Announcement 1 -->
    <div class="announcement-card">
      <h3 class="announcement-title">Mandahasa Concert</h3>
      <p class="announcement-content">Happening On NAT this Friday.<br>
        <a href="#" class="more-info-link">More Info →</a>
      </p>
      <div class="announcement-meta">
        <span>Admin</span> · <span>2d</span>
      </div>
    </div>

    <!-- Announcement 2 -->
    <div class="announcement-card">
      <h3 class="announcement-title">First Meeting Details</h3>
      <p class="announcement-content">Our first meeting will be held at the Cozy Corner Cafe on July 15th at 7 PM. We'll have a lively discussion about "The Secret Garden" and get to know each other. See you there!</p>
      <div class="announcement-meta">
        <span>Admin</span> · <span>1w</span>
      </div>
    </div>

    <!-- Announcement 3 -->
    <div class="announcement-card">
      <h3 class="announcement-title">First Meeting Details</h3>
      <p class="announcement-content">Our first meeting will be held at the Cozy Corner Cafe on July 15th at 7 PM. We'll have a lively discussion about "The Secret Garden" and get to know each other. See you there!</p>
      <div class="announcement-meta">
        <span>Admin</span> · <span>1w</span>
      </div>
    </div>

    <!-- Announcement 4 -->
    <div class="announcement-card">
      <h3 class="announcement-title">Book Selection</h3>
      <p class="announcement-content">Our first book selection is "The Secret Garden" by Frances Hodgson Burnett. We'll be discussing it at our first meeting on July 15th. Get your copy and start reading!</p>
      <div class="announcement-meta">
        <span>Admin</span> · <span>2d</span>
      </div>
    </div>

    <!-- Announcement 5 -->
    <div class="announcement-card">
      <h3 class="announcement-title">First Meeting Details</h3>
      <p class="announcement-content">Our first meeting will be held at the Cozy Corner Cafe on July 15th at 7 PM. We'll have a lively discussion about "The Secret Garden" and get to know each other. See you there!</p>
      <div class="announcement-meta">
        <span>Admin</span> · <span>1w</span>
      </div>
    </div>

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
</script>

</body>
</html>