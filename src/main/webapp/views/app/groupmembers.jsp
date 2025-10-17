<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../public/header2.jsp"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Family Memories - Members</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groupmemories.css">

  <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
</head>
<body>

<main class="container">
  <div class="page-header">
    <h1>Family Memories</h1>
    <p>Created by You.</p>
  </div>

  <!-- Tab Navigation -->
  <div class="tab-nav">
    <a href="${pageContext.request.contextPath}/groupmemories.jsp" class="tab-btn">Memories</a>
    <a href="${pageContext.request.contextPath}/groupannouncement.jsp" class="tab-btn">Announcements</a>
    <a href="#" class="tab-btn active">Members</a>
  </div>

  <!-- Members List -->
  <div class="members-list">
    <a href="${pageContext.request.contextPath}/groupprofile.jsp?memberId=1" class="member-card">
      <div class="member-avatar">
        <img src="https://via.placeholder.com/40?text=SC" alt="Sophia Carter">
      </div>
      <div class="member-info">
        <div class="member-name">Sophia Carter <span class="edit-icon"></span></div>
        <div class="member-role">Admin</div>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/groupprofile.jsp?memberId=2" class="member-card">
      <div class="member-avatar">
        <img src="https://via.placeholder.com/40?text=LB" alt="Liam Bennett">
      </div>
      <div class="member-info">
        <div class="member-name">Liam Bennett <span class="edit-icon"></span></div>
        <div class="member-role">Member</div>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/groupprofile.jsp?memberId=3" class="member-card">
      <div class="member-avatar">
        <img src="https://via.placeholder.com/40?text=OH" alt="Olivia Hayes">
      </div>
      <div class="member-info">
        <div class="member-name">Olivia Hayes <span class="edit-icon"></span></div>
        <div class="member-role">Member</div>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/groupprofile.jsp?memberId=4" class="member-card">
      <div class="member-avatar">
        <img src="https://via.placeholder.com/40?text=NP" alt="Noah Parker">
      </div>
      <div class="member-info">
        <div class="member-name">Noah Parker <span class="edit-icon"></span></div>
        <div class="member-role">Member</div>
      </div>
    </a>

    <a href="${pageContext.request.contextPath}/groupprofile.jsp?memberId=5" class="member-card">
      <div class="member-avatar">
        <img src="https://via.placeholder.com/40?text=AF" alt="Ava Foster">
      </div>
      <div class="member-info">
        <div class="member-name">Ava Foster <span class="edit-icon"></span></div>
        <div class="member-role">Member</div>
      </div>
    </a>
  </div>
</main>

<jsp:include page="../public/footer.jsp"/>

</body>
</html>